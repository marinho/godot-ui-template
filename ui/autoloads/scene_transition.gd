extends CanvasLayer

# source: https://www.youtube.com/watch?v=yZQStB6nHuI

func change_scene(target: String) -> void:
	FreezeManager.set_freezed(true)
	$AnimationPlayer.play("dissolve")

	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	
	$AnimationPlayer.play_backwards("dissolve")
	FreezeManager.set_freezed(false)
	
