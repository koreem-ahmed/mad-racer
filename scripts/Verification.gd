extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area is Red_car: area.hit_verification(get_instance_id())
