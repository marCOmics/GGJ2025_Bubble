extends Node2D
class_name GGJ_Game

var bubbleSCN = preload("res://src/game/bubble.tscn")
@onready var _gyroscope := $Gyroscope
@onready var _skeeter := $ParallaxBackground/ParallaxDown/Skeeter
@onready var _label := $ParallaxBackground/ParallaxUp/ACTPanel/RichTextLabel
@onready var _bubbleList := $ParallaxBackground/ParallaxDown/Bubbles
@onready var _pauseOrGameoverLabel = $ParallaxBackground/PauseOrGameOverTint/CanvasLayer/PauseOrGameOverLabel


static var RNG = RandomNumberGenerator.new()
static var _instance : GGJ_Game #Singleton Pattern
var _timeTillNextBubbleSpawn : float =  1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_skeeter.init(self, _gyroscope)
	_instance = self
	$ParallaxBackground/PauseOrGameOverTint.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_bubbles(delta)
	
	##Update richtext label
	#_label.text = "[font_size=70]x: " + str(_gyroscope.get_rotation().normalized().x) + "\n" + \
		#"y: " + str(_gyroscope.get_rotation().normalized().y) #+ "\n" + \
		##"z: " + str(_gyroscope.get_rotation().z) + "[/font_size]"


static func on_pc() -> bool:
	const MODELNAME_PC := "GenericDevice"
	
	if OS.get_model_name() == MODELNAME_PC:
		return true
	else: 
		return false


##Singleton pattern
static func get_instance() -> GGJ_Game:
	return _instance


func end_game() -> void:
	toggle_pause()
	_pauseOrGameoverLabel.text = "[center][font_size=200]GAME OVER[/font_size][/center]" 
	$ParallaxBackground/PauseOrGameOverTint/CanvasLayer/ContinueBtn.hide()


func spawn_bubbles(p_delta: float) -> void:
	const MIN_TIME_TO_SPAWN = 0.5
	const MAX_TIME_TO_SPAWN = 3.0
	
	_timeTillNextBubbleSpawn -= p_delta 
	
	if _timeTillNextBubbleSpawn <= 0:
		var newBubble := bubbleSCN.instantiate()
		newBubble.position = Vector2(1000, 0)  #so it doesn't trigger the collision when spawning
		_bubbleList.add_child(newBubble)
		_timeTillNextBubbleSpawn = RNG.randf_range(MIN_TIME_TO_SPAWN, MAX_TIME_TO_SPAWN)


func _on_hole_body_entered(body: Node2D) -> void:	
	if body is GGJ_Skeeter:
		pass #EDIT: Game over after animation of Bubble!
	else:
		despawn_bubble(body)
	pass # Replace with function body.


func despawn_bubble(p_body: Node2D) -> void:
	#print("Despawn bubble " + str(p_body)+ " from: " + str(_bubbleList.get_children()))
	for child in _bubbleList.get_children():
		if child == p_body.get_parent():
			var bubbleToDespawn : GGJ_Bubble = p_body.get_parent()
			bubbleToDespawn.despawn(_bubbleList)


#Switches from Paused to unpaused
func toggle_pause() -> bool:
	var currently_paused : bool = $ParallaxBackground/PauseOrGameOverTint.visible #This indicates if the game is paused
	currently_paused = !currently_paused
	$ParallaxBackground/PauseOrGameOverTint.visible = currently_paused
	$ParallaxBackground/PauseOrGameOverTint/CanvasLayer.visible = currently_paused
	#"underscore" Prefix, as CanvasLayer is swallowing the first symbol:
	_pauseOrGameoverLabel.text = "[center][font_size=200]PAUSED[/font_size][/center]" 
	get_tree().paused = currently_paused
	return currently_paused


func _on_pause_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		toggle_pause()


func _on_continue_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		toggle_pause()


func _on_quit_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_released():
		toggle_pause()
		#while Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#pass #wait till release, QUICK AND DIRTY, how we LIKE IT ;P
		get_tree().change_scene_to_file("res://src/start_screen.tscn")
