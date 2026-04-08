from get_db_connection import get_db_connection

def get_teams_for_specified_fan(nfl_fan_id: int):

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute(
        "{call proGetTeamsForSpecifiedFan(?)}",
        (nfl_fan_id,)
    )

    rows = cursor.fetchall()
    conn.close()

    # convert pyodbc.Row objects to dicts
    results = [
        {
            "TeamID": row.TeamID,
            "TeamName": row.TeamName,
            "Conference": row.Conference,
            "Division": row.Division,
            "TeamColors": row.TeamColors
        }
        for row in rows
    ]

    return {"data": results}