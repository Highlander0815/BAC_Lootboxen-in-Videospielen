extends Control

@onready var leaderboard_list = $MarginContainer/PanelContainer/VBoxContainer/List

var player_data = [{"name" : "GiantChestnut", "points" : 126}, {"name" : "Adventurer_1123095", "points" : 105}, {"name" : "GreenGecko", "points" : 99}, 
{"name" : "InnocentLazy", "points" : 88}, {"name" : "ShadyDeep", "points" : 76}, {"name" : "LittleTangerine", "points" : 61},
{"name" : "HellBeast", "points" : 52}, {"name" : "StormCloud", "points" : 48}, {"name" : "FitEros", "points" : 33},
{"name" : "DevilsHand", "points" : 19}, {"name" : "Adventurer_3451827", "points" : 12}, {"name" : "LittleBig", "points" : 8},
{"name" : "Lazarus", "points" : 5}, {"name" : "RandomName", "points" : 0}, {"name" : "Pea", "points" : 0}]

func _ready():
	player_data.append({"name" : Global.player_name, "points" : Global.player_points})

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

func calculate_points(offset):
	# probaility 20% if points are added
	var add_points = randi_range(1, 100)
	if add_points <= 50:
		var rnd_points = randi_range(1, 100)
		if rnd_points < (10 + offset):
			return 100
		if rnd_points < 30:
			return 20
		if rnd_points < 60:
			return 4
		return 1
	return 0

func update_leaderboard_data():
	var cnt = 10
	for npc in player_data:
		if npc["name"] == Global.player_name:
			npc["points"] = Global.player_points
		npc["points"] += calculate_points(cnt)
		if cnt > 0:
			cnt -= 1

# Custom comparison function
func compare_points(a, b):
	return a["points"] > b["points"]  # Return true if 'a' has fewer points than 'b'
		
func sort_array():
	player_data.sort_custom(compare_points)

func add_label():
	var cnt = 1
	
	for i in player_data:
		# Create a new Label node
		var lb_element = preload("res://Scenes/leaderbord_element.tscn")
		var player_lb_element = preload("res://Scenes/leaderbord_element_player.tscn")
		
		var element = lb_element.instantiate()
		var player_element = player_lb_element.instantiate()
				
		# Add the label to the VBoxContainer
		if i["name"] == Global.player_name:
			player_element.set_variables(str(cnt), i["name"], i["points"])
			leaderboard_list.add_child(player_element)
		else:
			element.set_variables(str(cnt), i["name"], i["points"])
			leaderboard_list.add_child(element)
		cnt += 1
		
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
	if Global.player_points > Global.old_player_points:
		if (Global.player_points - Global.old_player_points) >= 50:
			update_leaderboard_data()
		update_leaderboard_data()
		sort_array()
		Global.old_player_points = Global.player_points
		
		
