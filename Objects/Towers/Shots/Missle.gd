extends Area2D

var target = null
var speed = 500
var velocity
var exploded = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target.get_ref() and not exploded:
		velocity = ((target.get_ref().get_global_transform().origin - position).normalized() * speed)
		position += velocity * delta
		rotation = velocity.angle() + deg2rad(90)
	elif not exploded:
		position += velocity * delta
		

func set_target(new_target):
	target = weakref(new_target)

func explode():
	exploded = true
	$Sprite.hide()
	$Particles2D.set_emitting(false)
	$Explosion/Particles2D.set_emitting(true)
	$Explosion/Area2D/CollisionShape2D.set_disabled(false)
	$Explosion/Timer.start()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Timer_timeout():
	self.queue_free()

func getExplode():
	return exploded

