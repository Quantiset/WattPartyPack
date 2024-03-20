extends Node

# port for websocket server
const PORT = 9080

# instance of the websocket server and the tcp it is hosted on
var tcp = TCPServer.new() 
var ws = WebSocketPeer.new()

# maintain a map of ids to players
var players := {}

# map of player ids to their scores
var scores := {}

# current num being used for name
var curr_name = 1

# let the other scripts know when a new player has joined
signal client_connected(data)

# called when a new player is discovered
func register_player(player: Dictionary):
	if !players.has(player.id) and player.has("id"):
		# check if this player sent a name
		if !player.has("name"):
			# add a number for their name
			player["name"] = curr_name
			curr_name += 1
		
		# add this player to the list of current players
		players[player.id] = player
		
		# set their score to zero
		scores[player.id] = 0
		
		# debug print
		print("new player " + str(player.name) + " with id " + str(player.id))
	else:
		print("unrecognized new player packet")

# Called when the node enters the scene tree for the first time.
func _ready():
	# run the tcp server on the given port
	if tcp.listen(PORT) != OK:
		# prevents _process from being called if server doesn't start
		print("error starting server")
		set_process(false)
		
	# print out the server ip
	print("running ws server at ws://" + IP.get_local_addresses()[1] + ":" + str(tcp.get_local_port()))

# called from inside _process when receiving new packets
func _recv(data):
	# instantiate a json object from packet data
	var json = JSON.new()
	var err = json.parse(data)
	
	# check for errors in json parsing
	if err == OK and typeof(json.data) == TYPE_DICTIONARY:
		# make a player object from this
		var player = json.data
		
		# register a new player if they havent been seen yet
		if !players.has("id"):
			# add this player to the list of current players
			register_player(player)
			
			# emit the signal for a new player
			client_connected.emit(player)
		else:
			# update to an existing player
			players[player.id].update_data(player, true)
	else:
		print("Unexpected packet: " + data)
		
		# print out json parsing errors
		if err != OK: print("JSON parse error: " + json.get_error_message())

# called each frame
func _process(delta):
	# accept incoming connections over tcp
	while tcp.is_connection_available():
		# get this connection
		var conn: StreamPeerTCP = tcp.take_connection()
		
		# pass it to the websocket server
		if (conn != null): ws.accept_stream(conn)
	
	# update the websockets
	ws.poll()
	
	# if the ws connection is open, read in new packets
	if ws.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while ws.get_available_packet_count():
			# process stringified packet using a diff function
			_recv(ws.get_packet().get_string_from_ascii())
