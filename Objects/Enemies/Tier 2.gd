extends PathFollow2D

#Path Folowing Variables
onready var path_follow = self
var move_direction = 0

#Enemy Variables
var hp = 50
var speed = 50
var damage = 2

var instance
var tier1 = load("res://Objects/Enemies/Tier 1.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	path_follow.set_offset(path_follow.get_offset() + speed * delta)


func _on_Area2D_area_entered(area):
	if area.is_in_group("Cannon Shot"):
		area.queue_free()
		hp -= 10
	elif area.is_in_group("Missle"):
		if not area.getExplode():
			area.explode()
	elif area.is_in_group("MissleExplosion"):
		if area.getExplode():
			hp -= 20
	if hp <= 0:
		instance = tier1.instance()
		instance.set_offset(self.get_offset() - 10)
		get_parent().add_child(instance)
		instance = tier1.instance()
		instance.set_offset(self.get_offset() - 20)
		get_parent().add_child(instance)
		self.queue_free()

func get_damage():
	return damage

func kill():
	queue_free()
