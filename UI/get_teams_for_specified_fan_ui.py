import streamlit as st
from fetch_data import fetch_data

def get_teams_for_specified_fan_ui():
    st.header("Get Teams for Specified NFL Fan")

    nfl_fan_id = st.text_input("Enter NFL Fan ID")

    if st.button("Fetch Teams"):
        if not nfl_fan_id.strip():
            st.warning("Please enter an NFL Fan ID.")
        else:
            input_params = {}
            input_params["NFLFanID"] = nfl_fan_id.strip()

            df = fetch_data("fan/teams", input_params)

            if df is not None and not df.empty:
                st.subheader(f"Teams for NFL Fan ID: {nfl_fan_id}")
                st.dataframe(df, use_container_width=True, hide_index=True)
            else:
                st.info(
                    f"No teams found for NFL Fan ID {nfl_fan_id}. Please check the ID and try again."
                )