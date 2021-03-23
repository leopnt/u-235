extends Node2D

enum ennemy_types {EPN, Sin}
const ennemy_folder = "res://scenes/Objects/Ennemies/"

func _ready():
	pass


func _on_SpawnTrigger_timeout():
	_spawn_ennemy()
	
func _spawn_ennemy(spawn_pos:Vector2 = Vector2.ZERO, split_active:bool = false) -> void:
	if spawn_pos == Vector2.ZERO: 
		# random spawn position if no position is specified
		var norm_rand_vec = Vector2(rand_range(-1, 1), rand_range(-1, 1))
		norm_rand_vec = norm_rand_vec.normalized()
		spawn_pos = $Area2D/SpawnArea.shape.radius * norm_rand_vec

	var ennemy = null
	var r_index:int = ennemy_types.values()[randi()%ennemy_types.size()]
	match r_index:
		ennemy_types.EPN:
			ennemy = load(ennemy_folder + "EnnemyEPN.tscn").instance()
		ennemy_types.Sin:
			ennemy = load(ennemy_folder + "EnnemySin.tscn").instance()
	
	ennemy.position = spawn_pos
	ennemy.split_active = split_active
	ennemy.connect("split_collision", self, "_on_split_collision")
	call_deferred("add_child", ennemy)

func _on_split_collision(coll_position:Vector2) -> void:
	_spawn_ennemy(coll_position, true)
	_spawn_ennemy(coll_position, true)

func _on_Area2D_body_exited(body):
	body.dispose()


func _on_DifficultyIncrease_timeout():
	$SpawnTrigger.wait_time -= 0.05
	print("Spawner::>wait_time: ", $SpawnTrigger.wait_time)
	if $SpawnTrigger.wait_time <= 0.1:
		$DifficultyIncrease.stop()
