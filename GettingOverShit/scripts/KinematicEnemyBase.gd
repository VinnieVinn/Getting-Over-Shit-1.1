extends KinematicBody2D


export(float) var speed: float = 1
var velocity = Vector2()

export(float) var damageStrength: float = 1

export(float) var maxHp: float = 1 # Was needed in order to add export keyword to hp
var hp: float = 1 setget set_hp

var invincible: bool = false
export(float) var invincibilityTime: float = 1


signal death()
signal new_hp(hp)


# Makes the entity receive damage
func receive_damage(damage):
	if !invincible:
		set_hp(hp - damage)
		
		invincible = true
		tempTimer(invincibilityTime)
		invincible = false


# Sets HP of the entity
func set_hp(new_hp):
	hp = new_hp
	
	if(hp <= 0): 
		death()


func death():
	queue_free()


# Movement
func move():
	velocity = move_and_slide(velocity)


# Creates a temporary timer
func tempTimer(time):
	yield(get_tree().create_timer(time), "timeout")


# Called when the node enters the scene tree for the first time.
func _ready():
	set_hp(maxHp)


func _physics_process(_delta):
	move()
