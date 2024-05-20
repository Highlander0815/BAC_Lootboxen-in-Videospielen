extends Control

@onready var premium_label = $PanelContainer/VBoxContainer/HBoxContainer/Premium_Amount
@onready var premium_Items = $"PanelContainer/VBoxContainer/TabContainer/Seed Box/HBoxContainer/Premium_Chest/PanelContainer/Items"
@onready var premium_Chest = $"PanelContainer/VBoxContainer/TabContainer/Seed Box/HBoxContainer/Premium_Chest/PanelContainer/Shop_Chest"
@onready var premium_Chest_Container = $"PanelContainer/VBoxContainer/TabContainer/Seed Box/HBoxContainer/Premium_Chest/PanelContainer"
@onready var coins_label = $PanelContainer/VBoxContainer/HBoxContainer/Coin_Amount
@onready var basic_Items = $"PanelContainer/VBoxContainer/TabContainer/Seed Box/HBoxContainer/Basic_Chest/PanelContainer/Items"
@onready var timer = $InfoMessage/Timer
@onready var InfoMessage = $InfoMessage
@onready var Prompt = $InfoMessage/Prompt
@onready var farmland_label = $PanelContainer/VBoxContainer/TabContainer/Farmland/MarginContainer/VBoxContainer/HBoxContainer/Price_farmland
@onready var well_structure_btn = $PanelContainer/VBoxContainer/TabContainer/Structure/PanelContainer/VBoxContainer/Button
@onready var exchange_text = $PanelContainer/VBoxContainer/TabContainer/Exchange/MarginContainer/VBoxContainer/exchange_text

signal update_shop_wallet
signal update_ingots
signal update_farmland
signal well_bought
signal update_exchange_coins

var UI_node
var inv_space_price = 2
var farmland_price = 25
var elapsed_time = 0

func _ready():
	InfoMessage.hide()
	coins_label.text = str(Global.coins)
	premium_label.text = str(Global.silver_ingots)
	%Price_invspace.text = str(inv_space_price)
	farmland_label.text = str(farmland_price)
	UI_node = get_tree().get_first_node_in_group("UI")

func resume():
	get_tree().paused = false

func pause():
	get_tree().paused = true

func open_shop_menu():
	if Input.is_action_just_pressed("shop_menu") and get_tree().paused == false:
		show()
		UI_node.hide()
		pause()
		$GameTimer.start()
	elif Input.is_action_just_pressed("shop_menu") and get_tree().paused == true:
		hide()
		UI_node.show()
		on_resume()
		resume()
		$GameTimer.stop()

func on_resume():
	var loot = premium_Items.get_children()
	var basic_loot = basic_Items.get_children()
	if loot != null:
		for item in loot:
			# send loot to Inventory and delete the items
			item.pickup_item()

	if basic_loot != null:
		for item in basic_loot:
			# send loot to Inventory and delete the items
			item.pickup_item()
	
	resume()
	visible = false

func _process(_delta):
	open_shop_menu()
	premium_label.text = str(Global.silver_ingots)
	coins_label.text = str(Global.coins)
	var items = premium_Items.get_children()
	var basic_items = basic_Items.get_children()
	if !$"PanelContainer/VBoxContainer/TabContainer/Seed Box".visible and (items != null or basic_items != null):
		for i in items:
			i.hide()
		for i in basic_items:
			i.hide()
	elif $"PanelContainer/VBoxContainer/TabContainer/Seed Box".visible and (items != null or basic_items != null):
		for i in items:
			i.show()
		for i in basic_items:
			i.show()


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
		premium_label.text = str(Global.silver_ingots)
		
		show_prompt("Congratulations! You just bought 4 more inventory slots!")
	else:
		show_prompt("Sry, you don't have enough silver ingots...")

