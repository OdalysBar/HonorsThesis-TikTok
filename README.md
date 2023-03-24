# Comparing User Behavior from TikTok Users

### Background
TikTok is a social media app that has quickly gained popularity with over one billion users and counting. TikTok users can use the platform to post short content videos that consist of users dancing, acting, or lip-syncing to music. Using the TikTok public database, we collected data from 101 users using a TikTok API. 

### Analysis
We used ε-machines and generalized additive models (GAMs) to model the binarized posting behavior of the TikTok users. By estimating the ε-machines and GAMs from the observed user behavior, we created models that captured the behavior of a given user and inferred if they were self driven or seasonally driven. The ε-machine will best fit users whose future behavior depends on their recent activity and the GAM will fit users who typically post videos on a specific day of the week and time of day. Using the cross entropy loss function, we determined which category of users are more seasonally driven or self driven. 

