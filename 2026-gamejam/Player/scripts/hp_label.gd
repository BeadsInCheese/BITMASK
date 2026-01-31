extends RichTextLabel
func _ready():
	update_label()
	
func update_label():
	text = "Mask " + str($"../../HPSystem".current_hp)
