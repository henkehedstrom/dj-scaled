extends CharacterBody3D

@export var normal_speed = 0.5
@export var current_speed: float = 0.0
@export var max_speed: float = 4.0
@export var min_speed: float = 0.0
@export var acceleration: float = 1.0

@export var yaw_speed: float = 3.14
@export var yaw: float = 0.0;


@export var max_pitch_speed: float = 3.14
@export var max_yaw_speed: float = 3.14
@export var max_roll_speed: float = 3.14

var rotation_angle: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	current_speed = normal_speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	if Input.is_action_pressed("forward"):
		current_speed += acceleration * delta
		
	if Input.is_action_pressed("back"):
		current_speed -= acceleration * delta
	
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
		
		
	if Input.is_action_pressed("mouse_capture"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	
	current_speed = clamp(current_speed, min_speed, max_speed)
	
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
	rotate(up, local_rotation.z * delta) # Yaw
	rotate(forward, local_rotation.y * delta) # Roll

	
	yaw = 0.0;
	rotation_angle = Vector2.ZERO
	
func _physics_process(_delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	var aim = get_global_transform().basis
	var forward = -aim.z
	move_and_collide(forward * current_speed)
	
func _input(event):
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	if event is InputEventMouseMotion:
		rotation_angle = event.relative
