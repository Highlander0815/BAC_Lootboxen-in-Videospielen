@tool
extends Node2D

# Item detaisl for editor window
@export var item_type = ""
@export var item_name = ""
@export var item_texture : Texture
@export var item_rarity = ""
var scene_path = "res://Scenes/Inventory_Item.tscn"

# Scene-Tree Node reference
@onready var icon_sprite = $Sprite2D

var player_in_range = false

func _ready():
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		
func _process(_delta):
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture

	if player_in_range and Input.is_action_just_pressed("interact"):
		pickup_item()

func pickup_item():
	var item = {
		"quantity" : 1,
		"item_type" : item_type,
		"item_name" : item_name,
		"item_texture" : item_texture,
		"item_rarity" : item_rarity,
		"scene_path" : scene_path
	}
	if Global.player_node:
		Global.add_item(item, false)
		self.queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		body.interact_ui.visible = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		body.interact_ui.visible = false

func set_item_data(data):
	item_type = data["item_type"]
	item_name = data["item_name"]
	item_rarity = data["item_rarity"]
	item_texture = data["item_texture"]
