extends CharacterBody2D

signal defeated

@onready var player = $/root/Game/Player
@onready var sfx_eshoot: AudioStreamPlayer = $sfx_eshoot
@export var max_health := 30
var health := max_health

@export var orbit_radius := 400.0
@export var orbit_speed := 1.5

var bullet_asset = preload("res://Scenes/enemybullet.tscn")
@export var fire_rate := 1.5

const SPEED = 100
var angle_offset := 0.0

func _physics_process(delta: float) -> void:
	if player == null && get_node("/root/Game").game_over:
		return

	var to_player = global_position - player.global_position
	var distance = to_player.length()
	var radial_dir = to_player.normalized()
	var correction = (orbit_radius - distance) * radial_dir
	var tangent = Vector2(-radial_dir.y, radial_dir.x).rotated(angle_offset)
	velocity = (tangent * SPEED) + correction
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy != self:
			var diff = global_position - enemy.global_position
			var dist = diff.length()
			
			if dist < 100: # bigger influence radius
				var strength = (500 - dist) / 500.0  # closer = stronger push
				velocity += diff.normalized() * strength * 500
	look_at(player.global_position)
	move_and_slide()

func _ready():
	add_to_group("enemies")
	angle_offset = randf() * TAU
	shoot_loop()


func shoot_loop():
	while is_inside_tree():
		var tree := get_tree()
		if tree == null:
			return
		await tree.create_timer(fire_rate).timeout
		if not is_inside_tree():
			return
			
		if get_node("/root/Game").game_over:
			return
		
		shoot()

func shoot():
	if player == null || get_node("/root/Game").game_over:
		return
	var bullet = bullet_asset.instantiate()
	sfx_eshoot.play()
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
