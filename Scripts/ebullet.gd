extends Area2D

var direction := Vector2.ZERO
const SPEED := 400
@export var damage := 10

func _physics_process(delta):
	global_position += direction * SPEED * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
