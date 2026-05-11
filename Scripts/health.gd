extends RichTextLabel

func _ready():
	var player = get_node("/root/Game/Player")
	player.health_changed.connect(_on_health_changed)
	_on_health_changed(player.health, player.max_health)

func _on_health_changed(current, max):
	text = "Player Health: %d / %d" % [current, max]
