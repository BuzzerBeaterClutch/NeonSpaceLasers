extends Node
class_name HighScoreManager

const SAVE_PATH := "user://highscores.json"

var best_score: int = 0
var best_name: String = ""

func _ready() -> void:
	load_scores()

func is_new_high_score(score: int) -> bool:
	return score > best_score

func submit_score(name: String, score: int) -> void:
	best_score = score
	best_name = name.strip_edges()
	save_scores()

func save_scores() -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f == null:
		push_error("Could not write highscore file")
		return

	var data: Dictionary = {
		"name": best_name,
		"score": best_score
	}

	f.store_string(JSON.stringify(data, "\t"))
	f.close()

func load_scores() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if f == null:
		return

	var parsed: Variant = JSON.parse_string(f.get_as_text())
	f.close()

	if typeof(parsed) == TYPE_DICTIONARY:
		var dict := parsed as Dictionary
		best_score = int(dict.get("score", 0))
		best_name = str(dict.get("name", ""))
