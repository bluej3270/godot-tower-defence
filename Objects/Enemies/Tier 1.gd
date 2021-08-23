extends PathFollow2D

#Path Folowing Variables
onready var path_follow = self
var move_direction = 0

#Enemy Variables
var hp = 10
var speed = 75

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	path_follow.set_offset(path_follow.get_offset() + speed * delta)


func _on_Area2D_area_entered(area):
	if area.is_in_group("Cannon Shot"):
		area.queue_free()
		hp -= 5
		if hp <= 0:
			get_parent().get_parent().add_cash(5)
			queue_free()
