extends CharacterBody2D

signal defeated

@onready var player = $/root/Game/Player

@export var max_health := 30
var health := max_health

@export var orbit_radius := 400.0
@export var orbit_speed := 1.5

var bullet_asset = preload("res://Scenes/enemybullet.tscn")
@export var fire_rate := 1.5

const SPEED = 100

func _ready():
	shoot_loop()

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var to_player = global_position - player.global_position
	var distance = to_player.length()
	var radial_dir = to_player.normalized()
	var correction = (orbit_radius - distance) * radial_dir
	var tangent = Vector2(-radial_dir.y, radial_dir.x)

	velocity = (tangent * SPEED) + correction
	look_at(player.global_position)
	move_and_slide()

func shoot_loop():
	while true:
		await get_tree().create_timer(fire_rate).timeout
		shoot()

func shoot():
	if player == null:
		return

	var bullet = bullet_asset.instantiate()
	bullet.global_position = global_position
	bullet.direction = (player.global_position - global_position).normalized()
	$/root/Game.add_child(bullet)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	emit_signal("defeated")
	queue_free()
