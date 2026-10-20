Boa noite, professor.

Seguem as conferências e a ponte. Em cada resultado, cito o maior nível a que ele é significante, com o intervalo desse nível; os não significantes vão com o intervalo de 90%.

1) A diferença vem do índice de datas, não da seleção. Os carimbos da API caem todos às 00h de Londres, e a data de cada linha é a data UTC do carimbo, que no horário de verão britânico é a da véspera. Pelas datas das linhas, a janela de terça a quinta vai, então, da noite de terça à de quinta nas 63 reuniões do verão europeu e da noite de segunda à de quarta nas 48 do inverno. O horário de apuração não é documentado. A hipótese é o instante do carimbo: 20h em Brasília no verão europeu e 21h fora dele, uma hora a mais com o Brasil no horário de verão. O evento diário usa o Yahoo BRL=X da última cotação antes do anúncio à primeira depois, escolhidas pelo horário, e a janela pelas datas não entra em estimativa alguma. O DFM usa a média mensal das mesmas linhas, pela data da linha. Sob a hipótese, no inverno europeu cada linha traz a cotação da noite anterior à sua data, e a média do mês fica deslocada uma noite para trás. Mantive a série.

2) De 26/11 a 02/12/2013, o CDS vale 202,668 na terça, 205,168 na quarta, 205,000 na quinta e 214,000 na segunda. Não há cotação na sexta 29/11, e por isso a ampliada vai até 02/12. São seis dias, a única janela longa do CDS: as estreitas têm um dia, e as demais ampliadas, três. O valor de 28/11 difere do de quarta, e a amostra tem 39 cotações inteiras, 30 delas em 2013–2014. Sem outra fonte diária, não consigo confirmá-lo nem invalidá-lo. Ele fica na estreita com essa limitação, sem zerar a resposta. A ampliada não depende dele, mas termina em 214,000, também inteiro. A surpresa de DI da reunião entra no instrumento de qualquer forma. Por +50 p.b. no DI de 6 meses, com a surpresa ortogonalizada, o CDS responde −0,8 p.b. na estreita, não significante a 90% ([−6,7; 4,9]), e +7,7 p.b. na ampliada, significante a 90% e não a 95% ([0,7; 15,0]).

3) A contagem confere: são cinco, incluindo 01/11/2023, em que o CDS (17h de Nova York, 18h em Brasília) fica exatamente 30 minutos antes do anúncio. A margem de 30 minutos é uma convenção conservadora da auditoria. O horário da cotação é desconhecido em todas as ambiguidades do CDS e do Yahoo e no DI de 06/09/2017, cujo fim do pregão só tem o limite de fonte secundária. Em 27/11/2013 e 25/11/2015, também o anúncio só tem limite inferior. Os horários são conhecidos, mas próximos, só no DI de 19/06/2019 e de 01/11/2023: último negócio até as 18h00 e anúncio às 18h05 e às 18h30.

4) Na sensibilidade, os sete meses entram com z = 0 nos momentos, como no preenchimento por zero de Montiel Olea, Stock e Watson: contam em T e na variância dos momentos como surpresas nulas, e o VAR usa os 162 meses. É a interpretação como surpresa zero, não a exclusão. Excluí-los não mudaria o ponto, mas mudaria T e a variância dos momentos e, com elas, ξ_mp e os conjuntos. ξ_mp é a Wald de Montiel Olea, Stock e Watson (2021) da covariância entre o instrumento e a inovação dos fatores na direção do DI de 6 meses, com a variância corrigida pela estimação do VAR. A referência é a deles: o conjunto Anderson-Rubin de nível 1−α é limitado se e só se ξ_mp supera o quantil 1−α da χ²₁ (2,71 a 90% e 3,84 a 95%). O 10 é a regra de bolso de Staiger e Stock (1997) para o F de primeiro estágio, que eles também usam como referência para ξ. No artigo, ele é só uma referência convencional, não um limiar que classifica o instrumento.

