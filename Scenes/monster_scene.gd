extends Node3D

var bump_rate : float = 0.5
var current_bumb = 0.0
@onready var mon_spr = $Sprite3D
@export var vert_bumping:bool = true
@export var enemy_resource:Resource

var current_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enemy_resource:
		mon_spr.texture = enemy_resource.enemy_tex
		

func die()-> void:
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if vert_bumping:
		vert_bump(delta)

func vert_bump(delt:float):
	if position.y >= 0.0:
		current_bumb += delt * bump_rate
		position.y = sin(current_bumb) * 0.5
	else:
		position.y = 0.0
		current_bumb = 0.0