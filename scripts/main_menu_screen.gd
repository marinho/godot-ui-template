extends Node

@export var can_start_new_game: bool = true
@export var can_load_game: bool
@export_node_path var first_scene_new_game;

@onready var new_game_button = %NewGameButton
@onready var load_game_button = %LoadGameButton
@onready var escape_to_return = %EscapeToReturn
@onready var credits_scrollable = %CreditsScrollable


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game_button.visible = can_start_new_game
	load_game_button.visible = can_load_game


func _on_load_game_button_pressed():
	escape_to_return.can_return = false
	GuiTransitions.go_to("LoadGame")
	await GuiTransitions.show_completed
	escape_to_return.can_return = true


func _on_new_game_button_pressed():
	escape_to_return.can_return = false
	GuiTransitions.go_to("NewGame")
	await GuiTransitions.show_completed
	escape_to_return.can_return = true


func _on_credits_button_pressed():
	escape_to_return.can_return = false
	credits_scrollable.reset_scrolling()
	GuiTransitions.go_to("Credits")
	await GuiTransitions.show_completed
	escape_to_return.can_return = true
	credits_scrollable.start_scrolling()


func _on_quit_button_pressed():
	escape_to_return.can_return = false
	var quit_application_callback = func(): get_tree().quit()
	GuiTransitions.hide("MainMenu", quit_application_callback)
