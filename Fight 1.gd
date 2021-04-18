extends Node2D

var MAX_ENEMY_HP = 1600
var enemyHP = MAX_ENEMY_HP
var ourHP = [70,70,70,70,70,70,70]
var turn = 0
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
	if enemyHP == 0:
		get_tree().change_scene("res://Victory.tscn")
	elif _alive_count() == 0:
		get_tree().change_scene("res://Loose.tscn")
	if enemy_attack:
		get_node("RollDice").disabled = true
		get_node("pointer").position.x = 620
		get_node("pointer").position.y = 170
		if j > 50:
			_enemy_attack()
			j = 0
		j+=1


func _alive_count():
	return len(get_node("Sprite").get_children()) - ourHP.count(0)

func _change_life(nb: int):
	get_node("Sprite").get_child(nb).get_child(0).region_enabled = true 
	get_node("Sprite").get_child(nb).get_child(0).set_region_rect(Rect2((1-ourHP[nb]/70.0)*361, 0, 361, 328))
	get_node("Sprite").get_child(nb).get_child(0).set_offset(Vector2((1-ourHP[nb]/70.0)*361,0))



var posChatsX = [90, 230, 380, 515, 700, 830, 950]

func _attack():
	get_node("Dice1").visible = true
	get_node("EnemyDice").visible = false
	
	if turn >= 6:
		turn = 0
		enemy_attack = true
		
	
	if ourHP[turn + 1] == 0:
		turn += 1
		_attack()
		return
	
	get_node("pointer").position.x = posChatsX[turn+1]
	
	var damage = roll_dice(20, "Dice1")
	if (damage < enemyHP):
		enemyHP -= damage
		get_node("life").region_enabled = true
		var w = 361
		var h = 328
		get_node("life").set_region_rect(Rect2((1-float(enemyHP)/float(MAX_ENEMY_HP))*w, 0, w, h))
		get_node("life").set_offset(Vector2((1-float(enemyHP)/float(MAX_ENEMY_HP))*w, 0))
	else:
		enemyHP = 0
	
	turn += 1

func _enemy_attack():
	get_node("Dice1").visible = false
	get_node("EnemyDice").visible = true
	var damage = roll_dice(30, "EnemyDice") #/ _alive_count() # requires _check_deaths
	var nb = randi()%7
	while (ourHP[nb] == 0):
		nb = randi()%7
	if (damage < ourHP[nb]):
		ourHP[nb] -= damage
	else:
		ourHP[nb] = 0
	_change_life(nb)
	enemy_attack = false
	if(_alive_count() > 0):
		for i in range (7):
			if ourHP[i] > 0:
				get_node("pointer").position.x = posChatsX[i]
				turn = i
				break
		
		get_node("pointer").position.y = 348.107
		get_node("RollDice").disabled = false
