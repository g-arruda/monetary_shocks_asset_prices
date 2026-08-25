# Parecer sobre a narrativa da seção 5.3

## 1. Diagnóstico central

A seção atual parte de um problema correto, a força limitada da proxy no espaço dos fatores, mas atribui ao VAR pequeno uma função mais ampla do que o exercício pode cumprir. A palavra “verificação” sugere que a cobertura Anderson--Rubin do VAR alcançaria o DFM. Essa leitura seria indevida porque os conjuntos AR são construídos para um sistema de cinco observáveis, sem fatores ou cargas estimados, enquanto o DFM contém regressores gerados e não dispõe de um procedimento operacional que preserve cobertura sob instrumento fraco. O VAR pode responder se o padrão de curto prazo reaparece em outro sistema no qual a inversão AR/MOSW é aplicável. Ele não pode validar as respostas do DFM.

A frase segundo a qual o DFM permanece principal “porque usa as 111 séries” também precisa de revisão. O número de séries descreve a cobertura transversal do objeto estimado, mas não demonstra fundamentalidade, suficiência informacional ou superioridade inferencial. A primazia do DFM deve decorrer da pergunta empírica do artigo, que trata da propagação conjunta do choque entre variáveis macroeconômicas, curva de juros e classes de ativos. Essa cobertura é uma contribuição informacional do desenho, mas sua vantagem sobre o espaço do VAR pequeno ainda não foi medida por uma comparação direta.

O enquadramento defensável é o de um benchmark de baixa dimensão para triangulação qualitativa de curto prazo. A mesma proxy e a mesma normalização tornam os sinais comparáveis, mas os dois modelos têm informação, inovações, dinâmica e estimandos distintos. A inferência AR/MOSW pertence apenas ao VAR observável. No DFM, a estatística $\xi_{mp}=6{,}27$ exige cautela com as bandas convencionais, e a inferência weak-IV que incorpore a estimação de fatores e cargas permanece sem solução operacional.

## 2. Objeção mais forte do referee

A objeção adversarial pode ser formulada da seguinte maneira. O artigo apresenta um VAR pequeno, no qual os conjuntos AR são computáveis, como se esse exercício reparasse a fragilidade inferencial do DFM. Ao mesmo tempo, defende o DFM pelo painel de 111 séries sem demonstrar que esse espaço informacional recupera o choque melhor que o VAR. Como os modelos usam a mesma proxy, a concordância de sinais pode refletir a mesma contaminação, e a discordância de trajetórias pode decorrer da diferença entre os sistemas. O exercício não valida o DFM, não testa a validade da proxy e não identifica qual modelo contém a informação relevante.

A melhor resposta admissível deve aceitar o limite e estreitar a alegação. O VAR fornece uma triangulação porque reproduz, no impacto, os cinco sinais das variáveis comuns e permite inferência que não pressupõe uma proxy forte dentro daquele sistema. A concordância indica que o padrão qualitativo de curto prazo não depende exclusivamente da dinâmica fatorial de grande dimensão. Ela não transfere cobertura, não iguala magnitudes e não resolve omissão informacional. O DFM continua central porque estima o objeto transversal que motiva o artigo, enquanto o VAR responde apenas a uma pergunta auxiliar e mais estreita.

## 3. Caminhos alternativos, em ordem de preferência

1. Triangulação hierárquica no corpo, recomendada. Abrir pela limitação do DFM, formular a pergunta estreita, apresentar o VAR e seus conjuntos AR, interpretar apenas a concordância qualitativa de curto prazo e retornar ao objeto transversal do DFM. Esse caminho preserva o resultado existente e reduz o risco de sobrealegação.

2. Limitação antecipada na metodologia e subseção curta de robustez. Registrar antes dos resultados que não há cobertura weak-IV operacional para o DFM e reservar a seção 5.3 a uma síntese breve do VAR. A separação melhora a transparência, mas enfraquece a ligação imediata entre a limitação e a pergunta respondida pelo benchmark.

3. Exercício técnico predominantemente no apêndice. Manter no corpo apenas os sinais comuns e os horizontes cobertos a 90%, deslocando seleção de defasagens, divisor da covariância, NW(0) e topologias dos conjuntos para apêndice ou legenda técnica. Essa opção reduz a interrupção da narrativa, mas exige que o corpo preserve a limitação conceitual.

