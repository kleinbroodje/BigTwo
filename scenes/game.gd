extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().set_physics_object_picking_sort(true)
	get_viewport().set_physics_object_picking_first_only(true)
