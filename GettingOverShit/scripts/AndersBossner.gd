extends RigidBody2D

var speed: float = 80
var rotationalSpeed: float = 1

onready var target: RigidBody2D = get_parent().get_node("player")
var targetPos = Vector2.ZERO
var targetDir = Vector2.ZERO
var targetDis: float = 0
var xOffset: float = 0
var yOffset: float = -300

# HP --------------------------
export(float) var maxHp: float = 1 # Was needed in order to add export keyword to hp
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
	hp = new_hp
	
	if(hp <= 0): 
		death()
		print("Bossner is no more...")

func death():
	queue_free()
# /HP -------------------------


# Called when the node enters the scene tree for the first time.
func _ready():
	set_hp(maxHp)

func _process(_delta):
	targetPos = target.global_position + Vector2(xOffset, yOffset)
	targetDir = global_position.direction_to(targetPos)
	targetDis = global_position.distance_to(targetPos)

func _integrate_forces(_state):
	var modifiedSpeed = speed * targetDis/20
	
	if targetDis < 64 && modifiedSpeed < speed:
		linear_velocity = targetDir * modifiedSpeed
	else:
		linear_velocity = targetDir * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
