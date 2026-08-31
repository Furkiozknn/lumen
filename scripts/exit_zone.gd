extends Area2D
## Win trigger. The exit only activates once the player's own light
## source actually reaches it: player must be inside the trigger AND
## have an unobstructed line of sight (no LightOccluder2D-backed wall
## in the way) within the light's effective radius.
##
## This is a deliberate approximation of "sufficiently lit" — it does
## not sample the real rendered light value, it re-uses the same
## geometry (walls on collision layer 1) that casts the visual shadows,
## via a physics raycast. Good enough for a vertical slice; a true
## light-sampling check would need viewport texture reads.

@export var light_radius: float = 260.0

@onready var visual: Polygon2D = $Visual

var player_inside := false
var won := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false

func _physics_process(_delta: float) -> void:
	if won or not player_inside:
		return
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return
	if _is_lit_by(player):
		_win()

func _is_lit_by(player: Node2D) -> bool:
	var to_player: Vector2 = player.global_position - global_position
	if to_player.length() > light_radius:
		return false
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.collision_mask = 1 | 4 # solid walls (layer 1) + light-only occluders (layer 3 / bit 4)
	var result := space_state.intersect_ray(query)
	return result.is_empty()

func _win() -> void:
	won = true
	visual.color = Color(0.45, 1.0, 0.6, 1.0)
	print("LUMEN: Exit reached with sufficient light -- puzzle solved.")
