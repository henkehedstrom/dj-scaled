extends Node

var current_time:float 
var _is_started:bool
@export var goal_manager :Node
@export var scoreboard: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	if goal_manager:
		goal_manager.win.connect(on_win)
	else:
		print("GOAL MANAGER DOES NOT EXIST!")
	reset()
	start()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _is_started:
		current_time += delta
	pass
	
func on_win(id:int):
	pause()
	print("Player with id cleared the track in " + str(current_time) + " seconds!")
	if scoreboard:
		scoreboard.show_time(current_time)
	
	

func start():
	_is_started = true

func pause():
	_is_started = false

func reset():
	current_time = 0.0
