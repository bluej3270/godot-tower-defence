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
	get_parent().get_parent().set_cash(125)
	get_tree().paused = false
	self.hide()


func _on_Maps_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://UI/Map Selection.tscn")


func _on_Exit_pressed():
	get_tree().quit()
