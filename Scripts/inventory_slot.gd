extends Control

@onready var icon = $NinePatchRect/ItemIcon
@onready var quantity_label = $NinePatchRect/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ColorRect/ItemName
@onready var item_type = $DetailsPanel/ColorRect/ItemType
@onready var item_rarity = $DetailsPanel/ColorRect/ItemRarity
@onready var usage_panel = $UsagePanel
@onready var assign_button = $UsagePanel/ColorRect2/AssignButton
@onready var outer_border = $NinePatchRect

# Signals
signal drag_start(slot)
signal drag_end()

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

func set_empty():
	icon.texture = null
	quantity_label.text = ""

func set_item(new_item):
	item = new_item
	icon.texture = new_item["item_texture"]
	quantity_label.text = str(new_item["quantity"])
	item_name.text = str(item["item_name"])
	item_type.text = str(item["item_type"])
	if item["item_rarity"] != "":
		item_rarity.text = str("Rarity: ", item["item_rarity"])
	else:
		item_rarity.text = ""
	update_assignment_status()

func _on_drop_button_pressed():
	if item != null:
		var drop_position = Global.player_node.global_position
		var drop_offset = Vector2(0, 10)
		drop_offset = drop_offset.rotated(Global.player_node.rotation)
		Global.drop_item(item, drop_position + drop_offset)
		Global.remove_item(item["item_type"], item["item_rarity"])
		Global.remove_hotbar_item(item["item_type"], item["item_rarity"])
		usage_panel.visible = false


func update_assignment_status():
	is_assigned = Global.is_item_assigned_to_hotbar(item)
	if is_assigned:
		assign_button.text = "Unassign"
	else:
		assign_button.text = "Assign"
		
func _on_assign_button_pressed():
	if item != null:
		if is_assigned:
			Global.unassign_hotbar_item(item["item_type"], item["item_rarity"])
			is_assigned = false
		else:
			Global.add_item(item, true)
			is_assigned = true
		update_assignment_status()


func _on_item_button_gui_input(event):
	if event is InputEventMouseButton:
		# Usage panel
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():			
			if item != null:
				details_panel.visible = false
				usage_panel.visible = !usage_panel.visible
		# Dragging item
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				outer_border.modulate = Color(1, 1, 0)
				drag_start.emit(self)
			else:
				outer_border.modulate = Color(1, 1, 1)
				drag_end.emit()

