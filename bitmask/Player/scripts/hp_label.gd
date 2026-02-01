extends RichTextLabel
func _ready():
	update_label()
	
func update_label():
	text = "Mask integrity " + str(int($"../../HPSystem".current_hp))
