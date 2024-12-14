from transformers import LlamaForCausalLM, LlamaTokenizer

# Carregar o tokenizer e o modelo
tokenizer = LlamaTokenizer.from_pretrained("facebook/llama")
model = LlamaForCausalLM.from_pretrained("facebook/llama")

# Texto de entrada
input_text = "Qual é a capital do Brasil?"
input_ids = tokenizer(input_text, return_tensors="pt").input_ids

# Gerar a resposta
outputs = model.generate(input_ids)
response = tokenizer.decode(outputs[0], skip_special_tokens=True)

print(response)
