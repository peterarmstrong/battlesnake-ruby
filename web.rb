require 'sinatra'
require 'json'

MY_SNAKE_ID = "ee78439a-e6fa-40a0-a28a-874b7b10e287"
LEGAL_MOVES = %w(north east south west)

get '/' do
    responseObject = {
        "color"=> "#ffffff",
        "head_url"=> "https://pbs.twimg.com/profile_images/522096341728497664/Wcu4XQUw_400x400.png"
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
    my_snake_head = my_snake_coords[0]
    my_snake_neck = my_snake_coords[1]
    my_snake_head_x = my_snake_head[0]
    my_snake_head_y = my_snake_head[1]
    my_snake_neck_x = my_snake_neck[0]
    my_snake_neck_y = my_snake_neck[1]

    # [0,0],        [1,0],        ..., [width-1, 0]
    # [0,1],        [1,1],        ..., [width-1, 1]
    # ...
    # [0,height-2], [1,height-2], ..., [width-1, height-2]
    # [0,height-1], [1,height-1], ..., [width-1, height-1]

    dont_go = []
    puts "dont_go = #{dont_go}"

    # Avoid neck
    if my_snake_head_x - my_snake_neck_x == 1 # last move was east, don't go west
      dont_go << "west"
    elsif my_snake_head_x - my_snake_neck_x == -1 # last move was west, don't go east
      dont_go << "east"
    else
      if my_snake_head_y - my_snake_neck_y == 1 # last move was south, don't go north
        dont_go << "north"
      elsif my_snake_head_y - my_snake_neck_y == -1 # last move was north, don't go south
        dont_go << "south"
      else
        # assumption = no last move, nothing to avoid
      end
    end

    # Avoid outer walls
    dont_go << "west" if my_snake_head_x == 0
    dont_go << "east" if my_snake_head_x == width - 1
    dont_go << "north" if my_snake_head_y == 0
    dont_go << "south" if my_snake_head_y == height - 1

    # Avoid inner walls

    # Avoid snake bodies

    # Remove duplicates
    dont_go.uniq!

    puts "dont_go = #{dont_go}"
    puts "LEGAL_MOVES = #{LEGAL_MOVES}"

    possible_moves = LEGAL_MOVES.reject{|move| dont_go.include? move}

    puts "possible_moves = #{possible_moves}"
    move = choose_move(possible_moves)
    puts "move = #{move}"

    # Dummy response
    responseObject = {
      "move" => move,
      "taunt" => "going #{move}!"
    }

    return responseObject.to_json
end

def choose_move(possible_moves)
  # TODO - stub
  possible_moves[rand(possible_moves.length)]
end

post '/end' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    # No response required
    responseObject = {}

    return responseObject.to_json
end