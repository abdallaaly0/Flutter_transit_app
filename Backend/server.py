from flask import Flask, jsonify
from nyct_gtfs import NYCTFeed

#Connect to nyct_gtfs library 
feed = NYCTFeed("A", api_key="5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7")

app= Flask(__name__)

train = feed.trips[0]

@app.route('/Atrain', methods = ['GET'])
def index():
    data=str(train.location)
    return jsonify({'data' : data})


if __name__ == "__main__":
    #Host server localy 
    app.run(host='0.0.0.0')
