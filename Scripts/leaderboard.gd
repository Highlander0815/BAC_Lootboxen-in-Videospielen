extends Control

@onready var leaderboard_list = $MarginContainer/PanelContainer/VBoxContainer/List

var player_names = ["" ,"GiantChestnut", "Adventurer_1123095", "GreenGecko","LittleTangerine", "ShadyDeep", 
"InnocentLazy", "FitEros", "StormCloud", "HellBeast", "LittleBig", "Adventurer_3451827", "DevilsHand", "Pea", 
"Lazarus", "RandomName"]

var random_points_above = [250, 205, 155, 40, 35, 20, 5]
var random_points_below = [5, 20, 30, 45, 55, 80, 95, 100, 110, 130, 165, 195, 200, 205]

func _ready():
	pass

func initialize_list():
	var lb_element = preload("res://Scenes/leaderbord_element.tscn")
	var element = lb_element.instantiate()
	element.set_variables("Rank", "Player Name", "Points")
	leaderboard_list.add_child(element)

func show_leaderboard():
	clear_leaderboard()  # Clear existing labels
	initialize_list()
	add_label()          # Add new labels
	show()               # Show the Control node
	pause()              # Pause the game if needed

func hide_leaderboard():
	clear_leaderboard()  # Clear existing labels
	hide()               # Hide the Control node
	resume()             # Resume the game if it was paused

func clear_leaderboard():
	# Clear all children in the VBoxContainer.
	for child in leaderboard_list.get_children():
		child.queue_free()

func add_label():
	var ran_num = randi_range(3, 7)
	var cnt_above = 0
	var cnt_below = 0
	
	for i in range(1,16):
		# Create a new Label node
		var lb_element = preload("res://Scenes/leaderbord_element.tscn")
		var player_lb_element = preload("res://Scenes/leaderbord_element_player.tscn")
		
		var element = lb_element.instantiate()
		var player_element = player_lb_element.instantiate()
		
		if i < ran_num:
			element.set_variables(str(i), player_names[i], Global.player_points + random_points_above[cnt_above])
			cnt_above += 1
		if i == ran_num:
			player_element.set_variables(str(i), Global.player_name, Global.player_points)
		if i > ran_num:
			var points = Global.player_points - random_points_below[cnt_below]
			if points < 0:
				points = 0
			element.set_variables(str(i), player_names[i], points)
			cnt_below += 1
		
		# Add the label to the VBoxContainer
		if i == ran_num:
			leaderboard_list.add_child(player_element)
		else:	
			leaderboard_list.add_child(element)

func resume():
	get_tree().paused = false

func pause():
	get_tree().paused = true

func testLB():
	if Input.is_action_just_pressed("leaderboard") and get_tree().paused == false:
		show_leaderboard()
	elif Input.is_action_just_pressed("leaderboard") and get_tree().paused == true:
		hide_leaderboard()

func _process(_delta):
	testLB()
