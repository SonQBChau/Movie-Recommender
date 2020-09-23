# Movie-Recommender
A recommender system model that employs collaborative filtering to suggest relevant videos to each specific user.

## Project Abstract

As video content libraries grow bigger by the day, it is becoming difficult for viewers to find programming that appeals to them. A great solution is to recommend content for users to watch, based on their individual taste, without them having to search for it. This requires a good recommendation system that studies the viewing habit patterns of similar users.
With that in mind, we have set out to create a recommender system model that employs collaborative filtering to suggest relevant videos to each specific user.

<img src="https://github.com/SonQBChau/movie-recommender/blob/master/flutter/ss_4.png" >

The picture attached above shows an easy to understand visualization of how the recommender system will work. Users with similar taste will be grouped together, so if one user in a group watches a movie that another user in the same group hasn’t watched, the system will recommend said movie to the user (that hasn’t watched it) on the basis that they will probably like it, given that they have similar taste to the former user.

<img src="https://github.com/SonQBChau/movie-recommender/blob/master/flutter/ss_5.jpg" >

The figure above shows a complete diagram of how we expect the final product to look. The user will interact with our site which will give them a list of movies to rate. Based on their rating the recommender system will put them into a group and give them a selection of movies that match their preferences.

We are using the small Movielens dataset that has 100,000 ratings on 9,000 movies by 600 users.

The dataset is organized in a way that it assigns each user a unique user id, each movie a unique movie id, breaks each movie down by genre and keywords, and records each user rating on each movie.

The problem we are trying to solve is to recommend movies to people based on their tastes. In order to do this we are going to ask them to rate a list of movies, then take their ratings, run it through the system, assign them to groups. After they’re assigned to groups the model will output a selection of movies that they haven’t seen and are likely to enjoy.

Because our model is trying to learn the structure of the data in order to sort users into groups, and because our model does not know the outputs beforehand, this is an unsupervised learning problem.

A good visualization is shown below. Each row corresponds to a unique user, each column corresponds to a unique movie, and each rating in the matrix records a users rating of the movie.

The model then takes the filled out matrix and groups the user into a category with other users based on similar preferences, it will use these groups to determine what to recommend to our users. This is known as collaborative filtering.
