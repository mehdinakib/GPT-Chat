"""Copyright 2023 Outy Business"""

import ast
import openai
from flask import Flask, request

openai.api_type = "azure"
openai.api_base = "https://outy-chatbot-service-instance.openai.azure.com/"
openai.api_version = "2023-03-15-preview"
openai.api_key = "bad4bc2d9d594df08928ecfa4ca5fe06"

application = Flask(__name__)

@application.route("/")
def main():
    return "API V1.1"


@application.route("/chat", methods=["GET", "POST"])
def convert():
    if request.method == "GET":
        return "API V1.1 : /convert [POST]: takes a caracter as input and return  "
    elif request.method == "POST":
        data = request.json.get("message")
        response = openai.ChatCompletion.create(
            engine="outy-chat-dep",
            messages = [{"role":"system","content":str(data)}],
            temperature=0.7,
            max_tokens=800,
            top_p=0.95,
            frequency_penalty=0,
            presence_penalty=0,
            stop=None)
        return str(response["choices"][0]["message"]["content"])
    

if __name__ == '__main__':
   application.run(debug = True)