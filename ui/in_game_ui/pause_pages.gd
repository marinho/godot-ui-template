extends Control

@export var is_active = false
@export var pages : Array[NodePath] = []
@export var transition_to_fade : Resource
@export var transition_to_left : Resource
@export var transition_to_right : Resource

@onready var page_left_input_name = "ui_page_up"
@onready var page_right_input_name = "ui_page_down"

@onready var page_left_button = %PageLeftButton
@onready var page_right_button = %PageRightButton
@onready var transitions_container = %Transitions

var is_switching_page = false
var current_page_index = 0
var transitions = {}


func _ready():
	transitions = _create_transitions()


func _process(_delta):
	if is_switching_page or not visible:
		return

	if Input.is_action_just_pressed(page_left_input_name):
		page_left_button.pressed.emit()
	elif Input.is_action_just_pressed(page_right_input_name):
		page_right_button.pressed.emit()


func activate():
	is_active = true
	current_page_index = 0
	GuiTransitions.show("%s_to_fade" % get_node(pages.front()).name)
	# var counter = 0
	# for page in pages:
	# 	var layout = get_node(page)
	# 	layout.visible = counter == 0
	# 	counter += 1


func deactivate():
	is_active = false
	for page in pages:
		var layout = get_node(page)
		layout.hide()


func _navigate_to_left():
	if not is_active or is_switching_page:
		return

	var current_page = get_node(pages[current_page_index])
	var new_page_index = (current_page_index - 1) if current_page_index > 0 else pages.size() - 1
	var new_page = get_node(pages[new_page_index])

	var current_page_transition = transitions["%s_to_left" % current_page.name]
	var new_page_transition = transitions["%s_to_left" % new_page.name]

	print(["left:", current_page_transition.layout_id, new_page_transition.layout_id]) # XXX

	GuiTransitions.hide(current_page_transition.layout_id)
	GuiTransitions.show(new_page_transition.layout_id)

	await GuiTransitions.show_completed
	print("to left - show completed") # XXX
	current_page_index = new_page_index


func _navigate_to_right():
	if not is_active or is_switching_page:
		return

	var current_page = get_node(pages[current_page_index])
	var new_page_index = (current_page_index + 1) % pages.size()
	var new_page = get_node(pages[new_page_index])

	var current_page_transition = transitions["%s_to_right" % current_page.name]
	var new_page_transition = transitions["%s_to_right" % new_page.name]
	print(["right:", current_page_transition.layout_id, new_page_transition.layout_id]) # XXX

	GuiTransitions.hide(current_page_transition.layout_id)
	GuiTransitions.show(new_page_transition.layout_id)

	await GuiTransitions.show_completed
	print("to right - show completed") # XXX
	current_page_index = new_page_index


func _resume_game():
	InGameUi.unpause()


func _return_to_entry_scene():
	InGameUi.can_be_paused = false
	GameManager.load_entry_scene()


func _quit_game():
	DialogLauncher.confirm("Are you sure to quit the game?")
	var confirmed = await DialogLauncher.user_confirmed

	if confirmed:
		get_tree().quit()


func _create_transitions():
	var new_transitions = {}

	for page_path in pages:
		var page = get_node(page_path)

		var fade_transition = transition_to_fade.instantiate() as GuiTransition
		fade_transition.layout = page.get_path()
		fade_transition.layout_id = "%s_fade" % page.name
		fade_transition.group = page.get_children().front().get_path()
		transitions_container.add_child(fade_transition)
		new_transitions[fade_transition.layout_id] = fade_transition

		var left_transition = transition_to_left.instantiate() as GuiTransition
		left_transition.layout = page.get_path()
		left_transition.layout_id = "%s_to_left" % page.name
		left_transition.group = page.get_children().front().get_path()
		transitions_container.add_child(left_transition)
		new_transitions[left_transition.layout_id] = left_transition

		var right_transition = transition_to_right.instantiate()
		right_transition.layout = page.get_path()
		right_transition.layout_id = "%s_to_right" % page.name
		right_transition.group = page.get_children().front().get_path()
		transitions_container.add_child(right_transition)
		new_transitions[right_transition.layout_id] = right_transition

	return new_transitions
	
