extends HBoxContainer

var digitCoords:Dictionary = {
	1: Vector2(0, 0),
	2: Vector2(8, 0),
	3: Vector2(16, 0),
	4: Vector2(24, 0),
	5: Vector2(32, 0),
	6: Vector2(0, 8),
	7: Vector2(8, 8),
	8: Vector2(16, 8),
	9: Vector2(24, 8),
	0: Vector2(32, 8)
}

func _ready() -> void:
	pass

func DisplayDigits(n: int):
	#这段保留没看懂要干嘛为什么不是直接字典[i]
	#00000258
	#var s = "%08d" % n
	var s = str(n).pad_zeros(8)
	for i in 8:
		get_child(i).texture.region = Rect2(digitCoords[int(s[i])], Vector2(8, 8))
