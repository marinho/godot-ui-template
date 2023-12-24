extends HBoxContainer

@export var game_id: int

@onready var load_button: Button = %LoadButton
@onready var delete_button: Button = %DeleteButton

func set_game(game):
	self.game_id = game.id
	load_button.text = "#{} : {}%".format([game.id, game.completed_percent], "{}")


func _on_load_button_pressed():
	var game = GamePersistence.load_game(game_id)
	GameManager.set_current_game(game["id"])
	GameManager.load_scene(game["location"]["scene"])


func _on_delete_button_pressed():
	GamePersistence.delete_saved_game(game_id)
	# TODO: ask for confirmation

