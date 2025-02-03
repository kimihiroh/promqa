#!/usr/bin/bash

eval "$(conda shell.bash hook)"
conda activate bridge

current_time=$(date "+%Y%m%d-%H%M%S")

# preprocess videos
filepath_input=./data/examples.json
dirpath_original_video=$1
dirpath_output=$2
dirpath_log=./log/
mkdir -p $dirpath_log

NUM_PROCESS=$(( $(nproc) / 2 ))

## == trim video == ##
mkdir -p "$dirpath_output"/trimmed-videos/360p/
mkdir -p "$dirpath_output"/trimmed-videos/2160p/
video_list=()
echo "Start video trimming: $(date)"
while read -r item; do
    recording_id=$(echo "$item" | jq -r '.recording_id')
    example_id=$(echo "$item" | jq -r '.example_id')
    end_time=$(echo "$item" | jq -r '.end_time')

    # 360p
    filepath_input_360="$dirpath_original_video"/resolution_360p/"$recording_id"_360p.mp4
    filepath_output_360="$dirpath_output"/trimmed-videos/360p/"$example_id".mp4
    video_list+=("$end_time $filepath_input_360 $filepath_output_360")

    # 2160p
    filepath_input_2160="$dirpath_original_video"/resolution_4k/"$recording_id"_4K.mp4
    filepath_output_2160="$dirpath_output"/trimmed-videos/2160p/"$example_id".mp4
    video_list+=("$end_time $filepath_input_2160 $filepath_output_2160")
done < <(jq -c '.[]' "$filepath_input")

parallel -j "$NUM_PROCESS" --colsep ' ' ffmpeg -ss 00:00:00 -to "{1}" -i "{2}" -c copy "{3}" >> $dirpath_log/trim_"${current_time}".log 2>&1 ::: "${video_list[@]}"
echo "End video trimming: $(date)"


## == sample w/&w/o resize == ##
mkdir -p "$dirpath_output"/sampled-frames/360p/
mkdir -p "$dirpath_output"/sampled-frames/288p/
mkdir -p "$dirpath_output"/sampled-frames/2160p/
mkdir -p "$dirpath_output"/sampled-frames/765p/
echo "Start image sampling/resizing: $(date)"
triples=()
for filepath in "$dirpath_output"/trimmed-videos/360p/*; do
    example_id=$(basename  "${filepath%.mp4}")
    triples+=("$filepath 640 $dirpath_output/sampled-frames/360p/$example_id")
    mkdir -p "$dirpath_output"/sampled-frames/360p/"$example_id"
    triples+=("$filepath 512 $dirpath_output/sampled-frames/288p/$example_id")
    mkdir -p "$dirpath_output"/sampled-frames/288p/"$example_id"
done
for filepath in "$dirpath_output"/trimmed-videos/2160p/*; do
    example_id=$(basename  "${filepath%.mp4}")
    triples+=("$filepath 3840 $dirpath_output/sampled-frames/2160p/$example_id")
    mkdir -p "$dirpath_output"/sampled-frames/2160p/"$example_id"
    triples+=("$filepath 1360 $dirpath_output/sampled-frames/765p/$example_id")
    mkdir -p "$dirpath_output"/sampled-frames/765p/"$example_id"
done
parallel -j "$NUM_PROCESS" --colsep ' ' ffmpeg -i "{1}" -vf "fps=1,scale={2}:-1" "{3}"/%d.png >> $dirpath_log/sample_"${current_time}".log 2>&1 ::: "${triples[@]}"
echo "End image sampling/resizing: $(date)"
