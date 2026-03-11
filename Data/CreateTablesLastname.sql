-- Create a database for NFL app
--use m;

--CREATE DATABASE MIST353_NFL_RDB_Derringer;

--DROP database NFL_RDB_Derringer
-- Step 1: Create a login at the server level

use mist353;

CREATE LOGIN NandaSurendra

WITH PASSWORD = 'MI$T353Instructor';



-- Step 2: Switch to your target database

USE MIST353_NFL_RDB_Derringer;



-- Step 3: Create a database user mapped to the login

CREATE USER NandaSurendra

FOR LOGIN NandaSurendra;



-- Step 4: Grant EXECUTE permission on all stored procedures and UDFs

GRANT EXECUTE TO NandaSurendra;



-- Read access to all tables

GRANT SELECT TO NandaSurendra;


if(OBJECT_ID('Team') IS NOT NULL)
    DROP TABLE Team;

if(OBJECT_ID('ConferenceDivision') IS NOT NULL)
    DROP TABLE ConferenceDivision;

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
