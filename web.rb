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
    #puts requestJson

    turn = requestJson["turn"]
    food = requestJson["food"]
    gold = requestJson["gold"]
    mode = requestJson["mode"]
    inner_walls = requestJson["walls"]
    inner_walls ||= []
    height = requestJson["height"]
    game = requestJson["game"]
    snakes = requestJson["snakes"]
    width = requestJson["width"]

    my_snake = snakes.select{|snake| snake["id"] == MY_SNAKE_ID}.first
    other_snakes = snakes.reject{|snake| snake["id"] == MY_SNAKE_ID}

    #puts "turn is #{turn}"
    #puts "food is #{food}"
    #puts "gold is #{gold}"
    #puts "mode is #{mode}"
    #puts "inner_walls is #{inner_walls}"
    #puts "height is #{height}"
    #puts "game is #{game}"
    #puts "snakes are #{snakes}"
    #puts "width is #{width}"
    #puts "my_snake is #{my_snake}"
    #puts "other_snakes are #{other_snakes}"

# {"turn": 2, "food": [], "gold": [[10, 9]], "mode": "advanced", "walls": [], "height": 20, "game": "inspired-runoff", "snakes": [{"gold": 0, "url": "localsnake://greg", "kills": 0, "age": 2, "id": "4ac21049-218e-421b-b4ef-c095e5032647", "message": "", "name": "Sleepy Snake", "coords": [[14, 5], [14, 4], [15, 4]], "taunt": null, "status": "alive", "health": 98}, {"id": "ee78439a-e6fa-40a0-a28a-874b7b10e287", "message": "", "name": "Lean Snake", "coords": [[15, 13], [15, 14], [15, 15]], "taunt": "going north!", "health": 98, "status": "alive", "gold": 0, "kills": 0, "age": 2}], "width": 20}

# {"turn"=>56, "game"=>"puzzled-architecture", "height"=>20, "mode"=>"advanced", "food"=>[[15, 18], [7, 1], [4, 19], [15, 9], [13, 18], [2, 13], [0, 7], [7, 16], [8, 8], [14, 16], [5, 16], [6, 10], [12, 10], [11, 6], [14, 0], [19, 19]], "walls"=>[[8, 13], [11, 15]], "width"=>20, "snakes"=>[{"taunt"=>nil, "message"=>"", "gold"=>0, "id"=>"4f286331-b8e2-42d8-ac8f-d075ccfe301c", "age"=>56, "status"=>"alive", "coords"=>[[1, 18], [1, 19], [0, 19]], "health"=>44, "name"=>"Son of Chicken Snake", "kills"=>0}, {"taunt"=>"going south!", "message"=>"", "gold"=>0, "id"=>"ee78439a-e6fa-40a0-a28a-874b7b10e287", "age"=>56, "status"=>"alive", "coords"=>[[16, 1], [16, 0], [15, 0], [15, 1], [15, 2]], "health"=>95, "name"=>"Leanpub Bounty Snake", "kills"=>0}], "gold"=>[[9, 10]]}

# snakes grow at head. tail does not move if snake eats food. otherwise, tail is pulled along.

    my_snake_coords = my_snake["coords"]
    my_snake_head = my_snake_coords[0]
    my_snake_head_x = my_snake_head[0]
    my_snake_head_y = my_snake_head[1]

    # Board:
    # [0,0],        [1,0],        ..., [width-1, 0]
    # [0,1],        [1,1],        ..., [width-1, 1]
    # ...
    # [0,height-2], [1,height-2], ..., [width-1, height-2]
    # [0,height-1], [1,height-1], ..., [width-1, height-1]

    north_move_coord = [my_snake_head_x, my_snake_head_y - 1]
    east_move_coord = [my_snake_head_x + 1, my_snake_head_y]
    south_move_coord = [my_snake_head_x, my_snake_head_y + 1]
    west_move_coord = [my_snake_head_x - 1, my_snake_head_y]
    possible_move_coords = [north_move_coord, east_move_coord, south_move_coord, west_move_coord]

    # Outer Walls:
    # [-1, -1], [0, -1], ... [width, -1]
    # [-1, 0],               [width, 0]
    # [-1, 1],               [width, 1]
    # ...
    # [-1, height], [0, height], ..., [width, height]

    outer_walls = []
    # build top wall
    for x in -1 .. width
      outer_walls << [x, -1]
    end
    # build bottom wall
    for x in -1 .. width
      outer_walls << [x, height]
    end
    # build left wall
    for y in 0 .. height-1
      outer_walls << [-1, y]
    end
    # build right wall
    for y in 0 .. height-1
      outer_walls << [width, y]
    end

    #puts "there are #{outer_walls.length} outer walls"
    #puts outer_walls.inspect

    #puts "there are #{inner_walls.length} inner walls"

    walls = outer_walls + inner_walls

    #puts "there are #{walls.length} walls"

    #puts "walls"
    #puts walls.inspect

    #puts "possible_move_coords START AS #{possible_move_coords}"

    possible_move_coords = avoid_coords(possible_move_coords, walls)

    #puts "possible_move_coords are now #{possible_move_coords}"


    # Avoid snake bodies (including the tail for now, even though it usually moves)
    snake_bodies = my_snake["coords"]
    other_snakes.each do |snake|
      snake_bodies += snake["coords"]
    end

    #puts "snake_bodies = #{snake_bodies}"

    possible_move_coords = avoid_coords(possible_move_coords, snake_bodies)

    #puts "possible_move_coords are now #{possible_move_coords}"

    move_coord = choose_move_coord(possible_move_coords)
    #puts "move_coord = #{move_coord}"

    move = coords_to_move_direction(move_coord, north_move_coord, east_move_coord, south_move_coord, west_move_coord)
    #puts "move = #{move}"

    # Dummy response
    responseObject = {
      "move" => move,
      "taunt" => "going #{move}!"
    }

    return responseObject.to_json
end

def coords_to_move_direction(move_coord, north_move_coord, east_move_coord, south_move_coord, west_move_coord)
  return "north" if move_coord == north_move_coord
  return "east" if move_coord == east_move_coord
  return "south" if move_coord == south_move_coord
  return "west" if move_coord == west_move_coord
  return "omgwtfbbq"
end

def avoid_coords(possible_move_coords, coords)
  legal_coords = []
  possible_move_coords.each do |coord|
    legal_coords << coord unless coords.include? coord
  end
  legal_coords
end

def choose_move_coord(possible_move_coords)
  # TODO - stub
  possible_move_coords[rand(possible_move_coords.length)]
end

post '/end' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    # No response required
    responseObject = {}

    return responseObject.to_json
end