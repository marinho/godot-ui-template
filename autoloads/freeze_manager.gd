extends Node

var is_freezed = false

signal freezed
signal unfreezed

func set_freezed(new_value: bool):
	if new_value == is_freezed:
		return

	is_freezed = new_value
	get_tree().paused = is_freezed

	if is_freezed:
		freezed.emit()
	else:
		unfreezed.emit()
