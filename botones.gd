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
	$label_usuario_crear.show()
	$nombre_usuario_crear.show() # Replace with function body.
	$atras.show()
	$crear.show()
	ocultar_menu()



func _on_unirse_partida_pressed():
	$label_usuario_unirse.show()
	$nombre_usuario_unirse.show()
	$label_ip_unirse.show()
	$ip_unirse.show()
	$atras.show()
	$unirse.show()
	ocultar_menu()


func _on_salir_pressed():
	get_tree().quit()


func _on_atras_pressed():
	mostrar_menu()
	ocultar_unirse()
	ocultar_crear()
	$atras.hide()
	
func ocultar_unirse():
	$label_usuario_unirse.hide()
	$nombre_usuario_unirse.hide()
	$label_ip_unirse.hide()
	$ip_unirse.hide()
	$unirse.hide()
	
func ocultar_crear():
	$label_usuario_crear.hide()
	$nombre_usuario_crear.hide()
	$crear.hide()


func _on_crear_pressed():
	global.send_port= port1
	global.get_port = port2
	listening = true
	udp.listen(global.get_port)
	ocultar_crear()
	$atras.hide()
	global.nombre_1 = $nombre_usuario_crear.text
	$lista_espera/player1.text = global.nombre_1
	

func _on_unirse_pressed():
	global.send_port= port2
	global.get_port = port1
	listening = true
	udp.listen(global.get_port)
	ocultar_unirse()
	$atras.hide()
	global.nombre_2 = $nombre_usuario_unirse.text

func _process(_delta):
	if listening:
		udp.set_dest_address(global.send_ip,global.send_port)
		var s = "a"
		udp.put_packet(s.to_ascii()) 
	if udp.get_available_packet_count() > 0:
		udp.get_packet()
		$lista_espera/player2.text = global.nombre_2
		get_tree().change_scene("res://World.tscn")


