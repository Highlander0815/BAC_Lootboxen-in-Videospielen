extends Area2D

@export var player : Player
@export var facing_shape : FacingCollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("facing_direction_change", _on_player_facing_direction_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	pass # Replace with function body.

func _on_player_facing_direction_changed(facing : String):
	if (facing == "N"):
		facing_shape.position = facing_shape.facing_up
		facing_shape.rotation_degrees = 90
	if (facing == "E"):
		facing_shape.position = facing_shape.facing_right
		facing_shape.rotation = 0
	if (facing == "S"):
		facing_shape.position = facing_shape.facing_down
		facing_shape.rotation_degrees = 90
	if (facing == "W"):
		facing_shape.position = facing_shape.facing_left
		facing_shape.rotation = 0
