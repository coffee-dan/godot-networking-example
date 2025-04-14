extends Node

@onready var multiplayer_ui = $UI/Multiplayer

const HOST_START_POS = Vector2(78.0, 62.0)
const CLIENT_START_POS = Vector2(192.0, 62.0)
const PORT = 25565
const PLAYER = preload("res://player/player.tscn")

var peer = ENetMultiplayerPeer.new()

func _on_host_pressed():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer " + str(pid) + " has joined the game!")
			add_player(pid, CLIENT_START_POS)
	)
	
	add_player(multiplayer.get_unique_id(), HOST_START_POS)
	multiplayer_ui.hide()

func _on_join_pressed():
	peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer_ui.hide()

func add_player(pid : int, pos : Vector2):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	player.position = pos
	add_child(player)
	return player
