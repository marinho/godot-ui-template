extends CanvasLayer

@export var can_be_paused = false
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


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not can_be_paused:
		return

	if Input.is_action_just_pressed(toggle_input_name):
		if is_paused:
			unpause()
		else:
			pause()

	paging_input()
	

func paging_input():
	var page
	if layout_pause_menu.visible:
		page = layout_pause_menu
	elif layout_settings.visible:
		page = layout_settings
	elif layout_controls.visible:
		page = layout_controls
	else:
		return

	if Input.is_action_just_pressed(page_left_input_name):
		var page_left_button = page.get_node("PageLeftButton")
		page_left_button.pressed.emit()
	elif Input.is_action_just_pressed(page_right_input_name):
		var page_right_button = page.get_node("PageRightButton")
		page_right_button.pressed.emit()


func _on_quit_button_pressed():
	get_tree().quit()


func activate_for_game():
	visible = true
	can_be_paused = true
	GuiTransitions.show(layout_name_active_game)


func pause():
	is_paused = true
	FreezeManager.set_freezed(true)
	go_to_pause_menu()
	paused.emit()


func unpause():
	is_paused = false
	FreezeManager.set_freezed(false)
	
	GuiTransitions.go_to(layout_name_active_game)
	await GuiTransitions.show_completed
	paused.emit()


func return_to_entry_scene():
	can_be_paused = false
	GameManager.load_entry_scene()


func go_to_pause_menu():
	GuiTransitions.go_to(layout_name_pause_menu)
	await GuiTransitions.show_completed
	layout_pause_menu.get_node("FocusFirst").focus_on_first()
	

func go_to_settings():
	GuiTransitions.go_to(layout_name_settings)
	await GuiTransitions.show_completed
	layout_settings.get_node("FocusFirst").focus_on_first()
	

func go_to_controls():
	GuiTransitions.go_to(layout_name_controls)
	await GuiTransitions.show_completed
	layout_controls.get_node("FocusFirst").focus_on_first()
	
