extends Node
class_name GGF_ACTMngr

@onready var _actPanel = $ACTPanel
var _levelLbl: RichTextLabel

var _timeTillNextACT : float =  4
var _currACT : ACT_TYPES
var _level : int = 1

enum ACT_TYPES{
	AVOID = 0,
	BLOW = 1,
	POP = 2,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_actPanel.hide()

func init(p_levelLbl : RichTextLabel) -> void:
	_levelLbl = p_levelLbl


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	const MIN_TIME_TO_SPAWN = 5.0
	const MAX_TIME_TO_SPAWN = 12.0 
	
	_timeTillNextACT -= delta
	
	if _timeTillNextACT <= 0:
		_currACT = GGJ_Game.RNG.randi_range(GGF_ACTMngr.ACT_TYPES.AVOID, 2)
		_actPanel.show()
		$AnimationPlayer.play("Enter")
		_actPanel.frame = _currACT
		_timeTillNextACT = GGJ_Game.RNG.randf_range(MIN_TIME_TO_SPAWN, MAX_TIME_TO_SPAWN)


func level_up() -> void:
	_levelLbl.text = "[center][font_size=75]Level
" + str(_level) + "[/font_size][/center]"
