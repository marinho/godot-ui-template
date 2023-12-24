extends CanvasLayer

@export_group("Accept Dialog")
@export var accept_title = "Alert"
@export var accept_button_ok_label = "Ok"

@export_group("Confirmation Dialog")
@export var confirm_title = "Confirmation"
@export var confirm_button_ok_label = "Yes, I'm sure"
@export var confirm_button_cancel_label = "No"

signal user_confirmed(confirmed: bool)

@onready var confirm_dialog = ConfirmationDialog.new()
@onready var accept_dialog = AcceptDialog.new()

func _ready():
	_prepare_confirm_dialog()
	_prepare_accept_dialog()


func confirm(message: String):
	confirm_dialog.dialog_text = message
	confirm_dialog.popup_centered()


func accept(message: String):
	accept_dialog.dialog_text = message
	accept_dialog.popup_centered()


func _prepare_accept_dialog():
	accept_dialog.title = accept_title
	accept_dialog.ok_button_text = accept_button_ok_label
	accept_dialog.confirmed.connect(func (): _accept_result_confirmed())
	add_child(accept_dialog)


func _accept_result_confirmed():
	user_confirmed.emit(true)


func _prepare_confirm_dialog():
	confirm_dialog.title = confirm_title
	confirm_dialog.ok_button_text = confirm_button_ok_label
	confirm_dialog.cancel_button_text = confirm_button_cancel_label
	confirm_dialog.confirmed.connect(func (): _confirm_result_confirmed())
	confirm_dialog.canceled.connect(func (): _confirm_result_cancelled())
	add_child(confirm_dialog)


func _confirm_result_confirmed():
	user_confirmed.emit(true)


func _confirm_result_cancelled():
	user_confirmed.emit(false)
