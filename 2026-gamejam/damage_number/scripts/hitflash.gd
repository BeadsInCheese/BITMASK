extends Sprite2D
func hit_flash(damage):
	for i in range(10):
		material.set_shader_parameter("flash",0.1*i)
		await get_tree().process_frame
	for i in range(10):
		material.set_shader_parameter("flash",0.1*(9-i))
		await get_tree().process_frame
