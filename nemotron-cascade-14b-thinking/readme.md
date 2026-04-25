# Model

> [nvidia/Nemotron-Cascade-14B-Thinking](https://huggingface.co/nvidia/Nemotron-Cascade-14B-Thinking)

## Introduction

We're excited to introduce Nemotron-Cascade-14B-Thinking, a powerful general-purpose model trained through sequential and domain-wise reinforcement learning. Nemotron-Cascade-14B-Thinking is post-trained from the Qwen3-14B Base model, and it achieves best-in-class performance across a wide range of benchmarks. Different from Nemotron-Cascade-8B, Nemotron-Cascade-14B-Thinking is designed exclusively for the thinking mode.

## Training Pipeline

![pipeline](/_img/pipeline.png)

The training pipeline for Nemotron-Cascade begins with a multi-stage SFT phase to equip the model with foundational skills. Subsequently, Cascade RL is applied across multiple domains to further enhance the model’s performance in these areas.

Notably, RLHF for alignment, when used as a pre-step, boosts the model’s complex reasoning ability far beyond mere preference optimization, and subsequent domain-wise RLVR stages rarely degrade the benchmark performance attained in earlier domains and may even improve it (see an illustration in the following Figure).

![cascade](/_img/lcb_through_cascade_rl.png)

## Results

We evaluate our model against competitive reasoning models on a diverse set of benchmarks, covering general-knowledge reasoning, alignment and instruction following, mathematical reasoning, competitive programming, software engineering, and tool-use proficiency.
For Nemotron-Cascade models, we use a maximum generation length of 64K tokens and set the temperature to 0.6 and top-p to 0.95 for reasoning tasks.
Our Nemotron-Cascade-14B-Thinking achieves best-in-class performance across almost all benchmarks. Remarkably, Nemotron-Cascade-14B-Thinking surpasses DeepSeek-R1-0528 (671B) by a clear margin across all LCB v5, v6, and Pro benchmarks.

## Model Inference Parameters

- Temperature: 0.15
- Top K Sampling: 20
- Repeat Penalty: off
- Min P Sampling: 0.0
- Top P Sampling: 0.95

## LLM Studio Parameters

- Context length: 32768
- GPU offload: 36/36
- CPU thread pool: 9
- Evaluation batch size: 512
- Max Concurrent Predictions: 4
- RoPE Frequency Base: auto
- RoPE Frequency Scale: auto
- Offload KV cache to GPU memory: on
- Keep model in memory: on
- Try mmap(): on
- Seed: off
- Flash attention: off
- K Cache Quantization Type: off
- V Cache Quantization Type: off

## Performance

- Thought for/first token after: 3min41s / 13.59s
- Tokens per second (T-SQL/C#): 35.76 / 125.43

## Observations
