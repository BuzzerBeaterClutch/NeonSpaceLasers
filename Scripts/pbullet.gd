extends Area2D

@export var damage := 10
var direction: Vector2
const SPEED := 10

func _physics_process(delta: float) -> void:
	global_position += direction * SPEED

func _on_body_entered(body):
	if body == owner:
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
