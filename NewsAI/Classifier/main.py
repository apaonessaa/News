import os
import requests

API_URL = os.getenv('HF_API_URL')
headers = { "Authorization": f"Bearer {os.getenv('HF_TOKEN')}" }

def query(text, labels):
    payload = {
        "inputs": text,
        "parameters": {"candidate_labels": labels},
    }
    response = requests.post(API_URL, headers=headers, json=payload)
    return response.json(), response.status_code

from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/', methods=['POST'])
def classify():
    """Label classification from a text."""
    data = request.get_json()
    labels = data.get('labels', [])
    text = data.get('text', '')

    if text and labels:
        data, code = query(text, labels)
        
        if code != 200:
            return jsonify({'error': 'HF API'}), code

        # [ {'label': LABEL, 'score': SCORE} ]
        sorted_labels = [item['label'] for item in sorted(data, key=lambda x: x['score'], reverse=True)]
        
        return jsonify({f'result': sorted_labels})
    else:
        return jsonify({'error': 'Text to compute not provided'}), 400
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8083, debug=True)

