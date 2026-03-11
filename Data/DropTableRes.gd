extends Resource
class_name DropTableRes

@export var entries: Array[ItemRes] = []
@export var min_drops: int = 1
@export var max_drops: int = 1


func roll_items()-> Array[ItemRes]:
	var dropped_items: Array[ItemRes] = []
	var num_drops = randi() % (max_drops - min_drops + 1) + min_drops
	for i in range(num_drops):
		var total_rate = 0.0
		for entry in entries:
			total_rate += entry.item_drop_rate
		var roll = randf() * total_rate
		var cumulative_rate = 0.0
		for entry in entries:
			cumulative_rate += entry.item_drop_rate
			if roll <= cumulative_rate:
				dropped_items.append(entry)
				break
	return dropped_items

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
