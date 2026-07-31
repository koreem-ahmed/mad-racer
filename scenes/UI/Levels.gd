extends Control

@onready var lock_level_2: TextureRect = $"lock level 2"
@onready var lock_level_3: TextureRect = $"lock level 3"
@onready var lock_level_4: TextureRect = $"lock level 4"

var win: int

func _ready() -> void:
	get_tree().paused = false
	win = GlobalVars.wins
	print(GlobalVars.wins)

func _process(_delta: float) -> void:
	calc_win()


func calc_win() -> void:
	if win >= 1:
		if is_instance_valid(lock_level_2):
			lock_level_2.queue_free()
	if win >= 2:
		if is_instance_valid(lock_level_3):
			lock_level_3.queue_free()
	if win >= 3:
		if is_instance_valid(lock_level_4):
			lock_level_4.queue_free()
	if win >= 4:
		get_tree().change_scene_to_file("res://scenes/UI/thx_for_playing.tscn")
