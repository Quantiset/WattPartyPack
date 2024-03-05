extends Area2D

@export var lifetime := 10

func _ready():
	var t := get_tree().create_tween()
	scale = Vector2()
	t.tween_property(self, "scale", Vector2(1,1), 1)
	
	$Timer.start(lifetime)

func _on_timer_timeout():
	var t := get_tree().create_tween()
	t.tween_property(self, "scale", Vector2(), 1)
	t.tween_callback(queue_free)


func _on_body_entered(body):
	if body.is_in_group("Player"):
		queue_free()
