extends CanvasLayer

onready var score:int = 0

func _ready():
	pass


func _on_Player_increase_score(score_increment:int):
	score += score_increment
	$Control/MarginContainer/LabelScore.text = str(score)
	if score_increment > 0:
		$Control/MarginContainer/CPUParticles2D.restart()


func _on_Player_player_dead():
	$Control/AnimationPlayer.play("gameover")
	$Control/GameOverScreen/VBoxContainer/Button.grab_focus()


func _on_Button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
