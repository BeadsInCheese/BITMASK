extends StaticBody2D

func take_damage(damage):
	$HpSystem.take_damage(damage)
	
	
func apply_status(status):
	$StatusSystem.apply_status(status)
