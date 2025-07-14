# Weapon.gd

extends Node2D
@export var base_fire_rate := 1.0
@export var base_damage := 10.0
@export var bullet_scene: PackedScene
var upgrades: Dictionary = {}      # {"multi_shot": current_level, …}

# Derived stats
var fire_rate := base_fire_rate
var damage := base_damage
var projectiles_per_shot := 1
var bullet_effect_defs := {}       # {"freeze": {duration = …}, …}

func _ready():
	recalc_stats()

func add_upgrade(up: UpgradeResource):
	var level = upgrades.get(up.id, 0)
	if level < up.max_level:
		level += 1
		upgrades[up.id] = level
		up.apply(self, level)
		recalc_stats()

func add_bullet_effect(effect_name: String, data: Dictionary):
	bullet_effect_defs[effect_name] = data

func recalc_stats():
	# For simple additive modifiers put them here if you prefer
	pass

func shoot():
	for i in range(projectiles_per_shot):
		var bullet = bullet_scene.instantiate()
		bullet.damage = damage
		bullet.init_effects(bullet_effect_defs)
		get_parent().add_child(bullet)