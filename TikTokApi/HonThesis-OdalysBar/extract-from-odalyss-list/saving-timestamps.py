import pickle
import pandas as pd
import numpy as np


# users = pd.read_csv("famous-users.txt")
# users = pd.read_csv("viral-users.txt")
users = pd.read_csv("foryou-users.txt")

users = users.to_numpy() # convert to numpy array
# print(users[0][0]) # charlidamelio
# print(users[1][0]) # awezdarbar

numusers = len(users) # the number of usernames 


for i in range(0,numusers) : # for i from 0 to the whole list of usernames
	# load the pickle file for the ith user
	user_posts = pickle.load( open( "data/%s.p" % (users[i][0]), "rb" ))
	if len(user_posts) != 0 :
		# Saving the timestamp for their first post in list
		timestamps = [user_posts[0]['createTime']] 
		#print(list)
		numpost = len(user_posts) # numpost = the number of post for the ith user

		# we want to collect the timestamps from the 2nd post to the last post
		for k in range(1,numpost) : 
			# we will loop over all the post for the user
			# append all the timestamps into list
			timestamps.append(user_posts[k]['createTime']) 

		np.savetxt("timestamps/%s_timestamps.txt" % users[i][0],timestamps,fmt="%u")

