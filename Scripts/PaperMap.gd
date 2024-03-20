extends Map

var timer_since_last_pickup := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#super._ready()
	PLAYER_SCENE = preload("res://Scenes/PaperShip.tscn")

func _process(delta):
	super._process(delta)
	
	timer_since_last_pickup += delta
	if randi() % 530 == 1 and timer_since_last_pickup > 1.4:
		var pickup = preload("res://Scenes/Pickup.tscn").instantiate()
		pickup.body_entered.connect(_pickup_body_entered.bind(pickup))
		pickup.position = $Center.position + Vector2(randi()%400,0).rotated(2*PI*randf())
		add_child(pickup)
		timer_since_last_pickup = 0
	
	$Camera2D.position = $Camera2D.position.lerp($PaperShip.position, 0.01)

func _pickup_body_entered(body, pickup):
	body.dash()
