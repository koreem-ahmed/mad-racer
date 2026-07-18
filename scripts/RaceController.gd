extends Node


class_name RaceController


func _enter_tree() -> void:
	EventHub.on_lap_completed.emit()
	
	
	
func emit_on_lap_completed(info: LapCompleteData) -> void:
	print("RaceController on_lap_completed:", info)
