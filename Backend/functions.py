import string
from nyct_gtfs import NYCTFeed
import time
import datetime

# Function for getting A train time
def Train_stop_time(StationID: str):
    # Get first char of the string
    train_line=str(StationID[0])
    #Get Train ID
    StationID=StationID[1:]
    print(train_line)
    print(StationID)
    # Get the last char of the string
    train_direction=str(StationID[-1])
    print(train_direction)
    feed = NYCTFeed(train_line, api_key="5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7")

    # Read the all northbound A trains curruntely underway
    trains = feed.filter_trips(line_id=train_line,underway=True, travel_direction= train_direction,headed_for_stop_id= StationID)
    # If train no trains are under way
    if(len(trains) < 3):
        print("Train len ",end= "")
        print(len(trains))
        trains.extend(feed.filter_trips(line_id=train_line,underway=False, travel_direction= train_direction))
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
    i=0

    #Get the index where 0 is not the time 
    while (arrival_time_list[i] <= 0):
        i=i+1
    print(arrival_time_list[i])
    return arrival_time_list[i]


# Function for getting A train time
def Train_stop_time_list(StationID: str):
    # Get first char of the string
    train_line=str(StationID[0])

    # Get Station ID
    StationID=StationID[1:]
    print(train_line)
    print(StationID)

    #Get Train direction
    train_direction=str(StationID[-1])
    print(train_direction)
    feed = NYCTFeed(train_line, api_key="5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7")

    # Read the all northbound A trains curruntely underway
    trains = feed.filter_trips(train_line,underway=True, travel_direction= train_direction,headed_for_stop_id= StationID)
    # If train no trains are under way
    if(len(trains) < 4):
        print("Train len ",end= "")
        print(len(trains))
        trains.extend(feed.filter_trips(train_line,underway=False, travel_direction= train_direction))
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
    #Filiter list so that only numbers greater than or equal to 0 is in the list 
    arrival_time_list = [num for num in arrival_time_list if num >= 0]

    print(arrival_time_list)

    return arrival_time_list



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


