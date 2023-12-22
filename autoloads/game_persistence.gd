extends Node

@export var file_name = "game.json"

var file_path = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	file_path = "user://" + file_name


func read_file_as_json():
	if FileAccess.file_exists(file_path):
		var fp = FileAccess.open(file_path, FileAccess.READ)
		var contents = fp.get_as_text()
		var data = JSON.parse_string(contents)
		return data
	else:
		return {}


func save_json_to_file(json):
	var fp = FileAccess.open(file_path, FileAccess.WRITE)
	fp.store_string(JSON.stringify(json))


func get_saved_games():
	var json = read_file_as_json()
	if json.has("saved_games"):
		return json["saved_games"]
	else:
		return []


func save_new_game(first_scene_path):
	var json = read_file_as_json()
	if not json.has("saved_games"):
		json["saved_games"] = []

	var new_game = {
		"id": json["saved_games"].size() + 1,
		"datetime": Time.get_datetime_dict_from_system(),
		"completed_percent": 0.0,
		"time_played": 0.0,
		"player": {
			"name": "Player",
			"health": 100,
			"max_health": 100,
		},
		"location": {
			"scene": first_scene_path,
			"x": -1.0, # default spawn point
			"y": -1.0
		},
		"inventory": {}, # used to save items in the player's inventory, which can be integer or boolean values
		"saved_states": {}, # used to save state of objects in the scene, such as chests, levers, etc.
	}

	json["saved_games"].append(new_game)
	save_json_to_file(json)

	return new_game


func load_game(game_id: int):
	var json = read_file_as_json()
	if not json.has("saved_games"):
		return null

	var games_by_id = json["saved_games"].filter(func(x): return x["id"] == game_id)

	if games_by_id.size() == 0:
		return null

	return games_by_id[0]


func update_saved_game(game_id: int, partial_values):
	var game_json = read_file_as_json()
	var saved_game = load_game(game_id)
	# TODO merge partial_values with existing dictionary and save it
	
