extends Node2D


var enemyHP = 3400
var ourHP = [70,70,70,70,70,70,70]
var turn = 1
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
	

var posChatsX = [100, 230, 380, 515, 700, 830, 950]

func _attack():
	get_node("Dice1").visible = true
	get_node("EnemyDice").visible = false
	
	if turn >= 7:
		turn = 1
		enemy_attack = true
		get_node("RollDice").disabled = true
		get_node("pointer").position.x = 400
		get_node("pointer").position.y = 50
		return
	
	if ourHP[turn] == 0:
		turn += 1
		_attack()
		
	get_node("pointer").position.x = posChatsX[turn]
	
	var damage = roll_dice(20, "Dice1")
	if (damage < enemyHP):
		enemyHP -= damage
	else:
		enemyHP = 0
	
	turn += 1
	
	"""
	if (get_node("pointer").position.x <= 1100):
		var j = 0 if turn+1 == _alive_count() else turn+1
		get_node("pointer").position.x += 150
		while (ourHP[j] == 0):
			print("<= 1100 Le chat  " + str(j) + " a " + str(ourHP[j]) + "HP")
			get_node("pointer").position.x += 150
			j += 1
			if get_node("pointer").position.x >= 1100:
				get_node("pointer").position.x += 100
				j = 0
	else:
		var j = 0
		get_node("pointer").position.x = 100
		while (ourHP[j] == 0):
			print("Le chat  " + str(j) + " a " + str(ourHP[j]) + "HP")
			get_node("pointer").position.x += 150
			j += 1
	#get_node("RollDice").disabled = true
	var damage = roll_dice(20, "Dice1")
	if (damage < enemyHP):
		enemyHP -= damage
	else:
		enemyHP = 0
	turn += 1
	if turn == _alive_count():
		enemy_attack = true
		get_node("RollDice").disabled = true
		turn = 0
		get_node("pointer").position.x = 400
		get_node("pointer").position.y = 50
	"""
	
	
func _enemy_attack():
	get_node("Dice1").visible = false
	get_node("EnemyDice").visible = true
	var damage = roll_dice(50, "EnemyDice") #/ _alive_count() # requires _check_deaths
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
				break
				print(posChatsX[i])
		
		get_node("pointer").position.y = 348.107
		
		#print("Le chat numéro" + str(nb) + " a " + str(ourHP[nb]) + "HP")
		get_node("RollDice").disabled = false
		"""var j = 0
		get_node("pointer").position.x = 100
		while (ourHP[j] == 0):
			print("Le chat  " + str(j) + " a " + str(ourHP[j]) + "HP")
			get_node("pointer").position.x += 150
			j += 1
		get_node("pointer").position.y = 348.107
		"""