4. Diagnóstico futuro por correlações canônicas. Uma extensão poderia comparar diretamente o conteúdo informacional das inovações do VAR com o espaço das inovações fatoriais, por exemplo mediante correlações canônicas e medidas de informação incremental. Esse diagnóstico não integra a produção atual, não deve ser antecipado como resultado e, sozinho, tampouco provaria fundamentalidade.

## 4. Arquitetura narrativa recomendada

A abertura deve enunciar a lacuna inferencial do DFM e a pergunta limitada que o VAR pode responder. O segundo movimento apresenta as cinco variáveis, a especificação em nível com constante e tendência, a mesma proxy e a normalização de 50 pontos-base, já advertindo que os sistemas não têm o mesmo conjunto de informação nem o mesmo estimando. O terceiro movimento reporta primeiro a concordância dos cinco sinais no impacto e depois os horizontes em que os conjuntos de 90% excluem zero.

A interpretação deve vir logo após os resultados e se limitar à compatibilidade qualitativa concentrada no curto prazo. Em seguida, a seção deve declarar que a inversão AR/MOSW trata a baixa relevância no VAR, mas não testa exogeneidade da proxy, não cobre o DFM e não elimina a possibilidade de informação omitida no VAR pequeno. O fechamento retorna ao DFM, cuja função é descrever a propagação conjunta em 111 séries, e qualifica suas bandas diante de $\xi_{mp}=6{,}27$. Detalhes de AIC/BIC, divisor da covariância e topologias dos conjuntos devem ir para apêndice ou legenda técnica quando o texto for revisto.

## 5. Versão-modelo da seção 5.3

### Inferência sob instrumento fraco e benchmark de baixa dimensão

A inferência do DFM permanece limitada pela força da proxy no espaço dos fatores. A estatística $\xi_{mp}=6{,}27$ na amostra completa recomenda cautela com as bandas do *wild bootstrap*, pois ainda não há um procedimento Anderson--Rubin operacional que incorpore a estimação dos fatores, das cargas e da dinâmica fatorial. Diante dessa limitação, esta subseção responde a uma pergunta mais estreita. Os sinais de curto prazo das cinco variáveis comuns ao resultado principal também aparecem em um sistema de observáveis no qual a inversão Anderson--Rubin de Montiel Olea, Stock e Watson pode ser aplicada sem regressores gerados?

O benchmark contém IBC-Br, IPCA, yield de seis meses, câmbio BRL/USD e CDS soberano de cinco anos em nível. Cada equação inclui constante e tendência linear, e o VAR usa duas defasagens, selecionadas pelo AIC em uma amostra comum. A identificação emprega a mesma proxy do DFM e normaliza o choque para elevar o yield de seis meses em 50 pontos-base no impacto. Essas escolhas aproximam o choque e a escala dos dois exercícios, mas não tornam os modelos equivalentes. O VAR e o DFM usam conjuntos de informação distintos, geram inovações diferentes e propagam o impacto por dinâmicas próprias, de modo que seus pontos estimam objetos relacionados, mas não idênticos.

Os cinco sinais coincidem no impacto. Em ambos os modelos, o IBC-Br e o IPCA caem, enquanto o yield de seis meses, o câmbio BRL/USD e o CDS aumentam. No VAR, os conjuntos Anderson--Rubin de 90% excluem zero para o IBC-Br apenas no impacto. O conjunto do yield exclui zero entre $h=0$ e $h=7$, o do câmbio entre $h=0$ e $h=3$, e o do CDS entre $h=0$ e $h=10$. Para o IPCA, o conjunto de 90% contém zero em todos os horizontes. Esse padrão concentra a concordância nas respostas iniciais e não sustenta uma comparação de magnitudes ou trajetórias entre os modelos.

A concordância dos sinais constitui uma triangulação qualitativa de curto prazo. O resultado indica que a queda inicial da atividade e as altas do yield, do câmbio e do CDS não aparecem apenas quando a proxy é projetada sobre as inovações fatoriais. O exercício tem alcance delimitado, contudo, porque a mesma proxy identifica os dois sistemas. A inversão Anderson--Rubin protege a cobertura contra baixa relevância da proxy no VAR observável, mas não testa a exogeneidade da proxy. Por essa razão, o benchmark não exclui um confundidor comum aos dois modelos e não transforma concordância em validação do choque estrutural.

