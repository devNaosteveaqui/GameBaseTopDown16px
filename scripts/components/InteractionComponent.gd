class_name InteractionComponent extends BaseComponents

func get_position_on_eye():
	return entity.position + entity.raycast.target_position
func get_target_on_range():
	return entity.raycast.get_collider()
