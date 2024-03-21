extends Node

class_name Inventory

@export var resources : Dictionary = { }

signal resource_count_changed(type : ResourceItem, new_count : int)

func add_resources(type : ResourceItem, amount : int):
	if type in resources:
		resources[type] = resources[type] + amount
	else:
		resources[type] = amount
		
	emit_signal("resource_count_changed", type, resources[type])

func _input(_event):
	if Input.is_action_just_pressed("inventory"):
		print(resources)
