extends RichTextLabel

var default_text = "Current Score: "

func _ready():
	text = default_text + "0"

	var score_manager = get_tree().get_first_node_in_group("ScoreManager")
	if score_manager:
		score_manager.score_changed.connect(update_score)
	else:
		print("ERROR: ScoreManager not found")

func update_score(new_score: int):
	text = default_text + str(new_score)
