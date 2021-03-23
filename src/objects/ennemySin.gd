extends "res://src/objects/ennemy.gd"



func _ready():
	pass

func _process(delta):
	var dir:Vector2 = linear_velocity.normalized()
	var mag = ($Activate.wait_time - $Activate.time_left)
	mag *= 3000 * sin(0.03 * OS.get_ticks_msec())
	apply_central_impulse(delta * mag * dir.rotated(PI/2))
	mag = -0.1 * $Activate.time_left * position.length()
	apply_central_impulse(delta * mag * position.normalized())
