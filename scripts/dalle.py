import os
import json
import subprocess
import urllib.request
import sys

from openai import OpenAI

if len(sys.argv) == 1 or len(sys.argv[1]) < 20:
    print("you need to describe an image")
    exit(1)

with open("/home/jim/.config/io.datasette.llm/keys.json") as f:
    try:
        api_key = json.load(f)["openai"]
    except json.decoder.JSONDecodeError:
        print("invalid JSON in credentials file")
        exit(1)
    except KeyError:
        print("no OpenAI API key could be found")
        exit(1)
    except FileNotFoundError:
        print("No credentials file for LLM from pypi")
        exit(1)

def sanitize(word):
    good = []
    for char in word:
        if ord(char) < 65:
            good.append("_")
        else:
            good.append(char)
    return "".join(good)


sanitized_name = "-".join(map(sanitize, sys.argv[1].strip().split()))[:250] + ".png"
output_filename = f'/home/jim/Pictures/llm/{sanitized_name}'
if os.path.exists(output_filename):
    print("image already exists:", output_filename)
    subprocess.call(["xdg-open", output_filename])
    exit(1)

print(f"Creating {output_filename}")
client = OpenAI(api_key=api_key)

response = client.images.generate(
    model="dall-e-3",
    prompt=sys.argv[1],
    size="1024x1024",
    quality="standard",
    n=1,
)

image_url = response.data[0].url
urllib.request.urlretrieve(image_url, output_filename)
subprocess.call(["xdg-open", output_filename])
