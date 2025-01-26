extends Node
class_name GGJ_ACTMngr

signal mic_was_blowed

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
	AVOID_FAST = 1,
	POP = 2,
	BLOW = 3,
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
	
	##TEST MIC:
	#if Input.is_action_just_pressed("ui_text_backspace"):
		#for node in _bubbleList.get_children():
			#var bubble : GGJ_Bubble = node
			#bubble._on_mic_was_blowed()
	
	
	var idx = AudioServer.get_bus_index("Master")
	## And use it to retrieve its first effect, which has been defined
	## as an "AudioEffectRecord" resource.
	#var effectRecord : AudioEffectRecord = AudioServer.get_bus_effect(idx, 0)
	#var effectRecordIns : AudioEffectRecord = AudioServer.get_bus_effect_instance(idx, 0)
	#var recording : AudioStreamWAV = effectRecord.get_recording()
	#if recording != null:
		#print("Recording Data: " + str(recording.data))
	
	var volume = abs(AudioServer.get_bus_peak_volume_left_db(idx, 0))
	const VOLUME_THRESHOLD_FOR_BLOW = 10.0
	
	if volume < VOLUME_THRESHOLD_FOR_BLOW:
		mic_was_blowed.emit()
		#for node in _bubbleList.get_children():
			#var bubble : GGJ_Bubble = node
			#bubble._on_mic_was_blowed()


func update_ACTs(delta: float) -> void:
	const MIN_TIME_TO_SPAWN = 6.0
	const MAX_TIME_TO_SPAWN = 10.0
	#const TIME_DURATION
	
	
	_timeTillNextACT -= delta
	
	if _timeTillNextACT <= 0:
		var new_ACT = GGJ_Game.RNG.randi_range(GGJ_ACTMngr.ACT_TYPES.AVOID, 3)
		while (_currACT == new_ACT):
			new_ACT = GGJ_Game.RNG.randi_range(GGJ_ACTMngr.ACT_TYPES.AVOID, 3)
		_currACT = new_ACT
		
		_actPanel.show()
		$AnimationPlayer.play("Enter")
		Input.vibrate_handheld(100)
		#print("New ACT: " + str(new_ACT))
		_timeTillNextBubbleSpawn = 0.5 #start spawning bubbles at fixed time after announcement
		_actPanel.frame = _currACT
		_timeTillNextACT = GGJ_Game.RNG.randf_range(MIN_TIME_TO_SPAWN, MAX_TIME_TO_SPAWN)
		level_up()


func spawn_bubbles(p_delta: float) -> void:
	var MIN_TIME_TO_SPAWN = 0.5
	var MAX_TIME_TO_SPAWN = 2.0
	var amountPerSpawn = 1
	
	#Custom spawn behaviour dependend on ACT type
	match _currACT:
		ACT_TYPES.AVOID:
			pass
		ACT_TYPES.AVOID_FAST:
			MIN_TIME_TO_SPAWN = 0.3
			MAX_TIME_TO_SPAWN = 0.5
		ACT_TYPES.POP:
			pass
		ACT_TYPES.BLOW:
			MIN_TIME_TO_SPAWN = 2.0
			MAX_TIME_TO_SPAWN = 4.5
			amountPerSpawn = 7
	
	_timeTillNextBubbleSpawn -= p_delta 
	
	if _timeTillNextBubbleSpawn <= 0:
		for i in amountPerSpawn:
			var newBubble := bubbleSCN.instantiate()
			newBubble.init(get_currACT(), self)
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
