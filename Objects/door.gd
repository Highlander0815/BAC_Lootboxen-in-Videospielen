extends Sprite2D

var door_closed = true
var player_entered = false

func _ready():
	pass
	
func opening_door():
	$Door_Body/AnimationPlayer.play("Opening")
	await $Door_Body/AnimationPlayer.animation_finished
	$Door_Body/AnimationPlayer.play("Opened")
	$Door_Body/closed_door_collision.disabled = true
	$Door_Body/opened_door_collision.disabled = false
	$Door_Body/opened_door_collision2.disabled = false
	door_closed = false

func closing_door():
	$Door_Body/AnimationPlayer.play("Closing")
	await $Door_Body/AnimationPlayer.animation_finished
	$Door_Body/AnimationPlayer.play("Closed")
	$Door_Body/closed_door_collision.disabled = false
	$Door_Body/opened_door_collision.disabled = true
	$Door_Body/opened_door_collision2.disabled = true	
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


