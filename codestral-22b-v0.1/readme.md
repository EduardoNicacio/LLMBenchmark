# Model

- [mistralai/codestral-22b-v0.1](https://lmstudio.ai/models/mistralai/codestral-22b-v0.1)

## Summary

Mistral AI's latest coding model, **Codestral** can handle both instructions and code completions with ease in over 80 programming languages.

**Codestral 22B v0.1** is trained on a dataset of 80+ programming languages including of course Python, Java, C++, Javascript, and Bash.

It supports both instruction querying as well as Fill in the Middle querying.

More details and benchmark information can be found on their blogpost here:
[https://mistral.ai/news/codestral/](https://mistral.ai/news/codestral/)

## LLM Studio Parameters

- Context length: 8192
- GPU offload: 48/56
- CPU thread pool: 9
- Evaluation batch size: 512
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

- Thought for: 0min3s
- Tokens per second: 13.20

## Observations

- Didn't validate the input parameters as instructed.
- Didn't include the main statements within a try...catch block as instructed.
- Assumed a Python environment by default:

    > This is Python environment, but it seems like you're asking to write SQL code. Here's an example of how your procedures could be written:
