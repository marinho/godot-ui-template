extends CanvasLayer

@export var can_be_paused = false
@export var layout_name_active_game = "ActiveGame"
@export var layout_name_pause_menu = "PauseMenu"
@export var input_name = "ui_cancel"

@onready var layout_active_game = %ActiveGame
@onready var layout_pause_menu = %PauseMenu

signal paused
signal unpaused

var is_paused = false


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not can_be_paused:
		return

	if Input.is_action_just_pressed("ui_cancel"):
		if is_paused:
			unpause()
		else:
			pause()
	

func _on_quit_button_pressed():
	get_tree().quit()


func activate_for_game():
	visible = true
	can_be_paused = true
	GuiTransitions.show(layout_name_active_game)


func pause():
	is_paused = true
	FreezeManager.set_freezed(true)
	GuiTransitions.go_to(layout_name_pause_menu)
	await GuiTransitions.show_completed
	paused.emit()
	layout_pause_menu.get_node("FocusFirst").focus_on_first()


func unpause():
	is_paused = false
	FreezeManager.set_freezed(false)
	
	GuiTransitions.go_to(layout_name_active_game)
	await GuiTransitions.show_completed
	paused.emit()
