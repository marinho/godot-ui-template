extends Node

@export var focus_on_ready: bool
@export var controls_in_sequence: Array[Control]

# Called when the node enters the scene tree for the first time.
func _ready():
	if focus_on_ready:
		focus_on_first()

func focus_on_first():
	if not controls_in_sequence:
		return
		
	for control in controls_in_sequence:
		if control.visible:
			control.grab_focus()
			break
