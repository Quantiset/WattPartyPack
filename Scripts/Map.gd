extends Node2D
class_name Map

var players := 0

var init_timer := Globals.LOADING_TIME
var is_enabled := false

func _ready():
	$Pause.show()
	Websocket.client_connected.connect(_player_connected)

func _player_connected(data: Dictionary):
	var player = preload("res://Scenes/ControllableShip.tscn").instantiate()
	add_child(player)
	if init_timer > 0:
		player.disable()
	else:
		player.enable()
	players += 1
	Websocket.register_player(data.id, player)
	return player
