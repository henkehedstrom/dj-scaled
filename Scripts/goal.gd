extends Node3D

@onready var pling = $AudioStreamPlayer3D
var current_goal = false

var green_material = preload("res://Materials/ring_material_green.tres")
var red_material = preload("res://Materials/ring_material_red.tres")
var blue_material = preload("res://Materials/ring_material_blue.tres")

var goal_manager 

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_color(red_material)

func set_goalmanager(manager):
	goal_manager = manager

func set_current():
	current_goal = true
	_set_color(green_material)

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D && (!GameManager.is_multiplayer || body.name == str(multiplayer.get_unique_id())): #TODO better check for player?
		if current_goal:
			pling.play()
			_set_color(blue_material)
			current_goal = false
			goal_manager.next()

func _set_color(material):
	if $ring:
		var mesh = $ring.get_child(0)
		mesh.material_override = material
