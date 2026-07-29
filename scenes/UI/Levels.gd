extends Control

@onready var lock_level_2: TextureRect = $"lock level 2"
@onready var lock_level_3: TextureRect = $"lock level 3"
@onready var lock_level_4: TextureRect = $"lock level 4"

var win: int = 0

func _ready() -> void:
	get_tree().paused = false

func _process(_delta: float) -> void:
	calc_win()


func calc_win() -> void:
	if win > 1:
		lock_level_2.queue_free()
	if win > 2:
		lock_level_3.queue_free()
	if win > 3:
		lock_level_4.queue_free()
