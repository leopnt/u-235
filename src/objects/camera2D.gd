extends Camera2D

onready var noise:OpenSimplexNoise = OpenSimplexNoise.new()

func _ready():
	pass

func _process(delta):
	if !$ShakeTimer.is_stopped():
		var intensity = $ShakeTimer.time_left
		position.x = 60 * intensity * noise.get_noise_1d(40 * delta * OS.get_ticks_msec())
		position.y = 60 * intensity * noise.get_noise_1d(40 * delta * (OS.get_ticks_msec() + 10000))

func _on_Player_hit():
	print("Camera::>player hit")
	$ShakeTimer.start()

func _on_ShakeTimer_timeout():
	pass


func _on_Player_player_dead():
	position = Vector2.ZERO
