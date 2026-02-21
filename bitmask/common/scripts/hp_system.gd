extends Node

signal damage_taken
signal on_death
var max_hp = 300
var current_hp
var dead: bool = false


func _ready() -> void:
	current_hp = max_hp


func take_damage(dmg: float):
	damage_taken.emit(dmg)
	if (current_hp - dmg > 0):
		current_hp -= dmg
	else:
		die()


func die():
	if !dead:
		dead = true
		on_death.emit()
