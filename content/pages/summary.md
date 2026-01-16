Title: Quick Reference Guide
Slug: summary
Date: 2025-01-15

# Generative AI Training - Quick Reference Guide

## TL;DR - Model Evolution Summary

<table class="table table-bordered">
  <thead>
    <tr>
      <th>Model Type</th>
      <th>Data Type</th>
      <th>Training Goal</th>
      <th>Strengths</th>
      <th>Weaknesses</th>
      <th>Use Cases</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Machine Learning</strong></td>
      <td>Structured/Tabular</td>
      <td>Optimize algorithm parameters for specific task</td>
      <td>Lightweight, fast training, interpretable</td>
      <td>Limited to structured data, poor generalization</td>
      <td>Credit scoring, fraud detection</td>
    </tr>
    <tr>
      <td><strong>Deep Learning</strong></td>
      <td>Unstructured (images, audio, video)</td>
      <td>Optimize neural network weights using labeled data</td>
      <td>Excellent on unstructured data, task-specific accuracy</td>
      <td>Narrow experts, black box, requires large datasets</td>
      <td>Image classification, object detection</td>
    </tr>
    <tr>
      <td><strong>Base Models (GPT)</strong></td>
      <td>Internet text</td>
      <td>Predict next token in sequence</td>
      <td>General knowledge, broad capabilities, self-supervised</td>
      <td>Unmoderated, hallucinations, not task-optimized</td>
      <td>Text completion, foundation for fine-tuning</td>
    </tr>
    <tr>
      <td><strong>Assistant Models</strong></td>
      <td>Q&A datasets with human labeling</td>
      <td>Mimic helpful assistant responses</td>
      <td>Conversational, follows instructions, retains base knowledge</td>
      <td>Token simulators, no verification, spelling/math errors</td>
      <td>Chatbots, content generation, summarization</td>
    </tr>
    <tr>
      <td><strong>Reasoning Models</strong></td>
      <td>Verifiable problems (math, coding)</td>
      <td>Learn to generate reasoning chains via reinforcement learning</td>
      <td>Better logical reasoning, novel problem solving</td>
      <td>Slower inference, higher cost, longer outputs</td>
      <td>Math problems, coding, complex logical tasks</td>
    </tr>
  </tbody>
</table>

---

## Machine Learning Models

Traditional machine learning models are algorithms written by humans and trained using structured data. The model itself is a mathematical function that provides the "best-guess" output for given inputs, such as a credit default predictor analyzing financial data.

**Strengths:** These models are lightweight and easy to train, making them ideal for structured tabular data with clear features.

**Weaknesses:** Performance degrades significantly outside the trained data domain, and they struggle with unstructured data like images, text, or audio.

**Typical Workflow:** Collect structured data, fit various algorithms such as k-nearest neighbors or decision trees, assess performance through validation, and deploy for inference on unseen data.

---

## Deep Learning

Deep learning represents a paradigm shift: instead of hand-crafted algorithms, we use giant mathematical expressions called neural networks composed of simple operations. These networks require labeled data, and training involves optimizing millions or billions of parameters to achieve higher accuracy.

**Where It Excels:** Deep learning works exceptionally well on unstructured data such as images, audio, and video for tasks like classification, object detection, and sentiment analysis.

**Limitations:** Training requires significant computational time due to the large number of parameters. The learned relationships are often opaque (black box problem), and models tend to be narrow experts, excelling at specific tasks but lacking generalization across domains.

---

## Large Language Models - Base Models

The goal of large language models like GPT is to create a general expert capable across several tasks, moving beyond narrow specialization. These are still neural networks, but they're based on the Transformer architecture published by Google DeepMind in 2016, rescoped to predict the next word in a sequence.

### Training Process

