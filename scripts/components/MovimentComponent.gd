class_name MovimentComponent extends BaseComponents

func set_moviment_direction(dir:Vector2):
	entity.movimentDirection = dir

func set_in_moviment():
	entity.inMoviment = 1

func set_not_in_moviment():
	entity.inMoviment = 0

func update_velocity():
	entity.velocity = (entity.get_speed()*entity.movimentDirection)*entity.inMoviment

func reset_character_speed():
	entity.characterSpeed = Vector2((50 if entity.is_in_group(GameConfig.GROUP_ENTITY_PLAYER) else 40),50)
