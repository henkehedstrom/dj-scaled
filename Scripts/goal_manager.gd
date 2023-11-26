extends Node


@onready var goals: Array = get_children()
var currentIndex: int = 0
signal win


# Called when the node enters the scene tree for the first time.
func _ready():
	print(goals)
	goals[0].set_current()
	for goal in goals:
		goal.set_goalmanager(self)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func next():
	if currentIndex + 1 < goals.size():
		currentIndex+= 1
		goals[currentIndex].set_current()
	else:
		if GameManager.is_multiplayer:
			win.emit(multiplayer.get_unique_id())
		else:
			win.emit(0)
