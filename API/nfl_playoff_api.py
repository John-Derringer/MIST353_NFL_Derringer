from fastapi import FastAPI
from get_teams_by_conference_division import get_teams_by_conference_division
app = FastAPI()
@app.get("/team")
def read_team(conference: str = None, division: str = None):
    return get_teams_by_conference_division(conference=conference, division=division)