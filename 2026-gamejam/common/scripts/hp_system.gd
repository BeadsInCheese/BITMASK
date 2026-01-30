extends Node
signal damage_taken
signal on_death
var max_hp
var current_hp
func _ready() -> void:
	current_hp=max_hp
func take_damage(dmg:float):
	damage_taken.emit(dmg)
func die():
	on_death.emit()
