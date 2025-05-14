extends Area2D

signal died

var speed: float = 0
var startPosition: Vector2 = Vector2.ZERO
var bulletScene = preload("res://Scenes/EnemyBullet.tscn")
@onready var screenSize: Vector2 = get_viewport_rect().size

func _process(delta: float) -> void:
	#超出屏幕外重置
	position.y += speed * delta
	if position.y > screenSize.y + 32:
		Start(startPosition)

func PlayEntryAnimation():
	
	await get_tree().create_timer(randf_range(0.25, 0.55)).timeout
	var tween: Tween = create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", startPosition.y, 1.4)
	await tween.finished


func StartActivityTimers():
	StartMoveTimers()
	StartShootTimers()

func StartMoveTimers(moveMinTime: float = 5.0, moveMaxTime: float = 20.0):
	# ⭐ 注意：设置默认值时，类型提示 float 后面直接跟 = 默认值 ⭐
	# ⭐ 默认值必须是常量 ⭐
	$MoveTimer.wait_time = randf_range(moveMinTime, moveMaxTime) # 使用参数设置 MoveTimer 的时间
	$MoveTimer.start()
	
func StartShootTimers(shootMinTime: float = 4.0, shootMaxTime: float = 20.0):
	$ShootTimer.wait_time = randf_range(shootMinTime, shootMaxTime) # 使用参数设置 ShootTimer 的时间
	$ShootTimer.start()

func Start(pos: Vector2):
	speed = 0
	position = Vector2(pos.x, -pos.y)
	startPosition = pos
	#将敌人放在屏幕外的位置
	PlayEntryAnimation()
	StartActivityTimers()

func _on_move_timer_timeout() -> void:
	speed = randf_range(75, 100)

func _on_shoot_timer_timeout() -> void:
	var b = bulletScene.instantiate()
	get_tree().root.add_child(b)
	b.Start(position)
	StartShootTimers()

func Explode():
	speed = 0
	$AnimationPlayer.play("explode")
	#不再碰撞检测
	set_deferred("monitoring", false)
	#加五分
	died.emit(5)
	await $AnimationPlayer.animation_finished
	queue_free()
