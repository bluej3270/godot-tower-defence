extends Node2D

#enenmy spawning variables
var mob = load("res://Objects/Enemies/Tier 1.tscn")
var instance

#wave variables
var wave = 0
var mobs_left = 0
var wave_mobs = [1, 3, 5]

#building variables
var building = false
var cash = 50
var Cannon_Tower = load("res://Objects/Towers/Cannon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$WaveTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$UI/Cash.text = "$ " + str(cash)


func _on_WaveTimer_timeout():
	mobs_left = wave_mobs[wave]
	$MobTimer.start()


func _on_MobTimer_timeout():
	instance = mob.instance()
	$Path2D.add_child(instance)
	mobs_left -= 1
	print("mob spawned")
	if mobs_left <= 0:
		$MobTimer.stop()
		wave += 1
		if wave < len(wave_mobs):
			print("Next Wave")
			$WaveTimer.start()


func _on_Cannon_pressed():
	print("Cannon Button Pressed")
	print(building)
	if !building and cash >=25:
		instance = Cannon_Tower.instance()
		add_child(instance)
		building = true

func tower_built():
	building = false
	cash -= 25
