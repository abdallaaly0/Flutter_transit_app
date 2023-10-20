import json
from nyct_gtfs import NYCTFeed

# Create a Python dictionary with data
def data(A: str,B: str, C: str, D: str, E: str ):
    data = {
        "Routes":[
         {
          "stop_id": A,
            }
        ]
}
results=""
MTA_lines=["A","C","E","1","2","3","B","D","F","M","N","Q","R","W","J","Z","4","5","6"]
for lines in MTA_lines:
    feed2 = NYCTFeed(lines, api_key="5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7")
    trains=feed2.filter_trips(line_id=lines,underway=False, travel_direction= "S")
    print(lines + " line:")
    for stops in trains[0].stop_time_updates:
        results += str(stops.stop_id+",")
    print(results)
    results=""


# Specify the file path where you want to create the JSON file
# file_path = "/Users/veraldval/Desktop/GitHub/Flutter_transit_app/Backend/stations.json"

# # Open the file in write mode and save the JSON data
# with open(file_path, "w") as json_file:
#     json.dump(data, json_file, indent=4)

# print("JSON file created successfully.")