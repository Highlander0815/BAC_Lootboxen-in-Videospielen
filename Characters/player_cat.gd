extends CharacterBody2D

class_name Player

@export var move_speed : float = 80
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

signal facing_direction_change(facing : String)

func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(_delta):
	# Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	update_animation_parameters(input_direction)

	# Update velocity
	velocity = input_direction * move_speed
	
	# Move and Slide function uses velocity of character body to move character on map
	move_and_slide()
	
	move_direction(input_direction)
	
	pick_new_state()
	
func update_animation_parameters(move_input : Vector2):
	# Dont change animation parameters if there is no move input
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func pick_new_state():
	# Choose state based on what is happening with the player
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func move_direction(input_direction : Vector2):
	if (input_direction.x > 0.8):
		emit_signal("facing_direction_change", "E")
	if (input_direction.x < -0.8):
		emit_signal("facing_direction_change", "W")
	if (input_direction.y > 0.8):
		emit_signal("facing_direction_change", "S")
	if (input_direction.y < -0.8):
		emit_signal("facing_direction_change", "N")
