extends Node

const port1 = 7000
const port2 = 8000
var udp = PacketPeerUDP.new()
var listening = false

func ocultar_menu():
	$banner.hide()
	$menu.hide()
	
func mostrar_menu():
	$banner.show()
	$menu.show()

func _on_crear_partida_pressed():
	$lineEdit_playernick/labe_writenick.show()
	$lineEdit_playernick.show() # Replace with function body.
	$atras.show()
	$crear.show()
	$crear.set_disabled(false)
	ocultar_menu()



func _on_unirse_partida_pressed():
	$lineEdit_playernick/labe_writenick.show()
	$lineEdit_playernick.show()
	$ip_unirse/label_ip_unirse.show()
	$ip_unirse.show()
	$atras.show()
	$unirse.show()
	$unirse.set_disabled(false)
	ocultar_menu()


func _on_salir_pressed():
	get_tree().quit()


func _on_atras_pressed():
	mostrar_menu()
	ocultar_unirse()
	ocultar_crear()
	$atras.hide()
	
func ocultar_unirse():
	$lineEdit_playernick/labe_writenick.hide()
	$lineEdit_playernick.hide()
	$ip_unirse/label_ip_unirse.hide()
	$ip_unirse.hide()
	$unirse.hide()
	$unirse.set_disabled(true)
	
func ocultar_crear():
	$lineEdit_playernick/labe_writenick.hide()
	$lineEdit_playernick.hide()
	$crear.hide()
	$crear.set_disabled(true)


func _on_crear_pressed():
	if len($lineEdit_playernick.text) > 0:
		global.player_name = $lineEdit_playernick.text
		global.send_port= port1
		global.get_port = port2
		listening = true
		global.player = 1
		udp.listen(global.get_port)
		ocultar_crear()
		$atras.hide()
		$lista_espera/player1.text = global.player_name

func _on_unirse_pressed():
	if len($lineEdit_playernick.text) > 0:
		global.player_name = $lineEdit_playernick.text
		global.send_port= port2
		global.get_port = port1
		global.send_ip = $ip_unirse.text
		listening = true
		global.player = 2
		udp.listen(global.get_port)
		ocultar_unirse()
		$atras.hide()

func _process(_delta):
	var iplen = len(global.send_ip)
	if listening:
		$lista_espera/player1.text = "Esperando..."
		if (global.initOK==true and global.peer_initOK==true):
			get_tree().change_scene("res://worlds/world1-1.tscn")
		
		if iplen > 0:
			udp.set_dest_address(global.send_ip,global.send_port)
			var s = [-1,global.player_name,global.initOK]
			udp.put_var(s) 
	if udp.get_available_packet_count() > 0:
		var s = udp.get_var()
		if s.front() == -1:
			global.peer_name=s[1]
			global.initOK = true
			global.peer_initOK = s[2]
			if (iplen == 0):
				global.send_ip = udp.get_packet_ip()


