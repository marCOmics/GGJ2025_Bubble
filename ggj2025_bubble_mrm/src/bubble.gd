extends Sprite2D

enum BUBBLE_TYPES{
	NORMAL = 0, #avoid
	LARGE = 1, #slow, poppable
	RAINBOW = 2, #merges with other rainbow bubbles
	SMALL = 3, #pops upon collision with other bubbles
	FOAM = 4 #spawns in batches after hands wash themselves, blow away with mic
}

var type_to_radius : Dictionary = {
	BUBBLE_TYPES.NORMAL: 5.0,
	BUBBLE_TYPES.LARGE: 10.0,
	#TODO
}

const SINK_RADIUS = 500
const SPEED := 4.0
var _degree : float
var _radius := SINK_RADIUS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_degree = GGJ_Game.RNG.randf_range(-90.0, 360.0)
	offset = calc_offset(SINK_RADIUS)


#func init(p_degree : float) -> void:
	#_degree = p_degree


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#const AMPLITUDE : float = 100
	#var freq : float = 10.0
	#offset.x = cos(delta*freq) * AMPLITUDE
	_radius -= SPEED
	offset = calc_offset(_radius)
	pass


func calc_offset(p_radius: float, p_degree : float = _degree) -> Vector2:
	return Vector2(sin(deg_to_rad(p_degree)), \
				   cos(deg_to_rad(p_degree))) * p_radius
