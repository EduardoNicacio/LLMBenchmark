# Model

- [servicenow-ai/apriel-1.5-15b-thinker](https://huggingface.co/ServiceNow-AI/Apriel-1.5-15b-Thinker)

## Summary

**Apriel-1.5-15b-Thinker** is a multimodal reasoning model in ServiceNow’s Apriel SLM series which achieves competitive performance against models 10 times it's size. Apriel-1.5 is the second model in the reasoning series. It introduces enhanced textual reasoning capabilities and adds image reasoning support to the previous text model. It has undergone extensive continual pretraining across both text and image domains. In terms of post-training this model has undergone text-SFT only. Our research demonstrates that with a strong mid-training regimen, we are able to achive SOTA performance on text and image reasoning tasks without having any image SFT training or RL.

## Highlights

- Achieves a score of 52 on the Artificial Analysis index and is competitive with Deepseek R1 0528, Gemini-Flash etc.
- It is AT LEAST 1 / 10 the size of any other model that scores > 50 on the Artificial Analysis index.
- Scores 68 on Tau2 Bench Telecom and 62 on IFBench, which are key benchmarks for the enterprise domain.
- At 15B parameters, the model fits on a single GPU, making it highly memory-efficient.

## LLM Studio Parameters

- Context length: 8192
- GPU offload: 48/48
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

- Thought for: ~2min / ~4min
- Tokens per second: 50.19 / 49.07

## Observations

- Differently from other "thinking" or "reasoning" models, it displays its chain of thought directly in the LLM chat output. Nice. :-)
- It included a nice documentation at the header of each stored procedure, and split them all into separate code blocks as asked.
- It missed some explicit instructions, like not using Update* as input parameters in the retrieve stored procedures.
- On the other hand, it was one of the few models to suggest a cleaner way of handling parameter validation and execution error logging by using a separate stored procedure, called `dbo.RunWithErrorLogging`. Nice. :-)
- This model took longer to complete these tasks because it generated two sets of stored procedures, with and without the try...catch block for handling errors on Insert, Update or Select operations.
- The model generated tons of C# code. However, when outputing the latest classes after a long thought, it ran out of context/memory and could not proceed. A 24/32GB video card may help with that.
- The model spent over 2h of GPU time writing C# code and fine-tunning it. I've aborted the execution on the final step, when the model was about to display its final answer.
