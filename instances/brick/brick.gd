extends Sprite

var gibs=preload("res://instances/brick/brickgibs.tscn")

func _physics_process(delta):
	var objs = $destroyZone.get_overlapping_bodies()
	for obj in objs:
		if obj.name == "Mario" or obj.name=="fake_mario":
			for i in range(4):
				var newgib = gibs.instance()
				get_parent().add_child(newgib)
				newgib.set_global_position(get_global_position())
			queue_free()
