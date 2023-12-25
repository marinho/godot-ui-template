extends CanvasLayer

const layout_name_active_game = "ActiveGame"
const layout_name_pause_menu = "PauseMenu"
const layout_name_settings = "Settings"
const layout_name_controls = "Controls"

@onready var toggle_input_name = "ui_toggle_pause"
@onready var page_left_input_name = "ui_page_up"
@onready var page_right_input_name = "ui_page_down"

@onready var layouts = {
	layout_name_active_game: %ActiveGame,
	layout_name_pause_menu: %PauseMenu,
	layout_name_settings: %Settings,
	layout_name_controls: %Controls,
}

@onready var transitions = {
	layout_name_active_game: %TransitionToActiveGame,
	layout_name_pause_menu: %TransitionToPauseMenu,
	layout_name_settings: %TransitionToSettings,
	layout_name_controls: %TransitionToControls,
}

@onready var current_layout = layouts[layout_name_active_game]

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

	if current_layout == layouts[layout_name_active_game]:
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
	current_layout = layouts[layout_name_active_game]


func pause():
	is_paused = true
	FreezeManager.set_freezed(true)

	transitions[layout_name_pause_menu].animation_enter = GuiTransition.Anim.DEFAULT

	GuiTransitions.go_to(layout_name_pause_menu)
	await GuiTransitions.show_completed
	layouts[layout_name_pause_menu].get_node("FocusFirst").focus_on_first()
	current_layout = layouts[layout_name_pause_menu]

	paused.emit()
	can_be_paused = true


func unpause():
	is_paused = false
	FreezeManager.set_freezed(false)
	
	transitions[layout_name_pause_menu].animation_leave = GuiTransition.Anim.DEFAULT

	GuiTransitions.go_to(layout_name_active_game)
	await GuiTransitions.show_completed
	current_layout = layouts[layout_name_active_game]

	unpaused.emit()
	can_be_paused = true


func _return_to_entry_scene():
	can_be_paused = false
	GameManager.load_entry_scene()


func _switch_to_previous_layout():
	if current_layout == layouts[layout_name_pause_menu]:
		_transition_to_layout(layout_name_controls)
	elif current_layout == layouts[layout_name_settings]:
		_transition_to_layout(layout_name_pause_menu)
	elif current_layout == layouts[layout_name_controls]:
		_transition_to_layout(layout_name_settings)


func _switch_to_next_layout():
	if current_layout == layouts[layout_name_pause_menu]:
		_transition_to_layout(layout_name_settings)
	elif current_layout == layouts[layout_name_settings]:
		_transition_to_layout(layout_name_controls)
	elif current_layout == layouts[layout_name_controls]:
		_transition_to_layout(layout_name_pause_menu)


func _transition_to_layout(transition_to):
	is_switching_page = true
	ControlBlocker.set_active(true)
	GuiTransitions.go_to(transition_to)
	await GuiTransitions.show_completed
	layouts[transition_to].get_node("FocusFirst").focus_on_first()
	ControlBlocker.set_active(false)
	current_layout = layouts[transition_to]
	is_switching_page = false
