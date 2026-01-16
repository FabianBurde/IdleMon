extends Resource
class_name UnitRes

@export var unit_name:String
@export var unit_tex:Texture2D
var health:float
var phys_dmg:float
var magic_dmg:float
var phys_def:float
var magic_def:float
var speed:float
var attack_rate:float

@export var base_stat_points:int

func _init():
	randomize()
	unit_name = "New Unit"
	health = 100.0
	_set_random_stats(10, 50)


func _set_random_stats(min_stat:int, max_stat:int) -> void:
	phys_dmg = randi_range(min_stat, max_stat)
	magic_dmg = randi_range(min_stat, max_stat)
	phys_def = randi_range(min_stat, max_stat)
	magic_def = randi_range(min_stat, max_stat)
	speed = randi_range(min_stat, max_stat)
	print("Generated Unit Stats: ")
	print( phys_dmg, " ", magic_dmg, " ", phys_def, " ", magic_def, " ", speed)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_stat_points = 100
	_set_random_stats(10, base_stat_points)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.