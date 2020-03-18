extends Sprite

func _ready():
	set_z_index(-5)

func _physics_process(_delta):
	var objs = $winArea.get_overlapping_bodies()
	for obj in objs:
		if obj.name == "Mario" or obj.name=="fake_mario":
			if obj.canMove == true:
				$flag.flag = true
				var objy = obj.get_global_position().y
				obj.set_global_position(Vector2(get_global_position().x-4,objy))
			obj.canMove = false
