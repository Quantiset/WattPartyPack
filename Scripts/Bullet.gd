extends Area2D

var emitter

var velocity := Vector2()

func _physics_process(delta):
	print("SDF")
	position += velocity * delta
	$Line2D.rotation = velocity.angle()

func _on_body_entered(body):
	if body == emitter: 
		return
	if body.is_in_group("Player"):
		body.take_damage()
	queue_free()
