#!/usr/bin/bash

eval "$(conda shell.bash hook)"
conda activate bridge

filepath_error=./data/CaptainCook4D/annotations/annotation_json/error_annotations.json
filepath_activity=./data/CaptainCook4D/annotations/annotation_json/complete_step_annotations.json
filepath_step=./data/CaptainCook4D/annotations/annotation_json/activity_idx_step_idx.json
dirpath_graph=./data/CaptainCook4D/annotations/task_graphs/
dirpath_output=./data/our-video-qa/preprocess/
dirpath_log=./log/

# preprocess error annotation of captaincook4d
python src/preprocess/update_annotation.py \
    --filepath_error "$filepath_error" \
    --filepath_activity "$filepath_activity" \
    --filepath_step "$filepath_step" \
    --dirpath_graph "$dirpath_graph" \
    --dirpath_output "$dirpath_output" \
    --dirpath_log "$dirpath_log"
