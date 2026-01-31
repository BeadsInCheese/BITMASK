extends BulletModifier

class_name DirectDamage
@export var amount: float = 10


func on_collision(bullet, target):
	if (target.has_method("take_damage")):
		target.take_damage(amount)
