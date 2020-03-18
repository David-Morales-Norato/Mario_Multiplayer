extends KinematicBody2D
const UPVECTOR = Vector2(0,-1)
const GRAVITY = 15
const hs = 180

var motion = Vector2()
var dir = 0
var udp = PacketPeerUDP.new()

var canMove = true
# const CoinResource = preload("res://instances/rotating_coin/Rotating_coin.tscn")

func _ready():
	var path = "res://spr/luigi/spr_small_luigi.tscn"
	if global.player==2:
		path = "res://spr/mario/spr_small_mario.tscn"
	var spr_scn = load(path)
	var spr = spr_scn.instance()
	add_child(spr)
	collision_layer = 2
	udp.listen(global.get_port)

func _physics_process(delta):
	if udp.get_available_packet_count() > 0:
		var packet = udp.get_var()
		if packet.front() == 0: #mario status
			set_global_position(packet[1])
			dir = packet[2]
			motion = packet[3]
	motion.y+=GRAVITY
	
	if !is_on_floor():
		dir = 0
	
	if !canMove:
		dir = 1
		motion.x = hs/2
		if !is_on_floor():
			motion.x = 0
			motion.y = hs/2
	
	if dir == 1:
		$sprites.flip_h = false
	if dir ==-1:
		$sprites.flip_h = true

	if is_on_floor():
		if dir != 0:
			$sprites.play("run")
		else:
			$sprites.play("idle")
	else:
		if canMove == true:
			$sprites.play("jump")
		else:
			$sprites.play("pole")
	motion = move_and_slide(motion,UPVECTOR)
