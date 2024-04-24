extends Control
var counter = 0

@onready var button = $MarginContainer/PanelContainer/VBoxContainer/Button
@onready var intro = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/Introduction
@onready var help1 = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/help_wallet
@onready var help2 = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/help_currency
@onready var help3 = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/help_hotbar
@onready var help4 = $MarginContainer/PanelContainer/VBoxContainer/PanelContainer/help_shop

func _on_button_pressed():
	if counter == 0:
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
		button.text = "Got it!"
	elif counter >= 4:
		hide()
		help4.hide()
	counter += 1
