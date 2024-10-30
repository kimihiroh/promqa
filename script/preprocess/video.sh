#!/usr/bin/bash

eval "$(conda shell.bash hook)"
conda activate promqa

# preprocess videos, frames, and graphs
filepath_input=./data/examples.json
dirpath_original_video=$1
dirpath_output=$2
dirpath_log=./log/

python src/preprocess/video.py \
    --filepath_input "$filepath_input" \
    --dirpath_original_video "$dirpath_original_video" \
    --dirpath_output "$dirpath_output" \
    --dirpath_log "$dirpath_log"
