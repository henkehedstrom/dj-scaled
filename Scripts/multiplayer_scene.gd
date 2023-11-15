extends Node3D

var player = preload("res://fish.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = player.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		if currentPlayer.name == str(multiplayer.get_unique_id()):
			currentPlayer.get_child(1).current = true
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index += 1
	pass # Replace with function body.ody.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
