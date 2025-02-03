# ProMQA: Question Answering Dataset for Multimodal Procedural Activity Understanding

This repository contains code and data for "ProMQA: Question Answering Dataset for Multimodal Procedural Activity Understanding" (Hasegawa et al., NAACL 2025) [[arXiv](https://arxiv.org/abs/2410.22211)]. 

## News

* 2025/01/22: This work is accepted to NAACL 2025.
* 2024/10/29: 401 QA pairs are now available.


## Overview

ProMQA is an evaluation QA dataset for multimodal procedural activity understanding.

![Overview](https://github.com/kimihiroh/promqa/blob/main/docs/overview.png)

Given a recipe (text), a recording (video), and a question (text), the task is to predict an answer (text).

![Formulation](https://github.com/kimihiroh/promqa/blob/main/docs/formulation.png)

## Environment Setup

OS: `Ubuntu 24.04.1 LTS x86_64`.

### Virtual environment
```bash
conda create -y -n promqa python=3.11
conda activate promqa
conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
pip install -r requirements.txt
```

You may need to install the following packages, if you have not:
```bash
sudo apt install graphviz ffmpeg parallel
```

### Download video data
1. Follow [CaptainCook4D/downloader](https://github.com/CaptainCook4D/downloader) to download recordings.
```bash
cd data
mkdir -p CaptainCook4D
git clone git@github.com:CaptainCook4D/downloader.git
cd downloder
python download_gopro_data.py --data2d --resolution4K
```
2. Segment original recordings & sample frames & resize images
```bash
bash script/preprocess/video.sh
```

## Benchmarking

### Prediction 
1. Set an API key for each, e.g., `export OPENAI_API_KEY=<your_key>`
2. Run multimodal models from OpenAI, Google, and Anthropic:
```bash
bash script/benchmark/predict.sh \
    <dirpath_sampled_frames> \  # e.g., <dirpath_preprocessed>/sampled-frames/<resolution>/
    <model_id> \  # e.g., gpt-4o-2024-08-06
    <num_frames>  # e.g., 10
```

### Evaluation
1. Set an API key for each, e.g., `export OPENAI_API_KEY=<your_key>`
2. Run LLM-as-a-judge:
```bash
bash script/benchmark/evaluate.sh \
    <filepath_prediction>  # e.g., gpt-4o-2024-08-06_50_examples.json
```

## Data Annotation

![Interface](https://github.com/kimihiroh/promqa/blob/main/docs/interface.png)

### Download CaptainCook4D Annotation
```bash
cd data
mkdir -p CaptainCook4D
cd CaptainCook4D
git clone git@github.com:CaptainCook4D/annotations.git
```

### Preprocess
```bash
bash script/preprocess/update_annotation.sh
bash script/preprocess/create_example.sh
bash script/preprocess/sample.sh
bash script/preprocess/instruction.sh
```

### QA Generation
```bash
bash script/generation/run.sh
```

### Human Verification
```bash
ln -s ./data/videos/ ./src/manual/verification/static/
bash script/verification/start.sh
```


## ToDo
* [x] update path so that everything under this dir
* [ ] Add data annotation code
    * [x] preprocess
    * [x] QA generation
    * [ ] verification
* [ ] Add prediction code for other baselines
    * [ ] unimodal
    * [ ] socratic
    * [ ] open multimodal models
* [ ] run all code

## Citation (TBU)

If you find this work helpful in your research, please consider citing our work.
```bib
@article{hasegawa-etal-2024-promqa,
      title={ProMQA: Question Answering Dataset for Multimodal Procedural Activity Understanding},
      author={Hasegawa, Kimihiro and Imrattanatrai, Wiradee and Cheng, Zhi-Qi and Asada, Masaki and Holm, Susan and Wang, Yuran and Fukuda, Ken and Mitamura, Teruko},
      publisher = {arXiv},
      year={2024},
      url={https://arxiv.org/abs/2410.22211},
}
```

## Issues/Questions

For any issues, questions, or requests, please create a [GitHub Issue](https://github.com/kimihiroh/promqa/issues). 