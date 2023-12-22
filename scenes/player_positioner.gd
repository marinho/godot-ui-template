extends Node

@onready var player: CharacterBody3D = get_parent()
@onready var game_manager = get_node("/root/GameManager")
@onready var game_persistence = get_node("/root/GamePersistence")


# Called when the node enters the scene tree for the first time.
func _ready():
	var game = game_persistence.load_game(game_manager.current_game_id)
	var location = game["location"] if game.has("location") else null
	var valid_location = location and location.get("scene") == game_manager.current_scene_path
	var valid_position = location.get("x") != null and location.get("y") != null and location.get("z") != null

	if valid_location and valid_position:
		var saved_position = Vector3(location["x"], location["y"], location["z"])
		player.global_position = saved_position
