extends Sprite2D

var door_closed = true
var player_entered = false

func _ready():
	pass
	
func opening_door():
	$StaticBody2D/AnimationPlayer.play("Opening")
	await $StaticBody2D/AnimationPlayer.animation_finished
	$StaticBody2D/AnimationPlayer.play("Opened")
	$StaticBody2D/closed_door_collision.disabled = true
	$StaticBody2D/opened_door_collision.disabled = false
	$StaticBody2D/opened_door_collision2.disabled = false
	door_closed = false

func closing_door():
	$StaticBody2D/AnimationPlayer.play("Closing")
	await $StaticBody2D/AnimationPlayer.animation_finished
	$StaticBody2D/AnimationPlayer.play("Closed")
	$StaticBody2D/closed_door_collision.disabled = false
	$StaticBody2D/opened_door_collision.disabled = true
	$StaticBody2D/opened_door_collision2.disabled = true	
	door_closed = true

func _on_area_2d_body_entered(body):
	if body.name == "PlayerCat":
		player_entered = true

func _on_area_2d_body_exited(_body):
	player_entered = false

		
func _input(_event):
	if Input.is_action_just_pressed("interact") && player_entered == true:
		if (door_closed):
			opening_door()
		elif (!door_closed):
			closing_door()


