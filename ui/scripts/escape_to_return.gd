extends Node

@export var layout_to_return_to = "MainMenu"
@export var input_name = "ui_cancel"
@export var can_return = true
@onready var credits_scrollable = %CreditsScrollable

signal after_return

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if can_return and not GuiTransitions.is_hidden(layout_to_return_to):
		return

	if Input.is_action_just_pressed("ui_cancel"):
		can_return = false
		credits_scrollable.stop_scrolling()
		GuiTransitions.go_to(layout_to_return_to)
		await GuiTransitions.show_completed
		can_return = true
		after_return.emit()
	
func _on_show_completed():
	can_return = true