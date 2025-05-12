extends Area2D

@export var speed: float = 150
@onready var screenSize = get_viewport_rect().size
@onready var clampMinSize = Vector2(8, 8)
@onready var clampMaxSize = screenSize - clampMinSize

func _process(delta: float) -> void:
	var input = GetDirection()
	if MoveRight(input.x):
		$Ship.frame = 2
		$Ship/Boosters.animation = "right"
	elif MoveLeft(input.x):
		$Ship.frame = 0
		$Ship/Boosters.animation = "left"
	else:
		$Ship.frame = 1
		$Ship/Boosters.animation = "forward"
	MoveMent(delta, input)

func GetDirection():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func MoveRight(dirX: float):
	return dirX > 0

func MoveLeft(dirX: float):
	return dirX < 0
	
func MoveMent(delta: float, direction: Vector2):
	position += speed * delta * direction
	position = position.clamp(clampMinSize, clampMaxSize)
