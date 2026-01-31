extends StatusEffect

class_name SlowStatus
@export var speed_multiplier:float

func on_apply(system):
	system.change_speed_mult.emit(speed_multiplier)
func on_expire(system):
	system.change_speed_mult.emit(1/speed_multiplier)
