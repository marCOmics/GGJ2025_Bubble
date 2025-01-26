extends Node2D
class_name GGJ_Settings #THIS IS ONLY THE SCREEN/MENUE, use "Settings" or see settings.gd for data

@onready var _inputBtn = $InputBtn/InputArea/InputBtnLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_labels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#TODO: functions to save score etc. to json file


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_released():
		get_tree().change_scene_to_file("res://src/start_screen.tscn")


func _on_input_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_released():
		toggle_input_method()
		Settings.save_file()


func toggle_input_method() -> void:
	if Settings.input_is_gyroscope():
		Settings.set_input_method(Settings.INPUT_METHOD.TOUCH)
	else:
		Settings.set_input_method(Settings.INPUT_METHOD.GYROSCOPE)
	_update_labels()


func _update_labels() -> void:
	#Input method
	var typeString = "Gyroscope" if Settings.input_is_gyroscope() else "Touch"
	_inputBtn.text = \
		"[center][font_size=65]" + typeString + "[/font_size][/center]"
	
	#Highscore
	$HighscoreLbl.text = "[center][font_size=80]Highscore: " + str(Settings.get_highscore()) + "[/font_size][/center]"
