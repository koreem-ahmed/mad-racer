extends Node

class_name Track

func _on_track_collision_area_entered(area: Area2D) -> void:
	if area is Red_car: area.hit_boundry()
	
