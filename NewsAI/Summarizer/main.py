from flask import Flask, request, jsonify
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

def get_model(model_path):
    """Load a Hugging Face model and tokenizer from the specified directory"""
    tokenizer = AutoTokenizer.from_pretrained(model_path)
    model = AutoModelForSeq2SeqLM.from_pretrained(model_path)
    return model, tokenizer

# Load the models and tokenizers for each supported language
model, tokenizer = get_model('model/')

gen_kwargs = {
    "max_length": 1024,
    "do_sample": False,
    "num_beams": 4,
    "use_cache": True,
    "early_stopping": True,
    "num_return_sequences": 1,
    "repetition_penalty": 3.5,
    "encoder_repetition_penalty": 2.0,
    "length_penalty": 1.5, 
    "encoder_no_repeat_ngram_size": 4,
    "no_repeat_ngram_size": 6,
}

app = Flask(__name__)

@app.route('/', methods=['POST'])
def generate():
    """Generate a text from source text."""
    data = request.get_json()
    from_text = data.get(f'text', '')
    res = ''

    if from_text:
        inputs = tokenizer(from_text, return_tensors="pt", max_length=16384, truncation=True, add_special_tokens=True)
        outputs = model.generate(**inputs, **gen_kwargs)
        out = tokenizer.decode(outputs[0], skip_special_tokens=True)
        res = out.decode( 'unicode-escape' ).encode( 'ascii' )
        return jsonify({f'result': res})
    else:
        return jsonify({'error': 'Text to compute not provided'}), 400
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8082, debug=True)
