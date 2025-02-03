#!/usr/bin/bash

eval "$(conda shell.bash hook)"
conda activate bridge

# # preprocess videos, frames, and graphs
filepath_input=$1/samples.json
filepath_graph=$1/all_graphs.json
dirpath_output=$2
dirpath_log=./log/

python src/preprocess/instruction.py \
    --filepath_input "$filepath_input" \
    --filepath_graph "$filepath_graph" \
    --dirpath_output "$dirpath_output" \
    --dirpath_log "$dirpath_log"
