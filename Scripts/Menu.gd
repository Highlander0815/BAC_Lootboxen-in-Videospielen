extends Control

@onready var welcome_screen = $CanvasLayer/WelcomeScreen
@onready var menu = $MarginContainer/VBoxContainer
@onready var title = $Title

func _on_play_pressed():
	menu.hide()
	title.hide()
	welcome_screen.show()
	

func _on_options_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()
