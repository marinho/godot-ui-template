extends Area3D

@export_file() var target_scene


func _on_body_entered(_body):
	GameManager.load_scene(target_scene)
