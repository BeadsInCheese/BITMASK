extends RichTextLabel
func _ready():
	update_label()
	
func update_label():
	text = "Mask integrity " + str($"../../HPSystem".current_hp)
