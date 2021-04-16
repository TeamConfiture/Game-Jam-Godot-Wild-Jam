extends Node2D


var enemyHP = 100
var ourHP = 500
var team_attacked = false
var i = 0
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
	if (team_attacked):
		if (i > 50):
			_enemy_attack()
		i+=1
#	pass

func _attack():
	get_node("RollDice").disabled = true
	var damage = roll_dice(20, "Dice1")
	enemyHP -= damage
	if (enemyHP < 0):
		print("l'ennemi perd")
	team_attacked = true
	i = 0
	
	
	
func _enemy_attack():
	var damage = roll_dice(20, "EnemyDice")
	ourHP -= damage
	if (ourHP < 0):
		print("les amis perdent")
	team_attacked = false
	get_node("RollDice").disabled = false

