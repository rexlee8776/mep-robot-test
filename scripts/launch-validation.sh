#!/bin/bash

echo "Starting check on ROBOT CODE"

for FILE in $(find . -name "*.robot"); do
	echo "Syntax check on ${FILE}"
	robot --dryrun -d /tmp ${FILE}
done
