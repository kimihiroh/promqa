#!/usr/bin/bash

eval "$(conda shell.bash hook)"
conda activate bridge

filepath_input=$1/samples.json
filepath_template=src/generation/templates.yaml
dirpath_output=$1
filepath_graph=$1/all_graphs.json
dirpath_log=./log/

model_id=gpt-4o-2024-08-06
template_type=step-target

python src/generation/run.py \
    --filepath_input "$filepath_input" \
    --filepath_template "$filepath_template" \
    --filepath_graph "$filepath_graph" \
    --dirpath_output "$dirpath_output" \
    --model_id "$model_id" \
    --template_type "$template_type" \
    --dirpath_log "$dirpath_log"
