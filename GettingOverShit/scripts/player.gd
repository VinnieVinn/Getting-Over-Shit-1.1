extends RigidBody2D


var globalPos = Vector2()
var swordPos = Vector2()

export(float) var maxVelocity: float = 100
export(float) var damageStrength: float = 1
export(float) var lifeSteal: float = 0



# HP --------------------------
export(float) var maxHp: float = 1 # Was needed in order to add export keyword to hp
var hp: float = 1 setget set_hp

var invincible: bool = false
export(float) var invincibilityTime: float = 1

signal death()
signal new_hp(hp)

func receive_damage(amount):
	if !invincible:
		set_hp(hp - amount)
		
		invincible = true
		yield(get_tree().create_timer(invincibilityTime), "timeout")
		invincible = false

func add_hp(amount):
	set_hp(hp + amount)

func set_hp(new_hp):
	if(new_hp > maxHp):
		set_hp(maxHp) 
	elif(new_hp < 0):
		hp = 0
	else:
		hp = new_hp
	
	get_node("/root/mainScene/Hud").set_playerHealthBarAmount(new_hp, maxHp)
	
	if(hp <= 0): 
		death()

func death():
	print("DEAD")
	get_tree().quit()
# /HP --------------------------



# Called when the node enters the scene tree for the first time.
func _ready():
	set_hp(maxHp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	swordPos = $sword/TempSword.global_position
	globalPos = global_position
	
	if swordPos.x < globalPos.x:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false




# was made to limit the speed of the player, but it didn't work :(
#func _integrate_forces(state):
#	if state.linear_velocity.length() > maxVelocity:
#		var force = state.linear_velocity.normalized() * -5
#			state.add_central_force(force)
