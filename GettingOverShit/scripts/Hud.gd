extends Control


func set_playerHealthBarAmount(newAmount: float):
	get_node("CanvasLayer/PlayerHealth").value = newAmount


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
