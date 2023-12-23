extends Node

const NO_GAME = -1
@export var current_game_id : int = NO_GAME
@export var current_scene_path : String
@export_file() var entry_scene_path


func set_current_game(new_game):
	current_game_id = new_game["id"]


func load_scene(scene_file_path):
	current_scene_path = scene_file_path
	SceneTransition.change_scene(scene_file_path)
	await SceneTransition.after_scene_change
	InGameUi.activate_for_game()
	

func load_entry_scene():
	current_game_id = NO_GAME
	current_scene_path = entry_scene_path
	SceneTransition.change_scene(entry_scene_path)
	await SceneTransition.after_scene_change
