gunicorn -w 4 -k uvicorn.workers.UvicornWorker nfl_playoff_api:app
