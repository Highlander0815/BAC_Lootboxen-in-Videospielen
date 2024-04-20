extends CanvasLayer

class_name UI

signal update_wallet

@onready var wallet_label = %Amount
@onready var coins_label = $Control/MarginContainer2/VBoxContainer/HBoxContainer/Coins_Amount
@onready var premium_label = $Control/MarginContainer2/VBoxContainer/HBoxContainer2/Premium_Amount
@onready var spent_label = $Control/MarginContainer/VBoxContainer/HBoxContainer3/spent_label

var spent : float = 0.00

var wallet : float = 0.00:
	set(new_wallet):
		wallet = new_wallet
		_update_wallet_label()

func _ready():
	_on_coins_updated(Global.coins)
	_on_premium_updated(Global.silver_ingots)
	_update_wallet_label()
	Global.connect("update_coins", _on_coins_updated)
	Global.connect("update_silver_ingots", _on_premium_updated)
	Global.connect("update_global_wallet", _on_wallet_updated)
	Global.ui_ready()

func _on_wallet_updated(new_wallet):
	wallet = new_wallet
	_update_wallet_label()

func _update_wallet_label():
	wallet_label.text = "%.2f" % wallet

func _on_add_money_pressed():
	wallet += 0.40
	spent += 0.40
	Global.wallet_total += 0.40
	spent_label.text = "%.2f" % spent
	_on_money_added()

func _on_money_spent(new_wallet):
	wallet = new_wallet

func _on_money_added():
	update_wallet.emit(wallet)

func _on_coins_updated(coins):
	coins_label.text = str(coins)

func _on_premium_updated(silver_ingots):
	premium_label.text = str(silver_ingots)
