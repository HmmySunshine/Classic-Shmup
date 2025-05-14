extends MarginContainer
@onready var shieldBar: TextureProgressBar = $HBoxContainer/ShieldBar
@onready var scoreCounter: HBoxContainer = $HBoxContainer/ScoreCounter

func UpdateScore(score: int):
	scoreCounter.DisplayDigits(score)

func UpdateShield(maxValue: int, value: int):
	shieldBar.max_value = maxValue
	shieldBar.value = value
