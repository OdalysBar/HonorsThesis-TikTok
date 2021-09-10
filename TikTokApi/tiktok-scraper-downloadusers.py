import os

users =  ["daexo"]#,"itsnastynaz", "waivinci", "edjcontreras", "atul_bhoyar_", "itsniane", "troyallen", "miso_ara", "samuelgrubbs", "inoxiasounds"]
#users = ["dave.xo", "pudgywoke"," nintendo.grl", "miso_ara", "hamster_land", "furryfritz", "minecraft_noon", "mattstauffer3", "romper", "nailartistkim"]
#users = ["kittenmeow555", "korasplanet", "_chloe_aesthetics"," _mochafrappe_", "marythecrazyheadcat", "itsavage", "lepulu", "vincentmarson", "talordinh"," funnyjuicebox"]

# MORE USERS
# garett_nolan, davidbeck, aryanverma_001, jaykindafunny8, namenimsand ,wildcatridgesanctuary, abelcarden, zeezee25, itsyurrboiameer
# mmmjoemele, texasbeeworks, staysafeladiess, alliesparks, reimarito, riyas.14, angryreactions

#["addisonre"] 
for user in users:
	command = "tiktok-scraper user %s -n 2000 -t csv --session sid_tt=asdasd13123123123adasda" % user
	os.system(command)


# original
# 		

# new 
# tiktok-scraper user %s -d -n 2000 --session sid_tt=dae32131231

# diff
# tiktok-scraper user %s -n 2000 -d -w --hd --session sid_tt=asdasd13123123123adasda

# tiktok-scraper user USERNAME -n 2000 -d --session sid_tt=asdasd13123123123adasda