5) Documentado, 18h00 desde 2019:
- grade de juros da B3 no Wayback Machine, captura de 07/01/2019: https://web.archive.org/web/20190107143157/https://www.b3.com.br/pt_br/solucoes/plataformas/puma-trading-system/para-participantes-e-traders/horario-de-negociacao/derivativos/taxas-de-juros/
- a mesma grade, captura de 24/01/2022: https://web.archive.org/web/20220124102052/https://www.b3.com.br/pt_br/solucoes/plataformas/puma-trading-system/para-participantes-e-traders/horario-de-negociacao/derivativos/taxas-de-juros/
- Ofício Circular 094/2020-PRE: https://www.b3.com.br/data/files/71/43/8B/34/340A37109CFAD937AC094EA8/OC%20094-2020%20PRE%20Novos%20Hor%C3%A1rios%20de%20Negocia%C3%A7%C3%A3o%202020_01112020_R.pdf
- desde 12/12/2022, a grade atual da B3: https://www.b3.com.br/pt_br/solucoes/plataformas/puma-trading-system/para-participantes-e-traders/horario-de-negociacao/derivativos/taxas-de-juros/
- InfoMoney, 23/11/2022: https://www.infomoney.com.br/mercados/b3-altera-modelo-de-definicao-de-ajuste-do-di-que-tera-sessao-continua-ate-18h/

Limite superior de fontes secundárias, 18h15 em 2012–2018, o fim do segmento BM&F. Não encontrei a grade do DI1 desse período.
- Exame, 19/10/2012: https://exame.com/invest/mercados/horario-verao-muda-pregao-bm-fbovespa-506260/
- Jornal do Comércio, 14/10/2016: https://www.jornaldocomercio.com/_conteudo/2016/10/economia/526266-com-horario-de-verao-bm-fbovespa-altera-funcionamento-a-partir-do-dia-17.html

Na ponte, com essas convenções, na produção de 111 reuniões e com a surpresa ortogonalizada:
- Trajetória diária, por +50 p.b. de surpresa, nas 110 reuniões com vigésima cotação. Câmbio: −R$ 0,024 na primeira cotação, −0,022 na quinta e +0,036 na décima, não significantes a 90% ([−0,048; 0,000], [−0,073; 0,030] e [−0,033; 0,105]); +0,104 na vigésima, significante a 95% ([0,006; 0,203]). CDS: −0,8 e +0,6 p.b. na primeira e na quinta, não significantes a 90% ([−6,6; 5,0] e [−18,1; 19,4]); +18,8 na décima, significante a 95% ([4,6; 33,0]); +24,0 na vigésima, significante a 90% e não a 95% ([3,5; 44,5]).
- Forma reduzida mensal, por +50 p.b. de surpresa, nos 162 meses e com as séries do DFM (câmbio pela média mensal, CDS pelo fim do mês). Câmbio: +0,118 no mês, significante a 90% e não a 95% ([0,015; 0,221]); +0,244 até o mês seguinte, significante a 95% ([0,057; 0,431]). CDS: +35,0 e +42,7 p.b., significantes a 95% ([10,7; 59,3] e [8,9; 76,6]).
- DFM, por +50 p.b. no DI de 6 meses: câmbio +R$ 0,125 e CDS +30,6 p.b., significantes a 95% ([0,025; 0,275] e [8,0; 69,3]).

A inversão cambial aparece, assim, já na trajetória diária: o sinal muda entre a quinta e a décima cotação, e a depreciação é significante a 95% na vigésima. Como a primeira, a quinta e a décima cotação não são significantes a 90%, a inversão não fica datada.

Sem as sete janelas longas (104 reuniões), nenhum sinal muda e só duas significâncias mudam. A apreciação na primeira cotação passa a significante a 90% e não a 95% (−R$ 0,030, [−0,057; −0,003]), e o CDS da ampliada deixa de ser significante a 90% (+6,9 p.b., [−1,0; 15,1]). Na forma reduzida mensal, excluir os sete meses em vez de zerá-los muda o câmbio em menos de 0,001 e o CDS em menos de 0,1 p.b.

Abraço,
Gabriel
