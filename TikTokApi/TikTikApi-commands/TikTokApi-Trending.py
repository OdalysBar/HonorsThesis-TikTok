from TikTokApi import TikTokApi

# api = TikTokApi.get_instance(use_selenium=True)
# api = TikTokApi.get_instance()
# If playwright doesn't work for you try to use selenium

cookie = 'verify_kl4bvuwf_94XbZ723_XA3D_4pdr_A3o1_ZVznNhZniBgE'
results = 1

api = TikTokApi.get_instance(custom_verifyFp=cookie, use_selenium=True)


trending = api.trending(count=results, custom_verifyFp=cookie)

# This will return the Tiktok that is trending at the instant moment in time
# We can change the number of TikTok information we want it to return

# information given: that i think could be useful
	# id
	# creation time
	# uniqueId / nickname
	# verified
	# Music: title, author
	# challenges:
	# stats: sharecount, commentcount, playcount
	# hashtag
	# author stats: follower count, heartcount? - i think total likes?
# people are allowed to turn off share and stich this will lower the stat numbers 

