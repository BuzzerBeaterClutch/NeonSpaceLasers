extends Control

var menu_music = preload("res://Assets/Sound Effects/MenuMusic.ogg")

func _ready() -> void:
	MusicManager.play_music(menu_music)
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()
	
func _on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/leaderboard.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
