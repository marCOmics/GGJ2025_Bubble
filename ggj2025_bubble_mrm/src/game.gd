extends Node2D
class_name GGJ_Game

var bubbleSCN = preload("res://src/bubble.tscn")
@onready var _gyroscope := $Gyroscope
@onready var _skeeter := $ParallaxBackground/ParallaxDown/Skeeter
@onready var _label := $ParallaxBackground/ParallaxUp/Panel/RichTextLabel

static var RNG = RandomNumberGenerator.new()
var _timeTillNextBubbleSpawn : float =  1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Rescale window on mobile:
	if !on_pc():
		get_window().size = Vector2i(1080, 2000)
		get_window().content_scale_factor = 1.0
	
	
	_skeeter.init(self, _gyroscope)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_bubbles(delta)
	
	#Update richtext label
	_label.text = "[font_size=70]x: " + str(_gyroscope.get_rotation().normalized().x) + "\n" + \
		"y: " + str(_gyroscope.get_rotation().normalized().y) #+ "\n" + \
		#"z: " + str(_gyroscope.get_rotation().z) + "[/font_size]"


static func on_pc() -> bool:
	const MODELNAME_PC := "GenericDevice"
	if OS.get_model_name() == MODELNAME_PC:
		return true
	else: 
		return false


func spawn_bubbles(p_delta: float) -> void:
	const MIN_TIME_TO_SPAWN = 0.5
	const MAX_TIME_TO_SPAWN = 3.0
	_timeTillNextBubbleSpawn -= p_delta 
	#print("Time till spawn: " + str(_timeTillNextBubbleSpawn))
	
	if _timeTillNextBubbleSpawn <= 0:
		var newBubble := bubbleSCN.instantiate()
		$ParallaxBackground/ParallaxDown/Bubbles.add_child(newBubble)
		_timeTillNextBubbleSpawn = RNG.randf_range(MIN_TIME_TO_SPAWN, MAX_TIME_TO_SPAWN)
