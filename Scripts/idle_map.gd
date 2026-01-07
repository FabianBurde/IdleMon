extends Control

var dmg_num_util = preload("res://Scenes/Util/DmgNumUtil.tscn")

@export var game_scene:Node3D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
#	game_scene.connect(


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func attack_emeny() -> void:
	print("Attack Enemy")
	var num = dmg_num_util.instantiate()
	num.global_position = get_viewport().get_mouse_position()
	add_child(num)

func disable_click():
	get_tree().set_input_as_handled()
