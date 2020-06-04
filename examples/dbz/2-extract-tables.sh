#! /bin/sh

pup 'table.wikitable tr:nth-of-type(n+2) json{}' \
  < levels.html \
  > extracted-table-rows.json
