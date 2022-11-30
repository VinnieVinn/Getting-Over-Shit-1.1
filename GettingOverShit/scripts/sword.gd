extends RigidBody2D

var angle
var rad: float

var relSwordPos = Vector2()
var relMousePos = Vector2()

export(float) var rotationSpeed: float = 1
onready var originalRotationSpeed: float = rotationSpeed
export(float) var onContactSpeedMultiplier: float = 1
var collidingBodies: int = 0

var globalPos = Vector2()
var lastGlobalPos = Vector2()

onready var damageStrength: float = get_parent().damageStrength
onready var lifeSteal: float = get_parent().lifeSteal


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# $Label.text = String(rotationSpeed)
	
	relSwordPos = $TempSword.global_position - global_position
	relMousePos = get_global_mouse_position() - global_position
	
	angle = relSwordPos.angle_to(relMousePos)
	rad = float(angle)


# Made for handling forces
func _integrate_forces(_state): 
	# Movement:
	if rad != 0: 
		angular_velocity = rad * rotationSpeed
	else:
		angular_velocity = 0


func _on_Area2D_body_entered(body):
	collidingBodies += 1
	
	if collidingBodies == 1:
		rotationSpeed *= onContactSpeedMultiplier
	
	if body.has_method("receive_damage"):
		body.receive_damage(damageStrength)
		get_parent().add_hp(damageStrength * lifeSteal)


func _on_Area2D_body_exited(_body):
	collidingBodies -= 1
	
	if collidingBodies == 0:
		rotationSpeed = originalRotationSpeed
