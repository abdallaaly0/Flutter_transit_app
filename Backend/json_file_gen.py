import json
import os
from underground import metadata, SubwayFeed
from nyct_gtfs import NYCTFeed


# API_KEY = os.getenv('5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7')
# ROUTE='A'
# feed = SubwayFeed.get(ROUTE, api_key='5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7')
# print(feed.extract_stop_dict())


results=""
i=0
MTA_lines=["A","C","E","1","2","3","B","D","F","M","N","Q","R","W","J","4","5","6","7","L"]
for lines in MTA_lines:
    feed2 = NYCTFeed(lines, api_key="5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7")
    trains=feed2.filter_trips(line_id=lines,underway=False, travel_direction= "S")
    print(lines + " line:")
    print(trains[0].headsign_text)
    for stops in trains[0].stop_time_updates:
        results += str('"'+stops.stop_id[:-1]+'"'+',')
        i=i+1
    print(results)
    print("Number of stops: " + str(i))
    i=0
    results=""
