extends Node
class_name GGF_ACTMngr

@onready var _actPanel = $ACTPanel

var _timeTillNextACT : float =  6
var _currACT : ACT_TYPES

enum ACT_TYPES{
	AVOID = 0,
	BLOW = 1,
	POP = 2,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_actPanel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	const MIN_TIME_TO_SPAWN = 5.0
	const MAX_TIME_TO_SPAWN = 12.0
	
	_timeTillNextACT -= delta
	
	if _timeTillNextACT <= 0:
		var act_type = GGJ_Game.RNG.randi_range(GGF_ACTMngr.ACT_TYPES.AVOID, 2)
		_actPanel.show()
		_timeTillNextACT = GGJ_Game.RNG.randf_range(MIN_TIME_TO_SPAWN, MAX_TIME_TO_SPAWN)
