extends CharacterBody3D

var input_manager = preload("res://Scripts/input_manager.tscn")

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
var goal_manager

var inverse_x : bool 
var inverse_y : bool 

# Called when the node enters the scene tree for the first time.
func _ready():
	on_settings_changed()
	GameManager.settings_changed.connect(on_settings_changed)

	if goal_manager:
		goal_manager.win.connect(on_win)

	if !GameManager.is_multiplayer:
		var input = input_manager.instantiate()
		add_child(input)
		input.fish = self
	else:
		$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
		
	current_speed = normal_speed
	pass # Replace with function body.


func on_win(id:int):
	print("The fish that won has id " + str(id) + " you are " + str(multiplayer.get_unique_id()))
	on_win_internal.rpc(id)
	print("You won!")

@rpc("any_peer", "call_local")
func on_win_internal(id:int):
	if str(id) == name:
		get_parent().remove_child(self)
		print("destroyed fish")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id() && GameManager.is_multiplayer:
		return
		
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
	var test = get_inverse(inverse_x)
	rotate(right, local_rotation.x * delta * get_inverse(inverse_y)) # Pitch
	rotate(up, local_rotation.z * delta * get_inverse(inverse_x)) # Yaw
	rotate(forward, local_rotation.y * delta) # Roll

	
	yaw = 0.0;
	rotation_angle = Vector2.ZERO
	
func _physics_process(_delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() != multiplayer.get_unique_id() && GameManager.is_multiplayer:
		return
	var aim = get_global_transform().basis
	var forward = -aim.z
	move_and_collide(forward * current_speed)
	

func on_settings_changed():
	inverse_x = GameManager.x_inverse
	inverse_y = GameManager.y_inverse
	print("Settings changed")

func get_inverse(inverse):
	return int(inverse) if int(inverse) > 0 else -1 
