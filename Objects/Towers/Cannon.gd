extends Area2D

#building variables
var building = true
var colliding = false
var can_build = false
var price = 100

#Holds enemies in range of tower
var enemy_array = []

#tilemap variables
onready var tilemap = get_parent().get_parent().get_node("TileMap")
var cell_size = Vector2(64, 64)
var cell_position
var cell_id
var current_tile

#Shooting Variables
var shooting = false
var current_target = null
var target_position
var distance_to_t = 1000

#shooting variables
var instance
var shot = load("res://Objects/Towers/Shots/Cannon Shot.tscn")

const RADIUS = 48

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if building:
		if Input.is_action_just_pressed("R-click"):
			get_parent().get_parent().tower_built(0)
			queue_free()
		_follow_mouse()
		if can_build:
			$Base.modulate = Color(0.0, 1.0, 0.0, 0.6)
			$Gun.modulate = Color(0.0, 1.0, 0.0, 0.6)
		else:
			$Base.modulate = Color(1.0, 0.0, 0.0, 0.6)
			$Gun.modulate = Color(1.0, 0.0, 0.0, 0.6)
		if Input.is_action_just_pressed("click") and can_build:
			building = false
			get_parent().get_parent().tower_built(price)
			$Base.modulate = Color(1.0, 1.0, 1.0, 1.0)
			$Gun.modulate = Color(1.0, 1.0, 1.0, 1.0)
			$Agro/CollisionShape2D.visible = false
	else:
		if !current_target: #if we don't currently have a target
			$ShootTimer.stop()
			if enemy_array:
				current_target = enemy_array[0]
				chose_target()
				if current_target:
					$ShootTimer.start()
		else:
			if (!current_target): #if the target has already been destroied
				current_target = null
				$ShootTimer.stop()
			else:
				if is_instance_valid(current_target):
					target_position = current_target.get_global_transform().origin
					$Gun.rotation = (target_position - position).angle() + deg2rad(90)

func _on_Agro_area_entered(area):
	if area.is_in_group("enemy"):
		enemy_array.append(area.get_parent())
		if current_target:
			chose_target()

func _on_Agro_area_exited(area):
	if area.is_in_group("enemy"):
		enemy_array.erase(area.get_parent())

func _on_ShootTimer_timeout():
		chose_target()
		if current_target:
			instance = shot.instance()
			instance.set_target(current_target)
			instance.position = $Gun/ShotPosition.get_global_transform().origin
			get_parent().add_child(instance)
			$Gun/Flame.show()
			yield(get_tree().create_timer(0.1), "timeout")
			$Gun/Flame.hide()

func _follow_mouse():
	position = get_global_mouse_position()
	cell_position = Vector2(floor(position.x / cell_size.x), floor(position.y / cell_size.y))
	cell_id = tilemap.get_cellv(cell_position)
	if cell_id != -1 && !colliding:
		current_tile = tilemap.tile_set.tile_get_name(cell_id)
		if current_tile == "Cannon Base":
			can_build = true
			position = Vector2 (cell_position.x * cell_size.x + cell_size.x / 2, cell_position.y * cell_size.y + cell_size.y / 2)
		else: 
			can_build = false


func _on_Cannon_area_entered(area):
	if area.is_in_group("towers"):
		colliding = true


func _on_Cannon_area_exited(area):
	if area.is_in_group("towers"):
		colliding = false

func chose_target():
	distance_to_t = RADIUS + 1
	if enemy_array:
		current_target = enemy_array[0]
		for target in enemy_array:
			if target.get_offset() > current_target.get_offset():
				current_target = target
				target_position = target.get_global_transform().origin
				distance_to_t = (position - target_position).length()
	else: 
		current_target = null
