extends Control

var esc_visible = false
func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		if esc_visible == false:
			get_tree().paused = true
			self.raise()
			esc_visible = true
			self.visible = true
		else:
			esc_visible = false
			get_tree().paused = false
			self.visible = false

func _on_Restart_pressed():
	get_parent().get_tree().reload_current_scene()


func _on_Maps_pressed():
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()
