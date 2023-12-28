extends CanvasLayer

const layout_name_active_game = "ActiveGame"
const layout_name_pause_menu = "PauseMenu"
const layout_name_settings = "Settings"
const layout_name_controls = "Controls"

@onready var toggle_input_name = "ui_toggle_pause"
@onready var page_left_input_name = "ui_page_up"
@onready var page_right_input_name = "ui_page_down"
@onready var keyboard_controls = %KeyboardControls
@onready var gamepad_controls = %GamepadControls

@onready var pages = [
	{
		"name": layout_name_active_game,
		"layout": %ActiveGame,
		"transition": %TransitionToActiveGame,
	},
	{
		"name": layout_name_pause_menu,
		"layout": %PauseMenu,
		"transition": %TransitionToPauseMenu,
	},
	{
		"name": layout_name_settings,
		"layout": %Settings,
		"transition": %TransitionToSettings,
	},
	{
		"name": layout_name_controls,
		"layout": %Controls,
		"transition": %TransitionToControls,
	},
]

@onready var current_layout = %ActiveGame

signal paused
signal unpaused

var is_paused = false
var can_be_paused = false
var is_switching_page = false


func _ready():
	InputHelper.device_changed.connect(func(device: String, idx: int): _device_changed(device, idx))
	_device_changed(InputHelper.device)


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

	if current_layout == _get_page(layout_name_active_game).layout:
		return

	if change_direction < 0:
		var page_left_button = current_layout.get_node("PageLeftButton")
		page_left_button.pressed.emit()
	elif change_direction > 0:
		var page_right_button = current_layout.get_node("PageRightButton")
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
	current_layout = _get_page(layout_name_active_game).layout


func pause():
	is_paused = true
	FreezeManager.set_freezed(true)

	GuiTransitions.go_to(layout_name_pause_menu)
	await GuiTransitions.show_completed
	_get_page(layout_name_pause_menu).layout.get_node("FocusFirst").focus_on_first()
	current_layout = _get_page(layout_name_pause_menu).layout

	paused.emit()
	can_be_paused = true


func unpause():
	is_paused = false
	FreezeManager.set_freezed(false)
	
	GuiTransitions.go_to(layout_name_active_game)
	await GuiTransitions.show_completed
	current_layout = _get_page(layout_name_active_game).layout

	unpaused.emit()
	can_be_paused = true


func _return_to_entry_scene():
	can_be_paused = false
	GameManager.load_entry_scene()


func _switch_to_previous_layout():
	if current_layout == _get_page(layout_name_pause_menu).layout:
		_transition_to_layout(layout_name_controls)
	elif current_layout == _get_page(layout_name_settings).layout:
		_transition_to_layout(layout_name_pause_menu)
	elif current_layout == _get_page(layout_name_controls).layout:
		_transition_to_layout(layout_name_settings)


func _switch_to_next_layout():
	if current_layout == _get_page(layout_name_pause_menu).layout:
		_transition_to_layout(layout_name_settings)
	elif current_layout == _get_page(layout_name_settings).layout:
		_transition_to_layout(layout_name_controls)
	elif current_layout == _get_page(layout_name_controls).layout:
		_transition_to_layout(layout_name_pause_menu)


func _transition_to_layout(transition_to):
	is_switching_page = true
	ControlBlocker.set_active(true)
	GuiTransitions.go_to(transition_to)
	await GuiTransitions.show_completed
	_get_page(transition_to).layout.get_node("FocusFirst").focus_on_first()
	ControlBlocker.set_active(false)
	current_layout = _get_page(transition_to).layout
	is_switching_page = false


func _get_page(name):
	return pages.filter(func(page): return page.name == name).front()


func _device_changed(device: String, device_index: int = -1):
	print("Input Device: ", device)
	gamepad_controls.visible = device != "keyboard"
	keyboard_controls.visible = device == "keyboard"
