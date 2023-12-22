extends Node

@export var current_game_id : int = 0

var current_game = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_current_game(new_game):
	current_game = new_game
	

func load_scene(scene_file_path):
	# var next_scene = preload(scene_file_path)
	get_tree().change_scene_to_file(scene_file_path)
	
