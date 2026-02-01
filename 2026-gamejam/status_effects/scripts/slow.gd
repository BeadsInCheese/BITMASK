extends StatusEffect

class_name SlowStatus
@export var speed_multiplier: float


func on_apply(system):
	system.change_speed_mult.emit(max(speed_multiplier, 0.01))


func on_expire(system):
	system.change_speed_mult.emit(1 / max(speed_multiplier, 0.01))
