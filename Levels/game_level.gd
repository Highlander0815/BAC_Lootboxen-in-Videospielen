extends Node2D

class_name game_level

@onready var tile_map : TileMap = $TileMap
@onready var crop_timer : Timer = $Crop_Timer

var crop_layer : int = 5
var crops_source_id : int = 6
var final_seed_level : int = 3


func plant_growth(tile_map_pos, level, atlas_coord):
	# plant seedling/update texture on growth
	tile_map.set_cell(crop_layer, tile_map_pos, crops_source_id, atlas_coord)
	
	# After 5s grow bigger
	await get_tree().create_timer(5.0).timeout
	
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
		
		plant_growth(tile_map_pos, level,  new_atlas)

func growth_handler(tile_map_pos, plant : String):
	if plant == "Corn Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 1))
	if plant == "Carrot Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 2))
	if plant == "Cauliflower Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 3))
	if plant == "Tomato Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 4))
	if plant == "Aubergine Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 5))
	if plant == "Blue Poppy Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 6))
	if plant == "Cabbage Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 7))
	if plant == "Wheat Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 8))
	if plant == "Pumpkin Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 9))
	if plant == "White Radish Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 10))
	if plant == "Artichoke Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 11))
	if plant == "Purple Radish Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 12))
	if plant == "Star Fruit Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 13))
	if plant == "Cucumber Seeds":
		plant_growth(tile_map_pos, 0, Vector2i(0, 14))


func _on_timer_timeout():
	pass # Replace with function body.
