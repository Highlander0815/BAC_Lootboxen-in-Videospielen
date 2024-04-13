extends Node

# Inventory items
var inventory = []

# Custom signals
signal inventory_updated
signal highlight(current_slot)
signal spent(amount)
signal update_coins(total_coins)
signal update_silver_ingots(total_silver)
signal update_global_wallet(wallet)

var tile_map : TileMap
var farm_ground_layer = 4
var farm_level = 0
var soil_tiles = []

var farm_x = [3, 9, -4, 2, -11, -5, -4, 2]
var farm_y = [38, 41, 44, 30, 36]

var player_node : Node = null
@onready var inventory_slot_scene = preload("res://Scenes/inventory_slot.tscn")
var items



# Hotbar Items
var hotbar_size = 5
var hotbar_inventory = []

var inventory_size = 8
var max_inventory_size = 32

# Fake Money
var wallet : float = 0.0
# Ingame Currency
var coins : int = 5000
# Ingame Premium Currency
var silver_ingots : int = 100

func _ready():
	# Initializes the inventory with 8 slots (8 blocks per row, 4 rows)
	inventory.resize(inventory_size)
	hotbar_inventory.resize(hotbar_size)
	# Connect to Shop Node to receive the value of sold items

func ui_ready():
	tile_map = get_tree().get_first_node_in_group("TileMap")
	items = get_tree().get_nodes_in_group("Item_Group")
	var shop = get_shop()
	if shop:
		shop.connect("item_sold", _on_item_sold)
	var ui = get_ui()
	if ui:
		ui.connect("update_wallet", _on_update_wallet)
	var ingame_shop = get_ingame_shop()
	if ingame_shop:
		ingame_shop.connect("update_shop_wallet", _on_update_wallet)
		ingame_shop.connect("update_ingots", _on_update_ingots)
		ingame_shop.connect("update_farmland", _on_update_farmland)

	var shop_chest_premium = get_premium_chest()
	if shop_chest_premium:
		shop_chest_premium.connect("update_chest_ingots", _on_update_ingots)
	
	var shop_chest_basic = get_basic_chest()
	if shop_chest_basic:
		shop_chest_basic.connect("update_chest_coins", _on_update_coins)

func get_shop():
	return get_tree().get_first_node_in_group("Shop")

func get_ingame_shop():
	return get_tree().get_first_node_in_group("IngameShop")

func get_premium_chest():
	return get_tree().get_first_node_in_group("ShopChestPremium")

func get_basic_chest():
	return get_tree().get_first_node_in_group("ShopChestBasic")

func _on_update_coins(new_coins):
	coins = new_coins
	update_coins.emit(coins)

func _on_item_sold(total_coins, total_ingots):
	coins += total_coins
	silver_ingots += total_ingots
	update_coins.emit(coins)
	update_silver_ingots.emit(silver_ingots)

func _on_premium_updated():
	update_silver_ingots.emit(silver_ingots)

func _on_wallet_updated():
	update_global_wallet.emit(wallet)

func get_ui():
	return get_tree().get_first_node_in_group("UI")

func _on_update_wallet(new_wallet):
	wallet = new_wallet
	_on_wallet_updated()
	print("Global Wallet: ", wallet)

func _on_update_ingots(new_ingots):
	silver_ingots = new_ingots
	_on_premium_updated()

func money_spent(amount):
	spent.emit(amount)

# Adds an item to the inventory, returns true if successful
func add_item(item, to_hotbar = false):
	var added_to_hotbar = false
	
	# Add to hotbar
	if to_hotbar:
		added_to_hotbar = add_hotbar_item(item)
		inventory_updated.emit()
	
	# Add to inventory
	if not added_to_hotbar:
		for i in range(inventory.size()):
			if inventory[i] != null and inventory[i]["item_type"] == item["item_type"] and inventory[i]["item_name"] == item["item_name"]:
				inventory[i]["quantity"] += item["quantity"]
				inventory_updated.emit()
				return true
			elif inventory[i] == null:
				inventory[i] = item
				inventory_updated.emit()
				return true

		print("Inventory Full")
		spawn_item(item, player_node.position)

# Removes an item from the inventory based on type and rarity
func remove_item(item_type, item_name):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["item_type"] == item_type and inventory[i]["item_name"] == item_name:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false
	
# Increases inventory size dynamically
func increase_inventory_size(extra_slots):
	if inventory_size < max_inventory_size:
		inventory.resize(inventory.size() + extra_slots)
		inventory_updated.emit()
	else:
		print("Maximum inventory size reached")

