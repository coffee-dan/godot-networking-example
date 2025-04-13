extends Node

var peer = ENetMultiplayerPeer.new()

func _on_host_pressed():
	peer.create_server(25565)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer " + str(pid) + " has joined the game!")
	)

func _on_join_pressed():
	peer.create_client("localhost", 25565)
	multiplayer.multiplayer_peer = peer
