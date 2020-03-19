extends Node2D
const mario_scn = preload("res://instances/Mario/Mario.tscn")

func _ready():
	$Sprite.set_visible(false)
	var mario = mario_scn.instance()
	mario.isPlayer = true
	get_parent().call_deferred("add_child",mario)
	mario.set_global_position(get_global_position())
	mario.set_name(global.Mario)
	#
	var fakeMario = mario_scn.instance()
	get_parent().call_deferred("add_child",fakeMario)
	fakeMario.set_global_position(get_global_position())
	fakeMario.set_name(global.fake_mario)
	#queue_free()
