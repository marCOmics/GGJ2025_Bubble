extends Sprite2D


var _degree : float = 0.0
var _game : GGJ_Game
var _gyroscope : GGJ_Gyroscope

func init(p_game: GGJ_Game, p_gyroscope : GGJ_Gyroscope) -> void:
	_game = p_game
	_gyroscope = p_gyroscope


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees = _degree
	
	#if _game.on_pc():
		##Only allow mouse/touch input on PC (for testing)
		#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#_degree -= 5
		#elif  Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			#_degree += 5
	#else: #on Mobile devices
	_degree = _gyroscope.get_degree()
	

func _input(event):
	# Mouse in viewport coordinates.
	pass
	#if (event is InputEventScreenTouch):
		#if event.pressed:
			##print("Offset: " + str(offset.x)) #event.position)
			#m_degree += 1
