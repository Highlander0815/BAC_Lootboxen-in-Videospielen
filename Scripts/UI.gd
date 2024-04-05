extends CanvasLayer

class_name UI

signal update_wallet

@onready var wallet_label = %Amount

var wallet : float = 0.00:
	set(new_wallet):
		wallet = new_wallet
		_update_wallet_label()

func _ready():
	_update_wallet_label()

func _update_wallet_label():
	wallet_label.text = "%.2f" % wallet

func _on_add_money_pressed():
	wallet += 0.10
	_on_money_added()

func _on_money_spent(new_wallet):
	wallet = new_wallet

func _on_money_added():
	update_wallet.emit(wallet)
