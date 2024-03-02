extends Node2D

@onready var ball = $Ball

var l_score := 0
var r_score := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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

