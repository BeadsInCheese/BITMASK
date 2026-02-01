class_name DirectDamage
extends BulletModifier

@export var amount: float = 10


func on_collision(bullet, target):
	if target.has_method("take_damage") and target is not Player:
		target.take_damage(amount)
