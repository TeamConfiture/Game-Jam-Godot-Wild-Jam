extends Node2D


var enemyHP = 100
var ourHP = 700
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemy_attack:
		if j > 50:
			_enemy_attack()
			j = 0
		j+=1
#	pass
func _alive_count():
	return len(get_node("Sprite").get_children()) - deaths
#func _check_deaths():
	#deaths =
func _attack():
	#get_node("RollDice").disabled = true
	var damage = roll_dice(20, "Dice1")
	enemyHP -= damage
	i += 1
	if i >= _alive_count():
		enemy_attack = true
		get_node("RollDice").disabled = true
		i = 0
	
	
	
func _enemy_attack():
	var damage = roll_dice(20, "EnemyDice")
	ourHP -= damage
	enemy_attack = false
	get_node("RollDice").disabled = false

