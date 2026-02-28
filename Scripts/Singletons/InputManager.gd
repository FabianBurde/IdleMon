extends Node2D

var rects_to_draw: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ResourceManager.debug_mode == ResourceManager.DebugModes.RECTANGLES:
		queue_redraw()

func disable_click():
	get_tree().set_input_as_handled()


func _draw():
	for rect in rects_to_draw:
		draw_rect(rect, Color(1,0,0,0.5))
