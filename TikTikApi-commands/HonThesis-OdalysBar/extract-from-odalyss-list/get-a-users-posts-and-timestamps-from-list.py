import pickle

import time

cookie = 'verify_km6lowj4_EnrVVMgO_tLLY_4gde_AiUF_Zd2RLAp0Euqy'

from TikTokApi import TikTokApi

api = TikTokApi.get_instance(use_selenium=True, use_test_endpoints=True)

with open('famous-users-2.txt') as ofile:
	for line in ofile:
		user_name = line.strip()
		print("On user {}...".format(user_name))

		user_posts = api.byUsername(user_name, count=3000, custom_verifyFp=cookie)

		pickle.dump(user_posts, open( "data/{}.p".format(user_name), "wb"))

		print("Pausing for 10 minutes...")

		time.sleep(10*60)