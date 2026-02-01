extends StatusEffect
class_name DamageOverTime
@export var dps:float
func on_frame(delta:float,system):
	system.take_damage.emit(dps*delta)
