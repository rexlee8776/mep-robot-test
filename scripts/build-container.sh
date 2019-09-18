#!/bin/bash
# Copyright ETSI 2019
# See: https://forge.etsi.org/etsi-forge-copyright-statement.txt

#set -e
set -vx

DOCKER_FILE=./scripts/docker/Dockerfile
if [ -f ${DOCKER_FILE} ]
then
    #check and build stf569-rf image
    DOCKER_ID=`docker ps -a | grep -e stf569-rf | awk '{ print $1 }'`
    if [ ! -z "${DOCKER_ID}" ]
    then
        docker rm --force stf569-rf
    fi
    docker build --tag stf569-rf --force-rm -f ${DOCKER_FILE} .
    if [ "$?" != "0" ]
    then
        echo "Docker build failed: $?"
        exit -1
    fi
    docker image ls -a
    docker inspect stf569-rf:latest
    if [ "$?" != "0" ]
    then
        echo "Docker inspect failed: $?"
        exit -2
    fi
else
    exit -3
fi

# That's all Floks
exit 0

