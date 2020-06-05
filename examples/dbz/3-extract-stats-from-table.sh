#! /bin/sh

: '
This introduces a lot of new, more advanced jq operators and filters you
not yet seen. We will go through each step:

Filter out empty rows:
    map(select(.children[1] | (.children)?))

Some of the rows are weird header rows, but they are consistent in that they
lack entries for the character and power columns. So we just limit to rows that
have the data we want.

Extract DOM elements with the data we want:
  map({
    name: (.children[1].children[0].text),
    power: (.children[2].text | gsub("[^0-9]"; "") | tonumber)
  })

Recall we are processing the output from pup, so there are lost of nested
objects to mirror the DOM structure. We want to end up with a simple pair of
the character names and the power level for that table.

Also, note that the original source has garbage numbers like "1,000,0000
(almost)". We want neither commas nor commentary, so we clean the input string
and turn it into a number.

Group all the character data:
  group_by(.name)

Now that we have raw data, gather all of them by character so we can calculate
averages for that character.

Calculate statistics for each group:
  map({
    name: .[0].name,
    avgPower: ((map(.power) | add) / (map(.power) | length)),
    minPower: (map(.power) | min),
    maxPower: (map(.power) | max),
  })

This looks hairy, but review what we know. We have an array of grouped data, and
each group is an array of name/power objects.

We use a map operator to run a set of transformations and produce a single
result object for each group.

Getting the name is easy: get the first entry in the group and pick the name.

To get aggregate calculations, we need to get the list of power entries. Recall,
we are already in a map function for a given group, so we can map again on the
entries in the group to pluck out the power values. This little command can then
be piped to other operators to do the math and boil down to one value.

Emit a flat stream of results rather than a single array result:
  .[]
'

# Important note!!!
# jq 1.6 seems to have trouble with the "?//" operator
# jq 1.5 does not, so these examples use that version.
# It's not a common operator, so you may not have to care, but just be aware
# what you install on your computer
cat extracted-table-rows.json \
  | jq -c '
    map(select(.children[1] | (.children)?))
    | map({
      name: (.children[1].children[0].text),
      power: ((.children[2].text | gsub("[^0-9]"; "") ?// "0") | tonumber)
    })
    | .[]' \
  > extracted-stats.ndjson
