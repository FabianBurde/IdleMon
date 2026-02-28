extends Node

var unit_cost_dict: Dictionary = {
	"Soldier": 2,
	"Archer": 5,
	"Mage": 12,
}

var unit_slots: Array[UnitContainer] = []

var unit_01:Texture2D = preload("res://Assets/Textures/DemoAssets/Unit_01_Demo.png")

var merge_btn1: TextureButton
var merge_btn2: TextureButton
var merge_container: ColorRect

