# Bulletin Backend
Bulletin is a social networking platform centered around news. As the rise of social media continues, younger generations stray away from traditional news sites and articles and turn to resources such as Twitter and Facebook. This app seeks to combine traditional news outlets with a social media interface for a more captivating and engaging experience. With Bulletin, users are able to follow specific news sources or interests as well as follow other users. Using this approach, Bulletin strives to become a one-stop-shop news outlet for any generational user.


## Motivation
Looking around in my friend circles and family, I found that many of my younger friends and family viewed news through social media while older generations read news through online news articles or websites. Seeing this split dynamic, I figured I could build the best of both worlds by combining the two news outlets into one easy-to-use web application. From this idea, I built Bulletin. Bulletin is a one-stop-shop for news with the ability for users to tailor their news content. After selecting news interests and news sources, the user is greeted with a custom generated news feed containing only the news articles pertaining to his or her selections. Along with the tailored news feed, users have the ability to follow users, message users or groups of users, read notifications, like, comment, and share posts, and search for hashtags.


## Heroku App
This app has been deployed to Heroku [here](https://bulletin-app-front.herokuapp.com/).


## Features
* Customizable user feed
* Messaging to other users
* Searchable tags to find posts easier
* Notifications to prioritize user experience


## Build Status
This app has been deployed to Heroku [here](https://bulletin-app-front.herokuapp.com/). If this is your first time visiting Bulletin, please sign up.

You may also view a video demonstration [here](https://www.youtube.com/watch?v=LRW9Y2imcJs).


## Frameworks / Technologies Used
* [React JS](https://reactjs.org/)
* [Ruby on Rails as API](https://rubyonrails.org/)
* [Postgresql](https://www.postgresql.org/)
* [News API](https://newsapi.org/)
* [Material UI](https://material-ui.com/)
* HTML / CSS


## Prerequisites
The backend install steps require the following on your system
* [Rails](https://rubyonrails.org/)
* [Postgresql](https://www.postgresql.org/)


## Install Instructions
1. Clone this repository to you local machine.
2. Once cloned, navigate to the base folder of this repository.
3. Run bundle install in the terminal to install required gems.
4. Run rails db:setup to set up the database.
5. Run rails s to start the rails server.

Note: The frontend software must be downloaded and running as well to see a user interface. See the frontend project [here](https://github.com/hoobie4792/bulletin-frontend).