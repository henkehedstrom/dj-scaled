extends Node3D

@export var goal_number :String
@onready var pling = $AudioStreamPlayer3D
var current_goal = false
@onready var text_object = $Label3D

var goal_manager 

# Called when the node enters the scene tree for the first time.
func _ready():
	text_object.text = goal_number
	text_object.set_modulate(Color(1,0,0))

func set_goalmanager(manager):
	goal_manager = manager

func set_current():	
	current_goal = true
	text_object.set_modulate(Color(0,1,0))
	


func _on_area_3d_body_entered(body):
	if body is CharacterBody3D: #TODO better check for player?
		if current_goal:
			pling.play()
			print("entered" + self.name)
			text_object.set_modulate(Color(0,0,1))
			current_goal = false
			goal_manager.next()
		

