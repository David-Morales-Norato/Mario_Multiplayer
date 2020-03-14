extends Sprite


func _physics_process(delta):
	var objs = $destroyZone.get_overlapping_bodies()
	for obj in objs:
		if obj.name == "Mario":
			queue_free()