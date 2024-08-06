class_name SnapPoint

extends Area3D

enum State {Cursor, Instance}

var state: State = State.Instance

class SnapOffset:
	var offset_vec: Vector3
	var offset_distance: float
	
	func _init():
		offset_vec = Vector3.INF
		offset_distance = INF

signal new_snap_detected

@export var snap_detector_collider: CollisionShape3D

var current_active_snap_point_offset: Vector3 = Vector3.INF
var current_active_snap_point_distance: float = INF

func snap_detection_active(active: bool):
	if active:
		state = State.Cursor
		snap_detector_collider.disabled = false
	else:
		state = State.Instance
		snap_detector_collider.disabled = true

func _process(_delta):
	if state == State.Cursor:
		calculate_best_snap_point()

func calculate_best_snap_point():
	var collided_areas = get_overlapping_areas()
	if collided_areas.is_empty():
		current_active_snap_point_offset = Vector3.INF
		current_active_snap_point_distance = INF
	else:
		var closest_snap_offset: SnapOffset = SnapOffset.new()
		for instance in collided_areas:
			if instance is BuildableInstance:
				closest_snap_offset = _check_snapping(instance as BuildableInstance)
		
		if closest_snap_offset.offset_distance < current_active_snap_point_distance:
			current_active_snap_point_offset = closest_snap_offset.offset_vec
			current_active_snap_point_distance = closest_snap_offset.offset_distance

func _check_snapping(buildable: BuildableInstance) -> SnapOffset:
	var snap_points: Array[SnapPoint] = buildable.get_snap_points()
	var closest_snap_point_offset: Vector3 = Vector3.INF
	
	var closest_snap_offset: SnapOffset = SnapOffset.new()
	
	for snap_point in snap_points:
		var snap_points_aligned: bool = (-transform.basis.z).dot(snap_point.transform.basis.z) == 1
		if snap_points_aligned:
			var calculated_distance = global_position.distance_to(snap_point.global_position)
			if calculated_distance < closest_snap_offset.offset_distance and calculated_distance > 0:
				closest_snap_offset.offset_vec = global_position - snap_point.global_position
				closest_snap_offset.offset_distance = calculated_distance
	
	return closest_snap_offset
	
