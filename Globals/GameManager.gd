extends Node


const LEVELS = preload("res://scenes/UI/Levels.tscn")


var data: SaveData
var current_track: String = ""



func _enter_tree() -> void:
	data = SaveData._load()


func save_best_lap(new_time: float):
	data.save_best(current_track, new_time)


func get_best_lap(track_name: String) -> float:
	return data.get_best(track_name)


func change_to_main() -> void:
	get_tree().change_scene_to_packed(LEVELS)


func change_to_track(info: TrackInfo) -> void:
	current_track = info.track_name
	get_tree().change_scene_to_packed(info.track_scene)
