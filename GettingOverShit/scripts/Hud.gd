extends Control

onready var animationPlayer = get_node("CanvasLayer/AnimationPlayer")


func calculatePercentage(value: float, maxValue: float):
	return 100 * (value / maxValue)

func set_playerHealthBarAmount(newValue: float, maxValue: float):
	get_node("CanvasLayer/PlayerHealth").max_value = maxValue
	get_node("CanvasLayer/PlayerHealth").value = newValue

func set_bossnerHeadHealthBarAmount(newValue: float, maxValue: float):
	get_node("CanvasLayer/BossnerHeadHealth").max_value = maxValue
	get_node("CanvasLayer/BossnerHeadHealth").value = newValue
	
	if newValue <= 0:
		get_node("CanvasLayer/BossnerHeadHealth").visible = false
		get_node("CanvasLayer/BossnerRightArmHealth").visible = false
		get_node("CanvasLayer/BossnerLeftArmHealth").visible = false

func set_bossnerRightArmHealthBarAmount(newValue: float, maxValue: float):
	get_node("CanvasLayer/BossnerRightArmHealth").max_value = maxValue
	get_node("CanvasLayer/BossnerRightArmHealth").value = newValue

func set_bossnerLeftArmHealthBarAmount(newValue: float, maxValue: float):
	get_node("CanvasLayer/BossnerLeftArmHealth").max_value = maxValue
	get_node("CanvasLayer/BossnerLeftArmHealth").value = newValue

func animVictory():
	yield(get_tree().create_timer(1), "timeout")
	
	get_node("CanvasLayer/ColorRect").visible = true
	get_node("CanvasLayer/Label").visible = true
	
	animationPlayer.play("fadeIn")
	yield(get_tree().create_timer(4), "timeout")
	animationPlayer.play("fadeOut")


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("CanvasLayer/ColorRect").visible = false
	get_node("CanvasLayer/Label").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
