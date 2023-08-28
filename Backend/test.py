from nyct_gtfs import NYCTFeed

# load feed, input feed and api_key

feed1 = NYCTFeed("A", api_key="5zisyVOSabaBzo4djN7cS9AS6uNbXMfChhoFoWL7")
# feed2 = NYCTFeed("B", api_key="YOUR_MTA_API_KEY_GOES_HERE")
# feed3 = NYCTFeed("B", api_key="YOUR_MTA_API_KEY_GOES_HERE")
# feed4 = NYCTFeed("B", api_key="YOUR_MTA_API_KEY_GOES_HERE")
# feed5 = NYCTFeed("B", api_key="YOUR_MTA_API_KEY_GOES_HERE")
# feed6 = NYCTFeed("B", api_key="YOUR_MTA_API_KEY_GOES_HERE")
# feed7 = NYCTFeed("B", api_key="YOUR_MTA_API_KEY_GOES_HERE")

# input_station is the station we want to get information from. 
# we need a better way to automatically get an input such as through google maps

input_station = "Dyckman St"
# read a particular train [train1] (use 1st one) 
# or a group of them [trains1] (like BDFM, use second)
# i'll be using trains1 as an example for the rest of the program

train1 = feed1.filter_trips(line_id="A",underway= True,travel_direction="N")
print(train1)
trains1 = feed1.trips
print(trains1)

# get number of trains and the amount of stops left
# & make an index & a string placeholder for the station summary 
# [trains1_sum for summary of train and trains1_str for a readable str of that summary]

num_trains = len(trains1)
num_stops = len(trains1.stop_time_updates)
i = 0
j = 0

# read each train from feed and in the nested loop read their upcoming stops
# when a train with a stop that equals input_station is found, print train symbol and time

while(i < num_trains):
	trains1_sum = feed1.trips[i]
	trains1_str = str(trains1_sum)
	
	while(j < num_stops):
		stop_str = trains1.stop_time_updates[j]

		if(input_station in trains1_str):
			print(trains1.route_id)
			print(trains1.stop_time_updates[j].stop_id)
		
	

	