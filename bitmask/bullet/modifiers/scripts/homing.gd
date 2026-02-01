extends BulletModifier

class_name Homing

func on_process(bullet):
	for object in bullet.get_close_bodies():
		if object.has_method("take_damage") and object is not Player:
			bullet.direction += (object.global_position - bullet.global_position) * 0.01
			break
	bullet.direction = bullet.direction.normalized()
