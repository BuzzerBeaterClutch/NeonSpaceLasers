extends CharacterBody2D

var bullet_asset = preload("res://Scenes/playerbullet.tscn")
const speed = 400
@onready var bulletorigin = $BulletOrigin
func get_input():
	look_at(get_global_mouse_position())
	velocity.x = Input.get_axis("Left","Right") * speed
	velocity.y = Input.get_axis("Up","Down") * speed
	velocity = lerp(get_real_velocity(), velocity, 0.1)
	if Input.is_action_just_pressed("Shoot"):
		var bullet = bullet_asset.instantiate()
		bullet.global_position = bulletorigin.global_position
		bullet.direction = (get_global_mouse_position() - global_position).normalized()
		$/root/Game.add_child(bullet)
func _physics_process(delta):
	get_input()
	move_and_slide()