func set_player_reference(player):
	player_node = player

func adjust_drop_position(position):
	var radius = 10
	var nearby_items = get_tree().get_nodes_in_group("Items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
			position += random_offset
			break
	return position

# Drops an item at a specified position, adjusting for nearby items
func drop_item(item_data, drop_position):
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	get_tree().current_scene.add_child(item_instance)
	
# Try adding to hotbar
func add_hotbar_item(item):
	for i in range(hotbar_size):
		if hotbar_inventory[i] == null:
			hotbar_inventory[i] = item
			return true
	return false

# Removes an item from the hotbar
func remove_hotbar_item(item_type, item_name):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i]["item_type"] == item_type and hotbar_inventory[i]["item_name"] == item_name:
			if hotbar_inventory[i]["quantity"] <= 0:
				hotbar_inventory[i] = null
			inventory_updated.emit()
			return true
	return false

# Unassign hotbar item
func unassign_hotbar_item(item_type, item_rarity):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i]["item_type"] == item_type and hotbar_inventory[i]["item_rarity"] == item_rarity:
			hotbar_inventory[i] = null
			inventory_updated.emit()
			return true
	return false

# Prevents duplicate item assignment
func is_item_assigned_to_hotbar(item_to_check):
	return item_to_check in hotbar_inventory

# Swaps items in the inventory based on their indices
func swap_inventory_items(index1, index2):
	if index1 < 0 or index1 > inventory.size() or  index2 < 0 or index2 > inventory.size():
		return false
	
	var temp = inventory[index1]
	inventory[index1] = inventory[index2]
	inventory[index2] = temp
	inventory_updated.emit()
	return true

# Swaps items in the hotbar based on their indices
func swap_hotbar_items(index1, index2):
	if index1 < 0 or index1 > hotbar_inventory.size() or  index2 < 0 or index2 > inventory.size():
		return false
	
	var temp = hotbar_inventory[index1]
	hotbar_inventory[index1] = hotbar_inventory[index2]
	hotbar_inventory[index2] = temp
	inventory_updated.emit()
	return true

func highlight_slot(current_slot):
	highlight.emit(current_slot)

func spawn_item(data, item_position):
	var item_scene = preload("res://Scenes/Inventory_Item.tscn")
	var item_instance = item_scene.instantiate()
	item_instance.initiate_items(data["item_type"], data["item_name"], data["item_rarity"], data["item_texture"], data["item_value"], data["item_sellable"])
	item_instance.global_position = item_position
	print(items)
	items[0].add_child(item_instance)

func _on_update_farmland(new_coins):
	coins = new_coins
	update_coins.emit(coins)
	
	match farm_level:
		0:
			for x in range(farm_x[0], farm_x[1]):
				for y in range(farm_y[0], farm_y[1]):
					soil_tiles.append(Vector2i(x, y))
					tile_map.set_cells_terrain_connect(farm_ground_layer, soil_tiles, 3, 0)
		1:
			for x in range(farm_x[0], farm_x[1]):
				for y in range(farm_y[1], farm_y[2]):
					soil_tiles.append(Vector2i(x, y))
					tile_map.set_cells_terrain_connect(farm_ground_layer, soil_tiles, 3, 0)
		2:
			for x in range(farm_x[2], farm_x[3]):
				for y in range(farm_y[0], farm_y[1]):
					soil_tiles.append(Vector2i(x, y))
					tile_map.set_cells_terrain_connect(farm_ground_layer, soil_tiles, 3, 0)
		3:
			for x in range(farm_x[2], farm_x[3]):
				for y in range(farm_y[1], farm_y[2]):
					soil_tiles.append(Vector2i(x, y))
					tile_map.set_cells_terrain_connect(farm_ground_layer, soil_tiles, 3, 0)
		4:
			for x in range(farm_x[4], farm_x[5]):
				for y in range(farm_y[0], farm_y[1]):
					soil_tiles.append(Vector2i(x, y))
					tile_map.set_cells_terrain_connect(farm_ground_layer, soil_tiles, 3, 0)
		5:
			for x in range(farm_x[4], farm_x[5]):
				for y in range(farm_y[1], farm_y[2]):
					soil_tiles.append(Vector2i(x, y))
					tile_map.set_cells_terrain_connect(farm_ground_layer, soil_tiles, 3, 0)
		6:
			tile_map.erase_cell(6, Vector2i(-9, 36))
			tile_map.erase_cell(6, Vector2i(-8, 36))
			
	farm_level += 1
