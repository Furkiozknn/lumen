extends CharacterBody2D
## The player-controlled light source. Moves with WASD or arrow keys.
## Carries the PointLight2D that is the whole point of the game.

@export var speed: float = 220.0

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	var input_vector := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	input_vector = input_vector.limit_length(1.0)

	velocity = input_vector * speed
	move_and_slide()
