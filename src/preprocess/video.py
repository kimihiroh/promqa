"""
Preprocess videos and instructions

Create
* status image
* trimmed video
* sampled frames
* sampled frames after resizing

"""

from argparse import ArgumentParser
import logging
from pathlib import Path
import json
import pydot
from tqdm import tqdm
import subprocess
from datetime import datetime


def get_date(granularity="min") -> str:
    """
    get date

    """
    date_time = datetime.now()
    if granularity == "min":
        str_data_time = date_time.strftime("%Y%m%d-%H%M")
    elif granularity == "day":
        str_data_time = date_time.strftime("%Y%m%d")
    else:
        logging.error(f"Undefined timestamp granularity: {granularity}")

    return str_data_time


def load_data(filepath: Path) -> list[dict[str, str | float]]:
    with open(filepath, "r") as f:
        return json.load(f)


def create_folders(dirpaths: list[Path]) -> None:
    """create folders if not exists"""
    for dirpath in dirpaths:
        if not dirpath.exists():
            logging.info(f"Creating dir: {str(dirpath)}")
            dirpath.mkdir(parents=True)


def main(args):
    with open(args.filepath_input, "r") as f:
        examples = json.load(f)

    # create folders
    create_folders(
        [
            args.dirpath_output / "trimmed-videos/4K",
            args.dirpath_output / "sampled-frames/4K",
            # args.dirpath_output / "sampled-frames/765p",
        ]
    )

    """
    1. trimmed video (4K)
    2. sampled frames (4K)
    3. resized frames (1360x765)
    """
    for example in tqdm(examples):
        # 1. trim video
        filepath_original_video = (
            args.dirpath_original_video
            / f"resolution_4k/{example['recording_id']}_4K.mp4"
        )
        filepath_output_trimmed_video = (
            args.dirpath_output / f"trimmed-videos/4K/{example['example_id']}.mp4"
        )
        if not filepath_output_trimmed_video.exists():
            subprocess.run(
                [
                    "ffmpeg",
                    "-ss",
                    "00:00:00",
                    "-to",
                    example["end_time"],
                    "-i",
                    filepath_original_video,
                    "-c",
                    "copy",
                    "-threads",
                    args.num_threads,
                    filepath_output_trimmed_video,
                ]
            )

        # 2. frame sampling: 1 file per second
        dirpath_output_sampled = (
            args.dirpath_output / f"sampled-frames/4K/{example['example_id']}"
        )
        if not dirpath_output_sampled.exists():
            create_folders([dirpath_output_sampled])
            subprocess.run(
                [
                    "ffmpeg",
                    "-i",
                    filepath_output_trimmed_video,
                    "-vf",
                    "fps=1",
                    "-threads",
                    args.num_threads,
                    dirpath_output_sampled / "%d.png",
                ]
            )

        # sanity check
        splits = example["end_time"].split(":")
        num_frames = int(splits[0]) * 3600 + int(splits[1]) * 60 + int(splits[2])
        if num_frames != len([x for x in dirpath_output_sampled.glob("*.png")]):
            logging.error(
                "Potential sampling error: #frames does not match with duration"
            )
        
        # # 3. frame sample & resize: 1fps & width=765
        # dirpath_output_resized = (
        #     args.dirpath_output / f"sampled-frames/765p/{example['example_id']}"
        # )
        # if not dirpath_output_resized.exists():
        #     create_folders([dirpath_output_resized])
        #     subprocess.run(
        #         [
        #             "ffmpeg",
        #             "-i",
        #             filepath_output_trimmed_video,
        #             "-vf",
        #             f"fps=1,scale={args.resized_width}:-1",
        #             "-threads",
        #             args.num_threads,
        #             dirpath_output_resized / "%d.png",
        #         ]
        #     )


if __name__ == "__main__":
    parser = ArgumentParser(description="Preprocess videos and instructions")
    parser.add_argument("--filepath_input", type=Path, help="filepath to input data")
    parser.add_argument(
        "--dirpath_original_video", type=Path, help="dirpath to original video"
    )
    parser.add_argument("--dirpath_output", type=Path, help="dirpath_output")
    parser.add_argument("--fps", type=int, help="max #frames", default=1)
    parser.add_argument("--resized_width", type=int, help="resized width", default=765)
    parser.add_argument(
        "--num_threads", type=str, help="#threads for ffmpeg", default="36"
    )
    parser.add_argument("--dirpath_log", type=Path, help="dirpath for log")
    args = parser.parse_args()

    logging.basicConfig(
        format="%(asctime)s:%(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        level=logging.INFO,
        handlers=[
            logging.StreamHandler(),
            logging.FileHandler(
                args.dirpath_log / f"preprocess_video_{get_date()}.log"
            ),
        ],
    )

    if not args.dirpath_output.exists():
        args.dirpath_output.mkdir(parents=True)

    logging.info(f"Arguments: {vars(args)}")

    main(args)