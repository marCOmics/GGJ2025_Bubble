extends Node
class_name GGF_ACTMngr

var bubbleSCN = preload("res://src/game/bubble.tscn")
@onready var _actPanel = $ACTPanel
var _levelLbl: RichTextLabel

static var RNG = RandomNumberGenerator.new()

var _timeTillNextACT : float =  8
var _currACT : ACT_TYPES
var _level : int = 1
var _timeTillNextBubbleSpawn : float =  1
var _bubbleList : Node2D


enum ACT_TYPES{
	AVOID = 0,
	BLOW = 1,
	POP = 2,
	AVOID_FAST = 3,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_actPanel.hide()


func init(p_levelLbl : RichTextLabel, p_bubbleList : Node2D) -> void:
	_levelLbl = p_levelLbl
	_bubbleList = p_bubbleList


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_ACTs(delta)
	spawn_bubbles(delta)
	
	#i used abs() here but it probably isn't necessary, I just needed to know if there was sound input or not. so this was my quick solution 
	var volume = abs(AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("Record"), 0))
	if volume > 0: 
		$LabelTestMic.text = "Mic Vol: " +  str(volume)


func update_ACTs(delta: float) -> void:
	const MIN_TIME_TO_SPAWN = 6.0
	const MAX_TIME_TO_SPAWN = 10.0
	#const TIME_DURATION
	
	
	_timeTillNextACT -= delta
	
	if _timeTillNextACT <= 0:
		var new_ACT = GGJ_Game.RNG.randi_range(GGF_ACTMngr.ACT_TYPES.AVOID, GGF_ACTMngr.ACT_TYPES.AVOID_FAST)
		while (_currACT == new_ACT):
			new_ACT = GGJ_Game.RNG.randi_range(GGF_ACTMngr.ACT_TYPES.AVOID, GGF_ACTMngr.ACT_TYPES.AVOID_FAST)
		_currACT = new_ACT
		
		_actPanel.show()
		$AnimationPlayer.play("Enter")
		print("New ACT: " + str(new_ACT))
		_actPanel.frame = _currACT
		_timeTillNextACT = GGJ_Game.RNG.randf_range(MIN_TIME_TO_SPAWN, MAX_TIME_TO_SPAWN)
		level_up()


func spawn_bubbles(p_delta: float) -> void:
	const MIN_TIME_TO_SPAWN = 0.5
	const MAX_TIME_TO_SPAWN = 3.0
	
	_timeTillNextBubbleSpawn -= p_delta 
	
	if _timeTillNextBubbleSpawn <= 0:
		var newBubble := bubbleSCN.instantiate()
		newBubble.init(get_currACT())
		newBubble.position = Vector2(1000, 0)  #so it doesn't trigger the collision when spawning, quick and dirty fix
		_bubbleList.add_child(newBubble)
		_timeTillNextBubbleSpawn = RNG.randf_range(MIN_TIME_TO_SPAWN, MAX_TIME_TO_SPAWN)


func level_up() -> void:
	_level += 1
	_levelLbl.text = "[center][font_size=75]Level
" + str(_level) + "[/font_size][/center]"


func get_level() -> int:
	return _level


func get_currACT() -> int:
	return _currACT
