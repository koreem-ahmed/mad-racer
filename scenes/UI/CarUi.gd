extends VBoxContainer


class_name CarUi


@export var label_alignment: HorizontalAlignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT
@export var cpu_car_texture: Texture2D = preload("res://assets/levels/Images/CarRed.png")

@onready var lap_label: Label = $"Lap Label"
@onready var last_lap_label: Label = $"Last Lap Label"
@onready var car_texture: TextureRect = $HB/CarTexture
@onready var name_label: Label = $"HB/Name Label"


func _ready() -> void:
	name_label.horizontal_alignment = label_alignment
	lap_label.horizontal_alignment = label_alignment
	last_lap_label.horizontal_alignment = label_alignment
	
	car_texture.texture = cpu_car_texture

func update_values(car: Car, lap_count: int, lap_time: float) -> void:
	name_label.text = "%s (%02d)" % [car.car_name, car.car_number]
	lap_label.text = "Laps %d" % lap_count
	last_lap_label.text = "Last: %.2fs" % lap_time
