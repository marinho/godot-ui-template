extends CanvasLayer

@export var layout_name_active_game = "ActiveGame"
@export var layout_name_pause_menu = "PauseMenu"
@export var layout_name_settings = "Settings"
@export var layout_name_controls = "Controls"
@export var toggle_input_name = "ui_toggle_pause"
@export var page_left_input_name = "ui_page_up"
@export var page_right_input_name = "ui_page_down"

@onready var layout_active_game = %ActiveGame
@onready var layout_pause_menu = %PauseMenu
@onready var layout_settings = %Settings
@onready var layout_controls = %Controls

signal paused
signal unpaused

var is_paused = false
var can_be_paused = false
var is_switching_page = false


func _process(_delta):
	if not can_be_paused:
		return

	if Input.is_action_just_pressed(toggle_input_name):
		can_be_paused = false
		if is_paused:
			unpause()
		else:
			pause()

	paging_input()
	

func paging_input():
	if is_switching_page:
		return

	var change_direction = 0
	if Input.is_action_just_pressed(page_left_input_name):
		change_direction = -1
	elif Input.is_action_just_pressed(page_right_input_name):
		change_direction = 1
	else:
		return

	var page
	if layout_pause_menu.visible:
		page = layout_pause_menu
	elif layout_settings.visible:
		page = layout_settings
	elif layout_controls.visible:
		page = layout_controls
	else:
		return

	if change_direction < 0:
		var page_left_button = page.get_node("PageLeftButton")
		page_left_button.pressed.emit()
	elif change_direction > 0:
		var page_right_button = page.get_node("PageRightButton")
		page_right_button.pressed.emit()


func _on_quit_button_pressed():
	DialogLauncher.confirm("Are you sure to quit the game?")
	var confirmed = await DialogLauncher.user_confirmed

	if confirmed:
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
	layout_pause_menu.get_node("FocusFirst").focus_on_first()

	paused.emit()
	can_be_paused = true


func unpause():
	is_paused = false
	FreezeManager.set_freezed(false)
	
	GuiTransitions.go_to(layout_name_active_game)
	await GuiTransitions.show_completed

	unpaused.emit()
	can_be_paused = true


func return_to_entry_scene():
	can_be_paused = false
	GameManager.load_entry_scene()


func go_to_pause_menu():
	is_switching_page = true
	ControlBlocker.set_active(true)
	GuiTransitions.go_to(layout_name_pause_menu)
	await GuiTransitions.show_completed
	layout_pause_menu.get_node("FocusFirst").focus_on_first()
	ControlBlocker.set_active(false)
	is_switching_page = false
	

func go_to_settings():
	is_switching_page = true
	ControlBlocker.set_active(true)
	GuiTransitions.go_to(layout_name_settings)
	await GuiTransitions.show_completed
	layout_settings.get_node("FocusFirst").focus_on_first()
	ControlBlocker.set_active(false)
	is_switching_page = false
	

func go_to_controls():
	is_switching_page = true
	ControlBlocker.set_active(true)
	GuiTransitions.go_to(layout_name_controls)
	await GuiTransitions.show_completed
	layout_controls.get_node("FocusFirst").focus_on_first()
	ControlBlocker.set_active(false)
	is_switching_page = false
	
