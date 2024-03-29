extends Node2D
class_name Map

const COLOR_COMBINATIONS = [
	[Color("b700ff89"), Color("8a00e677")],
	[Color("b700ff89"), Color("8a00e677")],
	[Color("b700ff89"), Color("8a00e677")],
	[Color("ff1414ab"), Color("f5405bbe")],
	[Color("24b34a9a"), Color("35de5d9a")],
	[Color("b3249b9a"), Color("de357e9a")],
	[Color("b3249b9a"), Color("de357e9a")],
]

var players := 0

var player_enable_func = "enable"
var init_timer := Globals.LOADING_TIME
var is_enabled := false

var shockwave_push_player_strength := 150

var PLAYER_SCENE := preload("res://Scenes/ControllableShip.tscn")

func _ready():
	$Pause.show()
	var random_bg_idx : int = randi() % COLOR_COMBINATIONS.size()
	$Background/ParallaxLayer/Sprite2D.modulate = COLOR_COMBINATIONS[random_bg_idx][0]
	$Background/ParallaxLayer2/Sprite2D.modulate = COLOR_COMBINATIONS[random_bg_idx][1]
	Websocket.client_connected.connect(_player_connected)

func _player_connected(data: Dictionary):
	var player = PLAYER_SCENE.instantiate()
	add_child(player)
	if player.has_method("enable"):
		if init_timer > 0:
			player.disable()
		else:
			player.enable()
	players += 1
	Websocket.register_player(data.id, player)
	return player

func _process(delta):
	$Background.scroll_offset += Vector2(1,0.2) * delta * 2
	
	if not is_enabled and $Leaderboards/AnimationPlayer.is_playing():
		init_timer -= delta
		$Pause/CenterContainer/VBoxContainer/Label2.modulate.h += delta
		$Pause/CenterContainer/VBoxContainer/Label2.text = "Starting in " + str(int(init_timer))
		if init_timer < 0:
			$Pause.hide()
			get_tree().call_group("Player", player_enable_func)
			is_enabled = true
		else:
			return

func shockwave(pos, push_players := true):
	var uv = (pos - ($Camera2D.position + $Camera2D.offset - Vector2(1280, 720)/2)) / Vector2(1280, 720)
	$HUD/Shockwave.material.set_shader_parameter("center", uv)
	$HUD/ShockwaveAnim.play("Shockwave")
	
	if push_players:
		for player in get_tree().get_nodes_in_group("Player"):
			player.velocity += (player.position - pos) * shockwave_push_player_strength
