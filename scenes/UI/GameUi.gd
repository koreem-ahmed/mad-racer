extends Control


class_name GameUi


@onready var margin_container: MarginContainer = $MarginContainer
@onready var race_over_label: Label = $PanelContainer/RaceOverLabel
@onready var panel_container: PanelContainer = $PanelContainer
@onready var car_ui: CarUi = $MarginContainer/CarUi
@onready var car_ui_2: CarUi = $MarginContainer/CarUi2
@onready var car_ui_3: CarUi = $MarginContainer/CarUi3
@onready var car_ui_4: CarUi = $MarginContainer/CarUi4


var _car_ui_dict: Dictionary[Car, CarUi] = {}
var player_time: float = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		GameManager.change_to_main()


func _enter_tree() -> void:
	EventHub.on_lap_update.connect(on_lap_update)
	EventHub.on_race_over.connect(on_race_over)



func on_race_over(data: Array[CarRaceData]) -> void:
	race_over_label.text = "%10s %6s %6s %5s" % [
		"Car", "Time", "Best", "Laps"
	]
	for d in data: race_over_label.text += "\n%s" % d
	panel_container.show()
	get_tree().paused = true
	


func setup(cars: Array[Car]) -> void:
	var ui_nodes: Array[Node] = margin_container.get_children()
	for i in range(cars.size()):
		if i >= ui_nodes.size():
			break
		
		var ui: CarUi = ui_nodes[i]
		var car: Car = cars[i]
		ui.update_values(car, 0, 0.0)
		ui.show()
		_car_ui_dict[car] = ui
	
	cars_texture()


func cars_texture() -> void:
	match GlobalVars.player_car_texture:
		0:
			car_ui.cpu_car_texture = preload("res://assets/levels/Images/CarBlue.png")
			car_ui_2.cpu_car_texture = preload("res://assets/levels/Images/CarGreen.png")
			car_ui_3.cpu_car_texture = preload("res://assets/levels/Images/CarPurple.png")
			car_ui_4.cpu_car_texture = preload("res://assets/levels/Images/CarRed.png")
		1:
			car_ui.cpu_car_texture = preload("res://assets/levels/Images/CarGreen.png")
			car_ui_2.cpu_car_texture = preload("res://assets/levels/Images/CarBlue.png")
			car_ui_3.cpu_car_texture = preload("res://assets/levels/Images/CarPurple.png")
			car_ui_4.cpu_car_texture = preload("res://assets/levels/Images/CarRed.png")
		2:
			car_ui.cpu_car_texture = preload("res://assets/levels/Images/CarPurple.png")
			car_ui_2.cpu_car_texture = preload("res://assets/levels/Images/CarBlue.png")
			car_ui_3.cpu_car_texture = preload("res://assets/levels/Images/CarGreen.png")
			car_ui_4.cpu_car_texture = preload("res://assets/levels/Images/CarRed.png")
		3:
			car_ui.cpu_car_texture = preload("res://assets/levels/Images/CarRed.png")
			car_ui_2.cpu_car_texture = preload("res://assets/levels/Images/CarBlue.png")
			car_ui_3.cpu_car_texture = preload("res://assets/levels/Images/CarPurple.png")
			car_ui_4.cpu_car_texture = preload("res://assets/levels/Images/CarGreen.png")


func on_lap_update(car: Car, lap_count: int, lap_time: float) -> void:
	if car in _car_ui_dict:
		_car_ui_dict[car].update_values(car, lap_count, lap_time)
