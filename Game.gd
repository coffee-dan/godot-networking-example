extends Node

@onready var multiplayer_ui = $UI/Multiplayer

const HOST_START_POS = Vector2(78.0, 62.0)
const CLIENT_START_POS = Vector2(192.0, 62.0)
const PORT = 25565
const PLAYER = preload("res://player/player.tscn")

var peer = ENetMultiplayerPeer.new()
var players: Array[Player] = []

func _ready():
	$MultiplayerSpawner.spawn_function = add_player

func _on_host_pressed():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer " + str(pid) + " has joined the game!")
			$MultiplayerSpawner.spawn(pid)
	)
	
	$MultiplayerSpawner.spawn(multiplayer.get_unique_id())
	multiplayer_ui.hide()

func _on_join_pressed():
	peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer_ui.hide()

func add_player(pid : int):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	player.global_position = $Level.get_child(players.size()).global_position
	players.append(player)
	return player
