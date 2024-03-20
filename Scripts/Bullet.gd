extends Area2D

var emitter

var velocity := Vector2()

var bounces := 0

func _physics_process(delta):
	position += velocity * delta
	$Line2D.rotation = velocity.angle()

func _on_body_entered(body):
	if body == emitter: 
		return
	if body.is_in_group("Player"):
		body.take_damage()
	
	if bounces > 0:
		$RayCast2D.position = -velocity * 2
		$RayCast2D.target_position = velocity * 4
		$RayCast2D.force_raycast_update()
		var normal: Vector2 = $RayCast2D.get_collision_normal()
		velocity = velocity.bounce(normal)
		bounces -= 1
		return
	
	queue_free()
