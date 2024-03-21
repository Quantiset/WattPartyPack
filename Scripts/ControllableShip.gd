extends Ship
class_name ControllableShip

@export var team := 0

@export var acceleration = 15
@export var max_speed = 250
@export var dash_speed_scale := 1.6
@export var dash_acc_scale := 1.25
@export var dash_push_scale := 2.0

var can_shoot := false
var bounces := 0
var shots := 1

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

func shoot(dir_ = Vector2(240,0), shots_override = false):
	var shots_this = shots
	if shots_override:
		shots_this = 1
	for i in range(shots_this):
		var b = preload("res://Scenes/Bullet.tscn").instantiate()
		b.position = position
		b.velocity = dir_.rotated( (0 if shots_this == 1 else -PI/8)+(0.25*i*PI/shots_this) )
		b.bounces = bounces
		b.emitter = self
		get_parent().call_deferred("add_child", b)

func take_damage():
	disable()
	dead.emit()
	position.x = 10000

func _physics_process(delta):
	print(is_dashing)
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
	velocity += Vector2(x, y) * acceleration * (dash_acc_scale if is_dashing else 1.0)
	if velocity.length() > max_speed * (dash_speed_scale if is_dashing else 1.0):
		velocity = velocity.normalized() * max_speed * (dash_speed_scale if is_dashing else 1.0)
	velocity = velocity.lerp(Vector2(), 0.02)
	
	$Sprite2D.rotation = velocity.angle() + PI/2
	$CollisionPolygon2D.rotation = velocity.angle() + PI/2
	$Pivot.rotation = velocity.angle() + PI/2
	move_and_slide()
	
	for slide_idx in range(get_slide_collision_count()):
		var col = get_slide_collision(slide_idx)
		var collider = col.get_collider()
		if collider.is_in_group("Ball"):
			velocity -= (collider.global_position - global_position) * 2
			print(collider.global_position - global_position)
			collider.apply_central_impulse((collider.global_position - global_position) * 2 * (dash_push_scale if is_dashing else 1))


