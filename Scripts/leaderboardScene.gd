extends Control

@onready var leaderboard_label = $LeaderboardListLabel
@onready var menu_music = preload("res://Assets/Sound Effects/MenuMusic.ogg")

func _ready():
	var scores = LeaderboardManager.get_scores()

	var text = ""

	for i in range(scores.size()):

		var entry = scores[i]

		text += str(i + 1) + ". "
		text += entry["name"]
		text += " - "
		text += str(entry["score"])
		text += "\n"

	leaderboard_label.text = text
