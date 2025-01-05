extends Node3D

@export var force = 45

func _on_area_3d_area_entered(area):
	
	if area is HitboxComponent:
		
		var body = area.get_parent()
		print(body)
		if  not body is StaticBody3D:
			print("alma")
			var rayParams = PhysicsRayQueryParameters3D.create(global_transform.origin, body.global_transform.origin)
			var result = get_world_3d().direct_space_state.intersect_ray(rayParams)
			print(result)
			if result:
				var source = self.global_transform.origin
				
				var new_force = (body.global_transform.origin - source).normalized() * force
				body.velocity += new_force
			else:
				body.velocity += Vector3.UP * force
			
