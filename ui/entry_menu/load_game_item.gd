extends HBoxContainer

@export var game_id: int

@onready var load_button: Button = %LoadButton
@onready var delete_button: Button = %DeleteButton

signal game_deleted

func set_game(game):
	self.game_id = game.id
	load_button.text = "#{} : {}%".format([game.id, game.completed_percent], "{}")


func _on_load_button_pressed():
	var game = GamePersistence.load_game(game_id)
	GameManager.set_current_game(game["id"])
	GameManager.load_scene(game["location"]["scene"])


func _on_delete_button_pressed():
	DialogLauncher.confirm("Are you sure you want to delete this game?")
	var confirmed = await DialogLauncher.user_confirmed

	if confirmed:
		GamePersistence.delete_saved_game(game_id)
		game_deleted.emit()
