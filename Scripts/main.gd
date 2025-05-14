extends Node2D

var enemy: Resource = preload("res://Scenes/Enemy.tscn")
var score: int = 0

@onready var startButton: TextureButton = $CanvasLayer/CenterContainer/StartButton
@onready var gameOverButton: TextureButton = $CanvasLayer/CenterContainer/GameOverButton

func _ready() -> void:
	$AudioStreamPlayer.play()
	gameOverButton.hide()
	
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
	$CanvasLayer/UI.UpdateScore(score)

func NewGame():
	score = 0
	$CanvasLayer/UI.UpdateScore(score)
	$Player.Start()
	SpawnEnemies()


func _on_start_button_pressed() -> void:
	$Player.show()
	gameOverButton.hide()
	startButton.hide()
	NewGame()

func _on_player_died() -> void:
	get_tree().call_group("enemies", "queue_free")
	gameOverButton.show()
	await get_tree().create_timer(2).timeout
	gameOverButton.hide()
	startButton.show()
