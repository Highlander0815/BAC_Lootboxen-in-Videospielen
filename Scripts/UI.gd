extends CanvasLayer

class_name UI

signal update_wallet

@onready var wallet_label = %Amount
@onready var coins_label = $Control/MarginContainer2/VBoxContainer/HBoxContainer/Coins_Amount
@onready var premium_label = $Control/MarginContainer2/VBoxContainer/HBoxContainer2/Premium_Amount

var wallet : float = 0.00:
	set(new_wallet):
		wallet = new_wallet
		_update_wallet_label()

func _ready():
	_update_wallet_label()
	Global.connect("update_coins", _on_coins_updated)
	Global.connect("update_silver_ingots", _on_premium_updated)

func _update_wallet_label():
	wallet_label.text = "%.2f" % wallet

func _on_add_money_pressed():
	wallet += 0.10
	_on_money_added()

func _on_money_spent(new_wallet):
	wallet = new_wallet

func _on_money_added():
	update_wallet.emit(wallet)

func _on_coins_updated(coins):
	coins_label.text = str(coins)

func _on_premium_updated(silver_ingots):
	premium_label.text = str(silver_ingots)