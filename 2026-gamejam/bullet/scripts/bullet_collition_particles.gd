extends GPUParticles2D
@export var time=0.4
func _process(delta: float) -> void:
	time-=delta
	if(time<0):
		queue_free()
	modulate.a=time*2
