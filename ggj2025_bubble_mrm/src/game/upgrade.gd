extends Node2D
class_name GGJ_Upgrade
##TODO: Create Class GGJ_Object as super class of GGJ_Bubble and GGJ_Upgrade and gather common code

enum UPGRADE_TYPES{
	SPIKY_TOOTHBRUSH = 0,
}

static var RNG = RandomNumberGenerator.new()
var _speed := 6.0
var _degree : float
var _radius := GGJ_Game.SINK_RADIUS
var _type : UPGRADE_TYPES

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = calc_pos(GGJ_Game.SINK_RADIUS)
	_type = RNG.randi_range(UPGRADE_TYPES.SPIKY_TOOTHBRUSH, \
							UPGRADE_TYPES.SPIKY_TOOTHBRUSH)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_radius -= _speed
	position = calc_pos(_radius)


func calc_pos(p_radius: float, p_degree : float = _degree) -> Vector2:
	return Vector2(sin(deg_to_rad(p_degree)), \
				   cos(deg_to_rad(p_degree))) * p_radius


func despawn(p_upgradeList : Node2D) -> void:
	if !$AnimationPlayer.is_playing():
		$CharacterBody2D/CollisionShape2D.disabled = true #instantly remove collision
		_speed = 2.0 #Stop moving
		$AnimationPlayer.play("Despawn")
		await $AnimationPlayer.animation_finished
		hide()
		p_upgradeList.remove_child(self)
		queue_free()
