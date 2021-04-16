extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(".").connect("pressed", self, "_change_scene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _change_scene():
	get_tree().change_scene("res://Fight 1.tscn")
