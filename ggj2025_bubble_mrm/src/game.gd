extends Node2D
class_name GGJ_Game

@onready var _gyroscope := $Gyroscope
@onready var _skeeter := $ParallaxBackground/ParallaxDown/Skeeter
@onready var _label := $ParallaxBackground/ParallaxUp/Panel/RichTextLabel


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
	
