extends Node

var udp = PacketPeerUDP.new()

func _ready():
	udp.listen(global.get_port)

func _physics_process(_delta):
	if udp.get_available_packet_count() > 0:
		var packet = udp.get_var()
		if packet.front() == 2: # chat msg
			var chatboard = get_parent().get_node("camera/chatbox/chatboard")
			if chatboard!=null:
				chatboard.addEntry(packet[1])

		
		
		if packet.front() == 0: #mario movement
			var fakeMario = get_parent().get_node(global.fake_mario)
			if fakeMario !=null:
				fakeMario.set_global_position(packet[1])
				fakeMario.dir = packet[2]
				fakeMario.motion = packet[3]


func _exit_tree():
	udp.close()
