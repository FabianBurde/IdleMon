class_name Upgrades
extends TextureButton


@export var upgrade_name:String
@export var upgrade_cost:int
@onready var name_lbl = $Name
@onready var cost_lbl = $CostLBL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	name_lbl.text = upgrade_name
	if upgrade_name:
		upgrade_cost = UnitManager.upgrade_cost_dict[upgrade_name]
	cost_lbl.text = str(upgrade_cost)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func upgrade_meele_dmg():
	pass

func upgrade_unit_slot_capacity():
	pass

func btn_hovered():
	self.scale = Vector2(1.1, 1.1)
	self.modulate = Color(1, 1, 1, 0.8)

func btn_unhovered():
	self.scale = Vector2(1, 1)
	self.modulate = Color(1, 1, 1, 1)
