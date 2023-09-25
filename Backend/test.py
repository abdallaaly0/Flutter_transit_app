from flask import Flask, jsonify
import time
import functions


app = Flask(__name__)

            
#Defalut time
train_time = 0

# Function to get new A train time every 30 seconds
def update_train_time():
    while True:
        global train_time
        train_time=functions.A_train_stop_time("A48N")
        time.sleep(30)  # Update every 30 seconds


# Start the data update thread
import threading
update_thread = threading.Thread(target=update_train_time)
update_thread.daemon = True
update_thread.start()

@app.route('/api/train-time', methods=['GET'])
def get_time():
    global train_time
    return jsonify({'train time': train_time})

if __name__ == '__main__':
     app.run(host='0.0.0.0')
