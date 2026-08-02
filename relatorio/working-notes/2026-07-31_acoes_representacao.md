# Ações em log-nível: o resultado nulo do bloco acionário é mecânico

> **CURRENT.** Escrita sob (7,6), `z_jk_bs_purif`, vintage de 106 séries.
> Responde ao item de `_instrucoes/pendencias.md:588-595`, achado do council
> review de 2026-07-31. Corpo gerado com os números em
> `output/assets/asset_representation.md`; esta nota é a leitura à mão.
> **2026-08-02:** o `tex/main.tex` citado abaixo foi arquivado em
> `arquivo/tex/main.tex`; `texto_anpec/paper_anpec.tex` é o paper canônico.
> **Nada de produção foi modificado.**

## A pergunta e por que ela é grande

As 8 séries da B3 entram no painel como **retorno mensal composto**
(`download.R:414,423`), enquanto as outras 98 entram em nível ou log-nível. O
`cumsum` que recupera o nível de preço não está nos dados: está na **IRF**
(`impulse_responde.R:277`, tcode 2), aplicado ao ponto e dentro de cada uma das
800 réplicas. Como a padronização BLL diferencia o painel para estimar `Λ`
(`factor_estimation.R:300`), o bloco acionário é estimado sobre a **segunda
diferença** do log-preço — sobrediferenciação, já que retorno mensal aqui é
quase ruído branco (ac1 entre 0,03 e 0,17).

O paper reporta **0 de 392** células sig90 nesse bloco, que é o tema do próprio
título. A pergunta é se esse nulo é do dado ou da construção.

## Regra de leitura, fixada antes dos números

Registrada no plano e no cabeçalho do script, antes de qualquer estimação:
**mecânico** se sob `loglevel` houver ≥ 1 célula sig90 em h ≤ 12 **e**
ξ_mp ≥ 3,84 (forma forte ≥ 10); **não confirmado** se o bloco seguir em 0 sig90
com as guardas de pé; **h = 0 é o teste limpo da representação**, único horizonte
em que as duas medem o mesmo objeto e em que o `cumsum` é no-op;
**inconclusivo** se ξ_mp cair abaixo de 3,84.

Declarado também antes de rodar: a comunalidade do bloco no espaço de diferenças
é **praticamente idêntica** nas duas representações (mediana 0,801 → 0,811,
`asset_ibov` 0,909 → 0,894). A hipótese "a sobrediferenciação destrói o
componente comum" **já nascia não sustentada**. O que mudava era a geometria dos
elos econômicos: `cor(asset_ibov, Δcambio_usd)` no espaço de diferenças vai de
**−0,040** para **−0,451**, e `cor` com `Δyield_2y` de −0,224 para −0,357. A
diferença extra não empobrece o ajuste do fator; ela corta exatamente os elos
por onde a política monetária chega às ações.

## Veredito: mecânico, e por margem larga

Sob log-nível o bloco vai de **0 para 39** células sig90; sob nível simples, 28.
**Todas em h ≤ 12** — na verdade todas em **h = 0 a 5**, em 7 dos 8 índices:

| índice | h=0 produção | IC90 produção | h=0 log-nível | IC90 log-nível | sig90 |
|---|---|---|---|---|---|
| `asset_imob` | −2,89 | [−10,30; 1,47] | **−6,52** | [−12,52; −2,94] | h0-h5 |
| `asset_ifnc` | −1,97 | [−9,72; 2,51] | **−5,28** | [−11,15; −1,82] | h0-h5 |
| `asset_smll` | −2,68 | [−9,07; 1,52] | **−4,46** | [−9,60; −1,19] | h0-h5 |
| `asset_idiv` | −2,04 | [−8,18; 1,62] | **−3,90** | [−8,74; −1,19] | h0-h5 |
| `asset_ibov` | −1,67 | [−7,77; 1,76] | **−3,68** | [−8,70; −0,86] | h0-h4 |
| `asset_mlcx` | −1,74 | [−7,82; 1,61] | **−3,56** | [−8,42; −0,82] | h0-h4 |
| `asset_ifix` | −1,03 | [−3,59; 0,56] | **−1,63** | [−3,77; −0,41] | h0-h4 |
| `asset_imat` | −0,31 | [−4,93; 3,07] | +0,63 | [−3,38; 3,51] | — |

São **duas** coisas ao mesmo tempo, e vale separá-las: o ponto **dobra** de
magnitude e a banda **encolhe**. O proxy de |t| mediano do bloco em h=0 —
|ponto|/(meia-banda de 68%), a mesma régua do §5 Limitações — vai de **0,676
para 1,826**. O único que não participa é o `asset_imat`, que já estava no tier
`ambiguous` da régua de coerência.

