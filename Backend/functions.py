import string
from types import NoneType
import time
import datetime
import logging

from nyct_gtfs import NYCTFeed
# gets arrival time for specific station based on "StationID" 
# and returns the nearest train time
def Train_stop_time(StationID: str,ReturnList: bool):
    # First char of stationID represents desired train line
    train_line=str(StationID[0])
   
    #Remove the the first char to get specifc station
    StationID=StationID[1:]
    # Save desired direction "N" or "S" from the last char of string
    train_direction=str(StationID[-1])

    # Load feed from NYCTFeed and filter data for specfic train line
    feed = NYCTFeed(train_line, api_key="5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7")
    trains = feed.filter_trips(line_id=train_line,underway=True, travel_direction= train_direction,headed_for_stop_id= StationID)

    # If there are less than 3 trains underway add trains that are not underway yet heading for desirerd direction
    if(len(trains) < 3):
        trains.extend(feed.filter_trips(line_id=train_line,underway=False, travel_direction= train_direction))

    # refresh feed, for next call
    feed.refresh()

    # Store arrival times
    arrival_time_list= []

    # Get current real time
    current_time = datetime.datetime.now()

    # Loop through all data in list trains 
    for Train in trains:
        # Loop through all stops in list Train.stop_time_updates
        for Stops in Train.stop_time_updates:
            #If the train still has StationID left on its route get and print the arrival time
            if StationID == Stops.stop_id:
                #If Stops.arrival is noneType return empty sting 
                if(type(Stops.arrival) == NoneType):
                    if(ReturnList):
                        arrival_time_list.append("")
                        return arrival_time_list
                    return ""
                
                estimated_arrival_time=Stops.arrival - current_time

                # add arrival time to list for trian heading to stopID converted to mins
                arrival_time_list.append(int(estimated_arrival_time.total_seconds()/60))


    arrival_time_list=sorted(arrival_time_list)
    logging.basicConfig(level=logging.DEBUG)
    # If ReturnList is true return entire arrival_time_list 
    if(ReturnList):
        message = "Return list, Train Line: {} {}, arrival times: {} ".format(train_line,train_direction, arrival_time_list)
        logging.debug(message)
         #Filiter list so that only numbers greater than or equal to 0 is in the list 
        arrival_time_list = [num for num in arrival_time_list if num >= 0]
        return arrival_time_list
    
    i=0
    #Filiter list so that only numbers greater than or equal to 0 is in the list 
    arrival_time_list = [num for num in arrival_time_list if num >= 0]
    message = "Train Line: {}{}, arrival times: {} ".format(train_line,train_direction, arrival_time_list)
    logging.debug(message)
    #If list is empty return ""
    if(len(arrival_time_list)==0):
        return ""
    
    return arrival_time_list[i]




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


