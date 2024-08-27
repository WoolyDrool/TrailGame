extends PlayerTool

@export var max_items : int = 6
var current_items : int = 0
@onready var path : PathFollow3D = $Path3D/PathFollow3D

func _process(delta: float) -> void:
	pass


func _tool_primary() -> void:
	if toolCast.get_collider():
		ray_result = toolCast.get_collider()
	
	if ray_result:
		if ray_result.is_in_group("pickable"):
			print("AAAAAA")
	
	if ray_result:
		print(ray_result)
		if ray_result.is_in_group("pickable"):
			print("AAAAAA")
			ray_result.reparent(self, true)
			ray_result.position = Vector3(path.position.x, path.position.y + path.progress, path.position.z)
		else:
			pass
	pass
