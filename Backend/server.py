
from flask import Flask, jsonify, request
import time
import json
import functions


app = Flask(__name__)


#Defalut time
train_time = 0
response = ''
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



@app.route('/api/response', methods=['POST'])
def get_foo():
    global response

    if(request.method == 'POST'):
        request_data=request.data
        request_data = json.loads(request_data.decode('utf-8'))
        station_name=request_data['name']
        response=functions.A_train_stop_time(str(station_name))
        print(response)
        return jsonify({'name':response})
    else:
        return jsonify({'name':response})



if __name__ == '__main__':
     app.run(host='0.0.0.0')
