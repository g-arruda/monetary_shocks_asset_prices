Olá professor, tudo bem? Inclui as variáveis no modelo e tive que rodar tudo novamente, mas uma coisa estava me incomodando que são os valores para achar r (bai-ng) e q (amengual e watson) em que está dando 5 e 2 respectivamente. Achei os valores baixo então rodei um teste de sensibilidade gerando IRFs para r=5 e r=8, variando (parecido com o que Alessi e Kerssenfischer fazem no artigo deles) apenas q  (fatore dinamico), e também calculei novamente o valor das estatísticas do instrumento.

Notei 2 coisas:
1) O sinal dos impactos não mudam, o que muda é a magnitude.
2) o instrumento fica mais forte à medida que r,q sobe, exemplo: ((5,2), (7,5), (8,8)) = ((2.33), (7.08), (8.08)). Vale notar que r,q=5,2 tem valor abaixo do mínimo para as bandas de Anderson-Rubin.

Minha hipótese é que embora o painel seja amplo, 115 variáveis, creio que dentro de cada bloco muitas variáveis são altamente correlacionadas subestimando o número de fatores estáticos, pois com a normalização cada variável teria peso igual na hora de extrair os fatores, fazendo com que o bloco com mais variáveis teria mais peso na contribuiçao marginal.

Minha dúvida é como prosseguir. Devemos mudar a composição do painel? Penso em duas possibilidades:
1) reduzir o número de variáveis altamente correlacionadas.
2) Incluir mais variáveis fazendo com que o painel fique mais heterogêneo.

Estou anexando as IRFs que incluem as novas variáveis, a tabela com o grid dos valores do instrumento e a tabela das variaveis de Alessi e Kerssenfischer (2019).

Outra coisa que gostaria de informar é que a tabela sobre a identificação por heterocedasticidade já está pronta e estou finalizando a implementação das bandas de Anderson-Rubin para o DFM.