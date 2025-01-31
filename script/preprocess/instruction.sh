#!/usr/bin/bash

eval "$(conda shell.bash hook)"
conda activate bridge

# # preprocess videos, frames, and graphs
filepath_input=./data/our-video-qa/preprocess/$1
filepath_graph=./data/our-video-qa/preprocess/all_graphs.json
dirpath_output=/usr1/data/kimihiro/bridge/$2
dirpath_log=./log/

python src/preprocess/instruction.py \
    --filepath_input "$filepath_input" \
    --filepath_graph "$filepath_graph" \
    --dirpath_output "$dirpath_output" \
    --dirpath_log "$dirpath_log"
