extends Node2D

@onready var raycasts := [$RayCast2D,$RayCast2D2,$RayCast2D3,$RayCast2D4]

var total_players := 0
var players_left := 0

var init_timer := 15.0
var is_enabled := false

func _ready():
	$Pause.show()
	Websocket.client_connected.connect(_player_connected)

func _player_connected(data: Dictionary):
	var player = preload("res://Scenes/PlayerTron.tscn").instantiate()
	total_players += 1
	players_left += 1
	player.position = Vector2(randi() % 950 + 120, randi() % 500 + 100)
	add_child(player)
	if init_timer > 0:
		player.t_disable()
	Websocket.register_player(data.id, player)

func _physics_process(delta):
	
	if not is_enabled:
		init_timer -= delta
		$Pause/CenterContainer/VBoxContainer/Label2.modulate.h += delta
		$Pause/CenterContainer/VBoxContainer/Label2.text = "Starting in " + str(int(init_timer))
		if init_timer < 0:
			$Pause.hide()
			get_tree().call_group("Player", "t_enable")
			is_enabled = true
		else:
			return
	
	for raycast in raycasts:
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.get_collider().is_in_group("Player"):
				raycast.get_collider().disable()
				players_left -= 1
				if not raycast.get_collider().id in Websocket.id_to_scores:
					reset()
					return
				if players_left == 2:
					Websocket.id_to_scores[raycast.get_collider().id] += 1
				if players_left == 1:
					Websocket.id_to_scores[raycast.get_collider().id] += 2
				if players_left == 0:
					Websocket.id_to_scores[raycast.get_collider().id] += 3
					reset()


func reset():
	for raycast in raycasts:
		raycast.queue_free()
	raycasts = []
	get_tree().call_group("Player", "reset")
	$Leaderboards.display()
	init_timer = 999999
	is_enabled = false

func add_raycast(raycast):
	var t := get_tree().create_tween()
	t.tween_interval(0.8)
	t.tween_callback(raycast.set.bind("exclude_parent", false))
	raycasts.append(raycast)

