extends Map

var players_left := 0

var timer_since_last_pickup := 0.0

func _ready():
	for player in get_tree().get_nodes_in_group("Player"):
		player.can_shoot = true
		player.disable()
		player.dead.connect(_player_death.bind(player))

func _player_connected(data: Dictionary):
	var player = super._player_connected(data)
	players_left += 1
	player.dead.connect(_player_death.bind(player))
	player.position = $Center.position + Vector2(randi()%500-250,randi()%300-150)
	player.can_shoot = true

func _physics_process(delta):
	
	if not is_enabled:
		init_timer -= delta
		$Pause/CenterContainer/VBoxContainer/Label2.modulate.h += delta
		$Pause/CenterContainer/VBoxContainer/Label2.text = "Starting in " + str(int(init_timer))
		if init_timer < 0:
			$Pause.hide()
			get_tree().call_group("Player", "enable")
			is_enabled = true
		else:
			return
	
	timer_since_last_pickup += delta
	if randi() % 230 == 1 and timer_since_last_pickup > 1.4:
		var pickup = preload("res://Scenes/Pickup.tscn").instantiate()
		pickup.body_entered.connect(_pickup_body_entered.bind(pickup))
		pickup.position = $Center.position + Vector2(randi()%400,0).rotated(2*PI*randf())
		add_child(pickup)
		timer_since_last_pickup = 0

func _player_death(player):
	players_left -= 1
	if players_left == 3:
		Websocket.id_to_scores[player.id] += 1
	if players_left == 2:
		Websocket.id_to_scores[player.id] += 2
	if players_left == 1:
		Websocket.id_to_scores[player.id] += 3
		$Leaderboards.display()
		init_timer = 999999
		is_enabled = false


func _pickup_body_entered(body, pickup):
	if body.is_in_group("Player"):
		pickup.queue_free()
		var point = Vector2(240,0)
		for i in range(9):
			body.shoot(point)
			point = point.rotated(2*PI*i/9+randf())
