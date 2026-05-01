import streamlit as st
from fetch_data import post_data, fetch_data
from datetime import date, time

def schedule_game_ui():
    st.header("Schedule a Game")

    # Fetch all teams and stadiums for dropdowns
    parameters = {}
    teams_df = fetch_data("get_all_teams/", parameters)
    stadiums_df = fetch_data("get_all_stadiums/", parameters)

    GAME_ROUNDS = ["Wild Card", "Divisional", "Conference", "Super Bowl"]

    # Create dropdowns for home team, away team, and stadium
    team_options = dict(zip(teams_df["team_name"], teams_df["team_id"]))
    stadium_options = dict(zip(stadiums_df["stadium_name"], stadiums_df["stadium_id"]))

    home_team_name = st.selectbox("Select Home Team", options=team_options.keys())
    away_team_name = st.selectbox("Select Away Team", options=team_options.keys())
    stadium_name = st.selectbox("Select Stadium", options=stadium_options.keys())
    game_round = st.selectbox("Select Game Round", options=GAME_ROUNDS)

    game_date = st.date_input("Select Game Date", min_value=date.today())
    game_start_time = st.time_input("Select Game Start Time", value=time(13, 0))

    if st.button("Schedule Game"):
        if home_team_name == away_team_name:
            st.warning("Home team and away team cannot be the same. Please select different teams.")
            return

        home_team_id = team_options[home_team_name]
        away_team_id = team_options[away_team_name]
        stadium_id = stadium_options[stadium_name]

        parameters = {}
        parameters["home_team_id"] = home_team_id
        parameters["away_team_id"] = away_team_id
        parameters["game_date"] = game_date.isoformat()
        parameters["game_start_time"] = game_start_time.isoformat()
        parameters[stadium_id] = stadium_id
        parameters["game_round"] = game_round
        parameters["nfl_admin_id"] = st.session_state.app_user_id
        


        response = post_data("schedule_game/", parameters)

        if response is not None:
            st.success(response.get("status_message", "Game scheduled successfully."))
        else:
            st.error("Failed to schedule game. Please try again.")