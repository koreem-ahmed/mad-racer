extends Control

class_name count_down



@export var waiting_time: float = 1.0

@onready var label: Label = $Label
@onready var timer: Timer = $Timer
@onready var beep: AudioStreamPlayer = $Beep


var started: bool = false
var count: int = 3


func _unhandled_input(event: InputEvent) -> void:
	if !started and event.is_action_pressed("Start"):
		start_race()
		

func _ready() -> void:
	hide()
	update_label()
	timer.wait_time = waiting_time
	


func update_label() -> void:
	label.text = "%d" % count



func start_race() -> void:
	beep.play()
	show()
	started = true
	timer.start()



func _on_timer_timeout() -> void:
	count -= 1
	if count == 0:
		EventHub.emit_on_race_start()
		queue_free()
	else:
		beep.play()
		update_label()
