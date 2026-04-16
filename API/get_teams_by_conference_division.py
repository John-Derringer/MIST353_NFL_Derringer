from get_db_connection import get_db_connection

def get_teams_by_conference_division(
    conference: str = None,
    division: str = None
):

    conn = get_db_connection()
    cursor = conn.cursor()
    #cursor.execute("{call proGetTeamByConferenceDivision(?, ?)}", (conference, division))
    cursor.callproc("proGetTeamByConferenceDivision", (conference, division))
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