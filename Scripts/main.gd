extends Node2D

var enemy = preload("res://Scenes/Enemy.tscn")
var score = 0

func _ready() -> void:
	SpawnEnemies()

func SpawnEnemies():
	for x in range(9):
		for y in range(3):
			var e = enemy.instantiate()
			var pos = Vector2(x * (16 + 8) + 24, y * 16 + 16 * 4)
			add_child(e)
			e.Start(pos)
			e.died.connect(_on_enemy_died)
	
func _on_enemy_died(value):
	score += value
