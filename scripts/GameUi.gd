extends Control


class_name Game_Ui


@onready var margin_container: MarginContainer = $MarginContainer


var _car_ui_dict: Dictionary[Car, Car_Ui] = {}



func setup(cars: Array[Car]) -> void:
	var ui_nodes: Array[Node] = margin_container.get_children()
	for i in range(cars.size()):
		if i >= ui_nodes.size():
			break
		
		var ui: Car_Ui = ui_nodes[i]
		var car: Car = cars[i] 
		ui.update_values(car, 0, 0.0)
		ui.show()
		_car_ui_dict[car] = ui
	
	
