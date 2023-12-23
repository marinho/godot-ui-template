extends Node

@onready var player: CharacterBody3D = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	var game = GamePersistence.load_game(GameManager.current_game_id)
	var location = game["location"] if game.has("location") else null
	var valid_location = location and location.get("scene") == GameManager.current_scene_path
	var valid_position = location.get("x") != null and location.get("y") != null and location.get("z") != null

	if valid_location and valid_position:
		var saved_position = Vector3(location["x"], location["y"], location["z"])
		player.global_position = saved_position
