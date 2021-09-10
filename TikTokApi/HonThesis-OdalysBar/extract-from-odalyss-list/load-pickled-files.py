import pickle

user_name = 'texasbeeworks'

user_posts = pickle.load( open( "data/{}.p".format(user_name), "rb" ))

print(user_posts)

print(len(user_posts))