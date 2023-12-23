extends CanvasLayer


func _ready():
	visible = false
	FreezeManager.unfreezed.connect(func(): show_when_unfreezed())
	FreezeManager.freezed.connect(func(): hide_when_freezed())


func show_when_unfreezed():
	visible = true


func hide_when_freezed():
	visible = false
