extends Node3D

var solo_play_scene : PackedScene = preload("res://Scenes/raceTest.tscn")
var multiplayer_scene : PackedScene = preload("res://Scenes/raceTest.tscn") 

var player_info = {"name": "Name", "id": -1}

signal player_connected(peer_id, player_info)

@onready var main_menu :Control = $MainMenuControl
@onready var multiplayer_menu: Control = $MultiplayerControl
@onready var options_menu: Control  = $OptionsControl
@onready var lobby_menu: Control = $LobbyControl

var back = null
var current_menu = main_menu
@onready var quit_or_back_button = $QuitOrBackGameButton

var i_am_host :bool = false


func _ready():
	$Camera3D.current = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_show_menu(main_menu)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.peer_connected.connect(_on_player_connected)
	pass


func _on_solo_play_button_pressed():
	_add_to_players("Solo",0)
	_change_scene(solo_play_scene)


func connected_to_server():
	print("Connected to Server!" + "I am host: " + str(i_am_host))
	_add_to_players.rpc_id(1,"client", multiplayer.get_unique_id())
	

func connection_failed():
	print("Couldn't connect!")

func _on_quit_game_button_pressed():
	if back == null:	
		_quit_game()
	else:
		_show_menu(back)
	
func _change_scene(change_to_scene : PackedScene):
	get_tree().change_scene_to_packed(change_to_scene)
	pass

func _quit_game():
	get_tree().quit()
	pass


func _on_multiplayer_button_pressed():
	_show_menu(multiplayer_menu)


func _on_host_game_button_pressed():
	var peer = ENetMultiplayerPeer.new()
	if (peer.create_server(25567, 5) == null):
		print("failed to create server")
		pass
	
	multiplayer.multiplayer_peer = peer
	i_am_host = true
	_show_menu(lobby_menu)
	add_self()


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
	print("started client" + "I am host: " + str(i_am_host))

	add_self()
	_show_menu(lobby_menu)

func _on_player_connected(id : int):
	print("Player connected " + str(id))
	_register_player.rpc_id(id, $MultiplayerControl/NameLineEdit.text)


@rpc("any_peer", "reliable")
func _register_player(registered_name : String):
	var new_player_id = multiplayer.get_remote_sender_id()
	
	$LobbyControl/ConnectedPlayers.add_item(registered_name)
	print("client connected" + " I am host: " + str(i_am_host))
	
	_add_to_players.rpc(registered_name, new_player_id)

func _on_options_button_pressed():
	_show_menu(options_menu)

@rpc("any_peer")
func _add_to_players(local_name, id):
	print("attempting adding player with name: " + local_name + "and id" + str(id) + "I am host: " + str(i_am_host))
	if !GameManager.Players.has(id):
		print("adding player with name: " + local_name + "and id" + str(id) + "I am host: " + str(i_am_host))
		GameManager.Players[id]={
			"name": local_name,
			 "id": id}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			_add_to_players.rpc(GameManager.Players[i].name,i)
	
func _show_menu(menu:Control):
	back = menu.back_menu
	_make_all_menus_invisible()
	if menu == main_menu:
		quit_or_back_button.text = "Quit"
	else:
		quit_or_back_button.text = "Back"
	menu.visible = true

func _make_all_menus_invisible():
	main_menu.visible = false
	multiplayer_menu.visible = false
	options_menu.visible = false
	lobby_menu.visible = false

func _on_start_game_button_pressed():
	#TODO: add check that at least one player should have joined?
	#TODO: ready system? all players have to be ready before starting?
	_start_multiplayer_game.rpc()
	pass # Replace with function body.

@rpc("any_peer","call_local")
func _start_multiplayer_game():
	GameManager.is_multiplayer = true
	_change_scene(multiplayer_scene)

func add_self():
	var item_list = $LobbyControl/ConnectedPlayers
	var host_index = item_list.add_item($MultiplayerControl/NameLineEdit.text)
	item_list.set_item_custom_fg_color(host_index, Color.GOLD)

func _on_invert_y_axis_checkbox_toggled(button_pressed):
	GameManager.y_inverse = button_pressed
	GameManager.settings_changed.emit()
	print("set y inverse to " + str(button_pressed))
	pass # Replace with function body.


func _on_invert_x_axis_checkbox_toggled(button_pressed):
	GameManager.x_inverse = button_pressed
	GameManager.settings_changed.emit()
	print("set x inverse to "+ str(button_pressed))
	
	pass # Replace with function body.
