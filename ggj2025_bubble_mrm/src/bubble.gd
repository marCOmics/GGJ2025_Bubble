extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	const AMPLITUDE : float = 100
	#var freq : float = 10.0
	#offset.x = cos(delta*freq) * AMPLITUDE
	pass


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		#print("Offset: " + str(offset.x)) #event.position)
		offset.y += 10
