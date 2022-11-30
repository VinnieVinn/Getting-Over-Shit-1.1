extends RigidBody2D

var speed: float = 80
var rotationalSpeed: float = 0

onready var target: RigidBody2D = get_parent().get_node("player")
var targetPos = Vector2.ZERO
var targetDir = Vector2.ZERO
var targetDis: float = 0
var xOffset: float = 0
var yOffset: float = -100

var waitRandomIsActive: bool = false

signal idleRight()
signal pierceRight()
signal slapRight()
signal crushRight()

signal idleLeft()
signal pierceLeft()
signal slapLeft()
signal crushLeft()

var rightArmHealth: float = 1
var leftArmHealth: float = 1

var isSecondPhase: bool = false

var enemyEyeScene = load("res://enemyEye1.tscn")

export(float) var damageStrength: float = 1
var isCollidingWithPlayer: bool = false
var collidingBody


# HP --------------------------
export(float) var maxHp: float = 1 # Was needed in order to add export keyword to hp
export(float) var maxArmHp: float = 1
var hp: float = 1 setget set_hp

var invincible: bool = false
export(float) var invincibilityTime: float = 1

signal death()
signal new_hp(hp)

func receive_damage(damage):
	if !invincible && rightArmHealth == 0 && leftArmHealth == 0:
		set_hp(hp - damage)
		
		invincible = true
		yield(get_tree().create_timer(invincibilityTime), "timeout")
		invincible = false

func set_hp(new_hp):
	if(new_hp > maxHp):
		set_hp(maxHp) 
	elif(new_hp < 0):
		hp = 0
	else:
		hp = new_hp
	
	get_node("/root/mainScene/Hud").set_bossnerHeadHealthBarAmount(new_hp, maxHp)
	
	if(hp <= 0): 
		death()
		get_node("/root/mainScene/Hud").animVictory()

func death():
	queue_free()
# /HP -------------------------


func waitRandom():
	waitRandomIsActive = true
	
	yield(get_tree().create_timer(8), "timeout")
	
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	match rand.randi_range(1, 3):
		0:
			if rand.randi_range(0, 1) == 0:
				emit_signal("idleRight")
			else:
				emit_signal("idleLeft")
		1:
			if rand.randi_range(0, 1) == 0:
				emit_signal("pierceRight")
			else:
				emit_signal("pierceLeft")
		2:
			if rand.randi_range(0, 1) == 0:
				emit_signal("slapRight")
			else:
				emit_signal("slapLeft")
		3:
			if rand.randi_range(0, 1) == 0:
				emit_signal("crushRight")
			else:
				emit_signal("crushLeft")
	
	waitRandomIsActive = false


func waitRandom2():
	waitRandomIsActive = true;
	
	yield(get_tree().create_timer(8), "timeout")
	
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	match rand.randi_range(0, 1):
		0:
			spawnEyes()
		1:
			speed *= 2.5
			rotationalSpeed *= 3
			yield(get_tree().create_timer(5), "timeout")
			speed /= 2.5
			rotationalSpeed /= 3
	
	waitRandomIsActive = false


func spawnEyes():
	$"/root/mainScene".spawnEyes()


func activateSecondPhase():
	if !isSecondPhase:
		isSecondPhase = true
		speed = 50
		rotationalSpeed = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	set_hp(maxHp)
	#state = IDLE

func _process(_delta):
	if isCollidingWithPlayer:
		collidingBody.receive_damage(damageStrength)
	
	if rightArmHealth == 0 && leftArmHealth == 0:
		activateSecondPhase()
	
	if !waitRandomIsActive:
		if rightArmHealth != 0 && leftArmHealth != 0:
			waitRandom()
		else:
			waitRandom2()
	
	if isSecondPhase:
		targetPos = target.global_position
		targetDir = lerp(targetDir, global_position.direction_to(targetPos), 0.05)
	else:
		targetPos = target.global_position + Vector2(xOffset, yOffset)
		targetDir = global_position.direction_to(targetPos)
	
	targetDis = global_position.distance_to(targetPos)
	
	#match state:
	#	IDLE:
	#		emit_signal("idle") ###
	#		waitRandom()
	#	PIERCE:
	#		emit_signal("pierce")
	#	SLAP:
	#		emit_signal("slap")
	#	CRUSH:
	#		emit_signal("crush")

func _integrate_forces(_state):
	var modifiedSpeed = speed * targetDis/20
	
	if targetDis < 64 && modifiedSpeed < speed:
		linear_velocity = targetDir * modifiedSpeed
	else:
		linear_velocity = targetDir * speed
	
	angular_velocity = rotationalSpeed


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_body_entered(body):
	if body.has_method("receive_damage"):
		isCollidingWithPlayer = true
		collidingBody = body
func _on_Area2D_body_exited(body):
	if body.has_method("receive_damage"):
		isCollidingWithPlayer = false

func _on_RightForeArm_newRightArmHealth():
	rightArmHealth = $RightForeArm.hp
	get_node("/root/mainScene/Hud").set_bossnerRightArmHealthBarAmount(rightArmHealth, maxArmHp)
	print("bruh")
func _on_LeftForeArm_newLeftArmHealth():
	leftArmHealth = $LeftForeArm.hp
	get_node("/root/mainScene/Hud").set_bossnerLeftArmHealthBarAmount(leftArmHealth, maxArmHp)
