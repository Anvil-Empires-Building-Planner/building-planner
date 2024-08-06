class_name BuildableInstance
extends Area3D

@export var snap_points: Array[SnapPoint] = []
@export var mesh: MeshInstance3D

@onready var overlapped_material: Material = preload("res://editor/materials/Overlapped.tres")
@onready var not_overlapped_material: Material = preload("res://editor/materials/Not_Overlapped.tres")

func set_overlapped_material(overlapped: bool) -> void:
	print("Setting overlap mat to: " + str(overlapped))
	if overlapped:
		for id in mesh.get_surface_override_material_count():
			mesh.set_surface_override_material(id, overlapped_material)
	else:
		for id in mesh.get_surface_override_material_count():
			mesh.set_surface_override_material(id, not_overlapped_material)

func get_snap_points() -> Array[SnapPoint]:
	return snap_points

func is_cursor(yes: bool):
	for snap_point in snap_points:
		snap_point.snap_detection_active(yes)

func _activate_snap_detection():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
