extends Node

@export var websocket_url = "ws://watt-party-pack.in-my-ellement.partykit.dev/party/my-new-room"

var socket := WebSocketPeer.new()

var id_to_player := {}
var id_to_scores := {}

var queued_scenes := []

signal client_connected(data)

func _ready():
	randomize()
	socket.connect_to_url(websocket_url)

func register_player(id: String, player):
	print(id, id_to_player)
	id_to_player[id] = player

func parse_data(data: Dictionary):
	if data.id in id_to_player and is_instance_valid(id_to_player[data.id]):
		id_to_player[data.id].update_data(data)
	else:
		client_connected.emit(data)

func _process(delta):
	socket.poll()
	var state = socket.get_ready_state()
	print(state)
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var str = ""
			for ascii_val in socket.get_packet():
				str += char(ascii_val)
			var json = JSON.new()
			json.parse(str)
			var error = json.parse(str)
			if error == OK:
				var data_received = json.data
				if typeof(data_received) == TYPE_DICTIONARY:
					parse_data(data_received)
				else:
					print("Unexpected data")
			else:
				print("JSON Parse Error: ", json.get_error_message(), " in ", str, " at line ", json.get_error_line())
	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing.

func next_scene():
	print(queued_scenes)
	if queued_scenes.size() == 0:
		get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	else:
		var path = queued_scenes.pop_at(0)
		get_tree().change_scene_to_file(path)
