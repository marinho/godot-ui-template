extends Node

@export var layout_to_return_to = "MainMenu"
@export var input_name = "ui_cancel"
@export var can_return = true

signal before_return
signal after_return


func _process(_delta):
	if not can_return or not GuiTransitions.is_hidden(layout_to_return_to):
		return

	if Input.is_action_just_pressed(input_name):
		can_return = false
		before_return.emit()
		GuiTransitions.go_to(layout_to_return_to)
		await GuiTransitions.show_completed
		after_return.emit()
		can_return = true
