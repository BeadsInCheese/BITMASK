class_name DirectDamage
extends BulletModifier

@export var amount: float = 10
@export var player_is_immune: bool = false


func on_collision(bullet, target):
	if target is Player and player_is_immune:
		return
	if target.has_method("take_damage"):
		target.take_damage(amount)
