-- Create a database for NFL app
--use m;

--CREATE DATABASE mist353-nfl-derringer;

--DROP database mist353-nfl-derringer
-- Step 1: Create a login at the server level

use MIST353_NFL_RDB_Derringer;

if(OBJECT_ID('FanTeam') IS NOT NULL)
    DROP TABLE FanTeam;


if(OBJECT_ID('NFLFan') IS NOT NULL)
    DROP TABLE NFLFan;

if(OBJECT_ID('NFLAdmin') IS NOT NULL)
    DROP TABLE NFLAdmin;    

if(OBJECT_ID('Team') IS NOT NULL)
    DROP TABLE Team;

if(OBJECT_ID('ConferenceDivision') IS NOT NULL)
    DROP TABLE ConferenceDivision;

if(OBJECT_ID('AppUser') IS NOT NULL)
    DROP TABLE AppUser;


-- Create tables for first iteration

go

create TABLE ConferenceDivision (
    ConferenceDivisionID INT identity(1,1)
        constraint PK_ConferenceDivision PRIMARY KEY,
    Conference NVARCHAR(50) NOT NULL
        constraint CK_ConferenceNames CHECK (Conference IN ('AFC', 'NFC')),
     Division NVARCHAR(50) NOT NULL
        constraint CK_DivisionNames CHECK (Division IN ('East', 'North', 'South', 'West'))
        constraint UQ_ConferenceDivision UNIQUE (Conference, Division)
);
/*
alter table ConferenceDivision
   NOCHECK CONSTRAINT CK_ConferenceNames;

alter table ConferenceDivision
CHECK CONSTRAINT CK_ConferenceNames;

*/
go

create TABLE Team ( 
    TeamID INT identity(1,1)
        constraint PK_Team PRIMARY KEY,
    TeamName NVARCHAR(50) NOT NULL,
    TeamCityState NVARCHAR(50) NOT NULL,
    TeamColors NVARCHAR(100) NOT NULL,
    ConferenceDivisionID INT NOT NULL 
        constraint FK_Team_ConferenceDivision FOREIGN KEY REFERENCES ConferenceDivision(ConferenceDivisionID)
);
GO
-- Create tables for second iteration
CREATE TABLE AppUser(
    AppUserID INT identity(1,1)
        constraint PK_AppUser PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL
        constraint UK_APPUserEmail UNIQUE,
    PasswordHash VARBINARY(200) NOT NULL,
    Phone NVARCHAR(20) NULL,
    UserRole NVARCHAR(20) NOT NULL
        constraint CK_UserRole CHECK (UserRole IN (N'NFLAdmin', N'NFLFan'))
    
);
GO

create table NFLFan(
    NFLFanID INT
        constraint PK_NFLFan PRIMARY KEY,
        constraint FK_NFLFan_AppUser FOREIGN KEY (NFLFanID) REFERENCES AppUser(AppUserID)
);

GO

create table NFLAdmin(
    NFLAdminID INT
        constraint PK_NFLAdmin PRIMARY KEY,
        constraint FK_NFLAdmin_AppUser FOREIGN KEY (NFLAdminID) REFERENCES AppUser(AppUserID)
);

GO

GO

create table FanTeam(
    FanTeamID INT identity(1,1)
        constraint PK_FanTeam PRIMARY KEY,
    NFLFanID INT NOT NULL
        constraint FK_FanTeam_NFLFan FOREIGN KEY REFERENCES NFLFan(NFLFanID),
    TeamID INT NOT NULL
        constraint FK_FanTeam_Team FOREIGN KEY REFERENCES Team(TeamID),
    constraint UQ_FanTeam UNIQUE (NFLFanID, TeamID),
    PrimaryTeam BIT NOT NULL
);