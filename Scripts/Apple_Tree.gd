extends Node2D

enum TREE_STATE { EMPTY, RIPE }

var player_entered = false
var current_state : TREE_STATE = TREE_STATE.EMPTY

@export var launch_speed : float = 100
@export var launch_duration : float = 0.25

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(2)
	$AppleTree_Ripe.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "PlayerCat":
		player_entered = true


func _on_area_2d_body_exited(body):
	if body.name == "PlayerCat":
		player_entered = false

func _input(_event):
	if Input.is_action_just_pressed("interact") && player_entered == true && current_state == TREE_STATE.RIPE:
		current_state = TREE_STATE.EMPTY
		$AppleTree_Empty.visible = true
		$AppleTree_Ripe.visible = false
		
		for i in range(3):
			# Instantiate 3 apples
			
			var direction : Vector2 = Vector2(
				randf_range(-5.0, 5.0),
				randf_range(-5.0, 5.0)
			).normalized()
			
			print(direction)
			
		timer.start(5)

func _on_timer_timeout():
	current_state = TREE_STATE.RIPE
	$AppleTree_Empty.visible = false
	$AppleTree_Ripe.visible = true
