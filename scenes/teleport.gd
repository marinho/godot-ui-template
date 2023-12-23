extends Area3D

@export_file() var target_scene


func _on_body_entered(body):
	GameManager.load_scene(target_scene)
