extends Area2D

#building variables
var building = true
var colliding = false
var can_build = false
#Holds enemies in range of tower
var enemy_array = []

#tilemap variables
onready var tilemap = get_parent().get_node("TileMap")
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
		_follow_mouse()
		if can_build:
			$Base.modulate = Color(0.0, 1.0, 0.0, 0.6)
			$Gun.modulate = Color(0.0, 1.0, 0.0, 0.6)
		else:
			$Base.modulate = Color(1.0, 0.0, 0.0, 0.6)
			$Gun.modulate = Color(1.0, 0.0, 0.0, 0.6)
		if Input.is_action_just_pressed("click") and can_build:
			building = false
			get_parent().tower_built()
			$Base.modulate = Color(1.0, 1.0, 1.0, 1.0)
			$Gun.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		if !current_target: #if we don't currently have a target
			distance_to_t = RADIUS + 1
			current_target = weakref(enemy_array[0])
			print ("Weekref to target")
			target_position = current_target.get_global_transform().origin
			distance_to_t = (position - target_position).length()
			if current_target:
				print("There is a Current Target")
				$ShootTimer.start()
		else:
			if (!current_target.get_ref()): #if the target has already been destroied
				current_target = null
				$ShootTimer.stop()
			else:
				target_position = current_target.get_ref().get_global_transform().origin
				$Gun.rotation = (target_position - position).angle()
				

func _on_Agro_area_entered(area):
	if area.is_in_group("enemy"):
		print("Agro Area Entered")
		enemy_array.append(area.get_parent())


func _on_Agro_area_exited(area):
	if area.is_in_group("enemy"):
		print("Agro Area Exited")
		enemy_array.erase(area.get_parent())
	if !building:
		print (building)
		if area.get_parent() == current_target.get_ref():
			current_target = null
			$ShootTimer.stop()


func _on_ShootTimer_timeout():
	if current_target.get_ref():
		instance = shot.instance()
		instance.set_target(current_target.get_ref())
		instance.position = $Gun/ShotPosition.get_global_transform().origin
		get_parent().add_child(instance)

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
