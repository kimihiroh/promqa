#!/usr/bin/bash

eval "$(conda shell.bash hook)"
conda activate bridge

filepath_input=./data/our-video-qa/preprocess/original_updated.json
filepath_verbs=./data/our-video-qa/preprocess/error_type_to_verbs.json
dirpath_graph=./data/CaptainCook4D/annotations/task_graphs/
filepath_metadata_video=./data/CaptainCook4D/downloader/metadata/download_links.json
dirpath_output=./data/our-video-qa/preprocess/
dirpath_log=./log/

#
python src/preprocess/create_example.py \
    --filepath_input "$filepath_input" \
    --filepath_verbs "$filepath_verbs" \
    --dirpath_graph "$dirpath_graph" \
    --filepath_metadata_video "$filepath_metadata_video" \
    --dirpath_output "$dirpath_output" \
    --dirpath_log "$dirpath_log"
