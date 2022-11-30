extends KinematicBody2D


export(float) var speed: float = 1
var velocity = Vector2()
var targetDirection = Vector2()
export(float) var movementLerpAmount: float = 1

onready var target = $"/root/mainScene/player"
export(float) var closestDistanceToTarget: float = 1

var smooth_look_at = Vector2()

export(float) var damageStrength: float = 1
var isCollidingWithPlayer: bool = false
var collidingBody



# HP --------------------------
export(float) var export_hp: float = 1 # Was needed in order to add export keyword to hp
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
	set_healthBarAmount(new_hp)
	
	if(hp <= 0): 
		death()

func death():
	queue_free()
# /HP -------------------------

func set_healthBarAmount(newAmount: float):
	$TextureProgress.value = newAmount


# Called when the node enters the scene tree for the first time.
func _ready():
	set_hp(export_hp)
	$Sprite.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if isCollidingWithPlayer:
		collidingBody.receive_damage(damageStrength)


func _physics_process(_delta):
	# Movement:
	# if distance to player > closestDistanceToTarget: accelerate
	if global_position.distance_to(target.global_position) > closestDistanceToTarget:
		targetDirection = lerp(targetDirection, global_position.direction_to(target.global_position), movementLerpAmount) # A delayed lock-on to the player (thansk to lerp())
		velocity = move_and_slide(targetDirection * speed)
	else:
		velocity = move_and_slide(Vector2.ZERO)
	
	# Smooth rotation pointing to the player:
	smooth_look_at = lerp(smooth_look_at, target.global_position, 0.1)
	$Sprite.look_at(smooth_look_at)


func _on_Area2D_body_entered(body):
	if body.has_method("receive_damage"):
		isCollidingWithPlayer = true
		collidingBody = body
func _on_Area2D_body_exited(body):
	if body.has_method("receive_damage"):
		isCollidingWithPlayer = false
