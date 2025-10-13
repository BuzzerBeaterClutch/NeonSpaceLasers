extends Node2D

var enemy_scene = preload("res://Scenes/enemy.tscn")

@onready var player = $Player
var current_wave = 1
var enemies_remaining = 0
var score=0

func _ready():
	start_wave()

func start_wave():
	enemies_remaining = current_wave * 5  # 5 enemies per wave, scalable
	for i in range(enemies_remaining):
		spawn_enemy()
	print("Wave %d started with %d enemies" % [current_wave, enemies_remaining])

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.global_position = player.global_position

	# Keep repositioning until it's far from player
	while enemy.global_position.distance_squared_to(player.global_position) < 10000:
		enemy.global_position.x = randi_range(0, get_viewport_rect().size.x)
		enemy.global_position.y = randi_range(0, get_viewport_rect().size.y)

	enemy.connect("tree_exited", Callable(self, "_on_enemy_defeated"))
	add_child(enemy)

func _on_enemy_defeated():
	enemies_remaining -= 1
	score += 10
	if enemies_remaining <= 0:
		print("Wave Completed")
		print("Score: ",score)
		current_wave += 1
		await get_tree().create_timer(2.0).timeout  # Short delay between waves
		start_wave()
