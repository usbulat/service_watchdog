#!/bin/bash

usage="$(basename "$0") [-h] [-c config_file] -- watchdog for service restart if string is found in specified log file

where:
    -h  show this help text
    -c  config file path (default: service_watchdog.cfg)"

# Default config path
CONFIG_FILE="service_watchdog.cfg"

while getopts ':hc:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    c) CONFIG_FILE=$OPTARG
       ;;
    :) printf "Missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
    \?) printf "Illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

# Getting watchdog parameters
if [ -f "$CONFIG_FILE" ]; then
  source $CONFIG_FILE
else
  echo "Config file $CONFIG_FILE doesn't exist!"
  exit 2
fi

# If missing parameters, then exiting and logging about it
if [ -z "$log_file" ]; then
  echo "Log file path is not specified in config file!"
  exit 3
elif [ -z "$search_string" ]; then
  echo "Search string is not specified in config file!"
  exit 4
fi

# Checking if log file exists
if [ ! -f "$log_file" ]; then
  echo "$log_file log file doesn't exist!"
  exit 5
fi

# Parsing each new log line for search string occurrence
tail -n1 -f $log_file | while read l
  do
    if [[ "$l" == *"$search_string"* ]]; then
      SERVICE=$(echo $l | awk '{print $5}' | sed 's/.$//')
      # Restarting the service
      echo "Service $SERVICE will be restarted."
      systemctl restart backend@$SERVICE.service
      RESULT=$?
      if $RESULT; then
        echo "Service $SERVICE was restarted."
      else
        echo "Service $SERVICE restart failed!"
      fi
    fi
  done
