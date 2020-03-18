extends KinematicBody2D
const UPVECTOR = Vector2(0,-1)
const GRAVITY = 15
const JUMP_POWER = 360
var motion = Vector2()
const hs = 180
const accel = 20
const MAX_JUMP_LENIENCY = 5
var FRICTION = 0.4
var jumpLeniency = 0
var dir = 0
var canMove = true

var udp = PacketPeerUDP.new()


var gibs=preload("res://instances/brick/brickgibs.tscn")


func _ready():
	var path = "res://spr/mario/spr_small_mario.tscn"
	if global.player==2:
		path = "res://spr/luigi/spr_small_luigi.tscn"
	var spr_scn = load(path)
	var spr = spr_scn.instance()
	add_child(spr)
	collision_layer = 2

func _physics_process(delta):
	motion.y+=GRAVITY
	dir = 0
	if is_on_floor():
		FRICTION = 0.5
	else:
		FRICTION = 0.9
	
	if canMove == true:
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
	
	var cam = get_parent().get_node("camera")
	if (cam!=null):
		var x = get_global_position().x
		var y = get_global_position().y
		var camx = cam.get_global_position().x
		var camy = cam.get_global_position().y
		var wview = ProjectSettings.get_setting("display/window/size/width")
		var hview = ProjectSettings.get_setting("display/window/size/height")
		
		if (abs(x - camx)) > wview/2:
			motion.x = 0
			x = clamp(x,camx-wview/2,camx+wview/2)
		if (abs(y - camy)) > hview/2:
			motion.y = 0
			y = clamp(y,camy-hview/2,camy+hview/2)
		set_global_position(Vector2(x,y))
		

	udp.set_dest_address(global.send_ip,global.send_port)
	var packet = [0,get_global_position(),dir,motion] #mario status
	udp.put_var(packet)

	if Input.is_action_just_pressed("ui_accept"):
		print("Motion x: "+str(motion.x))
		print(" is on floor: "+str(is_on_floor()))

	motion = move_and_slide(motion,UPVECTOR)
