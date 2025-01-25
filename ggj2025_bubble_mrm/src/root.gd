extends Node2D

@onready var _gyroscope := $Gyroscope
@onready var _skeeter := $ParallaxBackground/ParallaxDown/Skeeter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_skeeter.init(_gyroscope)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
