extends Sprite2D

class_name lootbox

@onready var particles = $CPUParticles2D
@onready var light = $PointLight2D
@onready var animation = $AnimationTree
@onready var state_machine = animation.get("parameters/playback")
@onready var item_data = ItemData.new()
@onready var items = $"../Items"
@onready var button = $Button


var seeds
var player_in_range = false

var fade_out_duration = 2.0 # Duration of the fade-out in seconds
var fade_out_timer = 0.0 # Tracks the progress of the fade-out

func _ready():
	seeds = item_data.get_seeds()

func open_chest():
	state_machine.travel("opening")	
	await get_tree().create_timer(0.5).timeout
	light.enabled = true
	await get_tree().create_timer(0.2).timeout
	particles.emitting = true
	
	var rewards = []
	
	for i in range(0, 3):
		var reward = random_seed_generator()
		rewards.append(reward)
	
	return rewards


func random_seed_generator():
	var lucky_number = randi_range(1, 100)
	if lucky_number <= 1:
		return get_seeds_by_rarity(4)
	elif lucky_number <= 20:
		return get_seeds_by_rarity(3)
	elif lucky_number <= 70:
		return get_seeds_by_rarity(2)
	else:
		return get_seeds_by_rarity(1)

func get_seeds_by_rarity(rarity):
	var filtered_seeds = []
	for item in seeds:
		if item.item_rarity == str(rarity):
			filtered_seeds.append(item)
	
	if filtered_seeds.size() == 0:
		return {}  # Return an empty dictionary if no vegetables match the rarity
	
	# Seed the random number generator
	RandomNumberGenerator.new().randomize()
	
	# Select a random index in the range of the filtered list
	var random_index = randi() % filtered_seeds.size()
	
	# Return the randomly selected vegetable
	return filtered_seeds[random_index]

func spawn_items():
	button.disabled = true
	var rewards = await open_chest()
	await get_tree().create_timer(2.0).timeout

	# Define position of items
	var position_array = [Vector2(global_position.x -15, global_position.y + 5), Vector2(global_position.x, global_position.y + 8), Vector2(global_position.x + 15, global_position.y + 5)]
	
	# Instantiate and spawn Items from chest
	for i in range(0, 3):
		spawn_item(rewards[i], position_array[i])

func spawn_item(data, item_position):
	var item_scene = preload("res://Scenes/Shop_Item.tscn")
	var item_instance = item_scene.instantiate()
	item_instance.initiate_items(data["item_type"], data["item_name"], data["item_rarity"], data["texture"], data["item_value"], data["item_sellable"])
	item_instance.global_position = item_position
	items.add_child(item_instance)


func _on_button_pressed():
	await spawn_items()
