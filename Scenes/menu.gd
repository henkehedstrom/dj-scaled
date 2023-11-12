extends Node3D

var solo_play_scene : PackedScene = preload("res://level.tscn")
var player_info = {"name": "Name", "id": -1}

signal player_connected(peer_id, player_info)

func _ready():
	$Camera3D.current = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	$Control.visible = true
	$MultiplayerControl.visible = false
	$LobbyControl.visible = false
	pass


func _on_solo_play_button_pressed():
	_change_scene(solo_play_scene)


func _on_quit_game_button_pressed():
	_quit_game()


func _change_scene(change_to_scene : PackedScene):
	var root = get_tree().root
	var level = root.get_children()[0]
	root.remove_child(level)
	
	var new_scene = change_to_scene.instantiate()
	root.add_child(new_scene)
	pass


func _quit_game():
	get_tree().quit()


func _on_multiplayer_button_pressed():
	$Control.visible = false
	$MultiplayerControl.visible = true


func _on_host_game_button_pressed():
	var peer = ENetMultiplayerPeer.new()
	if (peer.create_server(25567, 5) == null):
		print("failed to create server")
		pass
	
	multiplayer.multiplayer_peer = peer
	print("started server")
	$MultiplayerControl.visible = false
	$LobbyControl.visible = true


func _on_join_game_button_pressed():
	$MultiplayerControl/JoinGameButton.disabled = true
	var peer = ENetMultiplayerPeer.new()
	
	var ip : String = $MultiplayerControl/IpAddressLineEdit.text
	
	var connect_result : Error = peer.create_client(ip, 25567)
	
	if connect_result != Error.OK:
		print("Failed to connect to server")
		$MultiplayerControl/JoinGameButton.disabled = false
		return
	
	multiplayer.multiplayer_peer = peer
	print("started client")
	multiplayer.peer_connected.connect(_on_player_connected)
	
	$MultiplayerControl.visible = false
	$LobbyControl.visible = true
	$LobbyControl/StartGameButton.visible = false

func _on_player_connected(id : int):
	_register_player.rpc_id(id, player_info)

@rpc("any_peer", "reliable")
func _host_announce():
	var item_list = $LobbyControl/ConnectedPlayers
	var host_index = item_list.add_item("Host")
	item_list.set_item_custom_fg_color(host_index, Color.GOLD)
	pass

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	new_player_info.id = new_player_id
	player_connected.emit(new_player_id, new_player_info)
	$LobbyControl/ConnectedPlayers.add_item(new_player_info.name + str(new_player_id))
	print("client connected")
	
	if multiplayer.get_unique_id() == 1:
		_host_announce.rpc_id(new_player_id)
