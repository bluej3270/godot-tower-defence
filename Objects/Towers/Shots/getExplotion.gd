extends Area2D


func getExplode():
	return self.get_parent().get_parent().getExplode()


func _on_Area2D_area_entered(area):
	if getExplode():
		if area.is_in_group("enemy"):
			area.get_parent().kill()


func _on_Area2D_area_exited(area):
	if getExplode():
		if area.is_in_group("enemy"):
			area.get_parent().kill()
