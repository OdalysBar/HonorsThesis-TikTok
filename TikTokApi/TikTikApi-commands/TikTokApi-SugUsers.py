# to create a large list of users 
# use the suggested users to snowball a list of users from just one user

from TikTokApi import TikTokApi

api = TikTokApi.get_instance(use_selenium=True)
#cookie = 'verify_kl4bvuwf_94XbZ723_XA3D_4pdr_A3o1_ZVznNhZniBgE'
#api = TikTokApi.get_instance(custom_verifyFp=cookie, use_selenium=True)

# api = TikTokApi.get_instance()
# If playwright doesn't work for you try to use selenium



# 3. List of Users
seed_users = ['odalysbar', 'washingtonpost', 'charlidamelio', 'chunkysdead']
seed_ids = [api.getUser(user_name)['userInfo']['user']['id'] for user_name in seed_users]
suggested = [api.getSuggestedUsersbyID(count=20, startingId=s_id) for s_id in seed_ids]

# This returns a list of user names that are suggested to the users in seed_users
# Some of these recomendations might be the same for certain users

tiktok_id = api.getUser('odalysbar')['userInfo']['user']['id']
suggested_100 = api.getSuggestedUsersbyIDCrawler(count=5, startingId=tiktok_id)

# This returns a list of suggested user names starting with one seed
# We can return back as many user names as we want by changing the count number 

# returns
	# id
	# title = name
	# subtitle = username (i think)
	# description: bio info
	# fans = followers
	# likes = total likes?
	# relation: i am not sure what the relation number means?????