O resultado é um bloco acionário que **se comporta como manual**: queda no
impacto em 7 de 8 índices, significativa a 90% do impacto até h≈4-5, morrendo
depois. É o que a teoria prevê e é o que a produção não conseguia mostrar.

## A banda inflada era inteiramente o `cumsum`

Provado no **mesmo modelo**, não em um modelo parecido. A célula `prod_nocum`
usa o painel de produção, o mesmo seed e o mesmo DFM, mudando só o tcode de 2
para 1. Auto-teste: `cumsum(prod_nocum) × 100` reproduz o ponto de produção com
desvio **0,00e+00** — bit a bit. O ponto é o mesmo objeto; a banda não, porque o
quantil de uma soma acumulada não é a soma acumulada do quantil.

Razão de largura da banda de 90% em h36 contra h0, por índice:

| | produção | log-nível | nível |
|---|---|---|---|
| mediana dos 8 | **10,46** | **0,84** | 0,56 |
| intervalo | 8,10 a 14,53 | 0,58 a 1,46 | 0,43 a 1,34 |

Contra 0,944 nas 81 séries de tcode 1 da produção. A anomalia documentada na
Tarefa 6 desaparece: em nível, o bloco acionário tem a mesma dinâmica de banda
que o resto do painel.

## O pico de +20% no médio prazo era erro acumulado — e o `.tex` já sabia

O bloco comentado em `tex/main.tex:445` diz que a alta do Ibovespa entre h=14 e
h=26 é acúmulo de erro de estimação, não economia. **Estava certo**, e a
representação em nível remove o artefato na origem em vez de explicá-lo depois:

| h | produção | log-nível |
|---|---|---|
| 12 | +11,52 | −0,20 |
| 18 | +18,20 (sig68) | +0,76 |
| 24 | **+20,26** (sig68) | **+1,40** |
| 36 | +16,37 | +1,63 |
| 48 | +7,92 | +1,28 |

Isso tem consequência fora daqui. O `CLAUDE.md` registra, no benchmark VAR, que
"o extremo global do DFM tem sinal oposto ao do impacto em 8 das 18 respostas —
exatamente as 8 ações, que viram positivas por volta de h=5 e chegam a +20 em
h≈24". **Essa armadilha de pontuação não existe sob a representação em nível**:
o extremo passa a concordar com o impacto, e a régua de "razão de impacto + pico
de mesmo sinal" que o `model_var.R` teve de adotar deixaria de ser necessária.

Na seção cruzada, a amplitude entre o índice que mais sobe e o que mais cai em
h=48 cai de **78,4 pp para 2,08 pp** (fator de 38). A inversão de ordenação da
Tarefa 6 (+0,903 em h=0 → −0,672 em h=48) muda de caráter: sob log-nível a
ordenação econômica **se mantém e até se reforça** até h=6 (+0,933 → +0,963) e só
então inverte, para −0,865 em h=24, com amplitude de 1,9 pp. Ou seja, o que a
H2 leu como "a ordenação econômica se inverte no horizonte longo" era, em boa
parte, ruído acumulado embaralhando a seção cruzada.

## O resto do modelo não se mexeu — e isso é o que dá crédito ao achado

Mudar o painel re-estima tudo, então a comparação só vale com guarda. Ela passa:

- **79 dos 92** pares sig90 do paper sobrevivem sob log-nível (75 sob nível).
- As manchetes não-acionárias em h=0 quase não andam: `yield_2y` 0,009164 →
  0,009067; `yield_5y` 0,009274 → 0,009303; `cambio_usd` 0,1498 → 0,1619;
  `embi_perc` 0,1995 → 0,2209; `cds_5y` 29,07 → 31,37. Todas seguem sig90.
- `ibc_br` **ganha** sig90 no impacto (−0,393 → −0,438), que não tinha.
- `price_ipca` inverte de sinal no impacto (−0,070 → +0,059), sem significância
  em nenhuma das duas.

A mudança está concentrada onde foi prevista. Não é outro modelo: é o mesmo
modelo com o bloco acionário consertado.

## ⚠ O preço, que é real e não pode ser omitido

**A representação em log-nível custa força de instrumento.**

| painel | ξ_mp full | ξ_mp pré-COVID | max \|λ\| pré-COVID |
|---|---|---|---|
| produção (retorno) | **10,43** | **12,22** | 0,996 |
| log-nível | **8,94** | **3,91** | **1,003** |
| nível | **10,23** | 5,73 | 0,992 |

Três consequências que precisam ser ditas juntas:

1. **No full sample o log-nível fica abaixo de 10.** O conjunto AR continua
   limitado (8,94 > 3,84), então as células sig90 acima não são inválidas — mas
   estão exatamente na faixa em que MOSW dizem que as bandas convencionais são
   só "aproximadamente válidas", que é a faixa que o §3 do paper usa para
   justificar (7,6). A significância nova é obtida num painel cujo primeiro
   estágio é **mais fraco** que o da produção. Isso não anula o achado — o achado
   é sobre a *representação*, e ele aparece com a banda encolhendo apesar de o
   instrumento enfraquecer —, mas proíbe apresentar o resultado como puro ganho.
