# Model

> [nvidia/OpenCodeReasoning-Nemotron-14B](https://huggingface.co/nvidia/OpenCodeReasoning-Nemotron-14B)

## Introduction

OpenCodeReasoning-Nemotron-14B is a large language model (LLM) which is a derivative of Qwen2.5-14B-Instruct (AKA the reference model). It is a reasoning model that is post-trained for reasoning for code generation. The model supports a context length of 32K tokens.

This model is ready for commercial/non-commercial use.

![Evaluation Results](/_img/results.png)

## Results from [OpenCodeReasoning](https://arxiv.org/abs/2504.01943)

Below results are the average of **64 evaluations** on each benchmark.

| Model                     | LiveCodeBench Avg. | CodeContest All |
| :---                      | :---               | :---            |
| DeepSeek-R1               | 65.6               | 26.2            |
| QwQ-32B                   | 61.3               | 20.2            |
| **Distilled 7B+ Models**                                         |
| Bespoke-Stratos-7B        | 14.7               | 2.0             |
| OpenThinker-7B            | 25.5               | 5.0             |
| R1-Distill-Qwen-7B        | 38.0               | 11.1            |
| OlympicCoder-7B           | 40.9               | 10.6            |
| **OCR-Qwen-7B**           | **48.5**           | **16.3**        |
| **OCR-Qwen-7B-Instruct**  | **51.3**           | **18.1**        |
| **Distilled 14B+ Models**                                        |
| R1-Distill-Qwen-14B       | 51.3               | 17.6            |
| **OCR-Qwen-14B**          | **57.7**           | **22.6**        |
| **OCR-Qwen-14B-Instruct** | **59.4**           | **23.6**        |
| **Distilled 32B+ Models**                                        |
| Bespoke-Stratos-32B       | 30.1               | 6.3             |
| OpenThinker-32B           | 54.1               | 16.4            |
| R1-Distill-Qwen-32B       | 58.1               | 18.3            |
| OlympicCoder-32B          | 57.4               | 18.0            |
| **OCR-Qwen-32B**          | **61.8**           | **24.6**        |
| **OCR-Qwen-32B-Instruct** | **61.7**           | **24.4**        |

## Reproducing our results

* [Models](https://huggingface.co/collections/nvidia/opencodereasoning-2-68168f37cd7c6beb1e3f92e7)
* [Dataset](https://huggingface.co/datasets/nvidia/OpenCodeReasoning)
* [Paper](https://arxiv.org/abs/2504.01943)

## How to use the models?

To run inference on coding problems:

````python
import transformers
import torch

model_id = "nvidia/OpenCodeReasoning-Nemotron-14B"

pipeline = transformers.pipeline(
    "text-generation",
    model=model_id,
    model_kwargs={"torch_dtype": torch.bfloat16},
    device_map="auto",
)

prompt = """You are a helpful and harmless assistant. 
            You should think step-by-step before responding to the instruction below.
            Please use python programming language only.

            You must use ```python for just the final solution code block with the following format:
            ``python
            # Your code here
            ``
            {user}
            """

messages = [
    {
        "role": "user",
        "content": prompt.format(user="Write a program to calculate the sum of the first $N$ fibonacci numbers")},
]

outputs = pipeline(
    messages,
    max_new_tokens=32768,
)

print(outputs[0]["generated_text"][-1]['content'])
````

## Citation

If you find the data useful, please cite:

```txt
@article{ahmad2025opencodereasoning,
      title={OpenCodeReasoning: Advancing Data Distillation for Competitive Coding}, 
      author={Wasi Uddin Ahmad, Sean Narenthiran, Somshubra Majumdar, Aleksander Ficek, Siddhartha Jain, Jocelyn Huang, Vahid Noroozi, Boris Ginsburg},
      year={2025},
      eprint={2504.01943},
      archivePrefix={arXiv},
      primaryClass={cs.CL},
      url={https://arxiv.org/abs/2504.01943}, 
}
```

## Model Architecture

Architecture Type: Dense decoder-only Transformer model
Network Architecture: Qwen-14B-Instruct

**This model was developed based on Qwen2.5-14B-Instruct and has 14B model parameters.**

**OpenCodeReasoning-Nemotron-14B was developed based on Qwen2.5-14B-Instruct and has 14B model parameters.**

## Input

* **Input Type(s):** Text
* **Input Format(s):** String
* **Input Parameters:** One-Dimensional (1D)
* **Other Properties Related to Input:** Context length up to 32,768 tokens

## Output

* **Output Type(s):** Text
* **Output Format:** String
* **Output Parameters:** One-Dimensional (1D)
* **Other Properties Related to Output:** Context length up to 32,768 tokens

Our AI models are designed and/or optimized to run on NVIDIA GPU-accelerated systems. By leveraging NVIDIA’s hardware (e.g. GPU cores) and software frameworks (e.g., CUDA libraries), the model achieves faster training and inference times compared to CPU-only solutions.

## Software Integration

* Runtime Engine: NeMo 2.3.0
* Recommended Hardware Microarchitecture Compatibility:
  * NVIDIA Ampere
  * NVIDIA Hopper
* Preferred/Supported Operating System(s): Linux

## Model Version(s)

1.0 (4/25/2025):

* OpenCodeReasoning-Nemotron-7B
* OpenCodeReasoning-Nemotron-14B
* OpenCodeReasoning-Nemotron-32B
* OpenCodeReasoning-Nemotron-32B-IOI

## Training and Evaluation Datasets

### Training Dataset

The training corpus for OpenCodeReasoning-Nemotron-14B is [OpenCodeReasoning](https://huggingface.co/datasets/nvidia/OpenCodeReasoning) dataset, which is composed of competitive programming questions and DeepSeek-R1 generated responses.

Data Collection Method: Hybrid: Automated, Human, Synthetic
Labeling Method: Hybrid: Automated, Human, Synthetic
Properties: 736k samples from OpenCodeReasoning (<https://huggingface.co/datasets/nvidia/OpenCodeReasoning>)

### Evaluation Dataset

We used the datasets listed in the next section to evaluate OpenCodeReasoning-Nemotron-14B.
**Data Collection Method: Hybrid: Automated, Human, Synthetic**
**Labeling Method: Hybrid: Automated, Human, Synthetic**

#### License/Terms of Use

GOVERNING TERMS: Use of this model is governed by [Apache 2.0](https://huggingface.co/nvidia/OpenCode-Nemotron-2-14B/blob/main/LICENSE).

#### Deployment Geography

Global

### Use Case

This model is intended for developers and researchers building LLMs.

### Release Date

Huggingface [04/25/2025] via <https://huggingface.co/nvidia/OpenCodeReasoning-Nemotron-7B/>

## Reference(s)

[2504.01943] OpenCodeReasoning: Advancing Data Distillation for Competitive Coding

## Inference

**Engine:** vLLM
**Test Hardware** NVIDIA H100-80GB

## Ethical Considerations

NVIDIA believes Trustworthy AI is a shared responsibility and we have established policies and practices to enable development for a wide array of AI applications.  When downloaded or used in accordance with our terms of service, developers should work with their internal model team to ensure this model meets requirements for the relevant industry and use case and addresses unforeseen product misuse.  

Please report security vulnerabilities or NVIDIA AI Concerns here.

## Model Inference Parameters

* Temperature: 0.1
* Top K Sampling: 20
* Repeat Penalty: off
* Min P Sampling: 0.0
* Top P Sampling: 0.95

## LLM Studio Parameters

* Context length: 32768
* GPU offload: 36/36
* CPU thread pool: 9
* Evaluation batch size: 512
* Max Concurrent Predictions: 4
* RoPE Frequency Base: auto
* RoPE Frequency Scale: auto
* Offload KV cache to GPU memory: on
* Keep model in memory: on
* Try mmap(): on
* Seed: off
* Flash attention: off
* K Cache Quantization Type: off
* V Cache Quantization Type: off

## Performance

- Thought for/first token after: ??? / ???
- Tokens per second (T-SQL/C#): ??? / ???

## Observations
