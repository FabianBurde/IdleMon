class_name Moveable
extends Control

@export var drag_threshold: float = 10.0
var dragging: bool = false
var drag_start_position: Vector2
var drag_disabled: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed and !drag_disabled:
		self.start_drag()
	if event is InputEventMouseMotion and dragging:
		var drag_distance = event.position.distance_to(drag_start_position)
		if drag_distance > drag_threshold:
			self.global_position += event.relative
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and not event.pressed:
		self.stop_drag()

func start_drag() -> void:
	drag_start_position = self.global_position
	dragging = true

func stop_drag() -> void:
	dragging = false
	var drop_target = has_drop_target()
	if drop_target:
		print("found target")
	else:
		self.global_position = drag_start_position

func has_drop_target() -> bool:
	var space_state = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()
	##1. if target is unit and is consumable/equippable
	##2. is other item -> swap
	##
	##
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
