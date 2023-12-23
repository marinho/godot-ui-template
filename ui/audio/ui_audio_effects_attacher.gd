extends Node

# inspired by: https://www.youtube.com/watch?v=QgBecUl_lFs

@export var root_path : NodePath

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_on_root_node()


func apply_on_root_node():
	if not root_path:
		print("root_path not set")
		return

	var root_node = get_node(root_path)
	apply_on_node(root_node)


func apply_on_node(root_node : Node):
	var audio_sounds = get_audio_sounds()
	install_connections(root_node, audio_sounds)


func get_audio_sounds():
	var audio_sounds = get_children().filter(func (child): return child is AudioStreamPlayer)
	return audio_sounds


func install_connections(root_node : Node, audio_sounds : Array):
	var valid_sounds = audio_sounds.filter(func (s): return s.is_active and s.node_group_name != "")
	for sound in audio_sounds:
		var ui_objects = get_children_in_group(root_node, sound.node_group_name)

		for ui_object in ui_objects:
			if sound.match_event(sound.INDEX_PRESSED):
				ui_object.pressed.connect(func (): sound.play())
			if sound.match_event(sound.INDEX_FOCUS_ENTERED):
				ui_object.focus_entered.connect(func (): sound.play())
			if sound.match_event(sound.INDEX_FOCUS_EXITED):
				ui_object.focus_exited.connect(func (): sound.play())
			if sound.match_event(sound.INDEX_MOUSE_ENTERED):
				ui_object.mouse_entered.connect(func (): sound.play())
			if sound.match_event(sound.INDEX_MOUSE_EXITED):
				ui_object.mouse_exited.connect(func (): sound.play())


func get_children_in_group(branch: Node, group: String) -> Array:
	var result = []

	for child in branch.get_children():
		if child.is_in_group(group):
			result.append(child)
		if child.get_child_count() > 0:
			result += get_children_in_group(child, group)

	return result
