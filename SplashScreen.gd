extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("credits_hover").connect("pressed", self, "_show_credits")
	get_node("Credits").connect("pressed", self, "_hide_credits")
	get_node("quit_hover").connect("pressed", self, "_quit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _show_credits():
	get_node("Credits").visible = true
	
func _hide_credits():
	get_node("Credits").visible = false
	
func _quit():
	get_tree().quit(0)
