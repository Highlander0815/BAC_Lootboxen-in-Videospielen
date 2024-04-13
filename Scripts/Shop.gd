extends Node2D

var can_access_shop = false
# Store references to items within the shop area
var items_in_shop = []

signal item_sold(total_coins, total_ingots)

func _ready():
	pass

func _process(_delta):
	pass

func _on_area_2d_body_entered(body):
	if body.name == "PlayerCat":
		$Roof.visible = false

func _on_area_2d_body_exited(body):
	if body.name == "PlayerCat":
		$Roof.visible = true

func _on_shop_area_body_entered(body):
	if body.name == "PlayerCat":
		can_access_shop = true

func _on_shop_area_body_exited(body):
	if body.name == "PlayerCat":
		can_access_shop = false
		sell_items()
		items_in_shop.clear() # Clear the list after selling items

func sell_items():
	var total_coins = 0
	var total_ingots = 0
	for item in items_in_shop:
		total_coins += item.get("item_value")
		if item.get("item_rarity") == "4":
			total_ingots += 1
		item.queue_free() # Remove the item from the scene

	item_sold.emit(total_coins, total_ingots)

func _on_shop_area_area_entered(area):
	if area.owner.get("item_sellable"):
		items_in_shop.append(area.owner)


func _on_shop_area_area_exited(area):
	if area.owner in items_in_shop:
		items_in_shop.erase(area.owner)
