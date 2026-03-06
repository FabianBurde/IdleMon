extends Resource
class_name ItemRes

enum ItemType {
	CONSUMABLE,
	EQUIPPABLE,
	MATERIAL
}

@export var name: String
@export var value: int
@export var type: ItemType

@export var item_tex: Texture2D
@export var consume_effect: Dictionary
@export var equip_effect: Dictionary

#func _init(_name: String, _value: int = 0, _type: ItemType = ItemType.CONSUMABLE, _item_tex: Texture2D = null) -> void:
#	name = _name
#	value = _value
#	type = _type
#	item_tex = _item_tex

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
