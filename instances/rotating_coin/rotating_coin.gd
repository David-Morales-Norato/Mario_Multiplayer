extends AnimatedSprite

# Declare member variables here. Examples:
var time = 18
var vspeed = -12


func _physics_process(delta):
	position.y+=vspeed
	vspeed+=1.3
	time-=1
	if time <= 0:
		queue_free()
	pass