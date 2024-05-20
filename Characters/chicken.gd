extends CharacterBody2D

enum CHICKEN_STATE { IDLE, WALK }

@export var move_speed : float = 5

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var collision = $CollisionShape2D

var move_direction : Vector2 = Vector2.ZERO
var current_state : CHICKEN_STATE = CHICKEN_STATE.IDLE

func _ready():
	select_new_direction()
	pick_new_state()

func _physics_process(_delta):
	if current_state == CHICKEN_STATE.WALK:
		velocity = move_direction * move_speed
		move_and_slide()
	
		# If character collides
		if velocity.length() < 1:
			state_machine.travel("Idle")
			current_state = CHICKEN_STATE.IDLE
			timer.stop()
			timer.start(2.0)
		
	else:
		velocity = Vector2.ZERO  # Stop the chicken's movement when not walking
	
func select_new_direction():
	move_direction = Vector2(
		randi_range(-1, 1),
		randi_range(-1, 1)
	)
	
	if(move_direction.x < 0):
		sprite.flip_h = true
		
	elif(move_direction.x > 0):
		sprite.flip_h = false
		
	if (sprite.flip_h):
		collision.position.x = 2
	else:
		collision.position.x = 0

func pick_new_state():
	if(current_state == CHICKEN_STATE.IDLE):
		state_machine.travel("Walk")
		current_state = CHICKEN_STATE.WALK
		select_new_direction()
		timer.start(randi_range(1, 2))
	elif(current_state == CHICKEN_STATE.WALK):
		state_machine.travel("Idle")
		current_state = CHICKEN_STATE.IDLE
		timer.start(randi_range(2, 5))


func _on_timer_timeout():
	pick_new_state()
