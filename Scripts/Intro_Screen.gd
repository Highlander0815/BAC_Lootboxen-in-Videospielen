extends Control
var counter = 0

@onready var title = $MarginContainer/PanelContainer/VBoxContainer/Title
@onready var button = $MarginContainer/PanelContainer/VBoxContainer/Button
@onready var intro = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/Introduction
@onready var help1 = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/help_wallet
@onready var help2 = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/help_currency
@onready var help3 = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/help_chest
@onready var help4 = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/help_shop
@onready var help5 = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/help_assign
@onready var help6 = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/help_hotbar
@onready var help7 = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/help_leaderboard

func _on_button_pressed():
	if counter == 0:
		title.text = "How to play"
		intro.hide()
		help1.show()
	elif counter == 1:
		help1.hide()
		help2.show()
	elif counter == 2:
		help2.hide()
		help3.show()
	elif counter == 3:
		help3.hide()
		help4.show()
	elif counter == 4:
		help4.hide()
		help5.show()
	elif counter == 5:
		help5.hide()
		help6.show()
	elif counter == 6:
		help6.hide()
		help7.show()
		button.text = "Got it!"
	elif counter == 7:
		help7.hide()
		title.text = "Controls"
		intro.show()
		hide()
	
	counter += 1
	if counter >= 8:
		counter = 0
