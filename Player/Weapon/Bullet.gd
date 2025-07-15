# Bullet.gd
extends Area2D
var damage: float
var effects: Array[Dictionary] = []
@export var speed: float = 400.0

@export var lifetime: float = 5.0
var lifetime_timer: Timer

func _ready() -> void:
	lifetime_timer = Timer.new()
	lifetime_timer.wait_time = lifetime
	lifetime_timer.one_shot = true
	lifetime_timer.autostart = false
	lifetime_timer.timeout.connect(queue_free)
	add_child(lifetime_timer)
	lifetime_timer.start()
	 
func init_effects(effect_defs: Dictionary):
	for effect_name in effect_defs.keys():
		effects.append({"name": effect_name, "data": effect_defs[effect_name]})

func _on_body_entered(body):
	body.take_damage(damage)
	for e in effects:
		match e.name:
			"freeze":
				body.apply_slow(e.data.duration)
	queue_free()

func _physics_process(delta):
	translate(Vector2.DOWN.rotated(rotation) * speed * delta)
