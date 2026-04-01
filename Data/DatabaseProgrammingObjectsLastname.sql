
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