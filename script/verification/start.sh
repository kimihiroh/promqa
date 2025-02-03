#!/usr/bin/bash

cd ./src/verification/ || exit

filepath_input=./data/generation/samples.json
filepath_output=./data/verification/samples.json
foldername=videos

num_worker=2
host=0.0.0.0
port=5000

secret_key=$(head -c 24 /dev/urandom | base64)

FILEPATH_INPUT="$filepath_input" FILEPATH_OUTPUT="$filepath_output" \
FOLDERNAME="$foldername" SECRET_KEY="$secret_key" \
    gunicorn -w "$num_worker" -b "$host":"$port" app:app
