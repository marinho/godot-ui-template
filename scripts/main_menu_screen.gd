extends Node

@export var can_start_new_game: bool = true
@export var load_game_item_button: Resource
@export_file() var first_scene_new_game;
@export_range(0, 10) var maximum_saved_games = 3;

@onready var new_game_button = %NewGameButton
@onready var load_game_button = %LoadGameButton
@onready var escape_to_return = %EscapeToReturn
@onready var credits_scrollable = %CreditsScrollable
@onready var load_game_screen = %LoadGame
@onready var load_game_list = %LoadGameList

@onready var game_manager = get_node("/root/GameManager")
@onready var game_persistence = get_node("/root/GamePersistence")


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game_button.visible = can_start_new_game
	load_game_button.visible = can_load_game()


func _on_load_game_button_pressed():
	escape_to_return.can_return = false
	update_load_game_list()
	GuiTransitions.go_to("LoadGame")
	await GuiTransitions.show_completed
	var first_button = load_game_list.get_children().front() as Button
	first_button.grab_focus()
	escape_to_return.can_return = true
	

func _on_new_game_button_pressed():
	escape_to_return.can_return = false
	GuiTransitions.go_to("NewGame")
	await GuiTransitions.show_completed

	var new_game = game_persistence.save_new_game(first_scene_new_game)
	game_manager.set_current_game(new_game)
	game_manager.load_scene(first_scene_new_game)


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


func can_load_game():
	var saved_games = game_persistence.get_saved_games()
	return len(saved_games) > 0


func update_load_game_list():
	for button in load_game_list.get_children():
		load_game_list.remove_child(button)
		button.queue_free()
	
	var saved_games = game_persistence.get_saved_games()
	
	if len(saved_games) == 0:
		return
	
	for game in saved_games.slice(0, maximum_saved_games):
		var date_string = Time.get_datetime_string_from_datetime_dict(game.datetime, true)
		var label = "#{} : {}".format([game.id, date_string], "{}")
		var new_button = load_game_item_button.instantiate() as Button
		new_button.text = label
		new_button.game_id = game["id"]
		new_button.pressed.connect(func(): load_game_from_button(game))
		load_game_list.add_child(new_button)


func load_game_from_button(game):
	game_manager.set_current_game(game)
	game_manager.load_scene(game["location"]["scene"])
	# TODO: player position
