extends Object



class_name LapCompleteData

var lap_time: float
var car: Red_car

func _init(p_car: Red_car, lt:  float) -> void:
	car = p_car
	lap_time = lt
	
	
func _to_string() -> String:
	return "LapCompleteData %s (%d) lap: %2f" % [
		car.car_name, car.car_number, lap_time
	]
