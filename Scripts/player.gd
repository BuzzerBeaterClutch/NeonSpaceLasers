extends CharacterBody2D
signal health_changed(current, max)
@export var max_health := 100
var health := max_health
var bullet_asset = preload("res://Scenes/playerbullet.tscn")
const speed = 400
var is_dead := false
@onready var bulletorigin = $BulletOrigin

signal died

func get_input():
	look_at(get_global_mouse_position())
	velocity.x = Input.get_axis("Left","Right") * speed
	velocity.y = Input.get_axis("Up","Down") * speed
	velocity = lerp(get_real_velocity(), velocity, 0.1)
	if Input.is_action_just_pressed("Shoot"):
		shoot()

func shoot():
	var bullet = bullet_asset.instantiate()
	bullet.global_position = bulletorigin.global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	$/root/Game.add_child(bullet)


func take_damage(amount):
	if is_dead:
		return
	health -= amount
	health = clamp(health,0, max_health)
	emit_signal("health_changed", health, max_health)
	if health <= 0:
		die()

func die():
	is_dead = true
	emit_signal("died")
	print("PLAYER DIED")

func _physics_process(delta):
	get_input()
	move_and_slide()
