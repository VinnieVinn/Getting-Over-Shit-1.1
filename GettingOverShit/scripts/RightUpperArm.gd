extends RigidBody2D

var currentPointingDir = Vector2.ZERO
var targetPointingDir = Vector2.ZERO setget set_target_pointing_direction

export var rotationSpeed: float = 1
var angle: float
var rad: float

func set_target_pointing_direction(dir: Vector2):
	targetPointingDir = global_position.direction_to(global_position + dir)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_target_pointing_direction(Vector2(-1,-1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Rotation
	currentPointingDir = global_position.direction_to($Sprite.global_position)#$Sprite.global_position - global_position
	
	angle = currentPointingDir.angle_to(targetPointingDir)
	rad = float(angle)

func _integrate_forces(_state):
	# Rotation
	if rad != 0: 
		angular_velocity = rad * rotationSpeed
	else:
		angular_velocity = 0
