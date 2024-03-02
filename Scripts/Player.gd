extends CharacterBody2D

@export var acceleration = 10
@export var max_speed = 200

@onready var inner_line = $Line2D
@export var inner_line_length = 11

var is_dashing := false

func _physics_process(delta):
	is_dashing = Input.is_action_pressed("dash")
	
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_up", "ui_down")
	
	velocity += Vector2(x, y) * acceleration * (1.15 if is_dashing else 1.0)
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed * (1.65 if is_dashing else 1.0)
	velocity = velocity.lerp(Vector2(), 0.05)
	
	$Sprite2D.rotation = velocity.angle() + PI/2
	$CollisionPolygon2D.rotation = velocity.angle() + PI/2
	$Pivot.rotation = velocity.angle() + PI/2
	move_and_slide()
	
	for slide_idx in range(get_slide_collision_count()):
		var col = get_slide_collision(slide_idx)
		var collider = col.get_collider()
		if collider.is_in_group("Ball"):
			collider.apply_central_impulse(to_local(collider.global_position) * 2)

func _process(delta):
	inner_line.add_point($Pivot/LineEmitter.global_position)
	if inner_line.get_point_count() > inner_line_length:
		inner_line.remove_point(0)
