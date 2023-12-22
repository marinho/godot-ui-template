extends Node

@export var current_game_id : int = -1
@export var current_scene_path : String


func set_current_game(new_game):
	current_game_id = new_game["id"]


func load_scene(scene_file_path):
	current_scene_path = scene_file_path
	get_tree().change_scene_to_file(scene_file_path)
	
