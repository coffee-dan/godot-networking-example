extends Node

func _ready():
	# Create client.
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer

	# Create server.
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(4000, 4)
	multiplayer.multiplayer_peer = peer
		
