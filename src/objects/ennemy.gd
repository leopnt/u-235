extends "res://src/objects/particle.gd"

const PlayerClass = preload("res://src/objects/player.gd")

export(float) var initial_vel:float = 500
signal split_collision

func _ready():
	var to_center:Vector2 = -position
	var random_angle = rand_range(-0.5, 0.5)
	apply_central_impulse(initial_vel * to_center.normalized().rotated(random_angle))


func dispose():
	print("Ennemy::>", self, " queue_free...")
	queue_free()

func _draw():
	draw_circle(
		Vector2.ZERO,
		$CollisionShape2D.shape.radius,
		Color(112, 40, 46, 0.8)
		)

func _on_Ennemy_body_entered(body):
	if body is self.get_script() && !split_active:
		emit_signal("split_collision", position)
		dispose()


func _on_InfluenceArea_body_entered(body):
	if body is PlayerClass:
		body.zone_entered()


func _on_InfluenceArea_body_exited(body):
	if body is PlayerClass:
		body.zone_exited()
