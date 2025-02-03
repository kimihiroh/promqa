#!/usr/bin/bash

eval "$(conda shell.bash hook)"
conda activate bridge

# # preprocess videos, frames, and graphs
filepath_input=./data/preprocess/samples.json
filepath_graph=./data/preprocess/all_graphs.json
dirpath_output=./data/preprocess/images/
dirpath_log=./log/

python src/preprocess/instruction.py \
    --filepath_input "$filepath_input" \
    --filepath_graph "$filepath_graph" \
    --dirpath_output "$dirpath_output" \
    --dirpath_log "$dirpath_log"
