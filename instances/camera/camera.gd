extends Camera2D

var mariopos = Vector2(0,0)
var fakepos = Vector2(0,0)
var mario_node
var fake_node

func _process(delta):
	mario_node = get_parent().get_node(global.Mario)
	fake_node = get_parent().get_node(global.fake_mario)
	if (mario_node!=null):
		mariopos = mario_node.get_global_position()
	
	if (fake_node!=null):
		fakepos = fake_node.get_global_position()
	var x = (mariopos.x + fakepos.x)/2
	var y = (mariopos.y + fakepos.y)/2
	set_global_position(Vector2(x,y))
