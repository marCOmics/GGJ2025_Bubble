extends Sprite2D


var m_degree : float = 0.0
const MODELNAME_PC := "GenericDevice"
var m_modelname : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_modelname = OS.get_model_name()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees = m_degree
	
	#Only allow mouse/touch input on PC (for testing)
	if m_modelname == MODELNAME_PC:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			m_degree -= 5
		elif  Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			m_degree += 5
	
	var gyroscope_rotation = Input.get_gyroscope()
	rotation = gyroscope_rotation
	


func _input(event):
	# Mouse in viewport coordinates.
	pass
	#if (event is InputEventScreenTouch):
		#if event.pressed:
			##print("Offset: " + str(offset.x)) #event.position)
			#m_degree += 1
