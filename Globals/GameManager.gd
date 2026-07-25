extends Node


const LEVELS = preload("res://scenes/UI/Levels.tscn")



func change_to_main() -> void:
	get_tree().change_scene_to_packed(LEVELS)



func change_to_track(info: TrackInfo) -> void:
	get_tree().change_scene_to_packed(info.track_scene)
