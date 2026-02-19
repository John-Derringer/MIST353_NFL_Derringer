-- 3 queries 
-- 1 each ConferenceDivision and Team tables, and 1 join query
use MIST353_NFL_RDB_Derringer;


GO

SELECT CD.ConferenceDivisionID, CD.Conference, CD.Division
FROM ConferenceDivision AS CD
ORDER BY CD.Conference, CD.Division;

SELECT T.TeamName, T.TeamCityState, T.TeamColors
FROM Team AS T
ORDER BY T.TeamName;

SELECT T.TeamName, T.TeamCityState, CD.Conference, CD.Division
FROM Team AS T
INNER JOIN ConferenceDivision AS CD ON T.ConferenceDivisionID = CD.ConferenceDivisionID