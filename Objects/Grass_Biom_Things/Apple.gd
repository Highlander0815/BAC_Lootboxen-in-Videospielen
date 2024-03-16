extends Sprite2D

var player_entered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _input(_event):
	if Input.is_action_just_pressed("interact") && player_entered == true:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "PlayerCat":
		player_entered = true


func _on_area_2d_body_exited(body):
	if body.name == "PlayerCat":
		player_entered = false
