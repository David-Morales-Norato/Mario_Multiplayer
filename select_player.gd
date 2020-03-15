extends MenuButton

const port1 = 7000
const port2 = 8000
var popup
var udp = PacketPeerUDP.new()
var listening = false

func _ready():
	pass # Replace with function body.



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
