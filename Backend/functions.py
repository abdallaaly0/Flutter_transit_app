import string
from nyct_gtfs import NYCTFeed
import time
import datetime

feeds = [["A","C","E","H","FS"],
         ["B","D","F","M"],
         ["G"],
         ["J","Z"],
         ["N","Q","R","W"],
         ["L"],
         ["1","2","3","4","5","6","7","S"]]

# Function for getting A train time
def A_train_stop_time(StationID: str):
    # Get first char of the string
    train_line=str(StationID[0])
    print(train_line)
    # Get the last char of the string
    train_direction=str(StationID[-1])
    print(train_direction)
    feed = NYCTFeed(train_line, api_key="5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7")

    # Read the all northbound A trains curruntely underway
    trains = feed.filter_trips(line_id=train_line,underway=True, travel_direction= train_direction)

    # To pull new data from feed, for next call
    feed.refresh()

    # Arrival time list 
    arrival_time_list= []

    print(StationID)
    #Get current real time
    current_time = datetime.datetime.now()

    for Train in trains:
        for Stops in Train.stop_time_updates:
            #If the train still has StationID left on its route get and print the arrival time
            if StationID == Stops.stop_id:
                print(Stops.stop_name)
                estimated_arrival_time=Stops.arrival - current_time

                #Fill list with estimated arrival times
                arrival_time_list.append(int(estimated_arrival_time.total_seconds()/60))

    #Sort list from least to greatest, so lowest arrival time is first index
    arrival_time_list=sorted(arrival_time_list)
    print(arrival_time_list)
    if arrival_time_list[0] == 0:
        return arrival_time_list[1]
    else:
        return arrival_time_list[0]
# input="7"
# x=5
# feed2 = NYCTFeed(input, api_key="5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7")
# trains2=feed2.filter_trips(line_id=input,underway=False, travel_direction= "N")
# print (trains2[x])
# print(" Stops for " + input +" train " + str(len(trains2[x].stop_time_updates)))
# for stops in trains2[x].stop_time_updates:
#     print(stops.stop_name +": "+ stops.stop_id)


# for train in trains2:
#     print(len(train.stop_time_updates))
#     for Stops in train.stop_time_updates:
#         print(Stops.stop_name +": "+ Stops.stop_id)


