from openai import OpenAI

# this is our method to take in a prompt from the Flutter user that they input as a description of their dream
# and output an image url that is a visual representation of the dream using OpenAI's DALL-E-2 image generator
# returns an image url that the Flutter side can use to download and show the image to the user
client = OpenAI()
final_prompt = "Create an image in a photo-realistic format from the perspective of someone dreaming this dream:" + "I was in this ancient forest where the trees were whispering secrets. As I wandered deeper in, I stumbled upon a hidden glade with glowing flowers. Each flower had a memory of someone I knew, and touching them brought back their most important moments." + ". Make sure to be as loyal to the source dream as possible."

response = client.images.generate(
    model="dall-e-3",
    prompt=final_prompt,
    size="1024x1024",
    quality="standard",
    n=1,
)
image_url = response.data[0].url
print(image_url)