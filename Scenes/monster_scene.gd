extends Node3D

var bump_rate : float = 0.2
var current_bump = 0.0
@onready var mon_spr = $Sprite3D
@export var vert_bumping:bool = true
@export var enemy_resource:Resource
@onready var name_label:Label3D = $NameLBL
@onready var attack_timer:Timer = $AttackTimer

@export var drop_table:DropTableRes
@onready var drop_util_scene = preload("res://Scenes/Util/ItemDropUtil.tscn")

var attack_tween
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
	attack_timer.wait_time = enemy_resource.attack_rate
	mon_spr.scale = Vector3(0.5,0.5,0.5) * (1 + 0.1 * LevelManager.current_level)

func take_damage(val) -> void:
	current_health -= val
	if current_health <= 0:
		print("Enemy Dead")
		die()

func attack_army() -> void:
	if UnitManager.unit_slots.size() > 0:
		var target_unit = null
		for i in range(UnitManager.unit_slots.size()):
			if UnitManager.unit_slots[i] != null:
				target_unit = UnitManager.unit_slots[i]
				break
		if attack_tween:
			attack_tween.kill()
		attack_tween = create_tween()
		attack_tween.tween_property(mon_spr, "modulate", Color.RED, 0.5)
		attack_tween.tween_property(mon_spr, "modulate", Color.WHITE, 0.5)
		target_unit.take_damage(enemy_resource.attack)

func die()-> void:
	ResourceManager.add_gold(enemy_resource.gold_reward)
	ResourceManager.add_exp(enemy_resource.exp_reward)
	LevelManager.enemies_in_level_killed += 1
	if monster_type == MONSTER_TYPES.boss:
		LevelManager.bosses_killed += 1
		SignalBus.level_advanced.emit()
	LevelManager.active_enemy = null
	SignalBus.enemy_dead.emit()
	#Handle drops
	var drops = drop_table.roll_items()
	for item in drops:
		SignalBus.item_droped.emit(item)


	SignalBus.update_ui_info.emit(ResourceManager.global_gold, ResourceManager.player_stats["exp"], ResourceManager.player_stats["lvl"],LevelManager.enemies_in_level_killed)
	ResourceManager.save_game()
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if vert_bumping:
		current_bump = fmod(current_bump + delta * bump_rate, TAU)
		position.y = sin(current_bump) * 0.15
