extends Node

signal score_changed(new_score)

var score := 0

func _ready():
	add_to_group("ScoreManager")

func add_points(amount: int):
	score += amount
	emit_signal("score_changed", score)

func reset():
	score = 0
	emit_signal("score_changed", score)
