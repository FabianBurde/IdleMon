extends TextureRect

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_title_bar_gui_input(event: InputEvent):
	print("input event for INVENTORY: ", event)
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
		dragging = true
	if event is InputEventMouseMotion and dragging:
			self.global_position += event.relative
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and not event.pressed:
		dragging = false