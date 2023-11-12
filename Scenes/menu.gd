extends Node3D

var solo_play_scene : PackedScene = preload("res://level.tscn")

func _ready():
	$Camera3D.current = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass


func _on_solo_play_button_pressed():
	_change_scene(solo_play_scene)


func _change_scene(change_to_scene : PackedScene):
	var root = get_tree().root
	var level = root.get_children()[0]
	root.remove_child(level)
	
	var new_scene = change_to_scene.instantiate()
	root.add_child(new_scene)
	pass

func _quit_game():
	get_tree().quit()
