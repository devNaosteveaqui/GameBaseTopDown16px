class_name JumpComponent extends BaseComponents

func update_shadow_position():
	if entity.is_in_jump:
		entity.shadow.offset = (entity.position - entity.nextPosition)*(-1) + Vector2(0,8)
	else:
		entity.shadow.offset = Vector2(0,8)

func reset_character_speed_jump():
	entity.characterSpeed = Vector2((50 if entity.is_in_group(GameConfig.GROUP_ENTITY_PLAYER) else 40),100)

func calculate_jump_height(target:Vector2,jump_heigth:Vector2=Vector2(48,48)):
	if entity.jump_origin.distance_to(entity.nextPosition + target*0.8) < entity.jump_heigth.x:
		entity.nextPosition = entity.nextPosition + target*0.8
		jump_heigth.y = 48 + (-1)*(entity.jump_origin.y - entity.nextPosition.y)
		return jump_heigth

func update_jump_flags(jump_heigth):
	if entity.is_jumping_up and entity.nextPosition.y - entity.position.y > jump_heigth.y:
		entity.is_jumping_up = false
		entity.is_jumping_down = true
	elif entity.is_jumping_down and entity.nextPosition.y - entity.position.y <= 0:
		entity.is_jumping_down = false
		entity.is_in_jump = false
		if not entity.is_jumpend_collide_possible:
			entity.set_collision_shape_flags(0,true)
			#active_collision_shape()

func get_jump_dir():
	if entity.is_jumping_up:
		return -1
	elif entity.is_jumping_down:
		return 1

func is_only_jump(target):
	return target.is_equal_approx(Vector2.ZERO) and entity.is_in_jump
