from get_db_connection import get_db_connection

def get_teams_in_same_conference_division_as_specified_team(
    team_name: str
):
    #width get_db_connection() as conn:
    
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("{call proGetTeamsInSameConferenceDivisionAsSpecifiedTeam(?)}", (team_name,))
    rows = cursor.fetchall()
    conn.close()

    #convert pyodbc.Row objects to dicts
    results = [
      {  "TeamName": row.TeamName,
        "Conference": row.Conference,
        "Division": row.Division,
        "TeamColors": row.TeamColors
      }
      for row in rows
    ]
    return {"data": results}