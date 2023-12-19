extends Node

@export var can_start_new_game: bool = true
@export var can_load_game: bool

@onready var new_game_button = %NewGameButton
@onready var load_game_button = %LoadGameButton

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game_button.visible = can_start_new_game
	load_game_button.visible = can_load_game


func _on_load_game_button_pressed():
	pass # Replace with function body.


func _on_new_game_button_pressed():
	pass # Replace with function body.


func _on_credits_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
