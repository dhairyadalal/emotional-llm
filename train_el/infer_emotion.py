import os
import pandas as pd
os.environ["CUDA_VISIBLE_DEVICES"]="0"
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig, TextStreamer
from huggingface_hub import login
import torch
from tqdm import tqdm
access_token = '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'
login(token=access_token)

bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_use_double_quant=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.bfloat16,
    llm_int8_enable_fp32_cpu_offload=True,
    
)
quantization_config_gemma = BitsAndBytesConfig(load_in_4bit=True)
#model 1: "mistralai/Mixtral-8x7B-v0.1"
#model 2: google/gemma-2-27b
model_id = "meta-llama/Meta-Llama-3.1-70B"
tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(model_id, 
                                            ## for gemma only------------------
                                            load_in_8bit=False,
                                            torch_dtype=torch.bfloat16,
                                            attn_implementation="eager",
                                            ## -----------------------------------
                                            offload_folder='/home/gauneg/emotion_experiments/offload',
                                            quantization_config=bnb_config)

prompt = lambda text,a,b,c,d,e:f"""
Read the given situation which has instructions and multiple choices a,b,c,d and e. Follow the instructions to sellect only one out of the given choices.

### instructions: 
{text}
### choices
a. {a}
b. {b}
c. {c}
d. {d}
e. {e}
### Predicted Choice
"""

df = pd.read_csv('../steu_items - recognise_likely_outof5.csv')

def process_string(strx):
    pred_arr = strx.split('###')
    fin_arr = [st.lower() for st in pred_arr if "predicted" in st.lower()]
    return fin_arr[0].replace('predicted choice', ' ').replace('\n', '').strip()


collected_res = []
for situ, a,b,c,d,e, y in df.values:
    mod_inp = prompt(situ, a,b,c,d,e)
    inps = tokenizer(mod_inp, return_tensors="pt").to('cuda')
    generate_ids = model.generate(**inps, max_length=256)
    gen_text = tokenizer.decode(generate_ids[0], skip_special_tokens=True)
    pred_y = process_string(gen_text)
    collected_res.append([situ, a, b, c, d, e, pred_y, y])


fin_df = pd.DataFrame(collected_res, columns=['situ', 'a', 'b', 'c', 'd', 'e', 'pred_text', 'true_value'])
fin_df.to_csv('./pred_gemma.csv', index=False)