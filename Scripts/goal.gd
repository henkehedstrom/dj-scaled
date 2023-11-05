extends Node3D

@export var goal_text :String
@onready var pling = $AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var text_object = $Label3D
	text_object.text = goal_text
	
func _on_area_3d_body_entered(body):
	pling.play()
	print("entered")
	pass # Replace with function body.
