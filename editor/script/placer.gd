extends Camera3D

@export var ray_length: int = 1000
@export var cursor: BuildableCursor = null
@export var snapped_status: Label
@export var snap_threshold: float = 2

enum States {Free, Snapped, Overlapping}
var state = States.Free

var target_position: Vector3 = Vector3.ZERO
var is_snapped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	get_target_position()
	var snap_offset = cursor.calculate_snap()
	var distance_to_cursor = target_position.distance_to(cursor.global_position)
	
	if state == States.Free:
		if snap_offset != Vector3.INF and snap_offset.length() < snap_threshold:
			state = States.Snapped
			snapped_status.text = "Snapped"
			cursor.global_position = cursor.global_position - snap_offset
		else:
			cursor.global_position = target_position
	elif state == States.Snapped:
		if distance_to_cursor > snap_threshold:
			state = States.Free
			cursor.global_position = target_position
	
func get_target_position():
	var mouse_pos = get_viewport().get_mouse_position()
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.exclude = [self]
	ray_query.from =from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	if not raycast_result.is_empty():
		target_position = raycast_result.position


func _on_cursor_new_snap_offset(new_offset: Vector3):
	if state == States.Overlapping:
		return
		
	var distance_to_cursor = target_position.distance_to(cursor.global_position)
	snapped_status.text = "Piece Snapped: Yes"
	state = States.Snapped
	cursor.position = cursor.position - new_offset


func _on_cursor_no_snap_offset():
	snapped_status.text = "Piece Snapped: No"
	state = States.Free
	cursor.position = target_position


func _on_cursor_overlapping(overlapping: bool):
	#if overlapping:
		#state = States.Overlapping
	#else:
		#state = States.Free
	pass
