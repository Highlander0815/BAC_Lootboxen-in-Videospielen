extends Sprite2D

# Speed of the movement
var speed = 1.8
# Height of the movement (amplitude)
var height = 1.8
# Starting y position
var start_y = 0.0
# Time accumulator
var time = 0.0

func _ready():
	# Remember the starting y position of the sprite
	start_y = position.y

func _process(delta):
	# Update the time based on the delta time of the frame
	time += delta * speed
	# Calculate the new y position using a sine wave for smooth oscillation
	position.y = start_y + sin(time) * height
