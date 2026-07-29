extends Control

@onready var blue_car: TextureRect = $HBoxContainer/BlueCar
@onready var green_car: TextureRect = $HBoxContainer/GreenCar
@onready var pink_car: TextureRect = $HBoxContainer/PinkCar
@onready var red_car: TextureRect = $HBoxContainer/RedCar
@onready var pointer: Label = $pointer
@onready var input: LineEdit = $input

var blue_pos: Vector2 = Vector2(188.0, 480.0)
var green_pos: Vector2 = Vector2(437.0, 480.0)
var pink_pos: Vector2 = Vector2(685.0, 480.0)
var red_pos: Vector2 = Vector2(935.0, 480.0)
var player_name: String
var pointer_placement: int = 0


func _ready() -> void:
	pointer.global_position = blue_pos
	input.text_submitted.connect(_player_name)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		pointer_placement -= 1
	
	elif Input.is_action_just_pressed("ui_right"):
		pointer_placement += 1


	if pointer_placement < 0:
		pointer_placement = 3
	
	if pointer_placement > 3:
		pointer_placement = 0


	match pointer_placement:
		0:
			pointer.global_position = blue_pos
		1:
			pointer.global_position = green_pos
		2:
			pointer.global_position = pink_pos
		3: 
			pointer.global_position = red_pos



func _player_name(name: String) -> void:
	player_name = name
	
	print(player_name)

func _on_next_button_pressed() -> void:
	Car.car_name
