extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	
	is_finished()
	
func is_finished():
	if len(global.jugadores_que_han_finalizado) >1 and global.is_in_level:
		global.is_in_level = false
		get_tree().change_scene("res://worlds/world1-2.tscn")
		global.is_in_level = true
func _on_Castillo_body_entered(body):
	if not global.jugadores_que_han_finalizado.has(body.name):
		global.jugadores_que_han_finalizado.append(body.name)
		body.queue_free()