# Functions for buying ingame premium currency
func _on_btn_buy_tiny_pressed():
	if Global.wallet >= 1.99:
		update_shop_wallet.emit(Global.wallet - 1.99)
		update_ingots.emit(Global.silver_ingots + 5)
		premium_label.text = str(Global.silver_ingots)
		Global.player_spent += 1.99
		show_prompt("Thank you for buying the tiny pack to support us a little.")
	else:
		show_prompt("You don't have enough money in your wallet...")

func _on_btn_buy_small_pressed():
	if Global.wallet >= 7.99:
		update_shop_wallet.emit(Global.wallet - 7.99)
		update_ingots.emit(Global.silver_ingots + 22)
		premium_label.text = str(Global.silver_ingots)
		Global.player_spent += 7.99
		show_prompt("Thank you for buying the small pack to support us a little more.")
	else:
		show_prompt("You don't have enough money in your wallet...")

func _on_btn_buy_medium_pressed():
	if Global.wallet >= 19.99:
		update_shop_wallet.emit(Global.wallet - 19.99)
		update_ingots.emit(Global.silver_ingots + 55)
		premium_label.text = str(Global.silver_ingots)
		Global.player_spent += 19.99
		show_prompt("Thank you for buying the medium pack to support us.")
	else:
		show_prompt("You don't have enough money in your wallet...")

func _on_btn_buy_large_pressed():
	if Global.wallet >= 49.99:
		update_shop_wallet.emit(Global.wallet - 49.99)
		update_ingots.emit(Global.silver_ingots + 138)
		premium_label.text = str(Global.silver_ingots)
		Global.player_spent += 49.99
		show_prompt("Thank you for buying the large pack to support us like a boss!")
	else:
		show_prompt("You don't have enough money in your wallet...")


func show_prompt(text, duration = 3.0):
	# Set the message
	Prompt.text = text
	# Start the timer with the specified duration
	timer.start(duration)
	# Show the panel
	InfoMessage.show()


func _on_timer_timeout():
	InfoMessage.hide()

# handle farmland shop
func _on_btn_add_farmland_pressed():
	if farmland_price <= 2000:
		if Global.coins >= farmland_price:
			update_farmland.emit(Global.coins - farmland_price)
			
			farmland_price *= 2
			farmland_label.text = str(farmland_price)
			coins_label.text = str(Global.coins)
			
			show_prompt("Congratulations on your new farmland! Happy farming!")
			if farmland_price >= 2000:
				farmland_label.text = "---"
		else:
			show_prompt("You don't have enough coins for buying new farmland.")
	else:
		show_prompt("Wow, you bought all the available farmland on this small island!")


func _on_info_basic_pressed():
	show_prompt("Drop rates:\nRarity 1: 35%\nRarity 2: 55%\nRarity 3: 9.5%\nRarity 4: 0.5%")


func _on_info_premium_pressed():
	show_prompt("Drop rates:\nRarity 1: 30%\nRarity 2: 50%\nRarity 3: 19%\nRarity 4: 1%")


func _on_button_pressed():
	if Global.silver_ingots >= 50:
		update_ingots.emit(Global.silver_ingots - 50)
		well_structure_btn.disabled = true
		well_structure_btn.text = "sold"
		Global.well = true
		well_bought.emit()
		
		show_prompt("You just bought access to the well!")
	else:
		show_prompt("You don't have enough silver ingots for buying new farmland.")


func _on_btn_exchange_pressed():
	var change = int(exchange_text.text.strip_edges())

	if change != null and change > 0:
		if Global.silver_ingots >= change:
			update_ingots.emit(Global.silver_ingots - change)
			update_exchange_coins.emit(Global.coins + (change * 5))
			premium_label.text = str(Global.silver_ingots)
			show_prompt("Exchange completed!")
		else:
			show_prompt("Exchange failed, not enough silver ingots")
	else:
		show_prompt("Exchange failed, input invalid")


func _on_game_timer_timeout():
	elapsed_time += 1
	print("Elapsed Time: ", elapsed_time)

func _exit_tree():
	$GameTimer.stop()
	Global.premium_timer = elapsed_time
