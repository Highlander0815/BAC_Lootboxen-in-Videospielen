extends Control

@onready var icon = $NinePatchRect/ItemIcon
@onready var quantity_label = $NinePatchRect/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ColorRect/ItemName
@onready var item_type = $DetailsPanel/ColorRect/ItemType
@onready var item_effect = $DetailsPanel/ColorRect/ItemEffect
@onready var usage_panel = $UsagePanel
@onready var assign_button = $UsagePanel/ColorRect2/AssignButton

# Slot item
var item = null
var slot_index = -1
var is_assigned = false

# Set index
func set_slot_index(new_index):
	slot_index = new_index

func _on_item_button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true

func _on_item_button_mouse_exited():
	details_panel.visible = false

func _on_item_button_pressed():
	if item != null:
		usage_panel.visible = !usage_panel.visible

func set_empty():
	icon.texture = null
	quantity_label.text = ""

func set_item(new_item):
	item = new_item
	icon.texture = new_item["item_texture"]
	quantity_label.text = str(new_item["quantity"])
	item_name.text = str(item["item_name"])
	item_type.text = str(item["item_type"])
	if item["item_effect"] != "":
		item_effect.text = str("+ ", item["item_effect"])
	else:
		item_effect.text = ""
	update_assignment_status()

func _on_drop_button_pressed():
	if item != null:
		var drop_position = Global.player_node.global_position
		var drop_offset = Vector2(0, 10)
		drop_offset = drop_offset.rotated(Global.player_node.rotation)
		Global.drop_item(item, drop_position + drop_offset)
		Global.remove_item(item["item_type"], item["item_effect"])
		Global.remove_hotbar_item(item["item_type"], item["item_effect"])
		usage_panel.visible = false


func _on_use_button_pressed():
	pass # Replace with function body.

func update_assignment_status():
	is_assigned = Global.is_item_assigned_to_hotbar(item)
	if is_assigned:
		assign_button.text = "Unassign"
	else:
		assign_button.text = "Assign"
		
func _on_assign_button_pressed():
	if item != null:
		if is_assigned:
			Global.unassign_hotbar_item(item["item_type"], item["item_effect"])
			is_assigned = false
		else:
			Global.add_item(item, true)
			is_assigned = true
		update_assignment_status()
