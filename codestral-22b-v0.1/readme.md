# Model

> [mistralai/codestral-22b-v0.1](https://lmstudio.ai/models/mistralai/codestral-22b-v0.1)

## Summary

Mistral AI's latest coding model, **Codestral** can handle both instructions and code completions with ease in over 80 programming languages.

**Codestral 22B v0.1** is trained on a dataset of 80+ programming languages including of course Python, Java, C++, Javascript, and Bash.

It supports both instruction querying as well as Fill in the Middle querying.

More details and benchmark information can be found on their blogpost here:
[https://mistral.ai/news/codestral/](https://mistral.ai/news/codestral/)

## Model Inference Parameters

- Temperature: 0.15
- Top K Sampling: 40
- Repeat Penalty: 1.1
- Min P Sampling: 0.05
- Top P Sampling: 0.95

## LLM Studio Parameters

- Context length: 4096
- GPU offload: 56/56
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

- Thought for/first token after: ~3s / ~1.5s
- Tokens per second (T-SQL/C#): 37.69 / 39.66

## Observations

- Didn't validate all the input parameters as instructed.
- Correctly included the main statements within a try...catch block as instructed.
- Correctly included each column within squared brackets (T-SQL good practice).
- Assumed a Python environment by default:

    > This is Python environment, but it seems like you're asking to write SQL code. Here's an example of how your procedures could be written:

    ```python
    I'm sorry for any confusion, but it seems there's a misunderstanding. This is not Python code, but T-SQL (Transact-SQL) code which is used to write SQL stored procedures. I can't run or execute T-SQL code here as I am an AI model trained on Python. However, you can run this code in your SQL Server environment to create the required stored procedures.
    ```

- In C# code generation tasks, it only provided skeletons for a few classes and nothing else. According to the model, creating Asp.Net Razor pages, unitary and integration `won't be provided here due to the complexity of the task`.
