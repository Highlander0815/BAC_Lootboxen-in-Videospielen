extends Node2D

class_name game_level

@onready var tile_map : TileMap = $TileMap
@onready var items = get_tree().get_nodes_in_group("Item_Group")
@onready var item_data = ItemData.new()

var elapsed_time = 0

var crop_layer : int = 5
var crops_source_id : int = 6
var final_seed_level : int = 3
var vegetables

var plant_register = {
	"(4, 0)" :  "Corn",
	"(3, 2)" : "Carrot",
	"(3, 3)" : "Cauliflower",
	"(3, 4)" : "Tomato",
	"(3, 5)" : "Aubergine",
	"(3, 6)" : "Blue Poppy",
	"(3, 7)" : "Cabbage",
	"(3, 8)" : "Wheat",
	"(3, 9)" : "Pumpkin",
	"(3, 10)" : "White Radish",
	"(3, 11)" : "Artichoke",
	"(3, 12)" : "Purple Radish",
	"(3, 13)" : "Star Fruit",
	"(3, 14)" : "Cucumber"
}

func _ready():
	$Timer.start()
	vegetables = item_data.get_vegetables()

func _physics_process(_delta):
	pass


func plant_growth(tile_map_pos, level, atlas_coord, time):
	# plant seedling/update texture on growth
	tile_map.set_cell(crop_layer, tile_map_pos, crops_source_id, atlas_coord)
	
	# After time seconds grow bigger
	if Global.well:
		time *= 0.8
		print(time)
	await get_tree().create_timer(time).timeout
	
	if level == final_seed_level:
		return
	else:
		level += 1
		var new_atlas : Vector2i
		if atlas_coord.x == 2 and atlas_coord.y == 1:
			new_atlas = Vector2i(3, 0)
			level -= 1
		else:
			new_atlas = Vector2i(atlas_coord.x + 1, atlas_coord.y)
		
		plant_growth(tile_map_pos, level, new_atlas, time)

func growth_handler(tile_map_pos, plant : String):
	if plant == "Corn Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 1), 15.0)
	if plant == "Carrot Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 2), 15.0)
	if plant == "Cauliflower Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 3), 30.0)
	if plant == "Tomato Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 4), 15.0)
	if plant == "Aubergine Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 5), 15.0)
	if plant == "Blue Poppy Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 6), 45.0)
	if plant == "Cabbage Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 7), 10.0)
	if plant == "Wheat Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 8), 10.0)
	if plant == "Pumpkin Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 9), 30.0)
	if plant == "White Radish Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 10), 15.0)
	if plant == "Artichoke Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 11), 30.0)
	if plant == "Purple Radish Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 12), 30.0)
	if plant == "Star Fruit Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 13), 45.0)
	if plant == "Cucumber Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 14), 15.0)

func harvest_crop(tile_map_pos, item_position):
	# removing the crop tile
	var data = get_plant_data(tile_map_pos)
	tile_map.erase_cell(crop_layer, tile_map_pos)

	spawn_item(data, item_position)

# get information about plant via atlas coord
func get_plant_data(tile_map_pos):
	var atlas_coord = tile_map.get_cell_atlas_coords(5, tile_map_pos)
	
	# get plant name
	var plant_name = plant_register[str(atlas_coord)]

	# get plant data
	var plant_data
	for item in vegetables:
		if item.item_name == str(plant_name):
			plant_data = item
	
	return plant_data

func spawn_item(data, item_position):
	var item_scene = preload("res://Scenes/Inventory_Item.tscn")
	var item_instance = item_scene.instantiate()
	item_instance.initiate_items(data["item_type"], data["item_name"], data["item_rarity"], data["texture"], data["item_value"], data["item_sellable"])
	item_instance.global_position = item_position
	items[0].add_child(item_instance)

func is_crop_mature(tile_map_pos) -> bool:
	var tile_data = tile_map.get_cell_tile_data(crop_layer, tile_map_pos)
	if tile_data:
		return tile_data.get_custom_data("Matured")
	return false


func _on_timer_timeout():
	elapsed_time += 1

func _exit_tree():
	$Timer.stop()
	Global.timer = elapsed_time
