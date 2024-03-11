extends Map


# Called when the node enters the scene tree for the first time.
func _ready():
	#super._ready()
	PLAYER_SCENE = preload("res://Scenes/PaperShip.tscn")

func _process(delta):
	super._process(delta)
	$Camera2D.position = $Camera2D.position.lerp($PaperShip.position, 0.01)
