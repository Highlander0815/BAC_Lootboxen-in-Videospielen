extends Sprite2D

class_name lootbox_basic

@onready var particles = $CPUParticles2D
@onready var light = $PointLight2D
@onready var animation = $AnimationTree
@onready var state_machine = animation.get("parameters/playback")
@onready var item_data = ItemData.new()
@onready var items = $"../Items"
@onready var button = $Button
@onready var InfoMessage = $InfoMessage
@onready var Prompt = $InfoMessage/Prompt
@onready var timer = $InfoMessage/Timer

signal update_chest_coins

var seeds
var player_in_range = false

var fade_out_duration = 2.0 # Duration of the fade-out in seconds
var fade_out_timer = 0.0 # Tracks the progress of the fade-out

func _ready():
	InfoMessage.hide()
	seeds = item_data.get_seeds()

# handles the opening of the chest
func open_chest():
	state_machine.travel("opening")
	await get_tree().create_timer(0.5).timeout
	light.enabled = true
	print("light enabled: ", light.enabled)
	await get_tree().create_timer(0.2).timeout
	particles.emitting = true

# generates a random number and returns a seed with the sidgnated rarity level
func random_seed_generator():
	var lucky_number = randf_range(0.0, 99.0)
	if lucky_number <= 0.5:
		return get_seeds_by_rarity(4)
	elif lucky_number <= 9.5:
		return get_seeds_by_rarity(3)
	elif lucky_number <= 55.0:
		return get_seeds_by_rarity(2)
	else:
		return get_seeds_by_rarity(1)

# returns a random seed of the given rarity level
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

# handles the creation of the 3 selected random seeds
func spawn_items():
	button.disabled = true
	
	# generate rewards
	var rewards = []
	for i in range(0, 3):
		var reward = random_seed_generator()
		rewards.append(reward)
	
	# Define position of items
	var position_array = [Vector2(global_position.x -15, global_position.y + 5), Vector2(global_position.x, global_position.y + 8), Vector2(global_position.x + 15, global_position.y + 5)]
	
	# Instantiate and spawn Items from chest
	for i in range(0, 3):
		spawn_item(rewards[i], position_array[i])

	await open_chest()
	await get_tree().create_timer(2.0).timeout
		
	for item in items.get_children():
		item.get_child(0).visible = true

# spawns one specific seed in the gameworld
func spawn_item(data, item_position):
	var item_scene = preload("res://Scenes/Shop_Item.tscn")
	var item_instance = item_scene.instantiate()
	item_instance.initiate_items(data["item_type"], data["item_name"], data["item_rarity"], data["texture"], data["item_value"], data["item_sellable"])
	item_instance.global_position = item_position
	item_instance.z_index = 1
	item_instance.get_child(0).visible = false
	items.add_child(item_instance)

# handles the functionality of the buy button
func _on_button_pressed():
	if Global.coins >= 5:
		update_chest_coins.emit(Global.coins - 5)
		await spawn_items()
		await get_tree().create_timer(2.5).timeout
		reset_chest()
	else:
		show_prompt("Sry, you don't have enough coins to buy a chest...")

# resets the chest after it has been opened
func reset_chest():
	light.enabled = false
	particles.emitting = false
	state_machine.travel("Idle")
	button.disabled = false

# shows a prompt with changeable information
func show_prompt(text, duration = 3.0):
	# Set the message
	Prompt.text = text
	# Start the timer with the specified duration
	timer.start(duration)
	# Show the panel
	InfoMessage.show()

# hides the info message after timer runs out
func _on_timer_timeout():
	InfoMessage.hide()
