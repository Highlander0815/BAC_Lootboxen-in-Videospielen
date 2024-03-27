extends Node2D

class_name game_level

@onready var tile_map : TileMap = $TileMap
@onready var crop_timer : Timer = $Crop_Timer

var crop_layer : int = 5
var crops_source_id : int = 6
var final_seed_level : int = 4


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
		else:
			new_atlas = Vector2i(atlas_coord.x + 1, atlas_coord.y)
		
		plant_growth(tile_map_pos, level,  new_atlas)

func growth_handler(tile_map_pos, plant : String):
	if plant == "corn":
		plant_growth(tile_map_pos, 0, Vector2i(0, 1))


func _on_timer_timeout():
	pass # Replace with function body.
