# Bullet.gd
extends Area2D
var damage: float
var effects: Array[Dictionary] = []
	 
func init_effects(effect_defs: Dictionary):
	for effect_name in effect_defs.keys():
		effects.append({"name": effect_name, "data": effect_defs[effect_name]})

func _on_body_entered(body):
	body.take_damage(damage)
	for e in effects:
		match e.name:
			"freeze":
				body.apply_slow(e.data.duration)
			# add more here
	queue_free()