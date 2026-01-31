extends BulletModifier
class_name ApplyStatus
@export var statuses:Array[StatusEffect]


func on_collision(bullet,target):
	if target.has_method("apply_status"):
		for status in statuses:
			target.apply_status(status)
