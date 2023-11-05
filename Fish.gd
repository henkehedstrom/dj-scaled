extends CharacterBody3D

var speed: float = 0.0
var max_speed: float = 4.0
var min_speed: float = 0.0
var acceleration: float = 1.0
var yaw_speed: float = 3.14

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
	
	var yaw: float = 0.0;
	if Input.is_action_pressed("right"):
		yaw = yaw_speed
		
	if Input.is_action_pressed("left"):
		yaw = -yaw_speed
	
	speed = clamp(speed, min_speed, max_speed)
	
	var aim = get_global_transform().basis
	var right = aim.x
	var up = aim.y
	var forward = aim.z
	
	rotate(right, rotation_angle.y * delta) # Pitch
	rotate(forward, rotation_angle.x * delta) # Roll
	rotate(up, yaw * delta) # Yaw
	pass
	
func _physics_process(delta):
	var aim = get_global_transform().basis
	var forward = -aim.z
	move_and_collide(forward * speed)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation_angle = event.relative
