extends Node2D

@onready var ball = $Ball

var players := 0

var l_score := 0
var r_score := 0

func _ready():
	Websocket.client_connected.connect(_player_connected)

func _player_connected(data: Dictionary):
	var player = preload("res://Scenes/Player.tscn").instantiate()
	player.team = players % 2
	add_child(player)
	players += 1
	player.position = $Center.position - Vector2((2*(players%2)-1)*200, 0)
	Websocket.register_player(data.id, player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_scores():
	$RLabel.text = str(r_score)
	$LLabel.text = str(l_score)

func _on_left_sector_body_entered(body):
	if body.is_in_group("Ball"):
		r_score += 1
		ball.set_pos($Center.position)
		update_scores()

func _on_right_sector_body_entered(body):
	if body.is_in_group("Ball"):
		l_score += 1
		ball.set_pos($Center.position)
		update_scores()

