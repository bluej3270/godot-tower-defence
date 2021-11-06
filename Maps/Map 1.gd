extends Node2D
var esc_visible = false

#enenmy spawning variables
var mob_t1 = load("res://Objects/Enemies/Tier 1.tscn")
var mob_t2 = load("res://Objects/Enemies/Tier 2.tscn")
var instance

#wave variables
var wave = 0
var t1_mobs_left = 0
var t2_mobs_left = 0
var wave_mobs = [[10, 0, 10], [15, 0, 20], [20, 5, 25], [50, 5, 50], [10, 15, 50], [100, 30, 50], [150, 60, 100], [0, 100, 100]]

#building variables
var building = false
var cash = 150
var Cannon_Tower = load("res://Objects/Towers/Cannon.tscn")
var Double_Cannon_Tower = load("res://Objects/Towers/Doubble Cannon.tscn")
var Missle_Tower = load("res://Objects/Towers/MissleLauncher.tscn")
var Double_Missle_Tower = load("res://Objects/Towers/Doubble Missle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$WaveTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
		cash += wave_mobs[wave] [2]
		wave += 1
		if wave < len(wave_mobs):
			$WaveTimer.start()


func _on_Cannon_pressed():
	if !building and cash >=100:
		instance = Cannon_Tower.instance()
		get_node("Towers").add_child(instance)
		building = true

func tower_built(price):
	building = false
	cash -= price

func add_cash(q):
	cash += q


func _on_Double_Cannon_pressed():
	if !building and cash >=150:
		instance = Double_Cannon_Tower.instance()
		get_node("Towers").add_child(instance)
		building = true

func set_cash(num):
	cash = num


func _on_Missle_pressed():
	if !building and cash >=300:
		instance = Missle_Tower.instance()
		get_node("Towers").add_child(instance)
		building = true


func _on_Double_Missle_pressed():
	if !building and cash >=450:
		instance = Double_Missle_Tower.instance()
		get_node("Towers").add_child(instance)
		building = true
