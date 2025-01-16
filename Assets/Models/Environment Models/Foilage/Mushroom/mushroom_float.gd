extends Node3D

@export var force : int = 45

func _on_area_3d_area_entered(area):
	
	if area is HitboxComponent:
		var body = area.get_parent()
		
		if not body is StaticBody3D:
			var rayParams : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(global_transform.origin, body.global_transform.origin)
			var result : Dictionary = get_world_3d().direct_space_state.intersect_ray(rayParams)
			
			if result:
				var source : Vector3 = self.global_transform.origin
				
				var new_force : Vector3 = (body.global_transform.origin - source).normalized() * force
				body.velocity += new_force
			else:
				body.velocity += Vector3.UP * force
			
