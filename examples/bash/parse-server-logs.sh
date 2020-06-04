#!/bin/bash

: '
Those of us that have to work with web servers can often find a lot of
information in the log files of that system: frequent visitors, popular pages,
and problem areas.

You might have used tools that can help you analyze log files you upload to your
computer. But you also have tools right on your computer for many of these
tasks!

Apache and Nginx are 2 popular web servers and they maintain slightly different
formats in their logs. This script has parsing arguments for both formats and a
few common tasks.

The Elastic company -- the one that builds Elasticsearch -- provides a couple
sample logs for us to play with.

Our overall flow will be:

- download the log file we want
- parse out the field we are interested in
- group and count them for some basic analysis

This makes use of some basic shell scripting to use the same script for both
servers.

Call it with:

./parse-server-logs.sh <apache|nginx> <task>

Useful links:
- https://easyengine.io/tutorials/nginx/log-parsing/
- https://neilen.com.au/2018/09/06/parsing-nginx-logs-using-awk
'

SERVER=$1
TASK=$2

case "$SERVER" in
  apache)
    URL=https://raw.githubusercontent.com/elastic/examples/master/Common%20Data%20Formats/apache_logs/apache_logs
    ;;
  nginx)
    URL=https://raw.githubusercontent.com/elastic/examples/master/Common%20Data%20Formats/nginx_logs/nginx_logs
    ;;
  *)
    echo "unrecognized web server: $1"
    exit 1
    ;;
esac

case "$TASK" in
  # Get raw logs
  raw-logs)
    curl -s $URL
    ;;

  # Requests by user agent
  user-agents)
    curl -s $URL \
      | awk -F'"' '{print $6}' \
      | sort \
      | uniq -c \
      | sort -nr \
      | head -n10
    ;;

  # Find all requested pages that returned a 404
  404-pages)
    curl -s $URL \
      | awk -F '"' '/ 404 / {print $2}' \
      | sort \
      | uniq -c \
      | sort -nr \
      | head -n10
    ;;

  # Find IP addresses asking for a specific page
  requester-for-page)
    curl -s $URL \
      | grep $3 \
      | awk '{print $1}' \
      | sort \
      | uniq -c \
      | sort -nr \
      | head -n10
    ;;

  *)
    echo "unknown command: $TASK"
    exit 1
    ;;
esac
