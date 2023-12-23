class_name UIAudioSoundPlayer
extends AudioStreamPlayer

@export var is_active : bool = true
@export var node_group_name : String = ""
@export_flags("pressed", "focus_entered", "focus_exited", "mouse_entered", "mouse_exited") var events_watched = 0

const INDEX_PRESSED = 0
const INDEX_FOCUS_ENTERED = 1
const INDEX_FOCUS_EXITED = 2
const INDEX_MOUSE_ENTERED = 3
const INDEX_MOUSE_EXITED = 4


func match_event(event_index: int):
	return is_bit_enabled(events_watched, event_index)


func is_bit_enabled(mask, index):
	return mask & (1 << index) != 0
	