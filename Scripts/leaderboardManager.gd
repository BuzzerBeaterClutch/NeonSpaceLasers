extends Node

const SAVE_PATH := "user://leaderboard.json"

var leaderboard : Array = []

func _ready():
	load_scores()

func submit_score(player_name: String, score: int):

	leaderboard.append({
		"name": player_name,
		"score": score
	})

	leaderboard.sort_custom(func(a,b):
		return a["score"] > b["score"]
	)

	if leaderboard.size() > 10:
		leaderboard.resize(10)

	save_scores()

func save_scores():

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file:
		file.store_string(JSON.stringify(leaderboard))
		file.close()

func load_scores():

	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)

	if file:
		var parsed = JSON.parse_string(file.get_as_text())

		if parsed is Array:
			leaderboard = parsed

		file.close()

func get_scores() -> Array:
	return leaderboard

func is_high_score(score: int) -> bool:

	if leaderboard.size() < 10:
		return true

	return score > leaderboard[-1]["score"]
