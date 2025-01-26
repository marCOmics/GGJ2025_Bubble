extends Node2D
class_name GGJ_Game

const SINK_RADIUS = 500
var upgradeSCN = preload("res://src/game/upgrade.tscn")
@onready var _gyroscope := $Gyroscope
@onready var _skeeter := $ParallaxBackground/ParallaxDown/Skeeter
@onready var _label := $ParallaxBackground/ParallaxUp/ACTPanel/RichTextLabel
@onready var _bubbleList := $ParallaxBackground/ParallaxDown/Bubbles
@onready var _upgradeList := $ParallaxBackground/ParallaxDown/Upgrades
@onready var _pauseOrGameoverLabel = $ParallaxBackground/PauseOrGameOverTint/CanvasLayer/PauseOrGameOverLabel
@onready var _ACTMngr = $ParallaxBackground/ParallaxUp/ACTMngr


static var RNG = RandomNumberGenerator.new()
static var _instance : GGJ_Game #Singleton Pattern
var _timeTillNextUpgrade : float = 6
const HANDWASH_TIME = 18
var _timeTillNextHandWash : float = HANDWASH_TIME



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_skeeter.init(self, _gyroscope)
	_instance = self
	$ParallaxBackground/PauseOrGameOverTint.hide()
	_ACTMngr.init($ParallaxBackground/ParallaxUp/Level/LevelLbl, _bubbleList)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_upgrade(delta)
	
	_timeTillNextHandWash -= delta
	if _timeTillNextHandWash <= 0:
		$HandAnimation.play("WashingHands")
		_timeTillNextHandWash = HANDWASH_TIME
	
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
	Settings.add_highscore(_ACTMngr.get_level())



func spawn_upgrade(p_delta: float) -> void:
	const MIN_TIME_TO_SPAWN = 10
	const MAX_TIME_TO_SPAWN = 20
	
	_timeTillNextUpgrade -= p_delta
	
	if _timeTillNextUpgrade <= 0:
		var newUpgrade := upgradeSCN.instantiate()
		newUpgrade.position = Vector2(1000, 0)  #so it doesn't trigger the collision when spawning, quick and dirty fix
		_upgradeList.add_child(newUpgrade)
		_timeTillNextUpgrade = RNG.randf_range(MIN_TIME_TO_SPAWN, \
											   MAX_TIME_TO_SPAWN)


func _on_hole_body_entered(body: Node2D) -> void:	
	if body.get_parent() is GGJ_Skeeter:
		pass #EDIT: Game over after animation of Bubble!
	if body.get_parent() is GGJ_Bubble:
		despawn_bubble(body)
	if body.get_parent() is GGJ_Upgrade:
		for child in _upgradeList.get_children():
			if child == body.get_parent():
				var upgrade : GGJ_Upgrade = body.get_parent()
				upgrade.despawn(_upgradeList)


func despawn_bubble(p_body: Node2D) -> void:
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
		Settings.add_highscore(_ACTMngr.get_level())
		toggle_pause()
		#while Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#pass #wait till release, QUICK AND DIRTY, how we LIKE IT ;P
		get_tree().change_scene_to_file("res://src/start_screen.tscn")
