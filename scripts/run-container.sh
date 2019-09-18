#!/bin/bash
# Copyright ETSI 2019
# See: https://forge.etsi.org/etsi-forge-copyright-statement.txt

#set -e
#set -vx

docker run stf569-rf:latest "/bin/bash" \
	-c  "cd /home/etsi/dev/robot \
	    && sh scripts/run-all.bash \
      && ls -ltr logs/"

# That's all Floks
exit $?

