from nyct_gtfs import NYCTFeed
import time
import datetime

feed = NYCTFeed("A", api_key="5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7")


# Function for getting A train time
def A_train_stop_time(StationID: str):

    # Read the all northbound A trains curruntely underway
    trains = feed.filter_trips(line_id="A",underway=True, travel_direction= "N")

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
                estimated_arrival_time=Stops.arrival - current_time

                #Fill list with estimated arrival times
                arrival_time_list.append(int(estimated_arrival_time.total_seconds()/60))

    #Sort list from least to greatest, so lowest arrival time is first index
    arrival_time_list=sorted(arrival_time_list)
    print(arrival_time_list)
    return arrival_time_list[0]