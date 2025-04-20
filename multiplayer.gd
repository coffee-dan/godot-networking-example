extends Node

signal noray_connected

const NETWORK_STRATEGY = "noray"
const NORAY_ADDRESS = "tomfol.io"
const NORAY_PORT = 8890
const LOCALHOST_PORT = 25565

var is_host := false
var external_oid := ""

# Overall attempting to use NAT punchthrough, if that is not available use relay
# server to coordinate multiplayer

func using_noray() -> bool:
	return NETWORK_STRATEGY == "noray"

func _ready() -> void:
	if using_noray():
		print("Setting up for Noray...")
		Noray.on_connect_to_host.connect(on_noray_connected)
		Noray.on_connect_nat.connect(handle_nat_connection)
		Noray.on_connect_relay.connect(handle_relay_connection)

		Noray.connect_to_host(NORAY_ADDRESS, NORAY_PORT)
	else:
		pass

func on_noray_connected() -> void:
	print("Connected to Noray server")
	Noray.register_host()
	await Noray.on_pid
	await Noray.register_remote()
	noray_connected.emit()

func host() -> void:
	print("Hosting...")
	var peer = ENetMultiplayerPeer.new()
	var port: int = Noray.local_port if using_noray() else LOCALHOST_PORT

	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	is_host = true

# oid is effectively the lobby code
func join(oid: String = "") -> void:
	if using_noray():
		assert(oid.length() > 0)
		Noray.connect_nat(oid)
		external_oid = oid
	else:
		var peer = ENetMultiplayerPeer.new()
		peer.create_client("localhost", LOCALHOST_PORT)
		multiplayer.multiplayer_peer = peer

func handle_nat_connection(address: String, port: int) -> Error:
	var err = await connect_to_server(address, port)

	if err != OK && !is_host:
		print("NAT failed, using relay...")
		Noray.connect_relay(external_oid)
		err = OK

	return err

func connect_to_server(address: String, port: int) -> Error:
	var err = OK

	if !is_host:
		var udp = PacketPeerUDP.new()
		udp.bind(Noray.local_port)
		udp.set_dest_address(address, port)

		err = await PacketHandshake.over_packet_peer(udp)
		udp.close()

		if err != OK:
			if err != ERR_BUSY:
				print("Handshake failed")
				return err
		else:
			print("Handshake success")

		var peer = ENetMultiplayerPeer.new()
		err = peer.create_client(address, port, 0, 0, 0, Noray.local_port)

		if err != OK:
			return err

		multiplayer.multiplayer_peer = peer
		return OK
	else:
		err = await PacketHandshake.over_enet(
			multiplayer.multiplayer_peer.host, address, port
		)

	return err

func handle_relay_connection(address: String, port: int) -> Error:
	return await connect_to_server(address, port)
