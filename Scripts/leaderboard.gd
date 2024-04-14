extends Control

@onready var leaderboard_list = $MarginContainer/PanelContainer/VBoxContainer/List

var player_names = ["" ,"GiantChestnut", "Adventurer_1123095", "GreenGecko","LittleTangerine", "ShadyDeep", 
"InnocentLazy", "FitEros", "StormCloud", "HellBeast", "LittleBig", "Adventurer_3451827", "DevilsHand", "Pea", 
"Lazarus", "RandomName"]

var random_points = [1532, 943, 654, 342, 562, 664, 843, 932, 1030, 1235, 1345, 1465, 1467, 1501, 1523, 1564]

func _ready():
	initialize_list()
	add_label()

func initialize_list():
	var lb_element = preload("res://Scenes/leaderbord_element.tscn")
	var element = lb_element.instantiate()
	element.set_variables("Rank", "Player Name", "Points")
	leaderboard_list.add_child(element)

func add_label():
	for i in range(1,16):
		# Create a new Label node
		var lb_element = preload("res://Scenes/leaderbord_element.tscn")
		
		var element = lb_element.instantiate()
		
		if i < 4:
			element.set_variables(str(i), player_names[i], Global.player_points + random_points[i])
		if i == 4:
			element.set_variables(str(i), Global.player_name, Global.player_points)
		if i > 4:
			element.set_variables(str(i), player_names[i], Global.player_points - random_points[i])
		
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
