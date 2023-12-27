extends Node

@export var can_start_new_game: bool = true
@export var load_game_item: Resource
@export_file() var first_scene_new_game
@export_range(0, 10) var maximum_saved_games = 5

@onready var new_game_button = %NewGameButton
@onready var load_game_button = %LoadGameButton
@onready var quit_button = %QuitButton
@onready var escape_to_return = %EscapeToReturn
@onready var credits_scrollable = %CreditsScrollable
@onready var main_menu_screen = %MainMenu
@onready var load_game_list = %LoadGameList


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_main_menu_buttons()
	var focus_first = main_menu_screen.get_node("FocusFirst")
	GuiTransitions.go_to("MainMenu")
	await GuiTransitions.show_completed
	focus_first.focus_on_first()
	GamePersistence.game_deleted.connect(func (_game_id): _game_deletion_callback())


func _on_load_game_button_pressed():
	escape_to_return.can_return = false
	update_load_game_list()
	GuiTransitions.go_to("LoadGame")
	await GuiTransitions.show_completed
	escape_to_return.can_return = true

	# Focus the first button
	_focus_on_first_load_game()


func _focus_on_first_load_game():
	if load_game_list.get_child_count() > 0:
		var first = load_game_list.get_children().front()
		first.get_node("FocusFirst").focus_on_first()
	

func _on_new_game_button_pressed():
	escape_to_return.can_return = false
	GuiTransitions.go_to("NewGame")
	await GuiTransitions.show_completed

	var new_game = GamePersistence.save_new_game(first_scene_new_game)
	GameManager.set_current_game(new_game["id"])
	GameManager.load_scene(first_scene_new_game)


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
	var saved_games = GamePersistence.get_saved_games()
	return len(saved_games) > 0


func update_load_game_list():
	for button in load_game_list.get_children():
		load_game_list.remove_child(button)
		button.queue_free()
	
	var saved_games = GamePersistence.get_saved_games()
	
	if len(saved_games) == 0:
		return
	
	# Add the buttons for the saved games
	for game in saved_games.slice(0, maximum_saved_games):
		var new_item = load_game_item.instantiate() as HBoxContainer
		load_game_list.add_child(new_item)
		new_item.set_game(game)
		new_item.game_deleted.connect(func() : _after_game_deleted())

	# Enable circular navigation between the buttons
	var first_item = load_game_list.get_children().front() as HBoxContainer
	var last_item = load_game_list.get_children().back() as HBoxContainer
	first_item.get_node("%LoadButton").focus_neighbor_top = last_item.get_node("%LoadButton").get_path()
	first_item.get_node("%DeleteButton").focus_neighbor_top = last_item.get_node("%DeleteButton").get_path()
	last_item.get_node("%LoadButton").focus_neighbor_bottom = first_item.get_node("%LoadButton").get_path()
	last_item.get_node("%DeleteButton").focus_neighbor_bottom = first_item.get_node("%DeleteButton").get_path()


func load_game_from_button(game):
	GameManager.set_current_game(game["id"])
	GameManager.load_scene(game["location"]["scene"])


func _game_deletion_callback():
	update_load_game_list()
	_focus_on_first_load_game()


func _update_main_menu_buttons():
	new_game_button.visible = can_start_new_game
	load_game_button.visible = can_load_game()

	if load_game_button.visible:
		new_game_button.focus_neighbor_top = load_game_button.get_path()
		quit_button.focus_neighbor_bottom = load_game_button.get_path()
	else:
		new_game_button.focus_neighbor_top = quit_button.get_path()
		quit_button.focus_neighbor_bottom = new_game_button.get_path()


func _after_game_deleted():
	var remaining_games = GamePersistence.get_saved_games()
	if len(remaining_games) == 0:
		_update_main_menu_buttons()
		escape_to_return.apply_return()
