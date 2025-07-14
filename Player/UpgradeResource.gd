# UpgradeResource.gd
@tool
extends Resource
class_name UpgradeResource
@export var id: String               # "multi_shot"
@export var display_name: String
@export var description: String
@export_range(1, 10) var max_level := 3

func apply(_weapon: Node, _level: int) -> void:
	# override per upgrade
	pass