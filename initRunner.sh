#!/bin/bash

cd actions-runner
if [ ! -f created.log ]
then
	./config.sh --url $GITHUB_REPO_URL --token $GITHUB_TOKEN
fi
echo "created" > created.log
./run.sh
