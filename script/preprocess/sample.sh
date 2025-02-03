#!/usr/bin/bash

eval "$(conda shell.bash hook)"
conda activate bridge

filepath_input=$1/all_examples.json
dirpath_output=$1
dirpath_log=./log/

python src/preprocess/sample.py \
    --filepath_input "$filepath_input" \
    --dirpath_output "$dirpath_output" \
    --dirpath_log "$dirpath_log" \
