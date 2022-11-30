extends RigidBody2D

var currentPointingDir = Vector2.ZERO
onready var targetPointingDir = Vector2.ZERO

export var rotationSpeed: float = 1
var angle: float
var rad: float


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Rotation
	targetPointingDir = get_parent().targetUpperPointingDir
	currentPointingDir = global_position.direction_to($Sprite.global_position)#$Sprite.global_position - global_position
	
	angle = currentPointingDir.angle_to(targetPointingDir)
	rad = float(angle)

func _integrate_forces(_state):
	# Rotation
	if rad != 0: 
		angular_velocity = rad * rotationSpeed
	else:
		angular_velocity = 0
