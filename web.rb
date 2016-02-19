require 'sinatra'
require 'json'

# Snake ID ee78439a-e6fa-40a0-a28a-874b7b10e287

get '/' do
    responseObject = {
        "color"=> "#eeeeee",
        "head_url"=> "https://leanpub-battlesnake.herokuapp.com/leanpublogo.png"
    }

    return responseObject.to_json
end

post '/start' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    # Get ready to start a game with the request data

    # Dummy response
    responseObject = {
        "taunt" => "battlesnake-ruby",
    }

    return responseObject.to_json
end

post '/move' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    # Calculate a move with the request data
    puts "debug hello world"


    # Dummy response
    responseObject = {
      "move" => "north", # One of either "north", "east", "south", or "west".
      "taunt" => "going north!",
    }

    return responseObject.to_json
end

post '/end' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    # No response required
    responseObject = {}

    return responseObject.to_json
end