extends Node3D

var fish 
var capture_mode:bool = true
var inverse_x = false
var inverse_y = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass # Replace with function body.


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("forward"):
		fish.current_speed += fish.acceleration * delta 
		
	if Input.is_action_pressed("back"):
		fish.current_speed -= fish.acceleration * delta
	
	if Input.is_action_pressed("right"):
		fish.yaw = -fish.yaw_speed 

	if Input.is_action_pressed("left"):
		fish.yaw = fish.yaw_speed 

	if Input.is_action_pressed("roll_right"):
		fish.rotation_angle.x = fish.yaw_speed

	if Input.is_action_pressed("roll_left"):
		fish.rotation_angle.x = -fish.yaw_speed

	if Input.is_action_pressed("pitch_up"):
		fish.rotation_angle.y = fish.yaw_speed

	if Input.is_action_pressed("pitch_down"):
		fish.rotation_angle.y = -fish.yaw_speed 
		
	if Input.is_action_just_pressed("mouse_capture"):
		capture_mode = !capture_mode
		if capture_mode:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	
	fish.current_speed = clamp(fish.current_speed, fish.min_speed, fish.max_speed)
	
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		fish.rotation_angle = event.relative
		

