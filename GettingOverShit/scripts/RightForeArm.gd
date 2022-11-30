extends RigidBody2D

var speed: float = 80
var rotationalSpeed: float = 1

onready var target: RigidBody2D = $"/root/mainScene/player"
var targetPos = Vector2.ZERO
var targetDir = Vector2.ZERO
var targetDis: float = 0
onready var xOffset: float = get_parent().get_parent().xOffset + 100
onready var yOffset: float = get_parent().get_parent().yOffset + 40

var currentPointingDir = Vector2.DOWN
var targetPointingDir = Vector2.ZERO setget set_target_pointing_direction

export var rotationSpeed: float = 1
var angle: float
var rad: float

func set_target_pointing_direction(dir: Vector2):
	targetPointingDir = global_position.direction_to(global_position + dir)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_target_pointing_direction(Vector2.DOWN)


func _process(_delta):
	targetPos = target.global_position + Vector2(xOffset, yOffset)
	targetDir = global_position.direction_to(targetPos)
	targetDis = global_position.distance_to(targetPos)
	
	
	# Rotation
	currentPointingDir = global_position.direction_to($Sprite.global_position)#$Sprite.global_position - global_position
	
	angle = currentPointingDir.angle_to(targetPointingDir)
	rad = float(angle)


func _integrate_forces(_state):
	var modifiedSpeed = speed * targetDis/20
	
	if targetDis < 64 && modifiedSpeed < speed:
		linear_velocity = targetDir * modifiedSpeed
	else:
		linear_velocity = targetDir * speed
	
	
	# Rotation
	if rad != 0: 
		angular_velocity = rad * rotationSpeed
	else:
		angular_velocity = 0
