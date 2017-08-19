extends RigidBody

const view_sensitivity = 0.25
const SPEED = 20

var yaw = 0   # yaw is left/right (y axis)
var pitch = 0 # pitch is up/down (x axis)

onready var camera = get_node("Camera")

func _ready():
	set_process_input(true)
	
func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		# compute the yaw with full 360 degree rotation
		yaw = fmod(yaw - event.relative_x * view_sensitivity, 360)
	
		# compute pitch with limited +85/-85 rotation, so we don't wrap around
		pitch = max(min(pitch - event.relative_y * view_sensitivity, 85), -85)
	
		# pitch angle goes on camera
		camera.set_rotation_deg(Vector3(pitch, 0, 0))
	
		# yaw goes on player (RigidBody)
		set_rotation_deg(Vector3(0, yaw, 0))
	
	if Input.is_action_pressed("move_forwards"):
		var x = sin(deg2rad(-yaw))
		var z = -cos(deg2rad(yaw))
		set_linear_velocity(Vector3(x, 0, z) * SPEED)
	elif Input.is_action_pressed("move_backwards"):
		var x = sin(deg2rad(-yaw) - PI)
		var z = -cos(deg2rad(yaw) - PI)
		set_linear_velocity(Vector3(x, 0, z) * SPEED)
	elif Input.is_action_pressed("move_left"):
		var x = sin(deg2rad(-yaw) - PI/2)
		var z = -cos(deg2rad(yaw) + PI/2)
		set_linear_velocity(Vector3(x, 0, z) * SPEED)
	elif Input.is_action_pressed("move_right"):
		var x = sin(deg2rad(-yaw) + PI/2)
		var z = -cos(deg2rad(yaw) - PI/2)
		set_linear_velocity(Vector3(x, 0, z) * SPEED)
	else:
		set_linear_velocity(Vector3())