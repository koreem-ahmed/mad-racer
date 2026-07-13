extends Area2D

class_name Oil


func _ready() -> void:
	await  get_tree().create_timer(
		randf_range(3.0, 5.0)
	).timeout
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Red_car: 
		area.hit_oil()
