extends GridContainer

const MAX_SLOTS = 36
var available_slots:int
var inventory_slots: Array = []
@onready var item_scene: PackedScene = preload("res://Scenes/Util/inventory_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.item_added_to_inventory.connect(add_new_item)

	available_slots = ResourceManager.inventory_slots
	for i in range(MAX_SLOTS):
		var slot = item_scene.instantiate() as InventoryItem
		if i >= available_slots:
			slot.disabled = true
		### CHANGE TO ONLY RESOURCE LOADING
		#data = AssetManager.get_item("health_potion_01").duplicate()
		#if i == 2:
		#	var data = ItemRes.new()
		#	data = AssetManager.get_item("wood_chest_armor")
		#	slot.item_data = data
		#	print("data is: ", data)
		add_child(slot)
		#self.create_tween().tween_property(slot, "scale", Vector2(1, 1), 0.5).set_delay(i * 1.05)
		inventory_slots.append(slot)
	load_item_data()

func load_item_data():
	for item in ResourceManager.inventory_items:
		for slot in inventory_slots:
			if item == null:
				break
			if slot.item_data == null:
				slot.item_data = item
				slot.update_data()
				break

func save_item_data():
	ResourceManager.inventory_items.clear()
	for slot in inventory_slots:
		if slot.item_data:
			ResourceManager.inventory_items.append(slot.item_data)
		else:
			ResourceManager.inventory_items.append(null)
	ResourceManager.save_game()


func add_new_item(item_resource: ItemRes) -> void:
	for slot in inventory_slots:
		if slot.item_data == null and !slot.disabled:
			slot.item_data = item_resource
			slot.set_tooltip()
			slot.update_data()
			slot.scale_tween(1.6,Tween.TRANS_ELASTIC)
			var free_slot = inventory_slots.find(null)
			if free_slot == -1:
				free_slot = 0
			ResourceManager.inventory_items[free_slot] = item_resource
			ResourceManager.save_game()
			break
		elif item_resource.is_stackable and slot.item_data.name == item_resource.name and slot and slot.item_data.current_stack_size < slot.item_data.stack_size:
			slot.item_data.increase_stack_size(1)
			slot.update_data()
			break
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
