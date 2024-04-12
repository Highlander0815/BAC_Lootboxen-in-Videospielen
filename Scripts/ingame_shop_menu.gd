extends Control

@onready var premium_label = $PanelContainer/VBoxContainer/HBoxContainer/Premium_Amount
@onready var Items = $"PanelContainer/VBoxContainer/TabContainer/Seed Box/PanelContainer/Items"
@onready var timer = $InfoMessage/Timer
@onready var InfoMessage = $InfoMessage
@onready var Prompt = $InfoMessage/Prompt


signal update_shop_wallet
signal update_ingots

var inv_space_price = 10

func _ready():
	InfoMessage.hide()
	premium_label.text = str(Global.silver_ingots)
	%Price_invspace.text = str(inv_space_price)

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
	if Global.silver_ingots >= inv_space_price:
		# increase space by 4 and reduce player silver ingots
		Global.increase_inventory_size(4)
		update_ingots.emit(Global.silver_ingots - inv_space_price)
		
		# set up new price and update label
		inv_space_price *= 2
		%Price_invspace.text = str(inv_space_price)
		
		show_prompt("Congratulations! You just bought 4 more inventory slots!")
	else:
		show_prompt("Sry, you don't have enough silver ingots...")

# Functions for buying ingame premium currency
func _on_btn_buy_tiny_pressed():
	if Global.wallet >= 1.99:
		update_shop_wallet.emit(Global.wallet - 1.99)
		update_ingots.emit(Global.silver_ingots + 5)
		show_prompt("Thank you for buying the tiny pack to support us a little.")
	else:
		show_prompt("You don't have enough money in your wallet...")

func _on_btn_buy_small_pressed():
	if Global.wallet >= 7.99:
		update_shop_wallet.emit(Global.wallet - 7.99)
		update_ingots.emit(Global.silver_ingots + 22)
		show_prompt("Thank you for buying the small pack to support us a little more.")
	else:
		show_prompt("You don't have enough money in your wallet...")

func _on_btn_buy_medium_pressed():
	if Global.wallet >= 19.99:
		update_shop_wallet.emit(Global.wallet - 19.99)
		update_ingots.emit(Global.silver_ingots + 55)
		show_prompt("Thank you for buying the medium pack to support us.")
	else:
		show_prompt("You don't have enough money in your wallet...")

func _on_btn_buy_large_pressed():
	if Global.wallet >= 49.99:
		update_shop_wallet.emit(Global.wallet - 49.99)
		update_ingots.emit(Global.silver_ingots + 138)
		show_prompt("Thank you for buying the large pack to support us like a boss!")
	else:
		show_prompt("You don't have enough money in your wallet...")


func show_prompt(text, duration = 3.0):
	# Set the message
	print(text)
	Prompt.text = text
	# Start the timer with the specified duration
	timer.start(duration)
	# Show the panel
	InfoMessage.show()


func _on_timer_timeout():
	InfoMessage.hide()
