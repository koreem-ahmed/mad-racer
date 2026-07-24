extends PathFollow2D


class_name Oil_dropper

const OIL = preload("res://scenes/Oil/Oil.tscn")



@export var debug: bool = true
@export var speed: float = 100.0
@export var oil_container: Node
@export var drop_time_vr: Vector2 = Vector2(3.0, 8.0)
@export var drop_margin: float = 25.0

@onready var dot: Sprite2D = $dot
@onready var dropper_timer: Timer = $dropper_timer

func _ready() -> void:
	dot.visible = false
	progress_ratio = randf()
	start_timer()


func _process(delta: float) -> void:
	progress += delta * speed

func start_timer() -> void:
	dropper_timer.wait_time = randf_range(
		drop_time_vr.x, drop_time_vr.y
	)
	dropper_timer.start()

func drop_oil() -> void:
	if !oil_container: 
		push_error("drop_oil oil_container is not assigned")
	
	var oil_hazard: Oil = OIL.instantiate()
	oil_container.add_child(oil_hazard)
	oil_hazard.global_position = Vector2( 
		global_position.x + randf_range(-drop_margin, drop_margin),
		global_position.y + randf_range(-drop_margin, drop_margin)
	)
	start_timer()

func _on_dropper_timer_timeout() -> void:
	drop_oil()
