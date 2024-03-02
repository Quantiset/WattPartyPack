extends Node

@export var websocket_url = "wss://libwebsockets.org"

var _client := WebSocketMultiplayerPeer.new()

func _ready():
	return
	
	_client.connection_closed.connect(_closed)
	_client.connection_error.connect(_closed)
	_client.connection_established.connect(_connected)
	_client.data_received.connect(_on_data)

	var err = _client.connect_to_url(websocket_url, ["lws-mirror-protocol"])
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	print("Connected with protocol: ", proto)
	_client.get_peer(1).put_packet("Test packet".to_utf8_buffer())

func _on_data():
	print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())

func _process(delta):
	_client.poll()
