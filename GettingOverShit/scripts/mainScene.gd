extends Node2D

var enemyEyeScene = load("res://enemyEye1.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func spawnEyes():
	var enemyEyeRight = enemyEyeScene.instance()
	var enemyEyeLeft = enemyEyeScene.instance()
	
	print("hej")
	
	enemyEyeRight.position = get_node("AndersBossner/RightEyePos").global_position
	enemyEyeLeft.position = get_node("AndersBossner/LeftEyePos").global_position
	
	call_deferred("add_child", enemyEyeRight)
	call_deferred("add_child", enemyEyeLeft)
