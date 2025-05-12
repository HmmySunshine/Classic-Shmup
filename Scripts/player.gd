extends Area2D

var canShoot: bool = true
@export var speed: float = 150
@export var coolDown = 0.25
@export var bulletScene: PackedScene

@onready var screenSize = get_viewport_rect().size
@onready var clampMinSize = Vector2(8, 8)
@onready var clampMaxSize = screenSize - clampMinSize
@onready var startPosition: Vector2 = Vector2(screenSize.x / 2, screenSize.y - 64)


func _ready() -> void:
	Start()
	
func Start():
	position = startPosition
	$GunCooldown.wait_time = 0.25

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
	if Input.is_action_pressed("shoot"):
		Shoot()

func Shoot():
	if not canShoot:
		return
	canShoot = false
	$GunCooldown.start()
	SpawnBullet()
	
func SpawnBullet():
	var bullet = bulletScene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.Start($BulletPosition.global_position)

func GetDirection():
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

func MoveRight(dirX: float):
	return dirX > 0

func MoveLeft(dirX: float):
	return dirX < 0
	
func MoveMent(delta: float, direction: Vector2):
	position += speed * delta * direction
	position = position.clamp(clampMinSize, clampMaxSize)


func _on_gun_cooldown_timeout() -> void:
	canShoot = true
