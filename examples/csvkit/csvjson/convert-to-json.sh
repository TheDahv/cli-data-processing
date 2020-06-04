#! /bin/sh

: '
Here, we will prepare some sample data to GeoJSON format that we could send to
an API.

We can start with data obtained from:
https://support.spatialkey.com/spatialkey-sample-csv-data/

We have it downloaded in the inputs folder for convenience.

First we want to turn the CSV file into JSON:

  cat $INPUT | csvjson

The tool does all the work of parsing the fields and even converting the values
to the appropriate JSON type.

If there were any escape values in the file (e.g., extra quotes or
double-quotes) we could tell csvjson with the -p flag. But there are not any
like that in this example.

Our target API might not take a bulk array of objects, so we can break it up to
emit one object per row with --stream

  cat $INPUT | csvjson --stream

csvjson is also powerful in that it knows how to format data containing
geo-spatial information (latitude and longitude) into a common format for
describing mapping data: GeoJSON. Our sample data has that information, so we
can emit that as well.

  # Show the fields with csvcut -n $INPUT
  cat $INPUT | csvjson --stream --lat point_latitude --lon point_longitude

Suppose you need to drop unneeded fields or rename some columsn. jq can take
this output and filter it further. The example is included in the final script
below.

Finally, we can send all of this to a file or we can pipe it directly into a
program to send to an API.
'

INPUT="$(dirname $0)/../../inputs/FL_insurance_sample.csv"

# We just want to find a free service hosting dummy API endpoints: https://reqres.in/
API_URL=https://reqres.in/api/properties

cat $INPUT \
  | head -n5 \
  | csvjson --stream --lat point_latitude --lon point_longitude \
  | jq -cr '
      { type, geometry }
      + (
        .properties
        | {
            properties: {
              policyID,
              line,
              material: .construction
            }
          }
        )
    ' \
  | parallel -N1 "echo {} | curl -s $API_URL -XPOST -H 'Content-Type: application/json' -d @-"

# Normally we'd use xargs to split each line as its own input to the next
# command rather than sending all at once. xargs has a hard time with quoted
# content (like JSON payloads), so we install and use "parallel" instead
