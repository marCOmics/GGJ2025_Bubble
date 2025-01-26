extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Setup settings
	#Settings._ready()
	
	#Rescale window on mobile:
	if !GGJ_Game.on_pc():
		get_window().size = Vector2i(1080, 2000)
		get_window().content_scale_factor = 1.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_released():
		get_tree().change_scene_to_file("res://src/game/game.tscn")


func _on_comic_btn_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_released():
		get_tree().change_scene_to_file("res://src/comic.tscn")


func _on_settings_btn_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_released():
		get_tree().change_scene_to_file("res://src/settings_screen.tscn")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_released():
		get_tree().quit()
