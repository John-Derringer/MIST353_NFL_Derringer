import os
import pyodbc
from dotenv import load_dotenv

load_dotenv()

def get_db_connection():
    server = os.getenv("DB_SERVER")
    database = os.getenv("DB_NAME")
    username = os.getenv("DB_LOGIN")
    password = os.getenv("DB_PASSWORD")

    # For Azure SQL Database, username should be in format user@server
    if '@' not in username:
        username = f"{username}@{server.split('.')[0]}"

    connection_string = (
        "DRIVER={ODBC Driver 18 for SQL Server};"
        f"SERVER=tcp:{server},1433;"
        f"DATABASE={database};"
        f"UID={username};"
        f"PWD={password};"
        "Encrypt=yes;"
        "TrustServerCertificate=yes;"  # Changed to yes for Azure
        "Connection Timeout=30;"
    )

    conn = pyodbc.connect(connection_string)
    return conn
