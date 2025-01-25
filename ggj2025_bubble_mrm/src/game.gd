extends Node2D
class_name GGJ_Game

var bubbleSCN = preload("res://src/bubble.tscn")
@onready var _gyroscope := $Gyroscope
@onready var _skeeter := $ParallaxBackground/ParallaxDown/Skeeter
@onready var _label := $ParallaxBackground/ParallaxUp/Panel/RichTextLabel
@onready var _bubbleList := $ParallaxBackground/ParallaxDown/Bubbles

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
		newBubble.position = Vector2(1000, 0)  #so it doesn't trigger the collision when spawning
		_bubbleList.add_child(newBubble)
		_timeTillNextBubbleSpawn = RNG.randf_range(MIN_TIME_TO_SPAWN, MAX_TIME_TO_SPAWN)


func _on_hole_body_entered(body: Node2D) -> void:	
	if body is GGJ_Skeeter:
		print("GAME OVER")
		get_tree().paused = true
	else:
		despawn_bubble(body)
	pass # Replace with function body.


func despawn_bubble(p_body: Node2D) -> void:
	#print("Despawn bubble " + str(p_body)+ " from: " + str(_bubbleList.get_children()))
	for child in _bubbleList.get_children():
		if child == p_body.get_parent():
			var bubbleToDespawn : GGJ_Bubble = p_body.get_parent()
			bubbleToDespawn.despawn(_bubbleList)
