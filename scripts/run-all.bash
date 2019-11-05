#!/bin/bash

## Launch robot tests validator

mkdir logs

/bin/bash scripts/launch-validation.sh > logs/robot_stdout.log 2> logs/robot_stderr.log

## Filter failed Keywords
grep -r10n "| FAIL |" logs/robot_stdout.log  | grep -v "Output:" | grep -v "Log:" | grep -v "Report:" > logs/failures.log
rm -f logs/robot_stdout.log


## Filter Errors on code
grep -rn " ERROR " logs/robot_stderr.log | grep -v "File has no tests or tasks" > logs/errors.log
rm -f logs/robot_stderr.log


ERRORS=`awk 'END{print NR}' logs/errors.log logs/failures.log`
if [ "${ERRORS}" -eq 0 ]; then
	rm -f logs/errors.log
	rm -f logs/failures.log
fi


if [ -f logs/errors.log ]; then
	cat logs/errors.log
fi

if [ -f logs/failures.log ]; then
	cat logs/failures.log
fi

if [ -f logs/erros.log ] || [ -f logs.failures.log ]; then
	echo "Errors are found. Job failed"
	exit 1
fi

