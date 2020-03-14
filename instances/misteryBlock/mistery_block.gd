extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var opened = false
const CoinResource = preload("res://instances/rotating_coin/Rotating_coin.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var objs = $blockBreak.get_overlapping_bodies()
	for obj in objs:
		if (obj.name == "Mario" or obj.name == "fake_mario") and opened == false:
			opened = true
			var coin = CoinResource.instance()
			coin.set_global_position(self.get_global_position())
			get_tree().get_root().add_child(coin)
			play("fainted")
