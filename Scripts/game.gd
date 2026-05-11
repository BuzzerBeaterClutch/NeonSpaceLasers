extends Node2D

@onready var score_manager = $ScoreManager
@onready var score_label = $GameplayLabels/CurrentScoreLabel
@onready var leaderboard_label = $LeaderboardListLabel
@onready var high_score_label: RichTextLabel = $GameplayLabels/HighScore
@onready var player = $Player
@onready var parallax = $ParallaxBackground
@onready var game_over_layer: CanvasLayer = $GameOverLayer
@onready var game_over_text: RichTextLabel = $GameOverLayer/GameOverControl/CenterContainer/GameOverVBox/GameOverLabel
@onready var retry_button: Button = $GameOverLayer/GameOverControl/CenterContainer/GameOverVBox/GRetryButton
@onready var back_button: Button = $GameOverLayer/GameOverControl/CenterContainer/GameOverVBox/GBackToMainButton
@onready var win_layer: CanvasLayer = $WinState
@onready var win_text: RichTextLabel = $WinState/WinControl/WinContainer/WinVBox/WinLabel
@onready var wretry_button: Button = $WinState/WinControl/WinContainer/WinVBox/WRetryButton
@onready var name_input: LineEdit = $GameOverLayer/GameOverControl/CenterContainer/GameOverVBox/NameInput
@onready var submit_button: Button = $GameOverLayer/GameOverControl/CenterContainer/GameOverVBox/SubmitButton
var enemy_scene = preload("res://Scenes/enemy.tscn")
var game_over:= false
var endless_mode: bool = false
var max_waves: int = 20
var current_wave = 1
var enemies_remaining = 0

func _ready():
	player.died.connect(_on_player_died)
	game_over_layer.hide()
	win_layer.hide()
	
	_update_high_score_label()
	start_wave()

func _process(delta):
	parallax.scroll_offset.y += 200 * delta
	

func start_wave():
	enemies_remaining = current_wave * 2
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
		# If endless mode → just continue
		if endless_mode:
			current_wave += 1
			await get_tree().create_timer(2.0).timeout
			start_wave()
			return
		var is_new_best := LeaderboardManager.is_high_score(score_manager.score)
		if current_wave >= max_waves:
			LeaderboardManager.submit_score(
				"Player",
				score_manager.score
			)
			_update_high_score_label()

			if is_new_best:
				win_text.text = "YOU WIN!\nNEW HIGH SCORE: %d" % score_manager.score
			else:
				win_text.text = "YOU WIN!\nScore: %d" % score_manager.score
					
			win_layer.show()
			get_tree().paused = true
		else:
			current_wave += 1
			await get_tree().create_timer(2.0).timeout
			start_wave()
		
func _on_player_died():

	game_over = true

	game_over_layer.show()

	name_input.grab_focus()

	get_tree().paused = true
	
func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	game_over_layer.hide()
	print("Retry")

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	game_over_layer.hide()
	print("Retry")
	
func _on_back_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	print("Return To Main Menu")

func _on_submit_score_pressed():
	var player_name := name_input.text

	if player_name.strip_edges() == "":
		player_name = "Anonymous"

	LeaderboardManager.submit_score(
		player_name,
		score_manager.score
	)
	_update_high_score_label()

	name_input.hide()
	submit_button.hide()

	game_over_text.text = "SAVED!\n%s - %d" % [player_name, score_manager.score]

func _update_high_score_label() -> void:
	var scores = LeaderboardManager.get_scores()

	if scores.size() > 0:
		high_score_label.text = "High Score: %d" % scores[0]["score"]
	else:
		high_score_label.text = "High Score: 0"
