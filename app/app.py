from flask import Flask, jsonify, request
import time
import random

app = Flask(__name__)

@app.route("/health")
def health():
    return jsonify(status="ok", uptime=time.time())

@app.route("/api")
def api():

    latency = random.uniform(0.05, 0.5)
    time.sleep(latency)
    value = {"message": "Hello from demo microservice", "latency": latency}
    return jsonify(value)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
