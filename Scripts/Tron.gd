extends Map

@onready var raycasts := [$RayCast2D,$RayCast2D2,$RayCast2D3,$RayCast2D4]

var players_left := 0

func _ready():
	super._ready()
	player_enable_func = "t_enable"
	PLAYER_SCENE = preload("res://Scenes/PlayerTron.tscn")

func _player_connected(data: Dictionary):
	var player = super._player_connected(data)
	if init_timer > 0:
		player.t_disable()
	else:
		player.t_disable()
	player.position = Vector2(randi() % 950 + 120, randi() % 500 + 100)

func _physics_process(delta):
	
	for raycast in raycasts:
		raycast.force_raycast_update()
		if raycast.is_colliding():
			if raycast.get_collider().is_in_group("Player"):
				raycast.get_collider().disable()
				players_left -= 1
				if players_left == 3:
					Websocket.scores[raycast.get_collider().id] += 1
				if players_left == 2:
					Websocket.scores[raycast.get_collider().id] += 2
				if players_left == 1:
					Websocket.scores[raycast.get_collider().id] += 3
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

