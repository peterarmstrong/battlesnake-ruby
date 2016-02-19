require 'sinatra'
require 'json'

MY_SNAKE_ID = "ee78439a-e6fa-40a0-a28a-874b7b10e287"

get '/' do
    responseObject = {
        "color"=> "#eeeeee",
        "head_url"=> "https://leanpub-battlesnake.herokuapp.com/public/images/logo.png"
    }

    return responseObject.to_json
end

post '/start' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    # Get ready to start a game with the request data

    # Dummy response
    responseObject = {
        "taunt" => "hello taunt",
    }

    return responseObject.to_json
end

post '/move' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    # Calculate a move with the request data
    puts requestJson

    turn = requestJson["turn"]
    food = requestJson["food"]
    gold = requestJson["gold"]
    mode = requestJson["mode"]
    walls = requestJson["walls"]
    height = requestJson["height"]
    game = requestJson["game"]
    snakes = requestJson["snakes"]
    width = requestJson["width"]

    my_snake = snakes.select{|snake| snake["id"] == MY_SNAKE_ID}.first
    other_snakes = snakes.reject{|snake| snake["id"] == MY_SNAKE_ID}

    puts "turn is #{turn}"
    puts "food is #{food}"
    puts "gold is #{gold}"
    puts "mode is #{mode}"
    puts "walls is #{walls}"
    puts "height is #{height}"
    puts "game is #{game}"
    puts "snakes are #{snakes}"
    puts "width is #{width}"
    puts "my_snake is #{my_snake}"
    puts "other_snakes are #{other_snakes}"

# {"turn": 2, "food": [], "gold": [[10, 9]], "mode": "advanced", "walls": [], "height": 20, "game": "inspired-runoff", "snakes": [{"gold": 0, "url": "localsnake://greg", "kills": 0, "age": 2, "id": "4ac21049-218e-421b-b4ef-c095e5032647", "message": "", "name": "Sleepy Snake", "coords": [[14, 5], [14, 4], [15, 4]], "taunt": null, "status": "alive", "health": 98}, {"id": "ee78439a-e6fa-40a0-a28a-874b7b10e287", "message": "", "name": "Lean Snake", "coords": [[15, 13], [15, 14], [15, 15]], "taunt": "going north!", "health": 98, "status": "alive", "gold": 0, "kills": 0, "age": 2}], "width": 20}

    my_snake_coords = my_snake["coords"]


    moves = %w(north east south west)
    move = moves[rand(4)]

    # Dummy response
    responseObject = {
      "move" => move,
      "taunt" => "going #{move}!"
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