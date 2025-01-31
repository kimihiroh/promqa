# ProMQA: Question Answering Dataset for Multimodal Procedural Activity Understanding

This repository contains code and data for ["ProMQA: Question Answering Dataset for Multimodal Procedural Activity Understanding" (Hasegawa et al., arXiv 2024)](https://arxiv.org/abs/2410.22211). 

## News

* 2024/10/29: 401 QA pairs are now available.


## Overview

ProMQA is an evaluation QA dataset for multimodal procedural activity understanding.

![Overview](https://github.com/kimihiroh/promqa/blob/main/docs/overview.png)

Given a recipe (text), a recording (video), and a question (text), the task is to predict an answer (text).

![Formulation](https://github.com/kimihiroh/promqa/blob/main/docs/formulation.png)

## Environment Setup

### Virtual environment
```bash
conda create -y -n promqa python=3.11
conda activate promqa
conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
pip install -r requirements.txt
```

### Download video data
1. Follow [CaptainCook4D/downloader](https://github.com/CaptainCook4D/downloader) to download recordings.
    * e.g., `python download_gopro_data.py --resolution4K --output_dir <dirpath_original>`
2. Segment original recordings & sample frames & resize
```bash
bash script/preprocess/video.sh \
    <dirpath_original> \
    <dirpath_preprocessed>
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

### Preprocess
```bash
bash script/preprocess/update_annotation.sh
bash script/preprocess/create_example.sh
bash script/preprocess/sample.sh
bash script/preprocess/instruction.sh samples.json samples
```

### QA Generation

### Human Verification


## ToDo
* [ ] Add data annotation code
    * [x] preprocess
    * [ ] QA generation
    * [ ] verification
* [ ] Add prediction code for other baselines
    * [ ] unimodal
    * [ ] socratic
    * [ ] open multimodal models
* [ ] run all code

## Citation

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