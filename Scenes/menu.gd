extends Node3D

var solo_play_scene : PackedScene = preload("res://level.tscn")
var multiplayer_scene : PackedScene = preload("res://Scenes/Levels/multiplayer_scene.tscn") #TODO change when multiplayer has its own scene :)

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
	print("started server" + "I am host: " + str(i_am_host))
	_show_menu(lobby_menu)


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

	
	_show_menu(lobby_menu)

func _on_player_connected(id : int):
	_register_player.rpc_id(id, player_info)

@rpc("any_peer", "reliable")
func _host_announce():
	var item_list = $LobbyControl/ConnectedPlayers
	var host_index = item_list.add_item("Host")
	item_list.set_item_custom_fg_color(host_index, Color.GOLD)

@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	new_player_info.id = new_player_id
	player_connected.emit(new_player_id, new_player_info)
	$LobbyControl/ConnectedPlayers.add_item(new_player_info.name + str(new_player_id))
	print("client connected" + " I am host: " + str(i_am_host))
	_add_to_players.rpc(new_player_info.name,new_player_id)
	
	if multiplayer.get_unique_id() == 1:
		_host_announce.rpc_id(new_player_id)
			

func _on_options_button_pressed():
	_show_menu(options_menu)

@rpc("any_peer")
func _add_to_players(name,id):
	print("attempting adding player with name: " + name + "and id" + str(id) + "I am host: " + str(i_am_host))
	if !GameManager.Players.has(id):
		print("adding player with name: " + name + "and id" + str(id) + "I am host: " + str(i_am_host))
		GameManager.Players[id]={
			"name": name,
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
	_change_scene(multiplayer_scene)
