# DOES NOT WORK

from TikTokApi import TikTokApi

cookie = 'verify_kl4bvuwf_94XbZ723_XA3D_4pdr_A3o1_ZVznNhZniBgE'
api = TikTokApi.get_instance(custom_verifyFp=cookie, use_selenium=True)
# api = TikTokApi.get_instance(use_selenium=True)

# 2. Collect Videos Liked by User
username = 'tiktok'
n_videos = 10
liked_videos = api.userLikedbyUsername(username, count=n_videos)
#liked_videos = [simple_dict(v) for v in liked_videos]

# this makles a nice looking table
# liked_videos_df = pd.DataFrame(liked_videos)
# liked_videos_df.to_csv('{}_liked_videos.csv'.format(username), index=False)

# ERROR: 
# Empty response from Tiktok to https://m. .....
