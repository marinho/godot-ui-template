extends CanvasLayer


var is_active = false


func _ready():
	set_active(is_active)


func set_active(new_value: bool):
	is_active = new_value
	if is_active:
		$Control.focus_mode = Control.FOCUS_ALL
		$Control.mouse_filter = Control.MOUSE_FILTER_STOP
		$Control.grab_focus()
	else:
		$Control.focus_mode = Control.FOCUS_NONE
		$Control.mouse_filter = Control.MOUSE_FILTER_IGNORE
