extends Object


class_name CarRaceData

const DEFAULT_LAPTIME: float = 999.99

var car_number: int
var car_name: String
var total_time: float = 0.0
var completed_laps: int
var partial_progress: float = 0.0
var best_lap: float = DEFAULT_LAPTIME
var target_laps: int = 0


var _total_time: float:
	get: return total_time

var _completed_laps: int:
	get: return completed_laps

var race_completed: bool:
	get: return completed_laps == target_laps

var total_progress: float:
	get: return completed_laps + partial_progress


func _init(_car_name: String, _car_number: int, _target_laps: int) -> void:
	car_name = _car_name
	car_number = _car_number
	target_laps = _target_laps	


func add_lap_time(lap_time: float) -> void:
	completed_laps += 1
	best_lap = min(best_lap, lap_time)
	


func set_total_time(_total_time: float) -> void:
	total_time = _total_time


func force_finish(_total_time: float, progress: float) -> void:
	partial_progress = progress
	total_time = _total_time


func _to_string() -> String:
	var total_str = "DNF"
	if race_completed: total_str = "%0.fs" % (total_time/1000)
	
	var best_lap_str: String = ""
	if best_lap != DEFAULT_LAPTIME:
		best_lap_str = "%.1fs" % best_lap
	
	return "%10s %6s %6s %5d" % [
		car_name, total_str, best_lap_str, completed_laps
	]



static func compare(a: CarRaceData, b: CarRaceData) -> bool:
	if a._completed_laps == b._completed_laps:
		if a.race_completed:
			return a._total_time < b._total_time
		return a.total_progress > b.total_progress 
	return a._completed_laps > b._completed_laps
