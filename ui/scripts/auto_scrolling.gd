extends ScrollContainer

@export var is_active : bool = false
@export var hide_scrollbar : bool = true
@export var speed = 1

@onready var v_scroll_bar = self.get_v_scroll_bar()

# Called when the node enters the scene tree for the first time.
func _ready():
	if hide_scrollbar:
		self.get_h_scroll_bar().modulate = Color(0, 0, 0, 0)
		self.get_v_scroll_bar().modulate = Color(0, 0, 0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_active and v_scroll_bar.value < v_scroll_bar.max_value:
		scroll_vertical += speed


func reset_scrolling():
	scroll_vertical = 0
	scroll_horizontal = 0


func start_scrolling():
	is_active = true


func stop_scrolling():
	is_active = false
