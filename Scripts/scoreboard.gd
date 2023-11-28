extends Node
@onready var panel:Panel = $Panel
@onready var time_text = $Panel/Time


# Called when the node enters the scene tree for the first time.
func _ready():
	panel.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func show_time(time:int):
	panel.visible = true
	time_text.text = "Time: " + str(time)

func _on_quit_pressed():
	get_tree().quit()
