extends ColorRect

@export var slot1_container:TextureButton
@export var slot2_container:TextureButton

var slot1_unit:UnitContainer
var slot2_unit:UnitContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UnitManager.merge_btn1 = slot1_container
	UnitManager.merge_btn2 = slot2_container
	UnitManager.merge_container = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_show() -> void:
	self.visible = !self.visible
	assert(slot1_unit == null and slot2_unit == null, "Units should be null when hiding the merge container")

func select_slot1() -> void:
	slot1_unit = null

func confirm_slot1(unit_container:UnitContainer) -> void:
	slot1_unit = unit_container
	unit_container.global_position = slot1_container.global_position + Vector2(64 -unit_container.size.x/2,32 -unit_container.custom_minimum_size.y)
	print(unit_container.global_position)
	print(slot1_container.global_position)
	
func confirm_slot2(unit_container:UnitContainer) -> void:
	slot2_unit = unit_container
	unit_container.global_position = slot2_container.global_position + Vector2(64 -unit_container.size.x/2,32 -unit_container.custom_minimum_size.y)

func merge_units():
	if slot1_unit == null or slot2_unit == null:
		return
	if slot1_unit.army_unit.unit_name != slot2_unit.army_unit.unit_name:
		return
	var new_unit = UnitRes.new()
	new_unit.unit_name = slot1_unit.army_unit.unit_name
	new_unit.health = slot1_unit.army_unit.health + slot2_unit.army_unit.health
	new_unit.phys_dmg = slot1_unit.army_unit.phys_dmg + slot2_unit.army_unit.phys_dmg
	new_unit.magic_dmg = slot1_unit.army_unit.magic_dmg + slot2_unit.army_unit.magic_dmg
	new_unit.speed = max(slot1_unit.army_unit.speed, slot2_unit.army_unit.speed) + 1
	var new_star_val = max(slot1_unit.army_unit.star_value, slot2_unit.army_unit.star_value) + 1
	new_unit.star_value = new_star_val
	UnitManager.unit_slots[slot1_unit.army_unit.unit_slot_id] = null
	UnitManager.unit_slots[slot2_unit.army_unit.unit_slot_id] = null
	ResourceManager.entity_dict.erase(slot1_unit.army_unit.unit_id)
	ResourceManager.entity_dict.erase(slot2_unit.army_unit.unit_id)
	slot1_unit.delete_unit()
	slot2_unit.delete_unit()
	slot1_unit = null
	slot2_unit = null
	SignalBus.unit_merged.emit(new_unit)
	ResourceManager.save_game()
