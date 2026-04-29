from get_db_connection import get_db_connection
import pymssql

def get_teams_in_same_conference_division_as_specified_team(
        team_name: str
):
    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)

    cursor.execute(
        """
        SELECT OT.TeamName, CD.Conference, CD.Division
        FROM Team MT
        INNER JOIN Team OT ON MT.ConferenceDivisionID = OT.ConferenceDivisionID
        INNER JOIN ConferenceDivision CD ON OT.ConferenceDivisionID = CD.ConferenceDivisionID
        WHERE MT.TeamName = %s AND OT.TeamName != %s
        """,
        (team_name, team_name)
    )

    rows = cursor.fetchall()
    conn.close()

    results = [
        {
            "TeamName": row["TeamName"],
            "Conference": row["Conference"],
            "Division": row["Division"]
        }
        for row in rows
    ]

    return {"data": results}