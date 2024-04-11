extends Control

@onready var premium_label = $PanelContainer/VBoxContainer/HBoxContainer/Premium_Amount
@onready var Items = $"PanelContainer/VBoxContainer/TabContainer/Seed Box/PanelContainer/Items"

signal update_shop_wallet
signal update_ingots

func _ready():
	premium_label.text = str(Global.silver_ingots)

func resume():
	get_tree().paused = false

func pause():
	get_tree().paused = true

func open_shop_menu():
	if Input.is_action_just_pressed("shop_menu") and !get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("shop_menu") and get_tree().paused == true:
		resume()

func _on_resume_pressed():
	var loot = Items.get_children()
	if loot != null:
		for item in loot:
			# send loot to Inventory and delete the items
			item.pickup_item()

	resume()
	visible = false

func _process(_delta):
	open_shop_menu()


# Price_invspace
# Label Name for inventory space price
func _on_btn_add_inv_space_pressed():
	pass # Replace with function body.


# Functions for buying ingame premium currency
func _on_btn_buy_tiny_pressed():
	if Global.wallet >= 1.99:
		update_shop_wallet.emit(Global.wallet - 1.99)
		update_ingots.emit(Global.silver_ingots + 5)

func _on_btn_buy_small_pressed():
	if Global.wallet >= 7.99:
		update_shop_wallet.emit(Global.wallet - 7.99)
		update_ingots.emit(Global.silver_ingots + 22)

func _on_btn_buy_medium_pressed():
	if Global.wallet >= 19.99:
		update_shop_wallet.emit(Global.wallet - 19.99)
		update_ingots.emit(Global.silver_ingots + 55)

func _on_btn_buy_large_pressed():
	if Global.wallet >= 49.99:
		update_shop_wallet.emit(Global.wallet - 49.99)
		update_ingots.emit(Global.silver_ingots + 138)
