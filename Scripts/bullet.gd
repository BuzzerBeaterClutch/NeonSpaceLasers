extends Area2D

var direction: Vector2
const Speed = 10

func _physics_process(delta: float) -> void:
	global_position += direction * Speed


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.queue_free()
		queue_free()
