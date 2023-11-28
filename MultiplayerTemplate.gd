extends Node


var player = preload("res://fish.tscn")
var input_manager = preload("res://Scripts/input_manager.tscn")
@export var spawn_position:Node
@export var goal_manager:Node




# Called when the node enters the scene tree for the first time.
func _ready():
	var spawn_positions = spawn_position.get_children()
	
	
	var index = 0
	
	for i in GameManager.Players:
		var currentPlayer = player.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		if currentPlayer.name == str(multiplayer.get_unique_id()):
			currentPlayer.get_child(1).current = true
			var input = input_manager.instantiate()
			add_child(input)
			input.fish = currentPlayer
			currentPlayer.goal_manager = goal_manager
		add_child(currentPlayer)
		
		for spawn in spawn_positions:
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index += 1
	pass # Replace with function body.ody.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
