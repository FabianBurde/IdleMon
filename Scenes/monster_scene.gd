extends Node3D

var bump_rate : float = 0.5
var current_bumb = 0.0
@onready var mon_spr = $Sprite3D
@export var vert_bumping:bool = true
@export var enemy_resource:Resource
@onready var name_label:Label3D = $NameLBL
var current_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enemy_spawned.emit()
	current_health = enemy_resource.health
	if enemy_resource:
		mon_spr.texture = enemy_resource.enemy_tex
		name_label.text = enemy_resource.enemy_name

func take_damage(val) -> void:
	current_health -= val
	if current_health <= 0:
		SignalBus.enemy_dead.emit()
		print("Enemy Dead")
		die()

func die()-> void:
	ResourceManager.add_gold(enemy_resource.gold_reward)
	ResourceManager.add_exp(enemy_resource.exp_reward)
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