Os conjuntos do VAR também não fornecem cobertura para as respostas do DFM. A justificativa da inversão Anderson--Rubin no sistema observável não se transfere a um modelo que estima previamente fatores e cargas, e nenhuma derivação adotada no artigo incorpora essa incerteza sob instrumento fraco. A recíproca também vale. O VAR de cinco variáveis pode omitir informação usada pelos agentes e pelo Banco Central, de modo que seus conjuntos não corrigem eventual não fundamentalidade produzida pela baixa dimensão. A presença de constante e tendência trata componentes determinísticos, mas não demonstra por si só que a especificação em níveis satisfaz todas as condições assintóticas do procedimento MOSW.

O DFM permanece o objeto principal porque a pergunta do artigo é transversal. O painel de 111 séries permite acompanhar a propagação conjunta do choque entre atividade, preços, curva de juros, câmbio, risco soberano, crédito e classes de ativos, enquanto o VAR cobre apenas cinco observáveis. Essa diferença define o alcance empírico do DFM, mas não prova que a grande dimensão garante fundamentalidade ou maior precisão. A evidência conjunta deve ser lida em dois níveis. O VAR sustenta compatibilidade qualitativa de curto prazo com conjuntos robustos à baixa relevância dentro do sistema observável. O DFM descreve a propagação transversal, mas suas bandas de 68% e 90% permanecem condicionadas à cautela indicada por $\xi_{mp}=6{,}27$.

## 6. Afirmações que devem ser evitadas

- O VAR “valida”, “verifica” ou “confirma formalmente” as respostas do DFM.
- Os dois modelos estimam o mesmo objeto ou deveriam produzir magnitudes e trajetórias iguais.
- A concordância dos sinais demonstra exogeneidade ou validade da proxy.
- Os conjuntos AR do VAR fornecem cobertura para os pontos ou bandas do DFM.
- O uso de 111 séries garante fundamentalidade, suficiência informacional ou superioridade inferencial.
- A robustez a instrumento fraco elimina a possibilidade de informação omitida no VAR pequeno.
- Uma banda de 68% que exclui zero autoriza chamar a resposta de “significativa”.

## 7. Pressupostos, verificações e incertezas

O parecer consultou a seção corrente de `paper/paper_anpec.tex`, `README.md`, `registro/metodo.md`, `registro/pendencias.md`, `registro/historico_decisoes.md`, a nota corrente `notas/2026-08-22_var_niveis_aic_tendencia.md`, `output/var/svar_iv_weak_robust.csv`, `output/var/svar_iv_weak_robust_diag.csv`, `output/var/svar_iv_weak_robust.md`, `output/irf/irf_coherence_h.csv`, `output/irf/irf_section.md` e a figura renderizada `paper/fig_weak_iv_main.pdf`.

Os CSVs confirmam os cinco sinais comuns no impacto. Na faixa de 90%, o conjunto do IBC-Br exclui zero apenas em $h=0$, o do yield em $h=0,\ldots,7$, o do câmbio em $h=0,\ldots,3$ e o do CDS em $h=0,\ldots,10$. O conjunto do IPCA contém zero em todos os horizontes. A figura reproduz essas janelas e mostra a ampliação dos conjuntos fora do curto prazo.

Os dois pareceres independentes considerados na preparação convergem na decisão `Revise`. Ambos recomendam retirar a linguagem de validação e usar o VAR como triangulação, embora preservem a ressalva de que a vantagem informacional do DFM ainda não foi demonstrada por uma comparação direta dos espaços informacionais. Essa convergência orienta a recomendação editorial, mas não acrescenta evidência aos resultados.

Permanecem três incertezas. Não existe cobertura weak-IV operacional para as respostas do DFM com fatores e cargas estimados. A grande dimensão não garante fundamentalidade. A seção e a documentação corrente tampouco estabelecem por completo a aplicabilidade assintótica de MOSW ao VAR em níveis com tendência linear. A última lacuna deve ser registrada como ressalva metodológica separada, sem invalidar por afirmação o exercício já produzido.
