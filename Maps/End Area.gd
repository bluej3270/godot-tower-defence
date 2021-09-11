extends Area2D

export var health = 100

func _process(delta):
	get_parent().get_node("UI/Health").text = "" + health as String

func _on_End_Area_area_entered(area):
	if area.is_in_group("enemy"):
		health -= area.get_parent().get_damage()
		if health <= 0:
			get_parent().get_node("UI/Death Screen").visible = true
			get_parent().get_node("UI/Death Screen").raise()
			get_parent().get_tree().paused = true
