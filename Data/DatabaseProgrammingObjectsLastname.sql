
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

create or alter procedure proGetTeamsForSpecifiedFan(
    @NFLFanID INT
    )
AS
BEGIN
    SELECT T.TeamName, CD.Conference, CD.Division
    FROM NFLFan F
    inner join Team T 
    on F.NFLFanID = T.TeamID
    inner join ConferenceDivision CD on T.ConferenceDivisionID = CD.ConferenceDivisionID
    where F.NFLFanID = @NFLFanID;
END;

-- execute proGetTeamsForSpecifiedFan @NFLFanID = 1;
-- execute proGetTeamsForSpecifiedFan @NFLFanID = 2;