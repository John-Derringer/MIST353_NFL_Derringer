-- 3 queries 
-- 1 each ConferenceDivision and Team tables, and 1 join query
--Testing
use MIST353_NFL_RDB_Derringer;

--go create or alter procedure proGetTeamByConferenceDivision

--@Conference NVARCHAR(50) = NULL,
--@Division NVARCHAR(50) = NULL

--AS
--BEGIN


SELECT CD.ConferenceDivisionID, CD.Conference, CD.Division
FROM ConferenceDivision AS CD
ORDER BY CD.Conference, CD.Division;

SELECT T.TeamName, T.TeamCityState, T.pyTeamColors
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