extends Ship
class_name ControllableShip

@export var team := 0

@export var acceleration = 20
@export var max_speed = 250

var is_dashing := false

var can_shoot := false

var x: float
var y: float

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
		shoot(Vector2(240,0).rotated($Sprite2D.rotation-PI/2))
	if str(data["joy"]["x"]).is_valid_float():
		x = float(data["joy"]["x"])
	if str(data["joy"]["y"]).is_valid_float():
		y = float(data["joy"]["y"])
	super.update_data(data)

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
	$Pivot/GPUParticles2D.emitting = velocity.length() > 2
	
	if not is_enabled: return
	
	if can_shoot and Input.is_action_just_pressed("shoot"):
		shoot(Vector2(240,0).rotated($Sprite2D.rotation-PI/2))
	
	if Input.is_action_pressed("dash"):
		is_dashing = true
		$DashTimer.start(0.1)
		$DashTimer.timeout.connect(func():
			is_dashing = false
		)
	
	velocity += Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")) * acceleration * (1.15 if is_dashing else 1.0)
	velocity += Vector2(x, y) * acceleration * (1.15 if is_dashing else 1.0)
	if velocity.length() > max_speed * (1.45 if is_dashing else 1.0):
		velocity = velocity.normalized() * max_speed * (1.45 if is_dashing else 1.0)
	velocity = velocity.lerp(Vector2(), 0.02)
	
	$Sprite2D.rotation = velocity.angle() + PI/2
	$CollisionPolygon2D.rotation = velocity.angle() + PI/2
	$Pivot.rotation = velocity.angle() + PI/2
	move_and_slide()
	
	for slide_idx in range(get_slide_collision_count()):
		var col = get_slide_collision(slide_idx)
		var collider = col.get_collider()
		if collider.is_in_group("Ball"):
			collider.apply_central_impulse((collider.global_position - global_position) * 2)


