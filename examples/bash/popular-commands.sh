#!/bin/bash

: '
This example shows how we can use text processing tools to find your most
popular commands on the current computer. The shell you are using keeps a
history file of all the commands you use. It includes things like the time when
you ran it and what the arguments were.

We just want to extract the command and drop the timestamp and arguments.

However, depending on what shell you are using the history format could be
different. You will see below how we test for the current shell and configure
the script.

The overall flow is:
- print the history file
- extract command from the history format
- sort the file so we can count the duplicates
- group and count the commands
- sort them in reverse order by count
- take the first 30 entries
'

# There are at least 2 popular shells you can expect to use: bash or zsh. Bash
# is likely to be on every machine, and zsh is something you might try out.
# This first command finds the command history file for the current shell
HISTORY_FILE=
PARSE_PROGRAM=
PARSE_DELIMITER=
if [ -z $(grep "zsh" <(echo $SHELL)) ]; then
  HISTORY_FILE=~/.bash_history
  PARSE_PROGRAM='{print $1}'
  PARSE_DELIMITER=' '
else
  HISTORY_FILE=~/.zsh_history
  PARSE_PROGRAM='{print $5}'
  PARSE_DELIMITER='[:; ]'
fi

cat $HISTORY_FILE \
  | awk -F "$PARSE_DELIMITER" "$PARSE_PROGRAM" \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -n 30
