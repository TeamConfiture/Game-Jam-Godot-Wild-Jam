extends Node2D


var enemyHP = 700
var ourHP = [70,70,70,70,70,70,70]
var i = 0
var enemy_attack = false
var j = 0
var deaths = 0
func roll_dice(dice: int, object: String):
	var roll = randi() % dice
	get_node(object + "/Label").text = str(roll + 1)
	get_node(object).visible = true
	get_node(object + "/DiceSound").play(0)
	return roll + 1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_node("RollDice").connect("pressed", self, "_attack")
	get_node("AudioStreamPlayer").play(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _alive_count() == 0 || enemyHP == 0:
		get_tree().change_scene("res://SplashScreen.tscn")
	if enemy_attack:
		if j > 50:
			_enemy_attack()
			j = 0
		j+=1
#	pass
func _alive_count():
	return len(get_node("Sprite").get_children()) - ourHP.count(0)
func _change_life(nb: int):
	get_node("Sprite").get_child(nb).get_child(0).region_enabled = true 
	get_node("Sprite").get_child(nb).get_child(0).set_region_rect(Rect2((1-ourHP[nb]/70.0)*361,0,361,328))
	get_node("Sprite").get_child(nb).get_child(0).set_offset(Vector2((1-ourHP[nb]/70.0)*361,0))
	print(ourHP[nb]/70.0)
	
	
func _attack():
	#get_node("RollDice").disabled = true
	var damage = roll_dice(20, "Dice1")
	if (damage < enemyHP):
		enemyHP -= damage
	else:
		enemyHP = 0
	i += 1
	if i == _alive_count():
		enemy_attack = true
		get_node("RollDice").disabled = true
		i = 0
	
	
	
func _enemy_attack():
	var damage = roll_dice(20, "EnemyDice") #/ _alive_count() # requires _check_deaths
	var nb = rand_range(0,6)
	while (ourHP[nb] == 0):
		nb = rand_range(0,6)
	if (damage < ourHP[nb]):
		ourHP[nb] -= damage
	else:
		ourHP[nb] = 0
	_change_life(nb)
	enemy_attack = false
	get_node("RollDice").disabled = false

