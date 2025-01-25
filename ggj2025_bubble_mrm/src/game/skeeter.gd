extends Sprite2D
class_name GGJ_Skeeter

@onready var _spikyToothbrush = $SpikyToothbrush

var _degree : float = 0.0
var _lastTickDegree : float = _degree
var _game : GGJ_Game
var _gyroscope : GGJ_Gyroscope
#var _hasSpikyToothbrush : bool = false #s. visibility of $SpikyToothbrush


func init(p_game: GGJ_Game, p_gyroscope : GGJ_Gyroscope) -> void:
	_game = p_game
	_gyroscope = p_gyroscope


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("Default")
	_spikyToothbrush.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees = _degree
	
	calc_new_degree()


func calc_new_degree():
	var newDegree = _gyroscope.get_degree()
	
	#Limit angular movement
	const MAX_DEGREE_CHANGE = 8
	var directionClockwise : bool
	var degreeDelta : float
	
	#Edge cases (to the top, where +270° meets -90°):
	if _degree < 0 and newDegree > 180:
		directionClockwise = false
		degreeDelta = (90 + _degree) + (270 - newDegree)
	elif _degree > 180 and newDegree < 0:
		directionClockwise = true
		degreeDelta = (90 + newDegree) + (270 - _degree)
	else: #Usual case
		directionClockwise = _degree < newDegree
		degreeDelta = abs(_degree - newDegree)
	
	if degreeDelta > MAX_DEGREE_CHANGE:
		if directionClockwise:
			_degree += MAX_DEGREE_CHANGE
		else:
			_degree -= MAX_DEGREE_CHANGE
	else: 
		#Interpolate degrees with last value to make it smoother
		#if newDegree < -90 + MAX_DEGREE_CHANGE and _lastTickDegree > 270 - MAX_DEGREE_CHANGE:
			#
		#elif newDegree < -90 + MAX_DEGREE_CHANGE and _lastTickDegree > 270 - MAX_DEGREE_CHANGE: #TODO
		
		
		#var newDegreeTemp = newDegree
		#if newDegreeTemp < 0: newDegreeTemp += 360
		#var _lastTickDegreeTemp = _lastTickDegree
		#if _lastTickDegreeTemp < 0: _lastTickDegreeTemp += 360
		#
		#newDegree = (_lastTickDegreeTemp + newDegreeTemp) / 2
		#if newDegree >= 360: newDegree -= 360
		
		_lastTickDegree = _degree
		_degree = newDegree


func hasToothbrushArmor() -> bool:
	return _spikyToothbrush.visible


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent() is GGJ_Bubble:
		var bubble = body.get_parent() as GGJ_Bubble
		if hasToothbrushArmor():
			bubble.pop()
			_spikyToothbrush.hide() #remove protection
		else:
			#print("Body: " + str(body.get_parent()))
			bubble.caputure_skeeter()
			hide()
	elif body.get_parent() is GGJ_Upgrade:
		var upgrade = body.get_parent() as GGJ_Upgrade
		upgrade.get_parent().remove_child(upgrade)
		upgrade.hide()
		_spikyToothbrush.show()
