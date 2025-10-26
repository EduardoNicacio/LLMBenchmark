# Model

- [ibm/granite-4-h-tiny](https://huggingface.co/ibm-granite/granite-4.0-h-tiny)

## Summary

**Granite-4.0-H-Tiny** is a 7B parameter long-context instruct model finetuned from Granite-4.0-H-Tiny-Base using a combination of open source instruction datasets with permissive license and internally collected synthetic datasets. This model is developed using a diverse set of techniques with a structured chat format, including supervised finetuning, model alignment using reinforcement learning, and model merging. Granite 4.0 instruct models feature improved instruction following (IF) and tool-calling capabilities, making them more effective in enterprise applications.

## Highlights

- Developers: Granite Team, IBM
- HF Collection: Granite 4.0 Language Models HF Collection
- GitHub Repository: [ibm-granite/granite-4.0-language-models](https://github.com/ibm-granite/granite-4.0-language-models)
- Website: Granite Docs
- Release Date: October 2nd, 2025
- License: Apache 2.0

## LLM Studio Parameters

- Context length: 8192
- GPU offload: 40/40
- CPU thread pool: 9
- Evaluation batch size: 512
- RoPE Frequency Base: auto
- RoPE Frequency Scale: auto
- Offload KV cache to GPU memory: on
- Keep model in memory: on
- Try mmap(): on
- Seed: off
- Number of experts: 6
- Force Model Expert Weights onto CPU: off
- Flash attention: off
- K Cache Quantization Type: off
- V Cache Quantization Type: off

## Performance

- Thought for: 0.2s / 0.2s
- Tokens per second: 131.65 / 147.68

## Observations

- Didn't create each stored procedure on its own code block as instructed.
- Simplistic, broken stored procedures - cannot be compiled.
- Repeated the SQL prompt with a refined version and it performed very well!
- Even though it didn't create all the required C# code, at least it provided a justification:

    ```txt
    Given the complexity of this task, I'll provide an overview and key components for each part rather than full files due to length constraints. Each section will include comments explaining its purpose.
    ```

- Model didn't provide a folder structure for the C# code, that's why every artifact is in the same folder/level.
