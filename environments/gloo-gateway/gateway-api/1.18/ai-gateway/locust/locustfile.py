from locust import HttpUser, task, between
import random
import logging

# User-configurable variables
class Config:
    HOST = "http://192.168.107.2:8080"  # Replace with your actual API base URL
    API_KEY = "YOUR_API_KEY"  # Replace with your actual API key if needed
    ENDPOINT = "/openai"  # Define the endpoint for the LLM API
    MODEL = "gpt-4o-mini"  # Make model configurable

    # List of payloads
    PAYLOADS = [
        {
            "messages": [
                {"role": "system", "content": "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair."},
                {"role": "user", "content": "Compose a poem that explains the concept of recursion in programming."}
            ]
        },
        {
            "messages": [
                {"role": "system", "content": "You are an expert in computer science."},
                {"role": "user", "content": "Explain how neural networks work in simple terms."}
            ]
        },
        {
            "messages": [
                {"role": "system", "content": "You are a creative writing assistant."},
                {"role": "user", "content": "Write a short story about a time traveler."}
            ]
        },
        {
            "messages": [
                {"role": "system", "content": "You are a programming debugger."},
                {"role": "user", "content": "I have an error in my code: 'IndexError: list index out of range'. What does it mean?"}
            ]
        },
        {
            "messages": [
                {"role": "system", "content": "You are a knowledgeable assistant."},
                {"role": "user", "content": "What are the main causes of climate change?"}
            ]
        }
    ]

# Set up logging
logger = logging.getLogger("locustfile")
handler = logging.FileHandler("locust_output.log")
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.INFO)

class LLMUser(HttpUser):
    host = Config.HOST
    wait_time = between(3, 10)  # Wait time between requests (in seconds)

    @task
    def send_request(self):
        # Use the endpoint defined in the configuration
        url = Config.ENDPOINT

        # Randomly select a payload and add the model dynamically
        payload = random.choice(Config.PAYLOADS)
        payload["model"] = Config.MODEL  # Inject the configurable model

        # Set the headers including the content type
        headers = {
            "Content-Type": "application/json"
        }

        # Log the outgoing request
        logger.info(f"Sending request to {url} with payload: {payload}")

        # Send the POST request to the LLM API
        with self.client.post(url, json=payload, headers=headers, catch_response=True) as response:
            if response.status_code != 200:
                # Log the failure
                logger.error(f"Request failed with status code {response.status_code} and response {response.text}")
                response.failure(f"Request failed with status code {response.status_code} and response {response.text}")
            else:
                # Log the successful response
                logger.info(f"Request succeeded with response: {response.text}")
                print(f"Response: {response.text}")
