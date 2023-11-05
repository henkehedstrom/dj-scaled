extends CharacterBody3D

var speed: float = 0.0
var max_speed: float = 4.0
var min_speed: float = 0.0
var acceleration: float = 1.0
var yaw_speed: float = 3.14
var yaw: float = 0.0;

var max_pitch_speed: float = 3.14
var max_yaw_speed: float = 3.14
var max_roll_speed: float = 3.14

var rotation_angle: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("forward"):
		speed += acceleration * delta
		
	if Input.is_action_pressed("back"):
		speed -= acceleration * delta
	
	if Input.is_action_pressed("right"):
		yaw = -yaw_speed
		
	if Input.is_action_pressed("left"):
		yaw = yaw_speed
		
	if Input.is_action_pressed("roll_right"):
		rotation_angle.x = yaw_speed
		
	if Input.is_action_pressed("roll_left"):
		rotation_angle.x = -yaw_speed
		
	if Input.is_action_pressed("pitch_up"):
		rotation_angle.y = yaw_speed
		
	if Input.is_action_pressed("pitch_down"):
		rotation_angle.y = -yaw_speed
	
	speed = clamp(speed, min_speed, max_speed)
	
	apply_rotation(delta)
	
	pass
	
func apply_rotation(delta: float):
	var aim = get_global_transform().basis
	var right = aim.x.normalized()
	var up = aim.y.normalized()
	var forward = aim.z.normalized()
	
	var local_rotation: Vector3 = Vector3(
		clamp(rotation_angle.y, -max_pitch_speed, max_pitch_speed),
		clamp(yaw, -max_yaw_speed, max_yaw_speed),
		clamp(rotation_angle.x, -max_roll_speed, max_roll_speed))
	
	rotate(right, local_rotation.x * delta) # Pitch
	rotate(up, local_rotation.y * delta) # Yaw
	rotate(forward, local_rotation.z * delta) # Roll
	
	yaw = 0.0;
	rotation_angle = Vector2.ZERO
	
func _physics_process(_delta):
	var aim = get_global_transform().basis
	var forward = -aim.z
	move_and_collide(forward * speed)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation_angle = event.relative
