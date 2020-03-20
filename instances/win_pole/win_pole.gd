extends Sprite

func _ready():
	set_z_index(-5)

func _physics_process(_delta):
	var objs = $winArea.get_overlapping_bodies()
	for obj in objs:
		if obj.name == global.Mario or obj.name==global.fake_mario:
			if obj.inLevel == true:
				$flag.flag = true
				var objy = obj.get_global_position().y
				obj.set_global_position(Vector2(get_global_position().x-4,objy))
				obj.end_level()
