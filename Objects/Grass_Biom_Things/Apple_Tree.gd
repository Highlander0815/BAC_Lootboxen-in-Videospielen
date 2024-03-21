extends Node2D

enum TREE_STATE { EMPTY, RIPE }

var player_entered = false
var current_state : TREE_STATE = TREE_STATE.EMPTY
var apple = preload("res://Objects/Items/Apple_Pickable.tscn")

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
			var apple_instance = apple.instantiate()
			apple_instance.position = position # + Vector2(randi_range(-10, 10), randi_range(-10, 10))
			get_parent().add_child(apple_instance)
			var direction : Vector2 = Vector2(
				randf_range(-5.0, 5.0),
				randf_range(-5.0, 5.0)
			).normalized()
			
			apple_instance.launch(direction * launch_speed, launch_duration)
			
		timer.start(5)

func _on_timer_timeout():
	current_state = TREE_STATE.RIPE
	$AppleTree_Empty.visible = false
	$AppleTree_Ripe.visible = true
