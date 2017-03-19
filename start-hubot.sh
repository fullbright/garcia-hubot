#!/bin/bash

scriptdirectory="$(dirname "$0")"
echo Moving to script directory $scriptdirectory
cd $(dirname "$0")
echo Current directory is $(pwd)

echo "Starting hubot"

# Load environment specific environment variables
if [ -f .env ]; then
  source .env
fi

./bin/hubot -a slack 

echo "Hubot started"

