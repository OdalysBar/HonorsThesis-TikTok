from TikTokApi import TikTokApi

#api = TikTokApi.get_instance(use_selenium=True)

cookie = 'verify_kl4bvuwf_94XbZ723_XA3D_4pdr_A3o1_ZVznNhZniBgE'
api = TikTokApi.get_instance(custom_verifyFp=cookie, use_selenium=True

# api = TikTokApi.get_instance()
# If playwright doesn't work for you try to use selenium




# DOES NOT WORK
# 1. Collect Videos Posted by user

# provide the user name 
# will return information on the videos posted by that user
username = 'washingtonpost'
uservideos = api.byUsername(username = 'washingtonpost', count=100) 

# return
	# user name
	# id
	# likes
	# shares
	# comments
	# plays

# this provides a nicer looking table
user_videos = [simple_dict(v) for v in user_videos]
user_videos_df = pd.DataFrame(user_videos)
user_videos_df.to_csv('{}_videos.csv'.format(username),index=False)




# DOES NOT WORK
# 4. Collect Trending Videos
n_trending = 20
trending_videos = api.trending(count=n_trending)
trending_videos = [simple_dict(v) for v in trending_videos]
trending_videos_df = pd.DataFrame(trending_videos)
trending_videos_df.to_csv('trending.csv',index=False)
# Basic info: shares, comment, plays
