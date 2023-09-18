from flask import Flask, jsonify
import random
import time

app = Flask(__name__)

# Simulated temperature data
temperature_data = 20.0

# Function to update temperature data periodically (simulated)
def update_temperature_data():
    while True:
        global temperature_data
        temperature_data = round(random.uniform(18.0, 25.0), 2)
        time.sleep(5)  # Update every 5 seconds

# Start the data update thread
import threading
update_thread = threading.Thread(target=update_temperature_data)
update_thread.daemon = True
update_thread.start()

@app.route('/api/temperature', methods=['GET'])
def get_temperature():
    global temperature_data
    return jsonify({'temperature': temperature_data})

if __name__ == '__main__':
     app.run(host='0.0.0.0')
