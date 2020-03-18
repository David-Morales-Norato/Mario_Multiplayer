extends Sprite

var flag = false
const limit = 100
var index = 0

func _ready():
	set_z_index(-4)

func _physics_process(_delta):
	if flag:
		if index < limit:
			var jump = 3
			var pos = get_global_position()
			set_global_position(Vector2(pos.x,pos.y+jump))
			index+=jump
