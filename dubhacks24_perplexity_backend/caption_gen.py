from openai import OpenAI
from flask import Flask, jsonify, request
import json

app = Flask(__name__)

response = ''

@app.route('/prompt', methods = ['GET', 'POST'])

def handle_prompt_caption():
    global response

    if(request.method == 'POST'):
        client = OpenAI()

        request_data = request.data
        request_data = json.loads(request_data.decode('utf-8'))
        prompt = request_data['prompt']
        final_prompt = "Summarize this paragraph into 1 sentence: " + prompt
        API_KEY = "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"

        messages = [
            {
                "role": "system",
                "content": (
                    "You are an artificial intelligence assistant and you need to "
                    "engage in a helpful, detailed, polite conversation with a user."
                ),
            },
            {
                "role": "user",
                "content": (
                    final_prompt
                ),
            },
        ]

        client = OpenAI(api_key=API_KEY, base_url="https://api.perplexity.ai")

        # chat completion without streaming
        response = client.chat.completions.create(
            model="llama-3.1-sonar-small-128k-chat",
            messages=messages,
        )
        
        return response
