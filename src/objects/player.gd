extends "res://src/objects/particle.gd"

var speed:float = 40000
onready var noise:OpenSimplexNoise = OpenSimplexNoise.new()
var mana:int = 0
var influence_zone_counter:int = 0

var life:int = 3

signal increase_score
signal player_dead
signal hit

func _ready():
	charge = -1 # player is always charged

func _process(delta:float):
	_apply_inputs(delta)
	
	$Kernel.position.x = 6 * noise.get_noise_1d(0.5*OS.get_ticks_msec())
	$Kernel.position.y = 6 * noise.get_noise_1d(0.5*OS.get_ticks_msec()+8000)
	$Kernel.rotate(-5 * delta)
	
	$Audio/ElecMove.volume_db = -9 + 0.02 * linear_velocity.length()
	$Audio/ElecMove.pitch_scale = lerp(
		$Audio/ElecMove.pitch_scale,
		1 + 0.001 * linear_velocity.length(),
		0.2
		)

func _apply_inputs(delta:float) -> void:
	var dir = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		dir += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		dir += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		dir += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		dir += Vector2.RIGHT
	
	apply_central_impulse(delta * speed * dir.normalized())
	update()

func _input(event):
	if event.is_action_pressed("ui_select"):
		if mana >= 100:
			_use_mana()

func _use_mana() -> void:
	mana = 0
	$Audio/ElecBuzz.play()
	if life < 3:
		life += 1
		_update_radiation_sound()
	print("Player::>mana used")

func _draw():
	var dtheta = 2 * PI / (life + 0.001) # avoid zero division error
	for i in range(life):
		var theta = i * dtheta
		draw_circle(
			20 *Vector2.UP.rotated(2 * $Kernel.rotation + theta),
			3,
			$Kernel.color
			)

	draw_circle($Kernel.position, 0.1 * mana, Color(40, 250, 110, 0.6))

	if mana >= 100:
		draw_arc($Kernel.position, 17, 0, 2*PI, 32, Color(40, 250, 110, 0.4), 2)

func _take_hit() -> void:
	emit_signal("hit")
	if life > 0:
		life -= 1
		$Audio/LaserPulse.play()
		_update_radiation_sound()
	if life <= 0:
		emit_signal("player_dead")
		get_tree().paused = true

func _update_radiation_sound() -> void:
	$Audio/Radiation.pitch_scale = 10 * (4 - life)

func _on_Player_body_entered(body):
	if body.has_method("dispose"):
		body.dispose()
		_take_hit()

func zone_entered():
	influence_zone_counter += 1
	$Audio/ElecFlyby.play()

func zone_exited():
	influence_zone_counter -= 1

func _on_ManaLoader_timeout():
	emit_signal("increase_score", 10 * influence_zone_counter)
	if mana < 100:
		mana += 10 * influence_zone_counter
		if mana > 100:
			mana = 100
