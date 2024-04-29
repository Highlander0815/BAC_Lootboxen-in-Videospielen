extends Control

class_name leaderboard_element_menu

@onready var rank_label = $HBoxContainer/Rank
@onready var player_label = $HBoxContainer/Player
@onready var points_label = $HBoxContainer/Points

var lb_rank : String
var lb_player : String
var lb_points : String

func _ready():
	call_deferred("deferred_init")
	
func deferred_init():
	if is_inside_tree():
		initialize_labels(lb_rank, lb_player, lb_points)

func initialize_labels(rank, player, points):
	rank_label.text = rank
	player_label.text = player
	points_label.text = points

func set_variables(rank, player, points):
	lb_rank = str(rank)
	lb_player = str(player)
	lb_points = str(points)
	
	if is_inside_tree():
		initialize_labels(lb_rank, lb_player, lb_points)
