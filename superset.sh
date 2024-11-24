#!/bin/bash

ENV_FILE=".env"

function show_help() {
  echo """
!IMPORTANT: This script can only work on MacOS. Windows will be supported in the near future

Usage: Superset commands
  ./database.sh [COMMAND] [OPTION]

Run Superset
  ./superset.sh [port]

Active Python Virtual Environment
  ./superset.sh active-env

Export Flask App
  ./superset.sh export-flask-app

!IMPORTANT: Best to run this command only once or twice
Generate Secret Key
  ./superset.sh generate-secret-key  

!IMPORTANT: Best to run this command after active-env
Export Secret Key
  ./superset.sh export-secret-key
"""
}

function run() {
  PORT="$@"
  if [ -z "$PORT" ]; then PORT=8088; fi
  export_flask_app
  superset run -p $PORT --with-threads --reload --debugger
}

function export_flask_app() {
  export FLASK_APP=superset
}

function generate_secret_key() {
  SECRET_KEY=$(openssl rand -base64 32 | tr -d '\n')
  echo "SUPERSET_SECRET_KEY=${SECRET_KEY}" >> "${ENV_FILE}"
  echo $SECRET_KEY
}

function export_secret_key() {
  if [ -f ".env" ]; then
    SECRET_KEY=$(tail -n 1 .env | awk -F'=' '{print $2}')
    if [ -n "$SECRET_KEY" ]; then
      export SUPERSET_SECRET_KEY="$SECRET_KEY"
      echo """
=================================================
SUPERSET_SECRET_KEY: 
    $SUPERSET_SECRET_KEY
=================================================
      """
    else
      echo "No SUPERSET_SECRET_KEY found"
    fi
  else
    echo ".env file does not exist."
  fi
}

COMMAND=$1;
if [ -n "$COMMAND" ]; then
  shift
else
  echo "No command provided. Showing help..."
  show_help
  exit 1
fi

if [ "$COMMAND" = "run" ] ; then
  run
elif [ "$COMMAND" = "active-env" ] ; then
  exec poetry shell
elif [ "$COMMAND" = "export-flask-app" ] ; then
  export_flask_app
elif [ "$COMMAND" = "export-secret-key" ] ; then
  export_secret_key
elif [ "$COMMAND" = "generate-secret-key" ] ; then
  generate_secret_key
elif [ "$COMMAND" = "help" ] ; then
  show_help
else
  show_help
fi