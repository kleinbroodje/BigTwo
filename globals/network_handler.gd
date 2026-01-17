extends Node

signal start_game

const IP_ADDRESS: String = "192.168.2.28"
const PORT: int = 6767
const MAX_CONNECTIONS: int = 2

var peer: ENetMultiplayerPeer

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CONNECTIONS)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	print("Server started")
	
func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer

func _on_peer_connected(_id: int) -> void:
	if multiplayer.is_server():
		if multiplayer.get_peers().size() == MAX_CONNECTIONS:
			emit_signal("start_game")
	
func _on_peer_disconnected(id: int) -> void:
	print("Player %d left" % id)
