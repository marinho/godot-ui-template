extends Node

var is_freezed = false

signal freezed
signal unfreezed

func set_freezed(to_be_freezed: bool):
	if to_be_freezed == is_freezed:
		return

	is_freezed = to_be_freezed
	get_tree().paused = is_freezed

	if is_freezed:
		freezed.emit()
	else:
		unfreezed.emit()