2. **Pré-COVID o painel log-nível quebra.** ξ_mp de 3,91 raspa o limiar de
   limitação do conjunto AR, a companion é **explosiva** (1,0030) e a correção de
   Kilian não converge. A janela de robustez pré-COVID, em que o paper se apoia,
   **não sobrevive** a essa representação. Isso sozinho impede uma promoção
   direta em (7,6).
3. **A variante fiel a AK é a mais fraca das duas.** O nível simples mantém
   ξ_mp em 10,23 (acima do limiar) e companion em 0,9755, entregando 28 células
   sig90 e **8 de 8** índices negativos no impacto. A regra pré-registrada
   cobria só o `loglevel`; a escolha entre log e nível **não** foi
   pré-registrada, e registro isso porque a comparação entre as duas foi feita
   depois de ver os números.

## O que isto **não** mostra

- **Não mostra que (7,6) é a dimensão certa no painel novo.** (r,q) não foi
  re-selecionado; o grid está reportado mas não decidido. Dada a queda de ξ_mp,
  é plausível que outra célula domine.
- **Não mostra que o X-13 é neutro.** O diagnóstico contorna o `clean.R`. Uma
  promoção passaria pelo `check_seasonality`, que hoje não marca retornos mas
  pode marcar níveis com tendência — e aí a série que entra no DFM não é a que
  foi testada aqui.
- **Não contradiz a correção de tcode de 2026-07-24.** Aquela decisão
  (`historico_decisoes.md` §3) trocou tcode 1 por 2 porque, *dado o painel de
  retornos*, acumular é a forma certa de obter resposta de nível — e estava
  certa nessa condicional. O que este exercício mostra é que a condicional é que
  estava errada: o conserto pertence ao painel, não ao transform de exibição.

## Recomendação, e a decisão do autor

Minha recomendação era promover: o bloco acionário é o tema do título e hoje está
nulo por construção. Ela **não foi seguida**, e registro isso explicitamente para
que a nota não seja lida como se a promoção estivesse encaminhada.

**Decisão do autor, 2026-07-31: a entrada do painel em log-nível fica de lado; o
próximo passo é corrigir apenas o `cumsum`.** O motivo é proporcional ao custo —
a rota em nível derruba ξ_mp para 8,94 no full, **quebra a janela pré-COVID**
(3,91, companion explosiva), exige re-selecionar (r,q) e reescreve todo o §4-§5.
Registrado em `historico_decisoes.md` §3.1 para não ser reaberto sem evidência
nova.

### ⚠ O que a correção do `cumsum` sozinha entrega — medido, não suposto

Rodado com a spec de produção e nboot=800, painel de retornos intacto, só
tcode 2 → 1:

| | produção | só o conserto do `cumsum` |
|---|---|---|
| sig90 no bloco | 0 de 392 | **1 de 392** (só `asset_ifix` em h=1) |
| sig90 em h=0 | 0 de 8 | **0 de 8** |
| sig68 em h ≤ 12 | 19 | **35** |
| razão de banda h36/h0 | 10,46 | **0,38** |

**O bloco continua nulo a 90%, e isso é matemática, não amostra.** Em h=0 o
`cumsum` é no-op e o ×100 é escalar positivo aplicado ao ponto e às duas pontas,
então **a significância em h=0 é invariante ao tcode**. Nenhuma escolha de
transform de exibição pode produzir o resultado acionário; quem o produz é a
representação do painel, e ela ficou de fora. **Nenhum texto futuro pode
atribuir a recuperação do bloco a esta correção** — ela não a produz.

O que a correção entrega de fato, e não é pouco: some a inflação de banda
(10,46 → 0,38), some o pico falso de +20,3% do Ibovespa em h≈24, some a
armadilha de pontuação do benchmark VAR, e o tier de 68% **melhora onde importa**
— as células sig68 em h ≤ 12 sobem de **19 para 35**, porque o ruído acumulado de
médio prazo deixa de existir e o sinal de curto prazo fica visível. É limpeza de
artefato, não resultado novo.

### Consequência para o texto

Com o painel mantido em retornos, o §4 **continua sem poder** afirmar que a
ausência de resposta acionária é um resultado econômico. A afirmação defensável
é mais estreita e menos confortável, e deve aparecer no corpo:

> *Sob a representação em retorno o bloco acionário não separa de zero a 90% em
> horizonte nenhum; sob a representação em nível ele separa do impacto a h≈5 em
> 7 dos 8 índices. Quem decide é a especificação de dados, não o dado — e esta
> versão mantém a primeira.*
