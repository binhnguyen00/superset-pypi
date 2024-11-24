function show_help() {
  echo """
Usage: Superset commands
  ./database.sh [COMMAND] [OPTION]

Run Superset
  ./superset.sh [port]

Active Python Virtual Environment
  ./superset.sh active-env

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
elif [ "$COMMAND" = "help" ] ; then
  show_help
else
  show_help
fi