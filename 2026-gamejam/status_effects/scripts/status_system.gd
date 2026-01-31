extends Node
class_name StatusSystem

signal take_damage(dmg)
var statuses:Array

var tick_length=0.5
var tick_timer=0

func apply_status(status):
	print("append satatus")
	statuses.append([status,status.duration])


func _process(delta: float) -> void:
	for status_index in len(statuses):
		if(tick_timer<=0):
			statuses[status_index][0].on_frame(tick_length,self)
			tick_timer=tick_length
		tick_timer-=delta
		statuses[status_index][1]-=delta
		if(statuses[status_index][1]<=0):
			statuses.remove_at(status_index)
			break
			
			
func death():
	for status in statuses:
		status.on_death()	
