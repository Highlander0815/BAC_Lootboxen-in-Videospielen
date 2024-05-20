extends Control

@onready var label_points = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/Points
@onready var label_spent = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/Spent
@onready var label_time = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer3/Time
@onready var label_prm_time = $MarginContainer/PanelContainer/VBoxContainer/HBoxContainer4/PremiumTime

func _ready():
	label_points.text = str(Global.player_points)
	label_spent.text = str(Global.player_spent)
	label_time.text = str(Global.timer)
	label_prm_time.text = str(Global.premium_timer)

func _on_quit_pressed():
	get_tree().quit()
