extends Node

@export var file_name = "game.json"

signal game_created(game_id : int)
signal game_updated(game_id : int)
signal game_deleted(game_id : int)

var file_path = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	file_path = "user://" + file_name


func _read_file_as_json():
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
	var json = _read_file_as_json()
	if json.has("saved_games"):
		return json["saved_games"]
	else:
		return []


func save_new_game(first_scene_path : String):
	var json = _read_file_as_json()
	if not json.has("saved_games"):
		json["saved_games"] = []

	var biggest_game_id = json["saved_games"].map(func(x): return x["id"]).max()

	var new_game = {
		"id": biggest_game_id + 1,
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
			"y": -1.0,
			"z": -1.0,
		},
		"inventory": {}, # used to save items in the player's inventory, which can be integer or boolean values
		"saved_states": {}, # used to save state of objects in the scene, such as chests, levers, etc.
	}

	json["saved_games"].append(new_game)
	save_json_to_file(json)
	game_created.emit(new_game["id"])

	return new_game


func load_game(game_id: int):
	var json = _read_file_as_json()
	if not json.has("saved_games"):
		return null

	var games_by_id = json["saved_games"].filter(func(x): return x["id"] == game_id)

	if games_by_id.size() == 0:
		return null

	return games_by_id[0]


func update_saved_game(game_id: int, partial_values):
	var game_json = _read_file_as_json()
	var saved_game = load_game(game_id)
	var updated_game = _override_dict(saved_game, partial_values)

	game_json["saved_games"] = game_json["saved_games"].map(func(x): return updated_game if x["id"] == game_id else x)
	
	save_json_to_file(game_json)
	game_updated.emit(game_id)
	

func delete_saved_game(game_id: int):
	var game_json = _read_file_as_json()
	game_json["saved_games"] = game_json["saved_games"].filter(func(x): return x["id"] != game_id)
	save_json_to_file(game_json)
	game_deleted.emit(game_id)


func _override_dict(original_dict, new_dict):
	var dict_to_overwrite = original_dict.duplicate()
	for key in new_dict.keys():
		if dict_to_overwrite.has(key):
			if typeof(dict_to_overwrite[key]) == TYPE_DICTIONARY:
				dict_to_overwrite[key] = _override_dict(dict_to_overwrite[key], new_dict[key])
			else:
				dict_to_overwrite[key] = new_dict[key]
		else:
			dict_to_overwrite[key] = new_dict[key]
	return dict_to_overwrite
