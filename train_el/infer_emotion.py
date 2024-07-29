import os
os.environ["CUDA_VISIBLE_DEVICES"]="0"
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig, TextStreamer
from huggingface_hub import login
import torch
access_token = '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'
login(token=access_token)

bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_use_double_quant=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.bfloat16,
    llm_int8_enable_fp32_cpu_offload=True,
    
)
#model 1: "mistralai/Mixtral-8x7B-v0.1"
#model 2: google/gemma-2-27b
model_id = "meta-llama/Meta-Llama-3.1-70B"
tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(model_id, 
                                             offload_folder='/home/gauneg/emotion_experiments/offload',
                                             quantization_config=bnb_config)
