#Function for GPS
def GPS(StationID: str):
    # Get first char of the string
    train_line=str(StationID[0])
    print(train_line)
    # Get the last char of the string
    train_direction=str(StationID[-1])
    print(train_direction)
    #Grab the feed
    feed = NYCTFeed(train_line, api_key="5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7")

    # Read the all northbound A trains curruntely underway
    trains = feed.filter_trips(line_id=train_line,underway=True, travel_direction= train_direction)

    # Arrival time list 
    arrival_time_list= []

    #Get current real time
    current_time = datetime.datetime.now()

    #GPS locations List using double list
    Train_Array_List = []
    Train_Array_List.append([])

    # To pull new data from feed, for next call
    feed.refresh()

    for Train in trains:
        for Stops in Train.stop_time_updates:
            #If the train still has StationID left on its route get and print the location
            if StationID == Stops.stop_id:
                estimated_arrival_time=Stops.arrival - current_time

                #Fill list with estimated arrival times
                Train_Array_List[Train].append(int(estimated_arrival_time.total_seconds()/60))

                locator = trains.location
                locator_action = trains.location_status
                GPS_String = locator_action + '' + locator
                Train_Array_List[Train].append(GPS_String)

    #sort 2d list based on time arrival and get train location of next train
    Train_Array_List=sorted(Train_Array_List)
    print(Train_Array_List)
    if Train_Array_List[0] == 0:
        return Train_Array_List[1][1]
    else:
        return Train_Array_List[0][1]