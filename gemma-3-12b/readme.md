# Model

- google/gemma-3-12b

## Summary

**Gemma** is a family of lightweight, state-of-the-art open models from Google, built from the same research and technology used to create the Gemini models. Gemma 3 models are multimodal, handling text and image input and generating text output, with open weights for both pre-trained variants and instruction-tuned variants. Gemma 3 has a large, 128K context window, multilingual support in over 140 languages, and is available in more sizes than previous versions. Gemma 3 models are well-suited for a variety of text generation and image understanding tasks, including question answering, summarization, and reasoning. Their relatively small size makes it possible to deploy them in environments with limited resources such as laptops, desktops or your own cloud infrastructure, democratizing access to state of the art AI models and helping foster innovation for everyone.

## Inputs and outputs

- Input:

    Text string, such as a question, a prompt, or a document to be summarized
    Images, normalized to 896 x 896 resolution and encoded to 256 tokens each
    Total input context of 128K tokens for the 4B, 12B, and 27B sizes, and 32K tokens for the 1B size.

- Output:

    Generated text in response to the input, such as an answer to a question, analysis of image content, or a summary of a document
    Total output context of 8192 tokens.

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

- Thought for: 0min2s
- Tokens per second: 54.18

## Observations

- Didn't create each stored procedure on its own SQL code block in the reply
