extends CanvasLayer

signal done

func _ready():
	$Sprite2D.show()
	$ColorRect.hide()
	$CenterContainer.hide()
	$AnimationPlayer.play_backwards("Dither")
	done.connect(_animation_finished)

func display():
	
	if $AnimationPlayer.is_playing():
		await $AnimationPlayer.animation_finished
	
	$CenterContainer/VBoxContainer/Label2.text = ""
	$ColorRect.show()
	$CenterContainer.show()
	
	$AnimationPlayer.play("FadeIn")
	
	var scores = Websocket.id_to_scores.keys()
	scores.sort()
	
	var i := 0
	for player_id in scores:
		$CenterContainer/VBoxContainer/Label2.text += "Player " + str(i) + ": " + str(Websocket.id_to_scores[player_id]) + "\n"
		i += 1
	
	await get_tree().create_timer(5.5).timeout
	
	$AnimationPlayer.play("FadeOut")
	
	await $AnimationPlayer.animation_finished
	
	done.emit()

func _animation_finished():
	$AnimationPlayer.play("Dither")
	await $AnimationPlayer.animation_finished
	Globals.next_scene()

