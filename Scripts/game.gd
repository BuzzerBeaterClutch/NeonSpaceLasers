extends Node2D

@onready var score_manager = $ScoreManager
@onready var score_label = $scoreLabels/HighScore
@onready var player = $Player
var enemy_scene = preload("res://Scenes/enemy.tscn")

var current_wave = 1
var enemies_remaining = 0

func _ready():
	score_manager.score_changed.connect(score_label.update_score)
	score_manager.reset()
	start_wave()

func start_wave():
	enemies_remaining = current_wave * 5
	for i in range(enemies_remaining):
		spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.global_position = player.global_position

	while enemy.global_position.distance_squared_to(player.global_position) < 10000:
		enemy.global_position.x = randi_range(0, get_viewport_rect().size.x)
		enemy.global_position.y = randi_range(0, get_viewport_rect().size.y)

	enemy.connect("tree_exited", Callable(self, "_on_enemy_defeated"))
	add_child(enemy)

func _on_enemy_defeated():
	enemies_remaining -= 1
	score_manager.add_points(10)

	if enemies_remaining <= 0:
		current_wave += 1
		await get_tree().create_timer(2.0).timeout
		start_wave()
