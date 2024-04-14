extends Control

# Welcome Screen at the start of a game
# User can read the Introduction and enter a Player Name

@onready var Name_Input = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Name_Input

func _ready():
	pass

func _process(_delta):
	pass

func _on_button_pressed():
	if Name_Input.text == "":
		Global.player_name = "Adventurer_638251"
	else:
		Global.player_name = Name_Input.text
	get_tree().change_scene_to_file("res://Levels/game_level.tscn")


func _on_name_input_text_submitted(text):
	if text == "":
		Global.player_name = "Adventurer_638251"
	else:
		Global.player_name = text
	get_tree().change_scene_to_file("res://Levels/game_level.tscn")
