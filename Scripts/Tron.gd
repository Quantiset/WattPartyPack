extends Node2D

var raycasts := []

func _physics_process(delta):
	for raycast in raycasts:
		var s := RayCast2D.new()
		if raycast.is_colliding():
			if raycast.get_collider().is_in_group("Player"):
				reset()

func reset():
	for raycast in raycasts:
		raycast.queue_free()
	get_tree().call_group("Player", "reset")
