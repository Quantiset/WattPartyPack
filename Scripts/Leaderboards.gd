extends CanvasLayer

signal done

func _ready():
	done.connect(_animation_finished)

func display():
	show()
	$AnimationPlayer.play("FadeIn")
	var i := 0
	for player_id in Websocket.id_to_scores:
		$CenterContainer/VBoxContainer/Label2.text += "Player " + str(i) + ": " + str(Websocket.id_to_scores[player_id]) + "\n"
		i += 1
	
	await get_tree().create_timer(5.5).timeout
	
	$AnimationPlayer.play("FadeOut")
	
	await $AnimationPlayer.animation_finished
	
	done.emit()

func _animation_finished():
	Websocket.next_scene()

