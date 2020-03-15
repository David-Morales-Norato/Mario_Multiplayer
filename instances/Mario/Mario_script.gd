extends KinematicBody2D
const UPVECTOR = Vector2(0,-1)
const GRAVITY = 15*3
const JUMP_POWER = 360*3
var motion = Vector2()
const hs = 180*3
const accel = 20*3
const MAX_JUMP_LENIENCY = 5*3
var FRICTION = 0.4*3
var jumpLeniency = 0
var dir = 0
var udp = PacketPeerUDP.new()

func _ready():
	collision_layer = 2

func _physics_process(delta):
	motion.y+=GRAVITY
	dir = 0
	if is_on_floor():
		FRICTION = 0.5
	else:
		FRICTION = 0.9

	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://world2.tscn")

	if Input.is_action_pressed("ui_right"):
		var multiplier = 1
		if motion.x < 0:
			if is_on_floor():
				multiplier = 2
			else:
				multiplier = 0.5
		motion.x += accel*multiplier
		dir = 1
	elif Input.is_action_pressed("ui_left"):
		var multiplier = 1
		if motion.x < 0:
			if is_on_floor():
				multiplier = 2
			else:
				multiplier = 0.5
		motion.x -= accel*multiplier
		dir =-1
	else:
		motion.x*=FRICTION
	if abs(motion.x) <= 0.3:
		motion.x = 0
	motion.x = clamp(motion.x,-hs,hs)

	if  Input.is_action_just_pressed("ui_up"):
		jumpLeniency = MAX_JUMP_LENIENCY

	if is_on_floor() and jumpLeniency > 0:
		motion.y = -JUMP_POWER
		jumpLeniency = 0
	if jumpLeniency > 0:
		jumpLeniency-=1
	if !is_on_floor() and motion.y < 0 and !Input.is_action_pressed("ui_up"):
		motion.y*=0.7
	motion = move_and_slide(motion,UPVECTOR)

	if !is_on_floor():
		dir = 0

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
		$sprites.play("jump")
	
	udp.set_dest_address(global.send_ip,global.send_port)
	var packet = [0,get_global_position(),dir,motion] #mario status
	udp.put_var(packet)
