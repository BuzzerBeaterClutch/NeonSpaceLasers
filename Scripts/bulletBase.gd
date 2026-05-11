extends Area2D
class_name BulletBase

@export var SPEED := 600
@export var damage := 10

var direction := Vector2.ZERO
var bullet_owner = null

func _physics_process(delta):

	global_position += direction * SPEED * delta

func set_direction(dir: Vector2):

	direction = dir.normalized()

func set_bullet_owner(node):
	bullet_owner = node

func destroy():

	queue_free()
