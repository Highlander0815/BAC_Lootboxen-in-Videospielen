extends Node2D

var can_access_shop = false
# Store references to items within the shop area
var items_in_shop = []

signal item_sold(total_coins)

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
	for item in items_in_shop:
		total_coins += 2
		item.queue_free() # Remove the item from the scene

	item_sold.emit(total_coins)


func _on_shop_area_area_entered(area):
	print(area.owner.get_groups())
	if area.owner.is_in_group("sellable"):
		items_in_shop.append(area.owner)


func _on_shop_area_area_exited(area):
	if area.owner in items_in_shop:
		items_in_shop.erase(area.owner)
