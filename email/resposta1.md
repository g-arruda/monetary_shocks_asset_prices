# me ajude a responder as perguntas do meu orientador no email.


1. Erro factual que precisa ser corrigido: O abstract (PT e EN) e a conclusão dizem que o BRL/USD deprecia 3,64% no impacto. Mas a Seção 4.2 diz 3,74%. São números diferentes para a mesma estimativa. Isso é o tipo de coisa que impacta a confiança do parecerista no resto do artigo, precisa achar qual dos dois está certo e uniformizar em todo o texto (abstract, introdução, seção 4, conclusão).

Resposta: Esse é um problema de versao, esqueci de atualizar essas seçoes após a mudança no modelo.

----

2. O ponto mais importante, tecnicamente: força do instrumento. Você destaca que Fmprob=10,06 supera a referência convencional só marginalmente, e ξmp=5,24 fica abaixo dela. Isso é uma faca de dois gumes: a transparência é ótima (muita gente esconde primeiro estágio fraco), mas isso vai ser o primeiro alvo de qualquer parecerista, porque é hoje um dos temas mais escrutinados em identificação por instrumento externo. Reparei uma inconsistência: você usa os conjuntos Anderson–Rubin robustos a instrumento fraco (Montiel Olea et al., 2021) só na comparação com o VAR de robustez (Seção 5.1, Figura 7), mas as figuras principais (1-6) usa apenas bandas de wild bootstrap convencionais. Se o instrumento é reconhecidamente fraco/marginal, o resultado principal do artigo também deveria ser acompanhado de inferência robusta a instrumento fraco, não só o benchmark de robustez. Isso fortalece muito o artigo porque antecipa a objeção óbvia.


Resposta: Hoje nao se tem na literatura um mecanismo de inferencia robusta a instrumento fraco aplicado aos modelos DFM. Montiel Olea et al. aplicam a um modelo VAR pequeno e a aplicaçao disso a um modelo DFM requer uma engenharia matematica que nao é trivial e nao sei se tenho capacidade.

----

3. A história de risco soberano/dominância fiscal é afirmada, mas não testada diretamente, e temos os dados para isso.
Você incluiu no painel exatamente o bloco que permitiria testar isso: dívida bruta, dívida líquida, resultado primário, e expectativas Focus para Selic/IPCA/câmbio/PIB. Mas a Seção 4 nunca reporta a resposta desse bloco fiscal a um choque monetário. Isso é uma lacuna concreta e fácil de preencher: se a história é juros sobem => percepção de sustentabilidade da dívida piora => prêmio de risco sobe, mostrar a resposta de dívida/resultado primário/expectativas fiscais Focus dá evidência direta a favor (ou contra) do mecanismo, em vez de deixá-lo como interpretação não testada, que é exatamente o que  admitimos no texto (embora o objetivo deste artigo não seja testar diretamente essa hipótese). Isso também ajudaria a distinguir o canal de dominância fiscal do canal alternativo que você cita na introdução (Dalgic & Ozhan, descasamento cambial/dominant currency pricing), que é uma história diferente e também compatível com os sinais encontrados, mas que você nunca volta a discutir depois da introdução.

Resposta: DLSP, DBGG e NFSP primária caem no início e só voltam a subir depois de cerca de dois anos, enquanto as expectativas de inflação, Selic e câmbio sobem e a de PIB cai antes de uma reversão conjunta. Só que a NFSP primária exclui juros e efeito cambial, e a DLSP incorpora ativos como reservas, então parte do movimento pode vir da forma de contabilização das séries.

Vou incluir as séries de expectativa fiscal no painel e ver o efeito sob a percepção de sustentabilidade da dívida.


----

4. A reconciliação com Gonçalves et al. (2025) me parece fraca demais para o tamanho da contradição.
Não é só uma diferença de magnitude, é uma inversão de sinal (depreciação vs. apreciação) para essencialmente a mesma pergunta no mesmo país. Deixar isso como uma questão em aberto para pesquisa futura é honesto, mas um editor de campo vai querer mais. Sugestão mínima: um parágrafo argumentando por que frequência diária + heterocedasticidade poderia mecanicamente favorecer o canal convencional (ex: heterocedasticidade em torno do anúncio capta primariamente a surpresa de curtíssimo prazo, antes que o mercado precifique o efeito sobre sustentabilidade fiscal, que se manifesta com alguma defasagem), mesmo sem rodar um novo exercício, um argumento causal explícito é bem mais convincente que pode depender da frequência. (Aqui, se decidirmos não rodar o novo exercício, eu posso escrever o argumento).

Resposta: Eu cheguei a tentar aplicar o exercicio, mas nao deu certo pois a agregaçao dos dados mensais ocorre uma diluiçao na variancia, fazendo com que a condiçao do posto desaparecesse, impossibilitando a identificaçao.
----

5. Problemas menores, mas que um editor vai notar na primeira leitura:

Seção 3.6 tem uma referência cruzada quebrada: (Table ??), sobrou do LaTeX, precisa corrigir antes de qualquer submissão.

A comparação DFM vs. VAR (Seção 5.1) usa defasagens diferentes (4 vs. 2) selecionadas por AIC em cada modelo, você mesmo admite que isso contamina a comparação. Vale rodar ao menos uma versão com defasagem casada como checagem adicional, já que é rápido de fazer e fecha uma objeção óbvia.

Resposta: Vou concertar o erro no latex e rodar a mesma defasagem o DFM e o VAR.
