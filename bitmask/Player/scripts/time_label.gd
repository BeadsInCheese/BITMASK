extends RichTextLabel

var total_seconds: float = 0
var running = true


func _process(delta: float) -> void:
	if not running:
		return

	total_seconds += delta
	update_label()


func update_label():
	text = get_time_string(total_seconds)


static func get_time_string(time_in_seconds: float) -> String:
	var formatted_time: String = ""
	var zeros = 2

	var seconds = int(time_in_seconds)
	var hours: int = seconds / 3600.0
	if hours > 0:
		formatted_time += str(hours).pad_zeros(zeros) + ":"

	var fractional_part := time_in_seconds - int(time_in_seconds)

	formatted_time += str((seconds % 3600) / 60).pad_zeros(zeros) + ":" + str(seconds % 60).pad_zeros(zeros) + "."
	formatted_time += str(int(fractional_part * pow(10, zeros))).pad_zeros(zeros)
	return formatted_time
