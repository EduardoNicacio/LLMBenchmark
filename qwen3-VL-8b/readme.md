# Model

> [qwen/qwen3-vl-8b](https://lmstudio.ai/models/qwen/qwen3-vl-8b)

## Summary

The latest generation vision-language model in the Qwen series with comprehensive upgrades to visual perception, spatial reasoning, and video understanding.

## Key Features

- Visual Agent: Operates PC and mobile GUIs—recognizes elements, understands functions, and completes tasks
- Visual Coding: Generates Draw.io, HTML, CSS, and JavaScript from images and videos
- Advanced Spatial Perception: Provides 2D/3D grounding for spatial reasoning and embodied AI applications
- Upgraded Recognition: Recognizes celebrities, anime, products, landmarks, flora, fauna, and more
- Expanded OCR: Supports 32 languages with robust performance in low light, blur, and tilt conditions
- Pure Text Performance: Text understanding on par with pure LLMs through seamless text-vision fusion

## Architecture Highlights

- 8.77B parameters
- Interleaved-MRoPE for enhanced video reasoning
- DeepStack for fine-grained detail capture
- Text-Timestamp Alignment for precise event localization
- Context length: 256,000 tokens
- Vision-enabled multimodal model

## Model Performance

Delivers strong vision-language performance across diverse tasks including document analysis, visual question answering, video understanding, and agentic interactions.

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

- Thought for/first token after: 0.35s / 0.28s
- Tokens per second (T-SQL/C#): 92.19 / 87.20

## Observations

- Good performance. Source-code is easy to follow and understand.
- Along with other Qwen models and GPT Oss, this model also wrapped all the names of the table columns with squared brackets, a good practice in MS SQL server.
- Didn't create the requested Razor pages, only their code-behind classes.
