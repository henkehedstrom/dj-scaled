extends Node3D

@export var goal_number :String
@onready var pling = $AudioStreamPlayer3D
var current_goal = false
@onready var text_object = $Label3D

var green_material = preload("res://Materials/ring_material_green.tres")
var red_material = preload("res://Materials/ring_material_red.tres")
var blue_material = preload("res://Materials/ring_material_blue.tres")


var goal_manager 

# Called when the node enters the scene tree for the first time.
func _ready():
	text_object.text = goal_number
	_set_color(Color(1,0,0), red_material)


func set_goalmanager(manager):
	goal_manager = manager

func set_current():	
	current_goal = true
	_set_color(Color(0,1,0), green_material)
	
func _on_area_3d_body_entered(body):
	if body is CharacterBody3D && (!GameManager.is_multiplayer || body.name == str(multiplayer.get_unique_id())): #TODO better check for player?
		if current_goal:
			pling.play()
			print("entered" + self.name)
			_set_color(Color(0,0,1), blue_material)
			current_goal = false
			goal_manager.next()
			
	
func _set_color(color:Color, material):
	text_object.set_modulate(color)
	if $ring:
		print("ring exists")
		var mesh = $ring.get_child(0)
		mesh.material_override = material



	
		

