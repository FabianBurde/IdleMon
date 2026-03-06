extends Node3D

var bump_rate : float = 0.7
var current_bumb = 0.0
@onready var mon_spr = $Sprite3D
@export var vert_bumping:bool = true
@export var enemy_resource:Resource
@onready var name_label:Label3D = $NameLBL
var current_health
var max_health
enum MONSTER_TYPES {normal, boss}
var monster_type:MONSTER_TYPES
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Enemy Spawned")
	if enemy_resource and monster_type == MONSTER_TYPES.normal:
		current_health = enemy_resource.health *(LevelManager.enemies_in_level_killed + 1 *LevelManager.current_level)
		max_health = enemy_resource.health * (LevelManager.enemies_in_level_killed + 1 *LevelManager.current_level)
		mon_spr.texture = enemy_resource.enemy_tex
		name_label.text = enemy_resource.enemy_name
		SignalBus.enemy_spawned.emit()
	elif enemy_resource and monster_type == MONSTER_TYPES.boss:
		current_health = enemy_resource.health 
		max_health = enemy_resource.health 
		mon_spr.texture = enemy_resource.enemy_tex
		name_label.text = enemy_resource.enemy_name + " [BOSS]"
		SignalBus.enemy_spawned.emit()
	LevelManager.active_enemy = self
	mon_spr.scale = Vector3(0.5,0.5,0.5) * (1 + 0.1 * LevelManager.current_level)

func take_damage(val) -> void:
	current_health -= val
	if current_health <= 0:
		print("Enemy Dead")
		die()

func die()-> void:
	ResourceManager.add_gold(enemy_resource.gold_reward)
	ResourceManager.add_exp(enemy_resource.exp_reward)
	LevelManager.enemies_in_level_killed += 1
	if monster_type == MONSTER_TYPES.boss:
		LevelManager.bosses_killed += 1
		SignalBus.level_advanced.emit()
	LevelManager.active_enemy = null
	SignalBus.enemy_dead.emit()
	SignalBus.update_ui_info.emit(ResourceManager.global_gold, ResourceManager.player_stats["exp"], ResourceManager.player_stats["lvl"],LevelManager.enemies_in_level_killed)
	ResourceManager.save_game()
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if vert_bumping:
		vert_bump(delta)

func vert_bump(delt:float):
	if position.y >= 0.0:
		current_bumb += delt * bump_rate
		position.y = sin(current_bumb) * 0.15
	else:
		position.y = 0.0
		current_bumb = 0.0
