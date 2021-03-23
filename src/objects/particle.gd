extends RigidBody2D

const G:float = 2000.0
var charge:int # -1, 0 or 1

var split_active:bool = false

func _ready():
	randomize()
	charge = int(round(rand_range(-1, 1)))

func _process(delta):
	_apply_gravity()

func dispose():
	pass

func _apply_gravity() -> void:
	for body in get_tree().get_nodes_in_group("gravity_bodies"):
		if body != self && !body.split_active:
			var dir:Vector2 = body.global_position - global_position
			var dist = dir.length()
			
			var m2 = body.mass
			var F =  -(charge * body.charge) * G * mass * m2 / (dist * dist)
			apply_central_impulse(F * dir.normalized())
