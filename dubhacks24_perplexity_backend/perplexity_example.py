from openai import OpenAI
from flask import Flask, jsonify, request
import json

app = Flask(__name__)

response = ''

@app.route('/prompt', methods = ['GET', 'POST'])

def promptRoute():
    global response

    if (request.method == 'POST'):
        request_data = request.data
        request_data = json.loads(request_data.decode('utf-8'))
        prompt = request_data['prompt'] #extracts what user is sending, gets what they put into the form

        #we need to implement some sort of code to send the user's input to the model and print
        #out the image in return
        return " "
    
        #need to run flask side on terminal to get url



YOUR_API_KEY = "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"

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
            "How many stars are in the universe?"
        ),
    },
]

client = OpenAI(api_key=YOUR_API_KEY, base_url="https://api.perplexity.ai")

# chat completion without streaming
response = client.chat.completions.create(
    model="llama-3-sonar-large-32k-online",
    messages=messages,
)
print(response)

# chat completion with streaming
response_stream = client.chat.completions.create(
    model="llama-3-sonar-large-32k-online",
    messages=messages,
    stream=True,
)
for response in response_stream:
    print(response)
