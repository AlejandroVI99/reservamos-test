# Instructions

* Ruby version 3.4.1

* Rails 8.0.1

Problem: The main goal is to create an endpoint which could return, from a destination that Reservamos offers, the minimum and maximum temperature of the following 7 days.

Solution: An endpoint was created which would consume the APIs of Open Weather and Reservamos in order to have the destinations it offers and from these, obtain the latitude and longitude of the cities and be able to use them to know their temperature.

After clone the repository, we need to set our project:

* Run ```bundle install```

Create .env file and add the API Key:

* ```OPENWEATHER_API_TOKEN=API Key```

Exec the next command:

* ```rails db:create db:migrate```

Start the server with:

* ```rails s```

When the server is started, we need to use Postman to test the endpoint

* ```http://127.0.0.1:3000/api/v1/destinations?city=```

* :eyes: The number of the port it will depent of which one are you using.

In Postman, we need to put the enpoint with the name of the city we want to know the temperature, it could be the partial or total name of any city in Mexico.

Examples

![image](https://github.com/user-attachments/assets/6762198a-cb78-4089-b529-ca6d3973fd1e)
![image](https://github.com/user-attachments/assets/58a330ec-2e91-4813-9e05-83d9814fc0e8)
