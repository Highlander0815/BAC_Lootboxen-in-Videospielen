@tool
extends Node2D

# Item details for editor window
@export var item_type : String = ""
@export var item_name : String = ""
@export var item_texture :Texture
@export var item_rarity : String = ""
@export var item_sellable : bool = false
@export var item_value : int = 0
var scene_path = "res://Scenes/Shop_Item.tscn"


# Scene-Tree Node reference
@onready var icon_sprite = $Sprite2D

func _ready():
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		
func _process(_delta):
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture


func pickup_item():
	var item = {
		"quantity" : 1,
		"item_type" : item_type,
		"item_name" : item_name,
		"item_texture" : item_texture,
		"item_rarity" : item_rarity,
		"scene_path" : scene_path,
		"item_sellable" : item_sellable,
		"item_value" : item_value
	}
	if Global.player_node:
		Global.add_item(item, false)
		self.queue_free()

func set_item_data(data):
	item_type = data["item_type"]
	item_name = data["item_name"]
	item_rarity = data["item_rarity"]
	item_texture = data["item_texture"]
	item_sellable = data["item_sellable"]
	item_value = data["item_value"]
	
func initiate_items(type, iname, rarity, texture, value, sellable):
	item_type = type
	item_name = iname
	item_rarity = rarity
	item_texture = texture
	item_sellable = sellable
	item_value = value


func _on_button_pressed():
	pickup_item()
	print("click")

func get_item_data():
	var item = {
		"quantity" : 1,
		"item_type" : item_type,
		"item_name" : item_name,
		"item_texture" : item_texture,
		"item_rarity" : item_rarity,
		"scene_path" : scene_path,
		"item_sellable" : item_sellable,
		"item_value" : item_value
	}
	return item
