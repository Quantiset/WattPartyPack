extends RigidBody2D

@export var line_length = 60
@export var line_width = 10

@onready var line: Line2D = $Line2D

var init_vel := Vector2(20,10)*5

var reset_state := Vector2()
	
func _integrate_forces(state):
	if reset_state.length() > 0:
		state.transform = Transform2D(0.0, reset_state)
		reset_state = Vector2()
		linear_velocity = Vector2()
		line.clear_points()

func _ready():
	$Line2D.width = line_width
	apply_central_impulse(init_vel)

func _process(delta):
	line.add_point(position)
	if line.get_point_count() > line_length:
		line.remove_point(0)

func set_pos(val):
	reset_state = val
