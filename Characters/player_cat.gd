extends CharacterBody2D

class_name Player

enum EQUIPMENT { AXE, SHOVEL, HOE, WATERINGCAN, HAND }

@export var move_speed : float = 80
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var tile_map : TileMap = get_node("/root/GameLevel/TileMap")
@onready var anim_tree : AnimationTree = $AnimationTree
@onready var state_machine = anim_tree.get("parameters/playback")
@onready var facing_direction : String = "S" # default direction

var velo_multiplicator : float = 1.0
var tool_in_use : bool = false
var current_equipment : EQUIPMENT = EQUIPMENT.HAND
var base_ground_layer : int = 1
var top_ground_layer : int = 2
var crop_layer : int = 3
var max_distance : int = 2
var custom_data_layer : String = "can_place_seeds"

signal facing_direction_change(facing : String)

func _ready():
	update_animation_parameters(starting_direction)
	$Action_Sprite.visible = false


func _physics_process(_delta):
	
	if tool_in_use:
		return
		
	# Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	update_animation_parameters(input_direction)

	# Update velocity
	velocity = input_direction * move_speed * velo_multiplicator
	
	# Move and Slide function uses velocity of character body to move character on map
	move_and_slide()
	
	move_direction(input_direction)
	
	pick_new_state()
	
func update_animation_parameters(move_input : Vector2):
	# Dont change animation parameters if there is no move input
	if(move_input != Vector2.ZERO):
		anim_tree.set("parameters/Walk/blend_position", move_input)
		anim_tree.set("parameters/Idle/blend_position", move_input)
		anim_tree.set("parameters/Axe/blend_position", move_input)
		anim_tree.set("parameters/Hoe/blend_position", move_input)
		anim_tree.set("parameters/Watering_Can/blend_position", move_input)
		anim_tree.set("parameters/Shovel/blend_position", move_input)

func pick_new_state():
	# Choose state based on what is happening with the player
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func move_direction(input_direction : Vector2):
	if (input_direction.x > 0.8):
		emit_signal("facing_direction_change", "E")
		facing_direction = "E"
	if (input_direction.x < -0.8):
		emit_signal("facing_direction_change", "W")
		facing_direction = "W"
	if (input_direction.y > 0.8):
		emit_signal("facing_direction_change", "S")
		facing_direction = "S"
	if (input_direction.y < -0.8):
		emit_signal("facing_direction_change", "N")
		facing_direction = "N"

func axe():
	state_machine.travel("Axe")

func shovel():
	state_machine.travel("Shovel")

func hoe():
	state_machine.travel("Hoe")
	create_soil()

func wateringcan():
	state_machine.travel("Watering_Can")

func _input(_event):
	if Input.is_action_pressed("run"):
		velo_multiplicator = 1.25
	
	if Input.is_action_just_released("run"):
		velo_multiplicator = 1.0
	
	if Input.is_action_just_pressed("use"):
				
		if current_equipment == EQUIPMENT.HAND:
			hand()
			return
			
		$Sprite2D.visible = false
		$Action_Sprite.visible = true
		tool_in_use = true
		if current_equipment == EQUIPMENT.AXE:
			axe()
		if current_equipment == EQUIPMENT.SHOVEL:
			shovel()
		if current_equipment == EQUIPMENT.HOE:
			hoe()
		if current_equipment == EQUIPMENT.WATERINGCAN:
			wateringcan()
	
	if Input.is_action_just_pressed("inventory_space_1"):
		print("Axe equipped!")
		current_equipment = EQUIPMENT.AXE
		
	if Input.is_action_just_pressed("inventory_space_2"):
		print("Shovel equipped!")
		current_equipment = EQUIPMENT.SHOVEL
	
	if Input.is_action_just_pressed("inventory_space_3"):
		print("Hoe equipped!")
		current_equipment = EQUIPMENT.HOE
	
	if Input.is_action_just_pressed("inventory_space_4"):
		print("Watering Can equipped!")
		current_equipment = EQUIPMENT.WATERINGCAN
		
	if Input.is_action_just_pressed("inventory_space_5"):
		print("Hand equipped!")
		current_equipment = EQUIPMENT.HAND
		
func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "axe_up" or anim_name == "axe_down" or anim_name == "axe_left" or anim_name == "axe_right":
		$Sprite2D.visible = true
		$Action_Sprite.visible = false
		tool_in_use = false

	elif anim_name == "shovel_up" or anim_name == "shovel_down":
		$Sprite2D.visible = true
		$Action_Sprite.visible = false
		tool_in_use = false
		
	elif anim_name == "hoe_left" or anim_name == "hoe_right":
		$Sprite2D.visible = true
		$Action_Sprite.visible = false
		tool_in_use = false
		
	elif anim_name == "watering_can_up" or anim_name == "watering_can_down" or anim_name == "watering_can_left" or anim_name == "watering_can_right":
		$Sprite2D.visible = true
		$Action_Sprite.visible = false
		tool_in_use = false

func use_equipped_tool():
	pass
	
func get_mouse_pos():
	return tile_map.local_to_map(get_global_mouse_position())

func get_player_pos():
	return tile_map.local_to_map(position)

func check_difference(vector1 : Vector2i, vector2 : Vector2i):
	var x_diff = abs(vector1.x - vector2.x)
	var y_diff = abs(vector1.y - vector2.y)
	
	return x_diff + y_diff <= max_distance
	
# gets tiledata of the tile, the player is looking at
func get_tile_beside(player_position : Vector2i):
	if facing_direction == "N":
		return Vector2i(player_position.x, player_position.y - 1)
	if facing_direction == "E":
		return Vector2i(player_position.x + 1, player_position.y)
	if facing_direction == "S":
		return Vector2i(player_position.x, player_position.y + 1)
	if facing_direction == "W":
		return Vector2i(player_position.x - 1, player_position.y)

# creates soil, where the hoe is pointed at
func create_soil():
	var player_position = get_player_pos()
	var tile = get_tile_beside(player_position)
	
	var soil_source_id = 5
	var soil_atlas_coord : Vector2i = Vector2i(0, 0)
	
	if tile_map.get_cell_tile_data(2, tile):
		print("Can't create soil!")
		return
		
	if get_tile_data(1, "can_place_soil", tile):
		tile_map.set_cell(top_ground_layer, tile, soil_source_id, soil_atlas_coord)
	else:
		print("Can't create soil!")

# Place, what is currently in players hand at mouseclick position
func hand():
	var seed_source_id = 6
	var seed_atlas_coord : Vector2i = Vector2i(0, 1)
	var current_tile = get_mouse_pos()
	
	if get_tile_data(2, custom_data_layer, current_tile):
		if check_difference(current_tile, get_player_pos()):
			print("plant seeds")
			tile_map.set_cell(crop_layer, current_tile, seed_source_id, seed_atlas_coord)
		else:
			print("Can't place seeds!")

# returns tiledata
func get_tile_data(layer, custom_data_layer, vector):
	var tile_data : TileData = tile_map.get_cell_tile_data(layer, vector)
	if tile_data:
		return tile_data
	else:
		return false
