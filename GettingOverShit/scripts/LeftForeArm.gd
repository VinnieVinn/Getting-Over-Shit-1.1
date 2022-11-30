extends RigidBody2D

var speed: float = 80
var rotationalSpeed: float = 1

onready var player: RigidBody2D = $"/root/mainScene/player"
onready var bossner: RigidBody2D = get_parent()
var targetPos = Vector2.ZERO
var targetDir = Vector2.ZERO
var targetDis: float = 0
onready var parentOffset = Vector2(bossner.xOffset, bossner.yOffset)
var offset = Vector2(-100,20)


var targetUpperPointingDir = Vector2.ZERO setget set_target_upper_pointing_direction

var currentPointingDir = Vector2.ZERO
var targetPointingDir = Vector2.ZERO setget set_target_pointing_direction

var angle: float
var rad: float

var idle: bool = true
var lockOn: bool = false

export(float) var damageStrength = 0 
var isCollidingWithPlayer = false
var collidingBody

signal newLeftArmHealth()


# HP --------------------------
onready var maxHp: float = get_parent().maxArmHp # Was needed in order to add export keyword to hp
var hp: float = 1 setget set_hp

var invincible: bool = false
export(float) var invincibilityTime: float = 1

signal death()
signal new_hp(hp)

func receive_damage(damage):
	if !invincible:
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
	
	emit_signal("newLeftArmHealth")
	
	if(hp <= 0): 
		death()
		print("Bossner's left arm is no more...")

func death():
	queue_free()
# /HP -------------------------




func get_playerDir():
	return global_position.direction_to(player.global_position)


func set_target_upper_pointing_direction(dir: Vector2):
	targetUpperPointingDir = global_position.direction_to(global_position + dir)

func set_target_pointing_direction(dir: Vector2):
	targetPointingDir = global_position.direction_to(global_position + dir)

func set_default_pointing_directions():
	set_target_pointing_direction(Vector2(2,1))
	set_target_upper_pointing_direction(Vector2(1,-1))


# Called when the node enters the scene tree for the first time.
func _ready():
	set_hp(maxHp)
	set_default_pointing_directions()


func _process(_delta):
	if isCollidingWithPlayer:
		collidingBody.receive_damage(damageStrength)
	
	# Movement
	if idle:
		targetPos = player.global_position + parentOffset + offset
	
	if lockOn:
		set_target_pointing_direction(get_playerDir())
		set_target_upper_pointing_direction(get_playerDir()*-1)
	
	
	targetDir = global_position.direction_to(targetPos)
	targetDis = global_position.distance_to(targetPos)
	
	# Rotation
	currentPointingDir = global_position.direction_to($Sprite.global_position)
	
	angle = currentPointingDir.angle_to(targetPointingDir)
	rad = float(angle)


func _integrate_forces(_state):
	# Movement
	var modifiedSpeed = speed * targetDis/20
	
	if targetDis < 64 && modifiedSpeed < speed:
		linear_velocity = targetDir * modifiedSpeed
	else:
		linear_velocity = targetDir * speed
	
	
	# Rotation
	if rad != 0: 
		angular_velocity = rad * rotationalSpeed
	else:
		angular_velocity = 0


func _on_Area2D_body_entered(body):
	if body.has_method("receive_damage"):
		isCollidingWithPlayer = true
		collidingBody = body
func _on_Area2D_body_exited(body):
	if body.has_method("receive_damage"):
		isCollidingWithPlayer = false




func _on_AndersBossner_idleLeft():
	pass


func _on_AndersBossner_pierceLeft():
	lockOn = true
	
	yield(get_tree().create_timer(4), "timeout")
	
	lockOn = false
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	idle = false
	speed *= 4
	targetPos = player.global_position
	
	yield(get_tree().create_timer(2), "timeout")
	
	speed /= 4
	idle = true
	set_default_pointing_directions()


func _on_AndersBossner_slapLeft():
	set_target_pointing_direction(Vector2.LEFT)
	set_target_upper_pointing_direction(Vector2(-2,1))
	
	yield(get_tree().create_timer(1), "timeout")
	
	idle = false
	speed *= 3
	targetPos = player.global_position + Vector2(offset.x, -30)
	
	yield(get_tree().create_timer(1), "timeout")
	
	rotationalSpeed *= 3
	#targetPos = player.global_position + Vector2(global_position.distance_to(player.global_position),0) #(player.global_position - global_position) #
	player.global_position + Vector2(player.global_position.x, 0)
	set_target_pointing_direction(Vector2.RIGHT)
	
	yield(get_tree().create_timer(3), "timeout")
	
	set_default_pointing_directions()
	idle = true
	
	yield(get_tree().create_timer(1), "timeout")
	
	rotationalSpeed /= 3
	speed /= 3


func _on_AndersBossner_crushLeft():
	set_target_pointing_direction(Vector2.LEFT)
	set_target_upper_pointing_direction(Vector2.RIGHT)
	
	yield(get_tree().create_timer(0.6), "timeout")
	
	idle = false
	speed *= 4
	targetPos = player.global_position + Vector2(0, -50)
	
	yield(get_tree().create_timer(2), "timeout")
	
	speed /= 4
	targetPos = global_position + Vector2(0, 100)
	
	yield(get_tree().create_timer(2), "timeout")
	
	set_default_pointing_directions()
	idle = true

