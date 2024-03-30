extends Area2D

class_name Apple_Pickup

@export var resource_type : Resource
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

var launch_velocity : Vector2 = Vector2.ZERO
var move_duration : float = 0
var time_since_launch : float = 0
var launching : bool = false :
	set(is_launching):
		launching = is_launching
		collision_shape.disabled = launching

func launch(velocity : Vector2, duration : float):
	launch_velocity = velocity
	move_duration = duration
	time_since_launch = 0
	launching = true

func _ready():
	pass

func _on_body_entered(body):
	if body.name == "PlayerCat":
		var inventory = body.find_child("Inventory")
		if (inventory):
			inventory.add_resources(resource_type, 1)
		queue_free()

func _on_body_exited(_body):
	pass

func _process(delta):
	if (launching):
		position += launch_velocity * delta
		time_since_launch += delta
		
		if(time_since_launch >= move_duration):
			launching = false

