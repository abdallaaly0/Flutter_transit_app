from flask import Flask, jsonify, request
import time
import json
import functions


app = Flask(__name__)


response = ''

@app.route('/api/single_times', methods=['POST'])
def get_foo():
    global response

    request_data=request.data
    request_data = json.loads(request_data.decode('utf-8'))
    station_name=request_data['name']
    response=functions.Train_stop_time(StationID=str(station_name),ReturnList=False)
    print(response)
    return jsonify({'name':response})

@app.route('/api/multipule_times', methods=['POST'])
def get_multipuleTimes():
    
    request_data=request.data
    request_data = json.loads(request_data.decode('utf-8'))
    station_name=request_data['name']
    response=functions.Train_stop_time(StationID=str(station_name),ReturnList=True)
    return jsonify({'name':response})

if __name__ == '__main__':
     app.run(host='0.0.0.0')
