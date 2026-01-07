extends Node3D

@onready var cam = $Camera3D
@onready var bg_spr = $BGSPR
@export var is_moving: bool = false

var monster_scene = preload("res://Scenes/monster_scene.tscn")
var env_scene = preload("res://Scenes/env_sprs.tscn")
var current_monster:Node3D = null
var z_step = 2.0
var current_z

signal ememy_dead
signal new_enemy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_monster()

func spawn_monster() -> void:
	if current_monster:
		current_monster.queue_free()
	current_monster = monster_scene.instantiate()
	add_child(current_monster)
	current_monster.position = Vector3(0,0,-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_moving:
		cam.position.z -= delta *0.2
		if cam.position.z <= -z_step:
			start_stop_walk()
			z_step += 2.0


func start_stop_walk() -> void:
	is_moving = !is_moving