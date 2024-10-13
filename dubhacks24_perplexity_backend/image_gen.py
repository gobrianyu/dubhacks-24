from openai import OpenAI
from flask import Flask, jsonify, request
import json

app = Flask(__name__)

response = ''

@app.route('/prompt', methods = ['GET', 'POST'])

# this is our method to take in a prompt from the Flutter user that they input as a description of their dream
# and output an image url that is a visual representation of the dream using OpenAI's DALL-E-2 image generator
# returns an image url that the Flutter side can use to download and show the image to the user
def handle_prompt_image():
    global response
    client = OpenAI()

    request_data = request.get_json()
    
    prompt = request_data.get('prompt', '')
    final_prompt = "Create an image in a photo-realistic format from the perspective of someone dreaming this dream:" + prompt + ". Make sure to be as loyal to the source dream as possible."

    response = client.images.generate(
        model="dall-e-3",
        prompt=final_prompt,
        size="1024x1024",
        quality="standard",
        n=1
    )
    image_url = response.data[0].url
    return jsonify({'image': image_url})
    
if (__name__ == "__main__"):
    app.run(debug=True)