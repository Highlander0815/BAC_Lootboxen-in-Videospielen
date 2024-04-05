extends Node

class_name ItemData

var seeds = [
	{"item_type": "Seed", "item_name": "Artichoke Seeds", "item_rarity": "3", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/artichoke_seed_item.png")},
	{"item_type": "Seed", "item_name": "Aubergine Seeds", "item_rarity": "2", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/aubergine_seed_item.png")},
	{"item_type": "Seed", "item_name": "Blue Poppy Seeds", "item_rarity": "4", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/blue_poppy_seed_item.png")},
	{"item_type": "Seed", "item_name": "Cabbage Seeds", "item_rarity": "1", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/cabbage_seed_item.png")},
	{"item_type": "Seed", "item_name": "Carrot Seeds", "item_rarity": "2", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/carrot_seed_item.png")},
	{"item_type": "Seed", "item_name": "Cauliflower Seeds", "item_rarity": "3", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/cauliflower_seed_item.png")},
	{"item_type": "Seed", "item_name": "Corn Seeds", "item_rarity": "2", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/corn_seed_item.png")},
	{"item_type": "Seed", "item_name": "Cucumber Seeds", "item_rarity": "2", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/cucumber_seed_item.png")},
	{"item_type": "Seed", "item_name": "Pumpkin Seeds", "item_rarity": "3", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/pumpkin_seed_item.png")},
	{"item_type": "Seed", "item_name": "Purple Radish Seeds", "item_rarity": "3", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/purple_radish_seed_item.png")},
	{"item_type": "Seed", "item_name": "Starfruit Seeds", "item_rarity": "4", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/starfruit_seed_item.png")},
	{"item_type": "Seed", "item_name": "Tomato Seeds", "item_rarity": "2", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/tomato_seed_item.png")},
	{"item_type": "Seed", "item_name": "Wheat Seeds", "item_rarity": "1", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/wheat_seed_item.png")},
	{"item_type": "Seed", "item_name": "White Radish Seeds", "item_rarity": "2", "item_sellable" : false, "item_value" : 0, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Seeds/white_radish_seed_item.png")}
]

var vegetables = [
	{"item_type": "Vegetable", "item_name": "Artichoke", "item_rarity": "3", "item_sellable" : true, "item_value" : 4, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/artichoke_item.png")},
	{"item_type": "Vegetable", "item_name": "Aubergine", "item_rarity": "2", "item_sellable" : true, "item_value" : 2, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/aubergine_item.png")},
	{"item_type": "Vegetable", "item_name": "Blue Poppy", "item_rarity": "4", "item_sellable" : true, "item_value" : 15, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/blue_poppy_item.png")},
	{"item_type": "Vegetable", "item_name": "Cabbage", "item_rarity": "1", "item_sellable" : true, "item_value" : 1, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/cabbage_item.png")},
	{"item_type": "Vegetable", "item_name": "Carrot", "item_rarity": "2", "item_sellable" : true, "item_value" : 2, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/carrot_item.png")},
	{"item_type": "Vegetable", "item_name": "Cauliflower", "item_rarity": "3", "item_sellable" : true, "item_value" : 4, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/cauliflower_item.png")},
	{"item_type": "Vegetable", "item_name": "Corn", "item_rarity": "2", "item_sellable" : true, "item_value" : 2, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/corn_item.png")},
	{"item_type": "Vegetable", "item_name": "Cucumber", "item_rarity": "2", "item_sellable" : true, "item_value" : 2, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/cucumber_item.png")},
	{"item_type": "Vegetable", "item_name": "Pumpkin", "item_rarity": "3", "item_sellable" : true, "item_value" : 4, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/pumpkin_item.png")},
	{"item_type": "Vegetable", "item_name": "Purple Radish", "item_rarity": "3", "item_sellable" : true, "item_value" : 4, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/purple_radish_item.png")},
	{"item_type": "Vegetable", "item_name": "Starfruit", "item_rarity": "4", "item_sellable" : true, "item_value" : 15, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/starfruit_item.png")},
	{"item_type": "Vegetable", "item_name": "Tomato", "item_rarity": "2", "item_sellable" : true, "item_value" : 2, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/tomato_item.png")},
	{"item_type": "Vegetable", "item_name": "Wheat", "item_rarity": "1", "item_sellable" : true, "item_value" : 1, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/wheat_item.png")},
	{"item_type": "Vegetable", "item_name": "White Radish", "item_rarity": "2", "item_sellable" : true, "item_value" : 2, "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Vegetables/white_radish_item.png")}
]

var fruits = [
	{"item_type": "Fruit", "item_name": "Apple", "item_rarity": "1", "texture": preload("res://Art/Sprout Lands - Sprites - premium pack/Objects/Items/Fruits/apple_item.png")}
]


func get_seeds():
	return seeds

func get_vegetables():
	return vegetables
