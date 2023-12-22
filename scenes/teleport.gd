extends Area3D

@export_file() var target_scene

@onready var game_manager = get_node("/root/GameManager")


func _on_body_entered(body):
	game_manager.load_scene(target_scene)
