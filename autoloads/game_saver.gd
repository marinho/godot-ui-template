extends Node

@export var auto_saving = false

@onready var game_manager = get_node("/root/GameManager")
@onready var game_persistence = get_node("/root/GamePersistence")

signal before_saved
signal after_saved


func _auto_saving_timer_timeout():
	# The frequence for timeout calls is set in the Timer node of game_saver.tscn
	if auto_saving and game_manager.current_game_id >= 0:
		save_player_state()


func save_player_state():
	before_saved.emit()
	print("Saving game...")

	var player = get_tree().get_first_node_in_group("Player") as CharacterBody3D

	var partial_values = {
		"datetime": Time.get_datetime_dict_from_system(),
		"completed_percent": 0.0,
		"time_played": 0.0,
		"player": {
			"health": 100,
			"max_health": 100,
		},
		"location": {
			"scene": game_manager.current_scene_path,
		},
	}
	if player:
		partial_values["location"]["x"] = player.global_position.x
		partial_values["location"]["y"] = player.global_position.y
		partial_values["location"]["z"] = player.global_position.z
	
	game_persistence.update_saved_game(
		game_manager.current_game_id,
		partial_values,
	)
	
	after_saved.emit()
	
