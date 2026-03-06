extends Node

var item_health_potion_texture: Texture2D = preload("res://Assets/Textures/Items/Healthpot_01.png")

#var item_wood_chest_armor_res : ItemRes = preload("res://Data/items/woodset/wood_chest.tres")

const ITEMS = {
	"health_potion_01": preload("res://Data/items/consumables/hppot01.tres"),
	"wood_chest_armor": preload("res://Data/items/woodset/wood_chest.tres")
}


func get_item(id: String) -> ItemRes:
	print(ITEMS)
	print(ITEMS.has(id))
	if id in ITEMS:
		return ITEMS.get(id,null) as ItemRes
	else:
		print("Item ID '%s' not found in AssetManager." % id)
		return null