**Data Collection:** Massive amounts of text are gathered from the internet. Datasets like [Fineweb](https://huggingface.co/datasets/HuggingFaceFW/fineweb) provide examples of this scale.

**Tokenization:** Text is converted into sequences of symbols called tokens. Starting with a stream of bytes, Byte Pair Encoding (BPE) merges the most common token pairs in the data. Continuing this process allows individual tokens to hold more information, with some tokens representing entire words. This increases the total vocabulary (GPT-2 used approximately 50,000 tokens).

**Neural Network Training:** A fixed set of tokens is passed to the model based on its context length. The model outputs a probability distribution over all possible tokens. Since the next token is available in the data itself, the dataset is self-labeled. The training goal is to have the model predict high probability for the correct next token and low probability for others. After training, the model learns to produce sequences that simulate what it saw in training data.

### Base Model Characteristics

Base models learn general representations and acquire substantial knowledge. They can be "prompted" into becoming assistants by using input sequences to guide future token behavior. However, they are not true assistants, are not moderated, and can hallucinate information.

**Special Tokens:** The `<|endoftext|>` token is introduced in training data to implicitly teach the model when a sequence should end. Through training, the model learns to assign high probability to this token when a sequence seems complete.

**Temperature Parameter:** The output probability distribution can be modified using temperature. Lower temperature makes the most likely tokens even more likely, producing deterministic outputs. Higher temperature gives lower-probability tokens a chance to be sampled, increasing creativity and randomness.

---

## Assistant Model Training

After a base model is trained on internet data, high-quality question-and-answer datasets are collected through human labelers and experts. These datasets, such as [Open Assistant](https://huggingface.co/datasets/OpenAssistant/oasst1/viewer/default/train?views%5B%5D=train&row=42), are enhanced with special tokens to organize conversations into a protocol separating system, user, and assistant tags. The model must learn to mimic assistant responses.

This data is tokenized as before, and training resumes using the base model as a starting point. OpenAI observed that the new model retains the general knowledge of the base model but adopts the persona of a helpful assistant, making it suitable for applications like chatbots.

### Prompting and Behavior

Assistant model behavior can be modified through prompting. Specifically, assigning roles, giving clear instructions, providing context, and offering several examples significantly improves the model's ability to behave as expected.

Assistant models can be thought of as having two types of memory: stored memory (information learned through training) and working memory (additional tokens provided in the context window).

### Scaling Observations

Empirically, assistant model performance increases with model size, leading companies to train increasingly larger models.

### Critical Risks

Assistant models are token simulators, meaning there is no reflection or sanity checks. Output from these models cannot be trusted as source of truth. They may appear like experts, but their outputs are based on imitating training data, not critical thought.

**Common Failures:** Models fail with spelling and math. Some issues stem from tokenization choices, while others are inherent to the nature of LLMs as probabilistic token generators.

---

## Thinking Models and Reasoning

Despite efforts to make assistant models better at logical problems, issues persisted. The fundamental problem is that assistant models could output an incorrect token early in a sequence, leading to cascading errors downstream.

Several methods were attempted to train assistant models better, but without success. The breakthrough came from using reinforcement learning. OpenAI succeeded with their o1 model, though details were initially unclear. Later in 2025, DeepSeek published a paper outlining exactly how to train a reasoning model.

### DeepSeek's Approach

The central idea was to use problems from a verifiable domain (math) and make the model generate several outputs, then imitate the outputs that were successful.

**Data:** Math problems such as those from [GSM8K Dataset](https://huggingface.co/datasets/openai/gsm8k/viewer/main/train?row=1).

**Starting Point:** A pretrained assistant model.

**Output Format:** A thinking model instructed to put its reasoning within `<think>` tags and the final answer within `<answer>` tags.

**Key Discovery:** DeepSeek observed that the model by itself learns to output a large number of tokens as part of its thinking during training. This is something researchers had previously tried to encourage through prompts like "let's think step by step," but now the model develops this behavior organically through reinforcement learning.

### Significance

Reasoning models represent "true" machine intelligence because machines can learn to come up with novel solutions given enough training, rather than simply pattern matching from training data.

**Advantages:** Reasoning models are more likely to produce correct answers to logical tasks and can develop multi-step reasoning strategies.

**Disadvantages:** These models produce a large number of tokens during the reasoning process, which leads to longer wait times and increased cost of inference.

---

## Tools and Extensions

Beyond prompting and reasoning models, we can optimize model performance by giving it access to tools.

**Search Tools:** Fetch latest information from the internet and place it in the model's context, addressing knowledge cutoff limitations.

**Code Interpreter Tools:** Run code and provide the model with execution output, enabling accurate computational tasks.

**Important Clarification:** Models themselves cannot search the internet or run code. Programmers must write software to integrate search APIs or code runtimes along with the model. Models can be taught (through training data or in-context learning) to use additional special tokens to trigger search, code execution, or other tools.

---

## Key Terminology

**Tokens:** Basic units of text (words, subwords, or characters) that models process. Tokenization converts raw text into these discrete units.

**Context Length:** The maximum number of tokens a model can process at once. Modern models range from 4K to 200K+ tokens.

**Model Parameters:** The learned weights in the neural network, typically billions in modern LLMs. More parameters generally mean more capacity but slower inference.

**Model Type:** Classification into Base Model (raw next-token predictor), Assistant Model (fine-tuned for helpfulness), or Reasoning Model (trained with reinforcement learning for logical tasks).

---

## Best Practices and Recommendations

**Critical Warning:** Don't take assistant model outputs as source of truth. Outputs can be convincing but incorrect, with no built-in verification or fact-checking.

**Use Prompting Techniques:** Optimize model output by assigning clear roles, providing explicit instructions, offering relevant context, and including examples (few-shot prompting).

**Leverage Tools:** Use search tools for up-to-date information that exceeds the model's knowledge cutoff. Use code interpreters to offload calculations and tasks that models inherently struggle with, such as arithmetic.

**Choose the Right Model:** Use thinking models for logical problems requiring multi-step reasoning. For general assistance and conversational tasks, standard assistant models are more cost-effective.

---

## Current Capabilities and Future Directions

**Multimodal Capabilities:** Current models can process images, audio, and video by converting them into tokens alongside text. This enables vision tasks, speech processing, and multimedia understanding.

**Agentic Systems:** The future involves models with tools talking to other models, enabling multi-agent collaboration and complex workflow automation.

**Local LLMs:** Running models on personal devices offers privacy and cost benefits, with open-source alternatives becoming increasingly capable.

**Enhanced Multimodal:** Continued improvements in image generation, real-time video understanding, and audio synthesis are expected.

---

## Additional Links

### Papers

- [GPT-2 Paper (2019)](https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf) - Language Models are Unsupervised Multitask Learners - foundational work on base models
- [GPT-3 Paper (2020)](https://arxiv.org/pdf/2005.14165) - Language Models are Few-Shot Learners - scaling laws and emergent capabilities
- [InstructGPT Paper (2022)](https://arxiv.org/pdf/2203.02155) - Training language models to follow instructions with human feedback (RLHF)
- [DeepSeek-R1 Paper (2025)](https://arxiv.org/pdf/2501.12948) - Technical paper detailing how to train reasoning models using reinforcement learning

### Datasets

- [Open Assistant](https://huggingface.co/datasets/OpenAssistant/oasst1/viewer/default/train?views[]=train&row=42) - High-quality conversational dataset for training assistant models
- [UltraChat](https://atlas.nomic.ai/data/stingning/ultrachat-1/map) - Large-scale dialogue dataset with interactive visualization
- [OLMo Hard-Coded](https://huggingface.co/datasets/allenai/olmo-2-hard-coded) - Curated dataset from Allen Institute for AI
- [FineWeb](https://huggingface.co/datasets/HuggingFaceFW/fineweb) - Large web-crawled dataset for pretraining language models
- [Big-Math-RL-Verified](https://huggingface.co/datasets/SynthLabsAI/Big-Math-RL-Verified) - Math problems with verified solutions for training reasoning models

### Useful Demos

- [Teachable Machine](https://teachablemachine.withgoogle.com/train/image) - GUI app for training simple machine learning models without code
- [LLM Probability Distribution](https://artefact2.github.io/llm-sampling/index.xhtml) - Interactive visualization of how LLMs sample tokens based on probability
- [BBycroft LLM Visualization](https://bbycroft.net/llm) - Visual explanation of how transformers and LLMs work internally
- [Tiktokenizer](https://tiktokenizer.vercel.app/) - Interactive tool to see how text gets tokenized by different models
- [SolidGoldMagikarp](https://www.lesswrong.com/posts/aPeJE8bSo6rAFoLqg/solidgoldmagikarp-plus-prompt-generation) - Exploration of unusual tokens and their effects on LLM behavior

---

<style>
table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 20px;
}

th, td {
  padding: 12px;
  border: 1px solid #ddd;
  vertical-align: top;
  text-align: left;
}

th {
  background-color: #f2f2f2;
  font-weight: bold;
}

tr:nth-child(even) {
  background-color: #f9f9f9;
}
</style>