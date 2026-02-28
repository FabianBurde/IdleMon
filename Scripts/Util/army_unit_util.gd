class_name UnitContainer
extends Moveable

@onready var star_progress:TextureProgressBar = $Sprite/StarProgress
@onready var spr = $Sprite
@onready var attack_timer = $AttackTimer
@onready var time_lbl = $Sprite/ATKTimeLBL
@export var army_unit:UnitRes


var merge_container
var merge_slot1 
var merge_slot2
var star_value:int = 1
var is_selected:bool = false
var spawn_tween:Tween
var attack_tween:Tween

var spawn_position:Vector2
var swap_target:Control = null
var is_in_merge_mode:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	SignalBus.enemy_dead.connect(stop_attack_timer)
	SignalBus.enemy_spawned.connect(start_attack_timer)
	if army_unit == null:
		army_unit = UnitRes.new()
	else:
		print("Unit Loaded: %s" % army_unit.unit_name)
		print(army_unit)
		for unit in ResourceManager.entity_dict.keys():
			print(ResourceManager.entity_dict[unit])
			print(army_unit.health)
			print(army_unit.phys_dmg)
			print(army_unit.magic_dmg)
			print(army_unit.speed)
	## This needs to be reworked to make time and speed more intuitive. ##
	self.attack_timer.wait_time = 7.0 - (0.1 * army_unit.speed)
	spawn_tween = create_tween()
	#attack_tween = create_tween()
	spawn_tween.tween_property(self, "modulate", Color.CORAL, 0.01).set_trans(Tween.TRANS_SINE)
	spawn_tween.tween_property(spr, "scale", Vector2(1.5, 1.5), 0.01).set_trans(Tween.TRANS_LINEAR)
	spawn_tween.tween_property(spr, "scale", Vector2(1.0, 1.0), 1.0).set_trans(Tween.TRANS_LINEAR)
	spawn_tween.tween_property(self, "modulate", Color.WHITE, 0.2).set_trans(Tween.TRANS_SINE)
	print(army_unit)
	star_progress.value = army_unit.star_value
	tooltip_text = "ID: %d\n Name: %s \nHealth: %d\nPAttack: %d\nMAttack: %d\n Speed: %d \n Stars: %d" % [
		army_unit.unit_id,
		army_unit.unit_name,
		army_unit.health,
		army_unit.phys_dmg,
		army_unit.magic_dmg,
		army_unit.speed,
		army_unit.star_value
	]
	#spawn_position = self.global_position
	if LevelManager.active_enemy:
		start_attack_timer()


func stop_attack_timer():
	attack_timer.stop()
	position = Vector2(position.x, position.y)
	modulate = Color.WHITE

func start_attack_timer():
	#attack_timer.wait_time = floorf(max(1.0, 5.0 - (0.1 * army_unit.speed)))
	if is_in_merge_mode:
		return
	attack_timer.start()

func attack_timeout():
	if attack_tween:
		attack_tween.kill()
	attack_tween = create_tween()
		#attack_tween = create_tween()
	if ResourceManager.debug_mode != ResourceManager.DebugModes.OFF:
		print( self, " attacks!" )
		print(attack_tween)
	attack_tween.tween_property(spr, "modulate", Color.RED, 0.2)
	attack_tween.tween_property(spr, "position", Vector2(5, -25), 0.2)
	attack_tween.tween_property(spr, "position", Vector2(2, 0), 0.2)
	attack_tween.tween_property(spr, "modulate", Color.WHITE, 0.2)
	await attack_tween.finished
	SignalBus.unit_attack.emit(0.1 * army_unit.phys_dmg)
	#print(LevelManager.active_enemy)
	if LevelManager.active_enemy != null:
		start_attack_timer()
	else:
		stop_attack_timer()
	

func has_drop_target() -> bool:
	var mouse_pos = get_global_mouse_position()
	var parent = get_parent()
	merge_slot1 = UnitManager.merge_btn1
	merge_slot2 = UnitManager.merge_btn2
	merge_container = UnitManager.merge_container
	#merge_container = get_node("MarginContainer/HBoxContainer2/VBoxContainer/UILower/MergeContainer")
	var search_rec_slot1 = Rect2(merge_slot1.global_position - Vector2(1,1), Vector2(128.0,128.0))
	var search_rec_slot2 = Rect2(merge_slot2.global_position - Vector2(1,1), Vector2(128.0,128.0))
	print(search_rec_slot1)
	print(search_rec_slot2)
	print(mouse_pos)
	if search_rec_slot1.has_point(mouse_pos) and merge_container.visible:
		swap_target = merge_slot1
		print("Found merge slot 1")
		return true
	if search_rec_slot2.has_point(mouse_pos) and merge_container.visible:
		InputManager.rects_to_draw.append(search_rec_slot2)
		print("Found merge slot 2")
		swap_target = merge_slot2
		return true
	for child in parent.get_children():
		if child is UnitContainer and child != self or child:
			var child_rect = Rect2(child.global_position, child.custom_minimum_size)
			if child_rect.has_point(mouse_pos):
				InputManager.rects_to_draw.append(child_rect)
				swap_target = child
				return true
	#var result = space_state.intersect_point(get_global_mouse_position(), 1, [], 2147483647, true, true)
	#return result.size() > 0
	return false


func stop_drag() -> void:
	dragging = false
	var drop_target = has_drop_target()
	if drop_target and swap_target is UnitContainer and swap_target != self:
		print("found target")
		print(swap_target)
		swap_unit(swap_target)
		swap_target = null
	elif drop_target and swap_target == merge_slot1:
		print("merging to slot 1")
		self.stop_attack_timer()
		self.is_in_merge_mode = true
		merge_container.confirm_slot1(self)
		swap_target = null
	elif drop_target and swap_target == merge_slot2:
		print("merging to slot 2")
		self.stop_attack_timer()
		self.is_in_merge_mode = true
		merge_container.confirm_slot2(self)
		swap_target = null
	else:
		self.global_position = drag_start_position
		swap_target = null
		attack_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_lbl.text = "%.1f s" % (attack_timer.time_left)
	if dragging and attack_timer.is_stopped() == false:
		attack_timer.stop()
	#elif not dragging and attack_timer.is_stopped() and is_in_merge_mode == false:
	#	attack_timer.start()

func update_res_dict():
	ResourceManager.entity_dict[army_unit.unit_id] = inst_to_dict(army_unit)		

func delete_unit():
	self.queue_free()

func unit_hovered():
	self.scale = Vector2(1.1, 1.1)
	self.modulate = Color(1, 1, 1, 0.8)

func unit_unhovered():
	self.scale = Vector2(1, 1)
	self.modulate = Color(1, 1, 1, 1)

func swap_unit(other_unit:UnitContainer):
	var temp_position = self.spawn_position
	print(other_unit.global_position)
	print(temp_position)
	self.position = other_unit.spawn_position
	other_unit.global_position = temp_position

func unit_clicked():
	print("Unit Clicked: %s" % army_unit.unit_name)
