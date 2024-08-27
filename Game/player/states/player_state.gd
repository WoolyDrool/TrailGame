extends State
class_name PlayerState

# Nodes
@export var cam_container : Node3D
@export var standing_collision : CollisionShape3D
@export var crouching_collision : CollisionShape3D
@export var ceiling_check : RayCast3D
@export var controller : CharacterBody3D

# Movement
var current_speed : float = 5.0
var input_dir : Vector2
@export var walking_speed : float  = 5
@export var sprinting_speed : float  = 8
@export var crouching_speed : float  = 2.5
@export var jump_velocity : float  = 4.5
@export var move_lerp_speed : float = 10
@export var gravity_accel_ramp : float = 1
@export var grav_multiplier : float = -1
@export var bunny_multiplier : float = 1
@export var bunny_deaccell : float = 0.24

# Camera
@export var mouse_sens : float = 0.4
@export var mouse_smoothing : bool = true
@export var mouse_lerp_speed : float = 20

# Internal variables
var direction = Vector3.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
