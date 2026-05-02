# Model

> [nvidia/Nemotron-Cascade-14B-Thinking](https://huggingface.co/nvidia/Nemotron-Cascade-14B-Thinking)

## Introduction

![benchmark results](/_img/nemotron-cascade-14b-thinking-results.png)

We're excited to introduce Nemotron-Cascade-14B-Thinking, a powerful general-purpose model trained through sequential and domain-wise reinforcement learning. Nemotron-Cascade-14B-Thinking is post-trained from the Qwen3-14B Base model, and it achieves best-in-class performance across a wide range of benchmarks. Different from Nemotron-Cascade-8B, Nemotron-Cascade-14B-Thinking is designed exclusively for the thinking mode.

## Training Pipeline

![pipeline](/_img/pipeline.png)

The training pipeline for Nemotron-Cascade begins with a multi-stage SFT phase to equip the model with foundational skills. Subsequently, Cascade RL is applied across multiple domains to further enhance the model’s performance in these areas.

Notably, RLHF for alignment, when used as a pre-step, boosts the model’s complex reasoning ability far beyond mere preference optimization, and subsequent domain-wise RLVR stages rarely degrade the benchmark performance attained in earlier domains and may even improve it (see an illustration in the following Figure).

![cascade](/_img/lcb_through_cascade_rl.png)

## Results

- We evaluate our model against competitive reasoning models on a diverse set of benchmarks, covering general-knowledge reasoning, alignment and instruction following, mathematical reasoning, competitive programming, software engineering, and tool-use proficiency.
- For Nemotron-Cascade models, we use a maximum generation length of 64K tokens and set the temperature to 0.6 and top-p to 0.95 for reasoning tasks.
- Our Nemotron-Cascade-14B-Thinking achieves best-in-class performance across almost all benchmarks. Remarkably, Nemotron-Cascade-14B-Thinking surpasses DeepSeek-R1-0528 (671B) by a clear margin across all LCB v5, v6, and Pro benchmarks.

| **Benchmark Metric: Pass@1** | **Qwen3-14B** | **DeepSeek-R1-0528 671B** | **Gemini-2.5-Flash-Thinking** | **Nemotron-Cascade-14B-Thinking** |
| :---: | :---: | :---: | :---: | :---: |
| ***Knowledge Reasoning*** |
| MMLU | 84.9 | 89.9 | - | 85.1 |
| MMLU Pro | 77.6 | 85.0 | 81.9 | 77.0 |
| GPQA-Diamond | 64.0 | 81.0 | 82.8 | 69.6 |
| ***Alignment*** |
| ArenaHard | 91.7 | 95.1 | 95.7 | 89.5 |
| IFEval (Strict Prompt) | 85.4 | 84.1 | 89.8 | 81.9 |
| IFBench | 33.7 | 38.0 | 36.1 | 41.7 |
| ***Math*** |
| AIME 2024 | 79.3 | 91.4 | 82.3 | 89.7 |
| AIME 2025 | 70.4 | 87.5 | 72.0 | 83.3 |
| ***Code*** |
| LCB v5 (08/24-02/25) | 65.2 | 74.8 | 63.4 | **77.5** |
| LCB v6 (08/24-05/25) | 63.5 | 73.3 | 61.9 | **74.6** |
| LCB Pro 25Q2 (Easy) | 53.6 | 63.9 | 47.4 | **68.9** |
| LCB Pro 25Q2 (Med) | 2.6 | 7.0 | 1.8 | **10.5** |
| SWE Verified (Agentless) | 27.4 | 57.6 | 48.9 | 43.1 |
| ***Tool Calling*** |
| BFCL V3 | 70.4 | 67.9 | 68.6 | 67.5 |

## Usage Recommendations

For local deployment, we recommend setting the sampling parameters to temperature = 0.6, top_p = 0.95.
We recommend using RoPE scaling with the [YaRN](https://arxiv.org/abs/2309.00071) method for better long-context support. This can be enabled by updating the model’s `config.json` as shown below:

```json
  {
    ...,
    "rope_scaling": {
        "rope_type": "yarn",
        "factor": 2.0,
        "original_max_position_embeddings": 32768
    }
  }
```

- **Nemotron-Cascade-14B-Thinking**: use `factor: 3.0` to extend the context length to 90K tokens for SWE Verified (Agentless), and `factor: 2.0` to extend the context length to 64K tokens for other benchmarks.
- **Nemotron-Cascade-8B** and **Nemotron-Cascade-8B-Thinking**: use `factor: 2.0` across all benchmarks.

## Evaluation Tookit

To reproduce our results, please check evaluation code, scripts, cached prediction files in <https://huggingface.co/nvidia/Nemotron-Cascade-14B-Thinking/blob/main/evaluation/README.md>

## Chat Template

Nemotron-Cascade-14B-Thinking follows the Qwen3-style ChatML template and is designed exclusively for the ***thinking*** mode. To align with the template used in [Nemotron-Cascade-8B](https://huggingface.co/nvidia/Nemotron-Cascade-8B), the `" /think"` tag should be appended to the end of the user input. Note that a leading space is included in this tag to ensure correct tokenization.

To reduce the context length in a multi-turn conversation, we include only the final summary of the model’s output in the conversation history and change the user turn’s `" /think"` tag to `" /no_think"`.

A brief example is shown below:

```python
from transformers import AutoTokenizer

model_name = 'nvidia/Nemotron-Cascade-14B-Thinking'
tokenizer = AutoTokenizer.from_pretrained(model_name)

'''
single-turn example
'''
messages = [
    {"role": "user", "content": "calculate 1+1?"}
]

# only thinking mode is supported (enable_thinking=True)
prompt_thinking = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True, enable_thinking=True)
# prompt_thinking = '<|im_start|>system\nYou are a helpful and harmless assistant.<|im_end|>\n<|im_start|>user\ncalculate 1+1? /think<|im_end|>\n<|im_start|>assistant\n'


'''
multi-turn example
'''
messages = [
    {"role": "user", "content": "calculate 1+1?"},
    {"role": "assistant", "content": "<think>THINKING_CONTENT</think>\nTo calculate \\(1 + 1\\):\n\n1. **Identify the operation**: This is a basic addition problem involving two integers.\n2. **Perform the addition**:  \n   \\(1 + 1 = 2\\).\n\n**Result**: \\(\\boxed{2}\\)",},
    {"role": "user", "content": "what about 2+2"}
]

# only thinking mode is supported (enable_thinking=True)
prompt_thinking = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True, enable_thinking=True)
# prompt_thinking = '<|im_start|>system\nYou are a helpful and harmless assistant.<|im_end|>\n<|im_start|>user\ncalculate 1+1? /no_think<|im_end|>\n<|im_start|>assistant\nTo calculate \\(1 + 1\\):\n\n1. **Identify the operation**: This is a basic addition problem involving two integers.\n2. **Perform the addition**:  \n   \\(1 + 1 = 2\\).\n\n**Result**: \\(\\boxed\{2\}\\)<|im_end|>\n<|im_start|>user\nwhat about 2+2 /think<|im_end|>\n<|im_start|>assistant\n'
```

## Release Date

Dec 08, 2025

## License

Your use of this model is governed by the [NVIDIA Open Model License](https://www.nvidia.com/en-us/agreements/enterprise-software/nvidia-open-model-license/).

## Citation

```txt
@article{Nemotron_Cascade_Scaling_Cascaded_Reinforcement_Learning,
  title={Nemotron-Cascade: Scaling Cascaded Reinforcement Learning for General-Purpose Reasoning Models},
  author={Wang, Boxin and Lee, Chankyu and Lee, Nayeon and Lin, Sheng-Chieh and Dai, Wenliang and Chen, Yang and Chen, Yangyi and Yang, Zhuolin and Liu, Zihan and Shoeybi, Mohammad and Catanzaro, Bryan and Ping, Wei},
  year={2025}
}
```

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

- Thought for/first token after: ??? / ???
- Tokens per second (T-SQL/C#): ??? / ???

## Observations

[placeholder]
