import streamlit as st

FastAPI_URL = "http://localhost:8000"


def fetch_data(endpoint: str, input_params: dict, method: str = "Get"):
    if method == "Get":
        response = requests.get(f"{FastAPI_URL}/{endpoint}", params=input_params)

        if response.status_code == 200:
            payload =response.json()
            rows = payload.get("data", [])
            df = pd.DataFrame(rows)
        
