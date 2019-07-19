#!/bin/bash

## Launch robot tests validator

/bin/bash /scripts/launch-validation.sh > logs/robot_stdout.log 2> logs/robot_stderr.log

## Filter failed Keywords
grep -r10n "| FAIL |" logs/robot_stdout.log  | grep -v "Output:" | grep -v "Log:" | grep -v "Report:" > logs/failures.log
rm -f logs/robot_stdout.log


## Filter Errors on code
grep -rn " ERROR " logs/robot_stderr.log | grep -v "File has no tests or tasks" > logs/errors.log
rm -f logs/robot_stderr.log
