extends Node

const IP_ADDRESS: String = "localhost"
const PORT: int = 6767
const MAX_CONNECTIONS: int = 3

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

func _on_peer_connected(id: int) -> void:
	print("Player %d joined" % id)
	
func _on_peer_disconnected(id: int) -> void:
	print("Player %d left" % id)
	
