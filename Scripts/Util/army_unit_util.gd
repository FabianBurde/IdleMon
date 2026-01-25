class_name UnitContainer
extends MarginContainer

@onready var star_progress:TextureProgressBar = $TextureRect/StarProgress
@onready var spr = $Sprite
@onready var attack_timer = $AttackTimer
@export var army_unit:UnitRes
var star_value:int = 1
var is_selected:bool = false
var spawn_tween:Tween
var attack_tween:Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	SignalBus.enemy_dead.connect(stop_attack_timer)
	SignalBus.enemy_spawned.connect(start_attack_timer)
	army_unit = UnitRes.new()
	attack_timer.wait_time = floorf(max(1.0, 5.0 - (0.1 * army_unit.speed)))
	spawn_tween = create_tween()
	#attack_tween = create_tween()
	spawn_tween.tween_property(self, "modulate", Color.CORAL, 0.01).set_trans(Tween.TRANS_SINE)
	spawn_tween.tween_property(spr, "scale", Vector2(1.5, 1.5), 0.01).set_trans(Tween.TRANS_LINEAR)
	spawn_tween.tween_property(spr, "scale", Vector2(1.0, 1.0), 1.0).set_trans(Tween.TRANS_LINEAR)
	spawn_tween.tween_property(self, "modulate", Color.WHITE, 0.2).set_trans(Tween.TRANS_SINE)
	print(army_unit)
	tooltip_text = "Name: %s \nHealth: %d\nPAttack: %d\nMAttack: %d\n Speed: %d" % [
		army_unit.unit_name,
		army_unit.health,
		army_unit.phys_dmg,
		army_unit.magic_dmg,
		army_unit.speed
	]

func stop_attack_timer():
	attack_timer.stop()
	position = Vector2(position.x, 0)
	modulate = Color.WHITE

func start_attack_timer():
	attack_timer.wait_time = floorf(max(1.0, 5.0 - (0.1 * army_unit.speed)))
	attack_timer.start()

func attack_timeout():
	print( self, " attacks!" )
	
	if attack_tween:
		attack_tween.kill()
	attack_tween = create_tween()
	print(attack_tween)
		#attack_tween = create_tween()
	attack_tween.tween_property(spr, "modulate", Color.RED, 0.2)
	attack_tween.tween_property(spr, "position", Vector2(5, -25), 0.2)
	attack_tween.tween_property(spr, "position", Vector2(2, 0), 0.4)
	attack_tween.tween_property(spr, "modulate", Color.WHITE, 0.2)
	await attack_tween.finished
	SignalBus.unit_attack.emit(0.1 * army_unit.phys_dmg)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func unit_hovered():
	self.scale = Vector2(1.1, 1.1)
	self.modulate = Color(1, 1, 1, 0.8)

func unit_unhovered():
	self.scale = Vector2(1, 1)
	self.modulate = Color(1, 1, 1, 1)

func unit_clicked():
	print("Unit Clicked: %s" % army_unit.unit_name)

func update_star_progress(value:int):
	star_value = value
	star_progress.value = star_value
