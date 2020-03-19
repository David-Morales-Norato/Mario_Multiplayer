extends LineEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var udp = PacketPeerUDP.new()


func _process(delta):
	if !has_focus():
		set_visible(false)
		global.canMove = true
	else:
		var board = get_parent().get_node("chatboard")
		board.time = board.cooldown
		set_visible(true)
	if Input.is_action_just_pressed("ui_accept"):
		if has_focus():
			global.canMove = true
			if len(text) > 0:
				var s = "("+str(global.player)+") "+global.player_name+": "+text
				udp.set_dest_address(global.send_ip,global.send_port)
				var packet = [2,s]
				udp.put_var(packet)
				get_parent().get_node("chatboard").addEntry(s)
			release_focus()
			text = ""
		else:
			global.canMove = false
			grab_focus()

func _exit_tree():
	udp.close()
