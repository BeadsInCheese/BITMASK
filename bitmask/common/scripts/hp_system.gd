extends Node
signal damage_taken
signal on_death
var max_hp=300
var current_hp
func _ready() -> void:
	current_hp=max_hp
	
	
func take_damage(dmg:float):
	damage_taken.emit(dmg)
	if(current_hp-dmg>0):
		current_hp-=dmg
	else:
		die()
		
		
func die():
	on_death.emit()
