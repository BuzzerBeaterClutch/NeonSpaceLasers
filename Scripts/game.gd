extends Node2D

@onready var score_manager = $ScoreManager
@onready var score_label = $"UILabels"/HighScore
@onready var player = $Player
@onready var game_over_layer: CanvasLayer = $GameOverLayer
@onready var game_over_text: RichTextLabel = $GameOverLayer/GameOverControl/CenterContainer/GameOverVBox/GameOverLabel
@onready var retry_button: Button = $GameOverLayer/GameOverControl/CenterContainer/GameOverVBox/GRetryButton
@onready var win_layer: CanvasLayer = $WinState
@onready var win_text: RichTextLabel = $WinState/WinControl/WinContainer/WinVBox/WinLabel
@onready var wretry_button: Button = $WinState/WinControl/WinContainer/WinVBox/WRetryButton
var enemy_scene = preload("res://Scenes/enemy.tscn")
var game_over:= false
var current_wave = 1
var enemies_remaining = 0

func _ready():
#	score_manager.score_changed.connect(score_label.update_score)
#	score_manager.reset()
	player.died.connect(_on_player_died)
	retry_button.pressed.connect(_on_retry_pressed)
	wretry_button.pressed.connect(_on_retry_pressed)
	game_over_layer.hide()
	win_layer.hide()
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

	enemy.defeated.connect(_on_enemy_defeated)
	add_child(enemy)

func _on_enemy_defeated():
	if game_over:
		return
	enemies_remaining -= 1
	score_manager.add_points(10)

	if enemies_remaining <= 0:
#		current_wave += 1
		win_layer.show()
		await get_tree().create_timer(2.0).timeout
#		start_wave()

func _on_player_died():
	game_over = true
	game_over_layer.show()
	# Option A: pause everything (common/easy)
	get_tree().paused = true
	
func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	game_over_layer.hide()
	print("Retry")
