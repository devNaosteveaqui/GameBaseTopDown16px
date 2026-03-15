class_name MovimentPatternDetectionComponent extends BaseComponents

func interuptSequence():
	var size_sequence = entity.sequence_click.size() 
	for i in size_sequence:
		if entity.sequence_click.size() == 0:
			return
		if Movimentos.isMovimentExecution(entity.sequence_click[0]):
			entity.sequence_click.pop_front()
			continue
		entity.sequence_click.pop_front()

func makeMoviment(moviment):
	## Logica
	#-> movimento realizado
	#--> Verifica se já foram adicionados movimentos de mais, se verdade então reseta a sequencia e adiciona a pilha,
	# caso contrário só adiciona na pilha
	#--> A cada movimento inicia-se um timer para que seja executado o movimento
	if entity.sequence_click.size() + 1 > 3:
		interuptSequence()
	entity.moviment_timer.start(0.4)
	entity.sequence_click.append(moviment)

func get_sequence():
	var seq = []
	for i in entity.sequence_click.size():
		if Movimentos.isMovimentExecution(entity.sequence_click[i]):
			seq.append(entity.sequence_click[i])
			return seq
		seq.append(entity.sequence_click[i])
	return seq
