#! /bin/bash

: '
In this example, we will do a simple exercise of looking up weather station
reports given some station codes.
I have no particular affinity for this, but they have a demo API I do not have
to sign up for.

Read more about the API at
https://www.weather.gov/documentation/services-web-api
Stations pulled from http://weather.rap.ucar.edu/surface/stations.txt

Here are the steps we will use:
- First we get the list of codes as input by printing them from the text file
  they are stored in
- xargs is a program that lets us run each line from the input through another
  command. We are using "curl" to issue the Web request, using xargs to
  replace the station code in the URL.
- Each response is passed to JQ
'

INPUT="$(dirname $0)/../../inputs/station-codes"
PRERECORDED_RAW="$(dirname $0)/raw-results.ndjson"

AGENT='(CLI Tutorial, david.dean.pierce@gmail.com)'
ACCEPT='application/ld+json'

# If the API is unavailable, use pre-saved data in $PRERECORDED_RAW
#cat $INPUT \
#  | xargs -P 2 -I {} curl -s "https://api.weather.gov/stations/{}/observations/latest" \
cat $PRERECORDED_RAW \
  | jq -c '
      (.geometry.coordinates | { lat: .[0], lon: .[1] }) +
      (
        .properties
        | {
            station,
            summary: .textDescription,
            temperature: .temperature.value,
            clouds: .cloudLayers | map(.amount) | join(", ")
          }
      )
  '
