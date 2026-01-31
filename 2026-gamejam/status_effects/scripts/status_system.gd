extends Node
class_name StatusSystem

signal take_damage(dmg)
var statuses:Array


func apply_status(status):
	print("append satatus")
	statuses.append([status,status.duration])


func _process(delta: float) -> void:
	for status_index in len(statuses):
		statuses[status_index][0].on_frame(delta,self)
		statuses[status_index][1]-=delta
		if(statuses[status_index][1]<=0):
			statuses.remove_at(status_index)
			break
			
			
func death():
	for status in statuses:
		status.on_death()	
