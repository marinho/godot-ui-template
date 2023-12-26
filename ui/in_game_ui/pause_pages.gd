extends Control

@export var pages : Array[NodePath] = []
@export var transition_to_left : Resource
@export var transition_to_right : Resource

@onready var page_left_input_name = "ui_page_up"
@onready var page_right_input_name = "ui_page_down"

@onready var page_left_button = %PageLeftButton
@onready var page_right_button = %PageRightButton

var is_switching_page = false
var current_page_index = 0
var transitions = {}


func _ready():
	transitions = create_transitions()


func _process(_delta):
	if is_switching_page or not visible:
		return

	if Input.is_action_just_pressed(page_left_input_name):
		page_left_button.pressed.emit()
	elif Input.is_action_just_pressed(page_right_input_name):
		page_right_button.pressed.emit()


func show_first_page():
	current_page_index = 0
	var counter = 0
	for page in pages:
		var layout = get_node(page)
		if counter == 0:
			layout.show()
		else:
			layout.hide()
		counter += 1


func hide_all_pages():
	for page in pages:
		var layout = get_node(page)
		layout.hide()


func _navigate_to_left():
	var current_page = get_node(pages[current_page_index])
	var new_page_index = (current_page_index - 1) if current_page_index > 0 else pages.size() - 1
	var new_page = get_node(pages[new_page_index])

	var current_page_transition = transitions["{}_to_left".format([current_page.name])]
	var new_page_transition = transitions["{}_to_left".format([new_page.name])]

	GuiTransitions.show(current_page_transition.layout_id)
	GuiTransitions.show(new_page_transition.layout_id)

	await GuiTransitions.show_completed
	print("to left - show completed") # XXX


func _navigate_to_right():
	var current_page = get_node(pages[current_page_index])
	var new_page_index = (current_page_index + 1) % pages.size()
	var new_page = get_node(pages[new_page_index])

	var current_page_transition = transitions["{}_to_right".format([current_page.name])]
	var new_page_transition = transitions["{}_to_right".format([new_page.name])]

	GuiTransitions.show(current_page_transition.layout_id)
	GuiTransitions.show(new_page_transition.layout_id)

	await GuiTransitions.show_completed
	print("to right - show completed") # XXX


func create_transitions():
	var new_transitions = {}

	for page_path in pages:
		var page = get_node(page_path)

		var left_transition = transition_to_left.instantiate() as GuiTransition
		left_transition.layout = page.get_path()
		left_transition.layout_id = "{}_to_left".format([page.name])
		left_transition.group = page.get_children().front().get_path()
		add_child(left_transition)
		new_transitions[left_transition.layout_id] = left_transition

		var right_transition = transition_to_right.instantiate()
		right_transition.layout = page.get_path()
		right_transition.layout_id = "{}_to_right".format([page.name])
		right_transition.group = page.get_children().front().get_path()
		add_child(right_transition)
		new_transitions[right_transition.layout_id] = right_transition

	return new_transitions
	
