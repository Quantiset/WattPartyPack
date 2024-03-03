extends CharacterBody2D

@export var team := 0

@export var acceleration = 10
@export var max_speed = 200

@onready var inner_line = $Line2D
@export var inner_line_length = 11

var is_dashing := false
var is_enabled := false

var can_shoot := false

var x: float
var y: float

var id: String

signal dead

func _ready():
	$Sprite2D.texture = [
		preload("res://Assets/PlayerR.png"),
		preload("res://Assets/Player.png")
	][team]

func update_data(data):
	if data.btnA and not is_dashing:
		dash()
	if data.btnB and can_shoot:
		shoot()
	x = data["joy"]["x"]
	y = data["joy"]["y"]
	id = data["id"]

func disable():
	is_enabled = false

func enable():
	is_enabled = true

func shoot(dir_ = Vector2(240,0), angle_override = 0):
	var b = preload("res://Scenes/Bullet.tscn").instantiate()
	b.position = position
	b.velocity = dir_
	b.emitter = self
	get_parent().add_child(b)

func take_damage():
	disable()
	dead.emit()
	position.x = 10000

func dash():
	is_dashing = true
	var t := get_tree().create_tween()
	$Sprite2D.modulate = Color(7,7,7)
	t.tween_property($Sprite2D, "modulate", Color(1,1,1), 2)
	t.tween_callback(set.bindv(["is_dashing", false]))

func _physics_process(delta):
	if not is_enabled: return
	
	if can_shoot and Input.is_action_just_pressed("shoot"):
		shoot(Vector2(240,0).rotated($Sprite2D.rotation-PI/2))
	
	velocity += Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")) * acceleration * (1.15 if is_dashing else 1.0)
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
