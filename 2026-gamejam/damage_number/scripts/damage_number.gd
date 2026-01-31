extends Label
var fade=1
var angular_offset
func _ready() -> void:
	angular_offset=randf()-0.5

func _process(delta: float) -> void:
	fade-=delta
	position-=Vector2(angular_offset*0.3,0.3)
	modulate.a=fade

func _on_timer_timeout() -> void:
	queue_free()
