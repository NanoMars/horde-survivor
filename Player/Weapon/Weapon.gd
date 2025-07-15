# Weapon.gd

extends Node2D
class_name PlayerWeapon
@export var base_fire_rate := 1.0
@export var base_damage := 10.0
@export var bullet_scene: PackedScene
var upgrades: Dictionary = {}      # {"multi_shot": current_level, …}

# Derived stats
var fire_rate: float:
	set(value):
		if value > 0:
			_fire_rate = value
	get:
		return _fire_rate

var _fire_rate: float = base_fire_rate

var damage := base_damage
var projectiles_per_shot := 1
var bullet_effect_defs := {}       # {"freeze": {duration = …}, …}

var firing: bool:
	set(value):
		if value and not _firing:
			_firing = true
			if fire_rate_timer.is_stopped():
				fire_rate_timer.start()
		elif not value and _firing:
			_firing = false
			if not fire_rate_timer.is_stopped():
				fire_rate_timer.stop()

var fire_rate_timer: Timer
			
var _firing: bool = false

func _ready():
	recalc_stats()
	fire_rate_timer = Timer.new()
	fire_rate_timer.wait_time = fire_rate
	fire_rate_timer.one_shot = false
	fire_rate_timer.autostart = false
	add_child(fire_rate_timer)
	fire_rate_timer.timeout.connect(shoot)


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
	print("Shooting!")
	for i in range(projectiles_per_shot):
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.rotation = global_rotation + randf_range(-0.1, 0.1)
		bullet.damage = damage
		bullet.init_effects(bullet_effect_defs)
		get_tree().get_first_node_in_group("game_root").add_child(bullet)