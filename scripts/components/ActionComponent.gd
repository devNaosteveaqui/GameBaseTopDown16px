class_name ActionComponent extends BaseComponents

func jump():
	if not entity.is_in_jump:
		entity.makeMoviment(Movimentos.MOVIMENTS.JUMP)
		entity.nextPosition = entity.position
		entity.jump_origin = entity.position
		entity.is_jumping_up = true
		entity.is_in_jump = true
		entity.set_collision_shape_flags(1,false)
		#deactive_collision_shape()
