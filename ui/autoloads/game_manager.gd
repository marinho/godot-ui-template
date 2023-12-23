extends Node

@export var current_game_id : int = -1
@export var current_scene_path : String


func set_current_game(new_game):
	current_game_id = new_game["id"]


func load_scene(scene_file_path):
	current_scene_path = scene_file_path
	SceneTransition.change_scene(scene_file_path)
	await SceneTransition.after_scene_change
	InGameUi.activate_for_game()
	
