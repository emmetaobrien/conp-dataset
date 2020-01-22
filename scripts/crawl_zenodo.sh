#!/usr/bin/env bash

set -e
set -u

BASEDIR=$HOME/conp-dataset
mkdir -p ${BASEDIR}/log
DATE=$(date)
LOGFILE=$(mktemp ${BASEDIR}/log/crawler-XXXXX.log)
TOUCHFILE=${BASEDIR}/.crawling
# Add user tokens here (separated by space), or edit file $HOME/.token
TOKEN_LIST="w4M00bgKOLzWDCHdFGeXc2wzaE9ftmedZAcneqTQEO9qQK4G3A7ez7CfOS7Y"

echo  "**** STARTING ZENODO CRAWL at ${DATE}, LOGGING IN ${LOGFILE} ****" &>>$HOME/crawl_zenodo.log
test -f ${TOUCHFILE} && (echo "Another crawling process is still running (${TOUCHFILE} exists), exiting!" &>>${LOGFILE}; exit 1 )

# We are in the protected section
touch ${TOUCHFILE}

(cd ${BASEDIR} && git pull main master)

docker run --rm -u $UID:$UID -v $HOME:$HOME -e HOME=$HOME -v ${BASEDIR}:/workdir -w /workdir bigdatalabteam/git-annex python3 ./scripts/crawl_zenodo.py --force --verbose -z ${TOKEN_LIST} &>>${LOGFILE}
\rm ${TOUCHFILE}