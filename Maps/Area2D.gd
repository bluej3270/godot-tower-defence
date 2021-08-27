extends Area2D

export var health = 100

func _process(delta):
	get_parent().get_node("UI/Health").text = "" + health as String

func _on_End_Area_area_entered(area):
	if area.is_in_group("enemy"):
		health -= area.get_parent().get_damage()
