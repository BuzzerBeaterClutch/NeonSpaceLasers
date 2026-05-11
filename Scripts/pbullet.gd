extends BulletBase

func _on_body_entered(body):

	if body == bullet_owner:
		return

	if body.is_in_group("enemies"):

		body.take_damage(damage)

		destroy()
