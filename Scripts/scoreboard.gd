extends Node
@onready var panel:Panel = $Panel
@onready var time_text = $Panel/Time
var scene = preload("res://Scenes/raceTest.tscn") 


# Called when the node enters the scene tree for the first time.
func _ready():
	panel.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func show_time(time:float):
	panel.visible = true
	time_text.text = "Time: " + str(time).pad_decimals(3)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	

func _on_quit_pressed():
	get_tree().quit()


func _on_restart_pressed():
		get_tree().change_scene_to_packed(scene)

