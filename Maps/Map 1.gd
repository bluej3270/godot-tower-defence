extends Node2D

#enenmy spawning variables
var mob_t1 = load("res://Objects/Enemies/Tier 1.tscn")
var mob_t2 = load("res://Objects/Enemies/Tier 2.tscn")
var instance

#wave variables
var wave = 0
var t1_mobs_left = 0
var t2_mobs_left = 0
var wave_mobs = [[25, 0], [25, 5], [35, 10]]

#building variables
var building = false
var cash = 125
var Cannon_Tower = load("res://Objects/Towers/Cannon.tscn")
var Double_Cannon_Tower = load("res://Objects/Towers/Doubble Cannon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$WaveTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$UI/Cash.text = str(cash)


func _on_WaveTimer_timeout():
	t1_mobs_left = wave_mobs[wave] [0]
	t2_mobs_left = wave_mobs[wave] [1]
	$MobTimer.start()


func _on_MobTimer_timeout():
	if t1_mobs_left > 0:
		instance = mob_t1.instance()
		$Path2D.add_child(instance)
		t1_mobs_left -= 1
	if t1_mobs_left <= 0 and t2_mobs_left > 0:
		instance = mob_t2.instance()
		$Path2D.add_child(instance)
		t2_mobs_left -= 1
	if t2_mobs_left <= 0 and t1_mobs_left <= 0:
		$MobTimer.stop()
		wave += 1
		if wave < len(wave_mobs):
			$WaveTimer.start()


func _on_Cannon_pressed():
	if !building and cash >=100:
		instance = Cannon_Tower.instance()
		add_child(instance)
		building = true

func tower_built(price):
	building = false
	cash -= price

func add_cash(q):
	cash += q


func _on_Double_Cannon_pressed():
	if !building and cash >=150:
		instance = Double_Cannon_Tower.instance()
		add_child(instance)
		building = true
