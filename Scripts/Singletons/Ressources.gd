class_name  Ressources
extends Node

var global_gold: int = 0
var max_level_progress: = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_gold(amount: int) -> void:
	global_gold += amount

func load_savefile(path: String) -> void:
	var save_data = load(path)
	if save_data:
		pass

func new_save_file():
	pass