extends Sprite2D
class_name GGJ_Bubble

enum BUBBLE_TYPE{
	NORMAL = 0, #avoid
	SMALL = 1, #pops upon collision with other bubbles
	LARGE = 2, #slow, poppable
	FOAM = 3, #spawns in batches after hands wash themselves, blow away with mic
	RAINBOW = 4, #merges with other rainbow bubbles
}

@onready var _collisionCircle = $CharacterBody2D/CollisionShape2D

var _speed := 6.0
var _degree : float
var _radiusToSinkhole := GGJ_Game.SINK_RADIUS
#var _bubbleListParent : Node2D
var _type : BUBBLE_TYPE
var _ACTMngr : GGJ_ACTMngr

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_degree = GGJ_Game.RNG.randf_range(-90.0, 360.0)
	position = calc_pos(GGJ_Game.SINK_RADIUS)


func init(p_type: int, p_ACTMngr: GGJ_ACTMngr) -> void:
	_ACTMngr = p_ACTMngr
	_ACTMngr.mic_was_blowed.connect(_on_mic_was_blowed)
	
	_type = p_type #BUBBLE_TYPE.LARGE #
	frame_coords.y = _type
	await ready
	_collisionCircle.scale = Vector2(5.0, 5.0)
	_speed = 6.0
	
	match p_type:
		BUBBLE_TYPE.NORMAL:
			pass
		BUBBLE_TYPE.SMALL:
			_collisionCircle.scale = Vector2(3.0, 3.0)
			_speed = 9.0
		BUBBLE_TYPE.LARGE:
			_collisionCircle.scale = Vector2(10.0, 10.0)
			_speed = 4.5
		BUBBLE_TYPE.FOAM:
			_collisionCircle.scale = Vector2(6.0, 6.0)
			frame_coords.x = GGJ_Game.RNG.randi_range(0, 2)
		BUBBLE_TYPE.RAINBOW:
			pass
		_:
			pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#const AMPLITUDE : float = 100
	#var freq : float = 10.0
	#offset.x = cos(delta*freq) * AMPLITUDE
	_radiusToSinkhole -= _speed
	position = calc_pos(_radiusToSinkhole)


func calc_pos(p_radius: float, p_degree : float = _degree) -> Vector2:
	return Vector2(sin(deg_to_rad(p_degree)), \
				   cos(deg_to_rad(p_degree))) * p_radius


func despawn(p_bubbleList : Node2D) -> void:
	if !$AnimationPlayer.is_playing():
		$CharacterBody2D/CollisionShape2D.disabled = true #instantly remove collision
		_speed = 2.0
		$AnimationPlayer.play("Despawn")
		await $AnimationPlayer.animation_finished
		if $SkeeterClone.visible: #GameOver Condition
			GGJ_Game.get_instance().end_game()
		p_bubbleList.remove_child(self)
		queue_free()


func pop() -> void:
	_speed = 0.0 #Stop moving
	$CharacterBody2D/CollisionShape2D.disabled = true #instantly remove collision
	$AnimationPlayer.play("Pop")
	await $AnimationPlayer.animation_finished
	if get_parent() != null:
		get_parent().remove_child(self)
	hide()
	queue_free()


#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#match "anim_name":
		#"Despawn":
			#hide()
			#_bubbleListParent.remove_child(self)


func caputure_skeeter() -> void:
	$SkeeterClone.show()


func _on_character_body_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		get_viewport().set_input_as_handled()
		print("bubble clicked")
		
		if _type == BUBBLE_TYPE.LARGE:
			pop()


func _on_mic_was_blowed() -> void:
	if _type == BUBBLE_TYPE.FOAM:
		_speed = -8.0
		$AnimationPlayer.play("Disperse")
		await $AnimationPlayer.animation_finished
		
		#bubble list removal?
		queue_free()
