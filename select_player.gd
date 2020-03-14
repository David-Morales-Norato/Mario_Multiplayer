extends MenuButton

const port1 = 7000
const port2 = 8000
var popup
var udp = PacketPeerUDP.new()
var listening = false

func _ready():
	popup = get_popup()
	popup.add_item("Player 1")
	popup.add_item("Player 2")
	popup.connect("id_pressed",self,"_option_pressed")
	pass # Replace with function body.

func _option_pressed(ID):
	_set_global_position(Vector2(-100,-100))
	var line = get_parent().get_node("LineEdit")
	var label = get_parent().get_node("Label")
	if line!=null:
		line.queue_free()
	if label!=null:
		label.text = "Waiting for the other player..."
	print("Starting game as Player "+str(1+ID))
	if (ID == 0): #Player 1
		global.send_port = port1
		global.get_port = port2
	if (ID == 1): #Player 2
		global.send_port = port2
		global.get_port = port1
	listening = true
	udp.listen(global.get_port)

func _process(_delta):
	if listening:
		udp.set_dest_address(global.send_ip,global.send_port)
		var s = "a"
		udp.put_packet(s.to_ascii()) 
	if udp.get_available_packet_count() > 0:
		udp.get_packet()
		get_tree().change_scene("res://World.tscn")

func _exit_tree():
	udp.close()
