from get_db_connection import get_db_connection

def validate_user(
    email: str,
    password_hash: str
):

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("{call proValidateUser(?, ?)}", (email, password_hash))
    rows = cursor.fetchall()
    conn.close()
    
    #convert pyodbc.Row objects to dicts
    results = [
      {  "AppUserID": row.AppUserID,
        "Fullname": row.Fullname,
        "UserRole": row.UserRole
      }
      for row in rows
    ]

    return {"data": results}