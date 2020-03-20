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
var inLevel = true #hasn't picked the flag
var isPlayer = false

var udp = PacketPeerUDP.new()
var is_dead
func _ready():
	print("inicio")
	is_dead = false
	var path = "res://spr/mario/spr_small_mario.tscn"
	if (!isPlayer and global.player==1) or (isPlayer and global.player==2):
		path = "res://spr/luigi/spr_small_luigi.tscn"
	var spr_scn = load(path)
	var spr = spr_scn.instance()
	add_child(spr)
	collision_layer = 2
	if isPlayer:
		$Label.text = global.player_name
	else:
		$Label.text = global.peer_name

func _physics_process(_delta):
	if(not is_dead):
		
		motion.y+=GRAVITY
	
		if is_on_floor():
			FRICTION = 0.5
		else:
			FRICTION = 0.9
		
		if isPlayer:
			dir = 0
		if inLevel == true and isPlayer == true and global.canMove==true:
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
		
		
		if dir==0 and is_on_floor():
			motion.x*=FRICTION
		if !is_on_floor():
			dir = 0
		
		if !inLevel:
			dir = 1

	# warning-ignore:integer_division
			motion.x = hs/2
			if !is_on_floor():
				motion.x = 0
	# warning-ignore:integer_division
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
			if inLevel == true:
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
			
		if isPlayer:
			udp.set_dest_address(global.send_ip,global.send_port)
			var packet = [0,get_global_position(),dir,motion] #mario status
			udp.put_var(packet)
	
		motion = move_and_slide(motion,UPVECTOR)
		if (get_slide_count() > 0): #Si está colisionando con algo
			
			var obj_colisionado = get_slide_collision(get_slide_count()-1).collider # Obtiene el objeto con el que colisiona
			if(obj_colisionado.is_in_group("enemy")): # Si colisiona contra el enemigo
			
				if(is_on_wall() or is_on_ceiling()):
					# Si el golpea al jugador por un lado o por arriba
					# El jugador recibe un golpe
					
					recibe_golpe() 
					
				elif(is_on_floor()):
					saltar()
					obj_colisionado.recibe_golpe() # Si lo chocan en la cabeza muere


func recibe_golpe():
	var org_trans = transform.y
	transform.y  -= 0.5*transform.y 
	$CollisionShape2D.disabled = true
	is_dead = true
	var actual_pos = position.y
	position.y += 3.5
	$sprites.play("dead")
	
	yield(get_tree().create_timer(2), "timeout") #Espera para volver
	
	position.y = actual_pos
	is_dead = false
	$CollisionShape2D.disabled = false
	transform.y  = org_trans
	$sprites.play("idle")
	pass


func _exit_tree():
	udp.close()
	
func saltar():
	$sprites.play("jump")
	motion.y -= 500


func end_level():
	inLevel = false
	$sprites.play("run")
	
	udp.put_var([1]) #mario status