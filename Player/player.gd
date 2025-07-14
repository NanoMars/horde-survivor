# player.gd
extends CharacterBody2D

@export var weapon: PlayerWeapon

@export var movement_speed := 200.0
@export var acceleration := 1000.0
@export var friction := 500.0

var look_velocity: float = 0
@export var look_dampening: float = 1
@export var look_speed: float = 10
var goal_look: float = 0


func _physics_process(delta):
	# grab input from actions instead of raw axes
	var move_input = Input.get_vector(
		"move_left", "move_right",
		"move_up",   "move_down",
		0.1
	)
	if move_input != Vector2.ZERO:
		velocity = velocity.move_toward(
			move_input.normalized() * movement_speed,
			acceleration * delta
		)
	else:
		velocity = velocity.move_toward(
			Vector2.ZERO,
			friction * delta
		)
	move_and_slide()

	var aim_input = Input.get_vector(
		"aim_left",  "aim_right",
		"aim_up",    "aim_down",
		0.1
	)
	if aim_input != Vector2.ZERO:
		goal_look = aim_input.angle()
		weapon.firing = true
	elif move_input != Vector2.ZERO:
		goal_look = move_input.angle()
		weapon.firing = false
	else:
		weapon.firing = false
	

	var angle_diff = wrapf(goal_look - rotation, -PI, PI)
	look_velocity += angle_diff * delta * look_speed
	look_velocity /= look_dampening
	rotation += look_velocity