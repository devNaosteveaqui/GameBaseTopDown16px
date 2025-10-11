Esse arquivo tem como intuito de organizar ideias de implementações para o jogo, considerando as alterações
nescessárias para serem aplicadas.

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

Os npcs terão diálogos de respostas diferentes para cada situação em que o jogador se encontrar. Por exemplo,
se o jogador ao fazer uma missão que precisa pelo menos uma quantidade X de objetivos completados, dependendo
da quantidade ele terá uma resposta peculiar, se conseguiu apenas o minimo ele dará uma resposta mais desanimada
ou apenas indiferente dependendo da personalidade do npc, e quanto maior a quantidade, mais intenso será a resposta,
mais impressionado o npc ficará ou mais.

Os npcs enquanto vivos, procuram evoluir concluindo objetivos, caçando, matando, construindo, imitando o que ve.

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

Blocos de Slimes quando colocados podem guardar itens dentro, qualquer item que encostar no placeable
será absrovido e preservado dentro do bloco de slime, estando sempre visivel. Para retirar só é
preciso interagir com o bloco.

Ef_0 - Itens com tempo de validade irão ter seu tempo extendido para a preservação mais longa do item
Ef_1 - Itens envelhecidos possuem uma chance em intervalos de tempo fixos, de receberem melhorias,
como manutenção ou até um upgrade, como também downgrade ou danos.
Ef_2 - Caso o placeable tenha um item dentro e esse bloco sofra dano, ele irá absorver qualquer
energia magica que exista no item, se não houver ele irá esperar até tiver perdido 50% da resistencia
e ao atingir essa faixa ele irá consumir o iten para se restaurar.
