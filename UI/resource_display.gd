extends GridContainer

@export var item_display_template : PackedScene

@onready var display_container : MarginContainer = $Displaycontainer

var displays : Array[ResourceItemDisplay]
var player_inventory : Inventory

func _ready():
	var player : Player = get_tree().get_first_node_in_group("player")
	player_inventory = player.find_child("Inventory") as Inventory
	player_inventory.connect("resource_count_changed", _on_player_inventory_resourcecount_changed)

func _on_player_inventory_resourcecount_changed(type : ResourceItem, new_count : int) -> void:
	print("New count for " + type.display_name + " is " + str(new_count))
