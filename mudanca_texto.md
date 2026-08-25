Revise o manuscrito ativo `paper/paper_anpec.tex` conforme as orientações abaixo. Faça as alterações no texto e na apresentação das figuras, mas não altere código de estimação, especificações, resultados ou artefatos
  quantitativos sem autorização explícita.

  ## Preparação obrigatória

  Antes de editar, leia integralmente:

  - `README.md`
  - `registro/metodo.md`
  - `registro/pendencias.md`
  - `registro/historico_decisoes.md`
  - `output/irf/irf_section.md`
  - `script/README.md`

  Consulte os artigos relevantes em `artigos/` sempre que uma solicitação envolver interpretação, atribuição ou validade metodológica. Confirme afirmações numéricas nas tabelas, CSVs ou RDS que lhes dão origem.

  Use a skill `como-escrever` para revisar a prosa acadêmica em português, sobretudo a seção 3.6. Aplique-a para melhorar clareza, encadeamento e economia, sem transformar cada escolha metodológica em uma justificativa
  preventiva.

  Preserve:

  - a voz geral do manuscrito;
  - a notação adotada;
  - as especificações vigentes;
  - a distinção entre DFM e benchmark VAR;
  - o grau de cautela autorizado pela evidência;
  - a regra de que bandas de 68% não devem ser descritas como significância estatística.

  ## Método de trabalho

  Antes de realizar cada alteração, classifique-a internamente como:

  1. alteração editorial direta;
  2. alteração que exige verificação na fonte;
  3. questão que exige decisão metodológica ou editorial.

  Implemente diretamente as alterações editoriais. Nos demais casos, verifique primeiro os artigos, os registros do projeto e os artefatos relevantes.

  Se uma solicitação conflitar com a evidência, com a metodologia vigente ou com uma decisão registrada, não introduza uma afirmação incorreta. Preserve apenas o conteúdo indispensável e registre o conflito no relatório
  final.

  Não reviva especificações rejeitadas e não reabra decisões encerradas sem evidência nova.

  ## Diretriz transversal de estilo

  O manuscrito está excessivamente defensivo. Revise todas as seções, inclusive passagens não mencionadas individualmente abaixo, para eliminar explicações que antecipam objeções sem serem necessárias à compreensão ou à
  validade do argumento.

  Procure especialmente frases que:

  - expliquem por que uma alternativa não foi adotada;
  - relatem a trajetória interna da pesquisa;
  - defendam uma escolha antes que exista uma objeção concreta;
  - citem autores apenas para legitimar uma decisão operacional;
  - enumerem repetidamente o que o artigo não faz;
  - acumulem ressalvas depois de uma afirmação já delimitada;
  - transformem diagnósticos auxiliares em justificativas metodológicas extensas;
  - respondam preventivamente a um possível referee;
  - descrevam onde uma escolha foi implementada quando basta dizer o que foi feito.

  Aplique esta regra de decisão:

  1. Se a informação é necessária para compreender, reproduzir ou interpretar corretamente a estimativa, mantenha-a de forma direta.
  2. Se ela apresenta uma limitação que modifica o alcance da conclusão, declare-a uma única vez, no local apropriado.
  3. Se ela apenas explica por que os autores não adotaram outra alternativa, corte-a.
  4. Se algum detalhe for necessário apenas para documentação, transfira-o para nota, apêndice ou registro metodológico.
  5. Se a frase existe apenas para prevenir uma crítica hipotética e não modifica a interpretação da evidência, remova-a.
  6. Não substitua uma frase defensiva por outra justificativa equivalente.

  Apresente primeiro o que foi feito, como foi estimado e o que foi encontrado. Explique a razão de uma escolha apenas quando essa razão for necessária para entender a identificação, a estimação ou a interpretação.

  O artigo não deve funcionar como resposta antecipada a pareceristas nem como registro da trajetória da pesquisa.

  Na revisão final, procure o acúmulo de construções como:

  - “por essa razão”;
  - “segue a implementação de”;
  - “não foi escolhido porque”;
  - “não implica”;
  - “não constitui”;
  - “não se transfere”;
  - “não torna equivalentes”;
  - “não deve ser interpretado como”.

  Essas expressões não são proibidas isoladamente. Entretanto, duas ou mais construções desse tipo no mesmo parágrafo indicam que o trecho provavelmente deve ser condensado.

  ## Seção 3

  ### 3.1. O Modelo de Fatores Dinâmicos Estruturais

  - Retire da discussão da equação 5 a atribuição da normalização a Barigozzi et al. caso essa normalização apareça apenas no código dos autores e não no artigo.
  - Descreva diretamente a normalização adotada.
  - Remova a frase: “Por essa razão os critérios de Bai & Ng (2002) não entram na forma padrão: eles pressupõem séries estacionárias.”
  - Não sugira que Bai–Ng deixou de ser empregado.
  - Diferencie, apenas se isso for necessário para evitar erro factual, a família de critérios utilizada da aplicação simples de Bai e Ng (2002).
  - Reescreva a passagem sobre Barigozzi et al. (2016) para afirmar que a normalização preserva a estrutura de fatores sob não estacionariedade, atribuindo essa interpretação a Alessi e coautores se a fonte confirmar essa
  atribuição.
  - Evite transformar essa explicação em uma defesa longa da escolha metodológica.

  ### 3.3. Identificação por instrumento externo

  - Verifique na fonte correspondente em `artigos/` se a condição lead–lag discutida no segundo parágrafo pertence ao LP-IV.
  - Determine se essa condição é aplicável ao procedimento efetivamente usado no artigo.
  - Se não for pertinente ao modelo estimado, remova a discussão.
  - Remova a frase: “O alinhamento temporal segue a implementação computacional de Alessi & Kerssenfischer (2019).”
  - Descreva o alinhamento temporal diretamente apenas se ele for necessário para compreender ou reproduzir a construção do instrumento.

  ### 3.5. Seleção de (r, q) e estimação

  - Informe de forma direta que `p = 4` foi selecionado pelo AIC.
  - Preserve somente os detalhes necessários para definir corretamente o exercício de seleção.
  - Remova a frase: “Nenhuma dimensão foi escolhida pela célula de maior força do instrumento, porque selecionar a especificação pela estatística de relevância converteria um diagnóstico em critério de especificação,
  procedimento que Montiel Olea et al. (2021) desaconselham.”
  - Não substitua essa frase por outra defesa da separação entre seleção do modelo e relevância do instrumento.
  - Simplifique a passagem sobre a correção de Kilian. Diga apenas que a correção foi implementada, sem mencionar onde está implementada.

  ### 3.6. Relevância do instrumento

  Reescreva integralmente a subseção com a skill `como-escrever`.

  A nova versão deve:

  - explicar de forma direta o que cada diagnóstico mede;
  - distinguir relevância do instrumento, inferência robusta a instrumento fraco e validade ou exogeneidade da proxy;
  - manter a distinção entre a inferência operacional do DFM e os conjuntos AR/MOSW próprios do benchmark VAR;
  - evitar justificativas defensivas e apartes técnicos dispensáveis;
  - não usar o valor 10 como se fosse valor crítico aplicável aos diagnósticos do projeto;
  - não descrever bandas de 68% como significância estatística;
  - apresentar os resultados antes de suas qualificações;
  - mencionar limitações apenas quando elas alterarem o alcance da conclusão.

  Além disso:

  - Remova da nota de rodapé a frase: “A teoria de inferência dos autores é formulada para um VAR de observáveis e não contempla a estimação prévia dos fatores e das cargas do DFM, de modo que sua cobertura Anderson–Rubin não
  se transfere diretamente às respostas observáveis do DFM.”
  - Omita as raízes das matrizes companion.
  - Remova a frase: “O valor 10 é uma referência convencional para o F de primeiro estágio homoscedástico do 2SLS, e não um valor crítico que Montiel Olea et al. (2021) derivem para a Wald robusta a heterocedasticidade usada
  aqui, então ele orienta a leitura sem constituir um teste.”
  - Encurte a legenda da tabela.
  - Mantenha na legenda somente o objeto apresentado, a especificação ou amostra indispensável e a definição de abreviações não evidentes.

  ## Seção 4. Resultados

  Amplie a interpretação das IRFs em toda a seção. A discussão atual está concentrada demais no impacto.

  Para cada grupo de variáveis, descreva, quando os artefatos permitirem:

  - o sinal e a magnitude no impacto;
  - a evolução nos primeiros horizontes;
  - o momento do pico ou do vale;
  - a persistência ou dissipação da resposta;
  - eventual reversão à média;
  - eventual cruzamento de zero;
  - estabilização ou mudança de sinal;
  - a incerteza indicada pelas bandas de 68% e 90%.

  Separe claramente:

  1. a descrição da trajetória estimada;
  2. a precisão estatística;
  3. a interpretação econômica autorizada pelo desenho.

  Não atribua mecanismos econômicos que não sejam identificados pelo modelo. Não converta uma descrição da trajetória em evidência de um canal específico.

  Use números apenas quando confirmados nos artefatos de origem. Evite repetir em prosa todos os valores já visíveis nas figuras. Selecione os horizontes e magnitudes que caracterizam a dinâmica.

  ### 4.1. Estrutura a termo

  Remova o trecho:

  “As respostas alcançam valores maiores nos primeiros meses e depois revertem, mas o horizonte e a magnitude dessa reversão variam com a defasagem do VAR dos fatores. A reversão é, portanto, uma propriedade da dinâmica
  conjunta estimada e não uma confirmação independente de um canal de prêmio de prazo ou de risco.”

  Se a exclusão prejudicar a continuidade, substitua-o por uma descrição objetiva das trajetórias da especificação de produção.

  Não discuta variações na defasagem do VAR dos fatores se elas não fizerem parte da especificação ou da robustez apresentada nessa seção.

  ### 4.2. Câmbio e risco soberano

  - Localize a expressão “calculada com média amostral”.
  - Determine qual quantidade foi calculada dessa forma e por que a média amostral seria necessária.
  - Se a média amostral for indispensável à conversão, explique a operação concretamente.
  - Se não for indispensável, elimine a expressão.
  - Substitua “sob reescala linear” por uma descrição concreta da transformação realizada.
  - Informe numerador, denominador e unidade quando forem necessários para compreender a magnitude.
  - Remova a frase: “Essa normalização aritmética coloca o tamanho do choque na mesma base, mas não torna equivalentes estimativas com frequências, horizontes, estratégias de identificação e denominadores cambiais distintos.”
  - Não substitua essa frase por outra lista de ressalvas sobre comparabilidade.

  ### 4.5. Preços

  - Retire do texto a comparação entre variantes do instrumento.
  - Concentre a subseção nos resultados da variante de produção `z_jk_bs_purif`.
  - Descreva a trajetória das respostas, e não apenas seu valor no impacto.
  - Mantenha comparações entre variáveis de preços somente quando elas ajudarem a interpretar a dinâmica da especificação principal.

  ## Seção 5. Robustez

  A seção deve apresentar as verificações que efetivamente informam a interpretação dos resultados. Não transforme cada robustez em uma defesa antecipada do artigo.

  Para cada exercício, deixe claro:

  - qual hipótese ou vulnerabilidade ele examina;
  - qual é o resultado;
  - o que esse resultado permite concluir;
  - o que permanece fora do alcance do teste, apenas quando essa limitação for necessária.

  Mova para apêndice ou remova exercícios cuja apresentação no corpo gere mais confusão do que informação.

  ### 5.1. Exogeneidade do instrumento

  Avalie a utilidade da atual figura 7, referente aos placebos.

  Considere o risco de um leitor interpretar visualmente uma resposta pontual como evidência, apesar da incerteza.

  - Verifique os resultados com bandas de 90% e 68%.
  - Avalie se a ausência de detecção a 90%, combinada com alguma evidência a 68%, pode sustentar uma objeção de referee.
  - Não descreva ausência de detecção como prova de ausência de contaminação.
  - Decida entre manter a figura no texto, movê-la para o apêndice ou removê-la.
  - Fundamente a decisão na função probatória do exercício, e não apenas na aparência da IRF.
  - Se a figura permanecer, torne a legenda e a discussão explícitas sobre a leitura das bandas.
  - Evite uma longa enumeração defensiva do que o teste não identifica.

  ### 5.2. Invertibilidade do sistema

  - Remova a discussão do teste lead–lag se a consulta à fonte confirmar que ele não é pertinente ao artigo ou ao estimador utilizado.
  - Avalie se o conteúdo restante justifica uma subseção autônoma.
  - Se não justificar, converta-o em um parágrafo conciso na subseção metodológica mais adequada da seção 3.
  - Use uma nota de rodapé apenas se houver documentação acessória que o leitor típico possa dispensar.
  - Preserve somente a ressalva metodológica necessária para delimitar o alcance da identificação.
  - Não mantenha a subseção apenas para antecipar uma possível crítica.

  ### 5.3. Benchmark VAR sob instrumento fraco

  - Corrija qualquer título ou frase truncada no início da subseção.
  - Preserve a especificação vigente `ibc5_fx_cds_level_trend_p2`.
  - Preserve sua inferência VAR-only por inversão dos testes AR/MOSW.
  - Não transfira essa inferência para o DFM.
  - Apresente as IRFs do DFM e do VAR lado a lado.
  - Identifique claramente escalas, horizontes, normalização, variáveis e bandas.
  - Se as definições diferirem, explique a diferença de forma breve e concreta.
  - Não sugira comparabilidade direta quando os objetos não forem comparáveis.

  Remova as frases:

  “Nenhum dos procedimentos testa a exogeneidade da proxy ou exclui um confundidor comum aos dois sistemas.”

  “Além disso, a documentação corrente não estabelece por completo a aplicabilidade assintótica do procedimento de Montiel Olea et al. (2021) ao sistema estimado em níveis com tendência linear.”

  Reforce a justificativa para manter o DFM como especificação principal. Desenvolva o argumento de insuficiência informacional do VAR pequeno:

  - o VAR condiciona a identificação e a dinâmica a um conjunto restrito de observáveis;
  - o DFM utiliza a informação comum de um painel amplo;
  - essa diferença sustenta o papel do DFM como especificação principal em um ambiente no qual a política monetária e os agentes observam um conjunto informacional maior.

  Apresente esse argumento como motivação e vantagem informacional do DFM. Não trate a comparação como prova automática de que o DFM elimina misspecification, invalidez da proxy ou problemas de instrumento fraco.

  Mantenha o benchmark como contraste disciplinado, não como especificação concorrente com igual papel no artigo.

  ### 5.4. O filtro de sinal seleciona risco soberano?

  Remova as frases:

  “A regra de leitura foi fixada sobre o EMBI+ antes que os números do CDS existissem, e o CDS é julgado pela mesma regra.”

  “O teste diário não detecta seleção de mais risco soberano, mas a reclassificação mostra que valores e máscara afetam separadamente a relevância e reforça a cautela com magnitudes e intervalos.”

  Depois das exclusões:

  - ajuste as transições;
  - descreva diretamente o teste realizado e seu resultado;
  - não relate a cronologia interna pela qual a regra de leitura foi escolhida;
  - não extrapole o que os testes permitem concluir;
  - não substitua as frases removidas por uma nova defesa da regra de classificação.

  ### 5.5. O filtro de sinal seleciona notícias do FOMC?

  Remova a frase:

  “Pela regra fixada antes da estimação, o veredito é, portanto, sinal fraco de contaminação FOMC: as regressões contemporâneas não a confirmam, mas a perda de relevância sob reclassificação impede absolvê-la.”

  Reescreva o parágrafo restante para apresentar separadamente:

  - o resultado das regressões contemporâneas;
  - o resultado da reclassificação;
  - a incerteza interpretativa que permanece.

  Não formule um “veredito” agregado se os dois exercícios respondem a perguntas diferentes. Não use linguagem de absolvição, contaminação presumida ou defesa preventiva.

  ## Figuras e tabelas

  Ao alterar a apresentação:

  - preserve o estilo visual estabelecido para as bandas;
  - não regenere resultados que não precisem ser modificados;
  - não altere valores, bandas ou escalas para produzir uma narrativa mais favorável;
  - mantenha legendas autocontidas, mas curtas;
  - defina símbolos e abreviações não evidentes;
  - confirme que referências cruzadas, numeração e chamadas no texto continuam corretas.

  Para a comparação DFM × VAR, reutilize artefatos existentes sempre que possível. Se uma nova composição visual for necessária, altere apenas o código ou arquivo responsável pela disposição da figura, sem reestimar os
  modelos.

  ## Verificação final

  Antes de concluir:

  1. Confira as citações alteradas diretamente nos artigos correspondentes.
  2. Registre artigo e página ou seção para cada verificação metodológica relevante.
  3. Confira toda afirmação numérica nos artefatos que a originam.
  4. Verifique que nenhuma passagem revive especificações rejeitadas em `registro/historico_decisoes.md`.
  5. Verifique a coerência com `registro/metodo.md` e `registro/pendencias.md`.
  6. Confirme que as exclusões não deixaram frases truncadas, referências órfãs, notas sem chamada ou transições quebradas.
  7. Confirme que figuras, tabelas, números e referências cruzadas apontam para os objetos corretos.
  8. Faça uma varredura global por prosa defensiva, não apenas nas frases citadas neste prompt.
  9. Verifique se cada limitação mantida modifica efetivamente o alcance de alguma conclusão.
  10. Confirme que detalhes removidos do texto principal continuam disponíveis em apêndices ou registros quando forem necessários à reprodução.
  11. Compile `paper/paper_anpec.tex` com a skill `compiletex`.
  12. Corrija erros ou avisos introduzidos pela revisão.
  13. Examine `git diff --check` e `git status --short`.
  14. Confirme que as mudanças ficaram restritas ao escopo solicitado e preserve modificações preexistentes não relacionadas.

  ## Entrega

  Entregue ao final:

  1. um resumo curto das alterações por subseção;
  2. os principais exemplos de prosa defensiva removida ou condensada;
  3. as verificações metodológicas realizadas, com artigo e página ou seção;
  4. a decisão sobre a figura 7 e sua justificativa;
  5. a decisão sobre a subseção 5.2;
  6. a solução adotada para a comparação visual DFM × VAR;
  7. conflitos entre as solicitações e as fontes ou decisões vigentes;
  8. pontos que permaneceram incertos;
  9. o resultado da compilação;
  10. a lista exata dos arquivos alterados.

  Faça uma revisão textual e metodologicamente disciplinada. Implemente as preferências editoriais solicitadas, elimine a prosa defensiva em todo o manuscrito e preserve apenas as explicações necessárias para compreender,
  reproduzir ou interpretar corretamente os resultados.