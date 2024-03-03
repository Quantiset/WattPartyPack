extends Node2D

@onready var ball = $Ball

var players := 0

var l_score := 0
var r_score := 0

var init_timer := 15.0 
var is_enabled := false

var timer_since_last_pickup := 0.0

func _ready():
	$Pause.show()
	Websocket.client_connected.connect(_player_connected)

func _player_connected(data: Dictionary):
	var player = preload("res://Scenes/Player.tscn").instantiate()
	player.team = players % 2
	add_child(player)
	if init_timer > 0:
		player.disable()
	players += 1
	player.position = $Center.position - Vector2((2*(players%2)-1)*200+randi()%20-10, randi()%20-10)
	Websocket.register_player(data.id, player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	if randi() % 530 == 1 and timer_since_last_pickup > 1.4:
		var pickup = preload("res://Scenes/Pickup.tscn").instantiate()
		pickup.body_entered.connect(_pickup_body_entered.bind(pickup))
		pickup.position = $Center.position + Vector2(randi()%400,0).rotated(2*PI*randf())
		add_child(pickup)
		timer_since_last_pickup = 0
		
	

func update_scores():
	$RLabel.text = str(r_score)
	$LLabel.text = str(l_score)
	if r_score >= 5 or l_score >= 5:
		var winning_team = (1 if r_score >= 5 else 0)
		for player in get_tree().get_nodes_in_group("Player"):
			if player.team == winning_team:
				Websocket.id_to_scores[player.id] += 2
		$Leaderboards.display()
		init_timer = 999999
		is_enabled = false

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

func _pickup_body_entered(body, pickup):
	if body.is_in_group("Player"):
		body.dash()
		pickup.queue_free()
