extends Node
class_name GGJ_Gyroscope

var _gyroscope_rotation : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if GGJ_Game.on_pc():
		#Emulate gyroscope on pc
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var mousePosFromCenter := get_viewport().get_mouse_position()
			mousePosFromCenter = Vector2(mousePosFromCenter.x - get_viewport().size.x, \
										 mousePosFromCenter.y - get_viewport().size.y)
			#print("Viewport X: " + str(get_viewport().size.x) + "Mouse X: " + str(mousePosFromCenter.x))
			set_rotation(Vector3(mousePosFromCenter.x, mousePosFromCenter.y, 0).normalized())
	else:
		var rotation := Input.get_accelerometer() #Input.get_gyroscope()
		rotation.x = -rotation.x #Mirror x-axis
		set_rotation(rotation)
	


func get_rotation() -> Vector3:
	return _gyroscope_rotation


func set_rotation(p_rot : Vector3) -> void:
	_gyroscope_rotation = p_rot


#in degrees
func get_degree() -> int:
	var rot : Vector3 = get_rotation().normalized()
	
	var degrees = rad_to_deg(atan(rot.y / rot.x))
	if rot.x < 0:
		degrees += 180
	
	#print("Degrees: " + str(degrees))
	return degrees #tan^-1(Gegenkathete/Ankathetee)
