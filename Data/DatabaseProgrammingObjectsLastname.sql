
use MIST353_NFL_RDB_Derringer;



SELECT CD.ConferenceDivisionID, CD.Conference, CD.Division
FROM ConferenceDivision AS CD
ORDER BY CD.Conference, CD.Division;

SELECT T.TeamName, T.TeamCityState, T.TeamColors
FROM Team AS T
ORDER BY T.TeamName;

SELECT T.TeamName, T.TeamCityState, CD.Conference, CD.Division
FROM Team AS T
INNER JOIN ConferenceDivision AS CD ON T.ConferenceDivisionID = CD.ConferenceDivisionID


GO
declare @myTeamName NVARCHAR(50) = 'Pittsburgh Steelers';

select OtherTeam.TeamName
from Team
MyTeam inner join Team OtherTeam on MyTeam.ConferenceDivisionID = OtherTeam.ConferenceDivisionID
where MyTeam.TeamName = @myTeamName and OtherTeam.TeamName != @myTeamName;

GO

create or alter procedure proValidateUser(
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(200)
)
AS
BEGIN
select AppUserID, FirstName + ' ' + LastName as Fullname, UserRole
from AppUser
where Email = @Email and
 PasswordHash = Convert(VARBINARY(200), @PasswordHash, 1);
END
-- execute proValidateUser @Email = 'tom.brady@example.com', @PasswordHash = '0x01';
-- select * from AppUser;



GO

CREATE OR ALTER PROCEDURE proGetTeamsForSpecifiedFan 
(
    @NFLFanID INT 
) 
AS 
BEGIN
    SELECT 
        T.TeamName, 
        CD.Conference, 
        CD.Division, T.TeamColors
    FROM NFLFan F   
     INNER JOIN FanTeam FT 
        ON F.NFLFanID = FT.NFLFanID 
    INNER JOIN Team T 
        ON FT.TeamID = T.TeamID 
    INNER JOIN ConferenceDivision CD 
        ON T.ConferenceDivisionID = CD.ConferenceDivisionID 
    WHERE F.NFLFanID = @NFLFanID  
END;

-- execute proGetTeamsForSpecifiedFan @NFLFanID = 1;
-- execute proGetTeamsForSpecifiedFan @NFLFanID = 2;

GO

create or alter procedure proScheduleGame
(
    @HomeTeamID INT,
    @AwayTeamID INT,
    @GameRound NVARCHAR(50),
    @GamDate DATE,
    @GameStartTime TIME,
    @StadiumID INT,
    @NFLAdminID INT -- the logged in admin who is scheduling the game
)
AS
BEGIN
        --Store the NFL ADMIN in context so that the trigger can access it when inserting into AdminChangesTracker
        declare @context VARBINARY(128) = cast(@NFLAdminID as VARBINARY(128));
        SET context_info @context;
    insert into Game (HomeTeamID, AwayTeamID, GameRound, GameDate, GameStartTime, StadiumID)
    values (@HomeTeamID, @AwayTeamID, @GameRound, @GamDate, @GameStartTime, @StadiumID);
    END

    /*
    GameRound: 'Wild Card', HomeTeamID: 22, AwayTeamID: 30, GameDate: '2026-01-10', GameStartTime: '16:30', StadiumID: 22, 
NFLAdminID for scheduling: 5 (Bill Belichick)

execute proScheduleGame  
@HomeTeamID = 22, 
@AwayTeamID = 30, 
@GameRound = 'Wild Card',
 @GamDate = '2026-01-10', 
 @GameStartTime = '16:30', 
 @StadiumID = 22,
  @NFLAdminID = 5;

  select * from Game order by GameID desc;
  select * from AdminChangesTracker order by AdminChangesTrackerID desc;
*/

/*

GameRound: 'Wild Card', HomeTeamID: 17, AwayTeamID: 19, GameDate: '2026-01-10', GameStartTime: '20:00', StadiumID: 17,
NFLAdminID for scheduling: 6 (Sean McVay)

execute proScheduleGame  
@HomeTeamID = 17,   
@AwayTeamID = 19,
@GameRound = 'Wild Card',
@GamDate = '2026-01-10', 
@GameStartTime = '20:00', 
 @StadiumID = 17,
 @NFLAdminID = 6;
    
    select * from Game order by GameID desc;
    select * from AdminChangesTracker order by AdminChangesTrackerID desc;
    
*/
GO
-- trigger to track changes made by NFL Admins to the Game table
-- 1. triggering event (insert, update, delete) on game table
-- 2. action: insert a record into AdminChangesTracker with the NFLAdminID, GameID, ChangeType, and ChangeDescription
    create or alter trigger trgTrackChangesOnSchedulingGame
    on Game
    after insert
    as
    BEGIN
        declare @NFLAdminID INT;
        declare @GameID INT;
        declare @ChangeType NVARCHAR(50);
        declare @ChangeDescription NVARCHAR(500);
        declare @GameRound NVARCHAR(50);
        declare @GameDate DATE;
        declare @GameStartTime TIME;
        declare @HomeTeamID INT;
        declare @AwayTeamID INT;    
        declare @HomeTeamName NVARCHAR(50);
        declare @AwayTeamName NVARCHAR(50);
        declare @StadiumID INT;
        declare @StadiumName NVARCHAR(100);
        declare @AdminFullName NVARCHAR(100);

        
        -- get the NFLAdminID from context
        set @NFLAdminID = convert(int, convert(binary(4), context_info()));
        
        -- get the GameID of the newly inserted game
        select @GameID = GameID, @GameRound = GameRound, @GameDate = GameDate, @GameStartTime = GameStartTime,
        @HomeTeamID = HomeTeamID, @AwayTeamID = AwayTeamID, @StadiumID = StadiumID
        from inserted;
       select @HomeTeamName = TeamName from Team where TeamID = @HomeTeamID;
       select @AwayTeamName = TeamName from Team where TeamID = @AwayTeamID;
       select @StadiumName = StadiumName from Stadium where StadiumID = @StadiumID;
       select @AdminFullName = FirstName + ' ' + LastName from AppUser where AppUserID = @NFLAdminID;

        
        set @ChangeType = 'Insert';
        set @ChangeDescription = @AdminFullName + ' scheduled a new game with GameID ' + cast(@GameID as NVARCHAR(50))
            + ': ' + @HomeTeamName + ' vs ' + @AwayTeamName + ' on ' + cast(@GameDate as NVARCHAR(50))
            + ' at ' + cast(@GameStartTime as NVARCHAR(50)) + ' in stadium ' + @StadiumName
            + ' . Game Round: ' + @GameRound;
        
        insert into AdminChangesTracker (NFLAdminID, GameID, ChangeType, ChangeDescription)
        values (@NFLAdminID, @GameID, @ChangeType, @ChangeDescription);
    END