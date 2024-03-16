extends Node2D

enum TREE_STATE { EMPTY, RIPE }

var player_entered = false
var current_state : TREE_STATE = TREE_STATE.EMPTY
var apple = preload("res://Objects/Grass_Biom_Things/Apple.tscn")

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(10)
	$TileMap_Ripe.visible = false


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
		$TileMap_Empty.visible = true
		$TileMap_Ripe.visible = false
		
		for i in range(3):
			var apple_instance = apple.instantiate()
			apple_instance.position = position + Vector2(randi_range(-10, 10), randi_range(-10, 10))
			get_parent().add_child(apple_instance)
		
		timer.start(10)

func _on_timer_timeout():
	current_state = TREE_STATE.RIPE
	$TileMap_Empty.visible = false
	$TileMap_Ripe.visible = true
