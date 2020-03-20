extends KinematicBody2D

var VEL_DESPL  = 3500
var Velocidad = Vector2(0,0)
var im_dead # Variable para controlar si el enemigo ha sido pisado
func _ready():
	im_dead = false # Está vivo al inicio de la instancia
	pass # Replace with function body.

func _physics_process(delta):
	if(not im_dead): # Mientras no esté muerto va a moverse 
		Velocidad.y += 5*15*delta # Caida del objeto
	
		if (get_slide_count() > 0): #Si está colisionando con algo
			var obj_colisionado = get_slide_collision(get_slide_count()-1).collider # Obtiene el objeto con el que colisiona
			if(is_on_floor()): # Si está en un bloque no aumenta la velocidad
				Velocidad.y = 0
			if(obj_colisionado.is_in_group("player")): # Si colisiona contra el jugador
				# golpear al jugador
				if(is_on_ceiling()):
					obj_colisionado.saltar()
					recibe_golpe() # Si lo chocan en la cabeza muere
				else:
					# Si el golpea al jugador por un lado o por arriba
					# El jugador recibe un golpe
					obj_colisionado.recibe_golpe() 
				
		mover(delta)
		move_and_slide(Velocidad, Vector2(0,-1))

func recibe_golpe():
	im_dead = true
	get_node("Sprite").frame = 2
	get_node("CollisionShape2D").disabled = true
	yield(get_tree().create_timer(1), "timeout") #Espera 3 segundos cayendo
	queue_free()
	
func mover(delta):
	if(is_on_wall()): # Si se choca con un muro
		get_node("Sprite").flip_h = !get_node("Sprite").flip_h # se cambia la dirección
	Velocidad.x = -(int(get_node("Sprite").flip_h)*2-1)*VEL_DESPL*delta
	