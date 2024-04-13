extends Control

@onready var leaderboard_list = $MarginContainer/PanelContainer/VBoxContainer/List


func _ready():
	initialize_list()
	add_label()

func initialize_list():
	var lb_element = preload("res://Scenes/leaderbord_element.tscn")
	var element = lb_element.instantiate()
	element.set_variables("Rank", "Player Name", "Points")
	leaderboard_list.add_child(element)

func add_label():
	for i in range(1,10):
		# Create a new Label node
		var lb_element = preload("res://Scenes/leaderbord_element.tscn")
		
		var element = lb_element.instantiate()
		element.set_variables("1", "Player", "1")
		
		# Add the label to the VBoxContainer
		leaderboard_list.add_child(element)

func resume():
	get_tree().paused = false

func pause():
	get_tree().paused = true

func testLB():
	if Input.is_action_just_pressed("leaderboard") and get_tree().paused == false:
		show()
		pause()
	elif Input.is_action_just_pressed("leaderboard") and get_tree().paused == true:
		hide()
		resume()

func _process(_delta):
	testLB()
