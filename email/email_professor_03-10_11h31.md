Bom dia, Gabriel. Tudo bem?

Cara, para tentarmos fechar uma versão do artigo para submetermos, li o texto novamente e pensei num plano de ataque para colocarmos as coisas em ordem e tentar achar uma narrativa coerente para a história. Queria que você lesse os itens a seguir, veja o que acha a respeito e mais ou menos quanto tempo levaria para concluir tudo, caso decida por esse caminho. Qualquer ponto em que você tenha dúvida ou que não esteja de acordo, me diga para alinharmos tudo antes.

A ideia aqui é fechar uma única rodada de verificações para decidirmos a submissão. Não pretendemos demonstrar definitivamente a exogeneidade do instrumento nem identificar que o risco causa a depreciação. Queremos avaliar se a interpretação monetária da resposta conjunta permanece convincente diante das principais ameaças à identificação e à precisão. As checagens abaixo testam se isso resiste a contaminação, a imprecisão e à pandemia. A ordem importa, porque o primeiro passo pode mudar os fatores.

0) Congelar a base. Reconstruir as séries, comparar com as originais e reestimar o caso base completo, incluindo fatores, identificação e IRFs. Primeiro, reporte quanto mudam câmbio e CDS; depois congelamos essa versão para os demais exercícios.

Sobre a interpolação do Focus: Seja m_t ∈ {1,…,12} o mês do calendário de t e Y o ano de t. A previsão de horizonte fixo de 12 meses é:

\(g_t^{12m} = \frac{12-m_t}{12}F_t(g_y)+ \frac{m_t}{12}F_t(g_{y+1}) \)

onde F_t(.) é a mediana da última pesquisa Focus do mês t para o ano indicado. Chamaria essa série de aproximação de horizonte fixo, seguindo o procedimento de ponderação de previsões anuais discutido na literatura, Dovern, Fritsche & Slacalek (2012, Review of Economics and Statistics, “Disagreement among Forecasters in G7 Countries”).



1) Precisão (baixo custo).

- Conjuntos Anderson-Rubin de 95% para câmbio e CDS.

- Tabela curta com o impacto e um conjunto de horizontes escolhido antes de olhar os resultados (sugiro h = 0, 1, 3, 6, 12 e 24 meses), sem selecionar os meses mais favoráveis.

- Intervalos de confiança para a janela pré-COVID.

- Verificar autocorrelação nos termos que compõem os momentos do teste Anderson–Rubin e apresentar sensibilidade a Newey-West com 1 a 3 defasagens, ampliando essa verificação se os diagnósticos indicarem dependência mais longa.

2) Evento diário. Estimar, na amostra comum, a associação das variações diárias de câmbio e CDS com a surpresa bruta e com a surpresa ortogonalizada. Tratar essas regressões como diagnósticos de forma reduzida. Se estimarmos efeitos normalizados por uma variação do DI, explicitar o primeiro estágio e usar inferência apropriada à força do instrumento. O objetivo é verificar em que etapa surge a divergência com a evidência diária, sem atribuí-la antecipadamente à identificação ou à agregação.

3) Medir a influência de cada reunião sobre a relação entre instrumento e inovações. Reestimar excluindo individualmente as reuniões mais influentes e, como exercício adicional, excluindo conjuntamente as 5 e 10 mais influentes. Reportar também a relevância do instrumento e a incerteza após as exclusões. Separadamente, avaliar a exclusão de reuniões com movimentos contemporâneos extremos de VIX, S&P 500 ou Brent, usando uma regra definida previamente. Esse exercício verifica possível contaminação internacional durante a janela do evento, distinta dos controles anteriores ao anúncio usados na ortogonalização. Não selecionar reuniões pelo comportamento de câmbio ou CDS.

4) Placebo. Apresentar os placebos nos horizontes definidos, reportando os resultados pontuais e uma avaliação conjunta ou correção por múltiplos testes. Explicitar a hipótese correspondente ao \(p=0,54\). Se ele testar o coeficiente do EPU na previsão da surpresa, descrevê-lo como ausência de evidência de poder preditivo naquela especificação, sem interpretá-lo como validação da exogeneidade.

5) Apêndice. Respostas de câmbio e CDS com surpresa bruta, instrumento ortogonalizado e filtro de Jarociński-Karadi, com intervalos. Já está estimado e é barato. Mas o filtro não separa um choque de risco de um choque monetário (os dois podem elevar o DI e derrubar a bolsa), então não deve ser usado como argumento central de identificação.

Fica para depois: instrumento alternativo (extensão), números da DBGG e a agregação temporal completa.

Critério de decisão, combinado antes de rodar:

Avaliaremos conjuntamente magnitude, precisão, relevância do instrumento e estabilidade da resposta inicial de câmbio e CDS. Os horizontes posteriores servirão para caracterizar persistência e reversão, sem exigência de manutenção do sinal.

- Se a resposta inicial tiver suporte estatístico e permanecer economicamente estável nas verificações, avançamos para a submissão com uma conclusão delimitada.

- Se o padrão permanecer, mas a precisão for limitada ou diminuir nas subamostras, ajustamos a linguagem e avaliamos se a evidência ainda sustenta uma contribuição publicável.

- Se poucos eventos determinarem o resultado, ou surgirem divergências precisas e substantivas entre desenhos comparáveis, investigamos antes de submeter. Inversões pontuais acompanhadas de grande incerteza não serão tratadas isoladamente como invalidação.

Reportar os conjuntos de confiança de 90% e 95%, sem transformar um nível específico de significância em critério automático de submissão.

Reportar tudo o que rodar, inclusive o que não ficar bom.

