extends Area2D

signal died
signal shield_changed
var canShoot: bool = true
@export var speed: float = 150
@export var coolDown = 0.25
@export var bulletScene: PackedScene
@export var maxShield = 10 # 护盾值

#设置值的时候会调用函数
var shield = maxShield:
	set = SetShield

@onready var screenSize = get_viewport_rect().size
@onready var clampMinSize = Vector2(8, 8)
@onready var clampMaxSize = screenSize - clampMinSize
@onready var startPosition: Vector2 = Vector2(screenSize.x / 2, screenSize.y - 64)

func SetShield(value: int):
	shield = min(maxShield, value)
	shield_changed.emit(maxShield, shield)
	if shield <= 0:
		hide()
		died.emit()
		
func _ready() -> void:
	Start()
	
func Start():
	position = startPosition
	$GunCooldown.wait_time = 0.25
	shield = 10

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

#触碰敌人护盾值减少
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_bullet"):
		shield -= maxShield / 4
	
	if area.is_in_group("enemies"):
		area.Explode()
		shield -= maxShield / 2
