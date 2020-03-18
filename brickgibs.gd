extends Sprite

var hs
var vs
var TTL = 300

func _ready():
	hs = rand_range(-5,5)
	vs = -5*randf()
	if (randf() > 0.5):
		flip_h = true
	if (randf() > 0.5):
		flip_v = true


func _physics_process(_delta):
	var motion = Vector2(hs,vs)
	set_global_position(motion+get_global_position())
	vs += 0.4
	TTL-=1
	if (TTL < 0):
		queue_free()
