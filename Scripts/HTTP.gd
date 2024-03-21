extends Node

# http server instance
var server: HttpServer

# http file router instance
var router: HttpFileRouter

# Called when the node enters the scene tree for the first time.
func _ready():
	# instantiate a new http server and router
	server = HttpServer.new()
	router = HttpFileRouter.new("res://web_frontend/index.html")
	
	# register the file router and start the server
	server.register_router("/", router)
	server.start()
	
	# debug prints
	print("running http server at http://" + IP.get_local_addresses()[1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
