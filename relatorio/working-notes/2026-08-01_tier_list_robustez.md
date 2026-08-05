# Tier list dos resultados de robustez — leitura de parecerista (SBE/ANPEC)

> **CURRENT (2026-08-01).** Vintage de 106 séries, produção `(r=7, q=6, p=6)`,
> proxy `z_jk_bs_purif`, ξ_mp 10,43 full / 12,22 pré-COVID. **Nota de triagem:
> nenhuma estimação nova foi rodada e nenhum arquivo de produção ou `.tex` foi
> tocado.** É uma leitura do material já existente sob a régua de um parecerista
> de ANPEC/SBE: o que entra na §5, em que ordem, com que ressalva, e o que não
> pode entrar. Fontes: `tex/main.tex` (§5 comentada em 447-500 + seis blocos
> comentados dentro do §4), `texto_anpec/paper_anpec.tex`, `_instrucoes/pendencias.md`,
> `diagnostics/diagnostico_dfm.md`, `output/{het,var,assets,factors,instrument,nongaussian,irf}/`
> e as working-notes de 07-27 a 08-01.
>
> **2026-08-02:** `tex/main.tex` foi arquivado em `arquivo/tex/main.tex` —
> a prosa "escrita, comentada" descrita nesta nota vive lá agora, e o
> destino é portá-la para `texto_anpec/paper_anpec.tex` (o paper canônico,
> que ainda não tem `§5 Robustez`), não descomentar o arquivo antigo.

## 0. Enquadramento

O paper tem **muito mais robustez rodada do que escrita**. O ativo mais valioso
do projeto hoje não é um resultado novo: é que quase toda objeção previsível já
foi testada e está em CSV. O risco é o inverso do usual — não é falta de
material, é **escolher errado o que entra**, porque pelo menos quatro dos itens
disponíveis cortam contra o paper e dois são armadilhas se escritos como
corroboração.

Estado do texto na data desta nota:

- `tex/main.tex` — `\section{Robustez}` **inteira comentada** (447-500), com as
  quatro subseções já redigidas (`sec:exogeneidade`, `sec:estado`, Placebos,
  Limitações). Mais seis passagens comentadas dentro do §4 ativo (346, 363, 365,
  369, 441, 445).
- `texto_anpec/paper_anpec.tex` — **não tem seção de robustez nenhuma**. Vai de
  `\section{Resultados}` direto para `Concluding remarks`.

Régua usada abaixo: (i) responde a uma objeção que um parecerista de fato
levantaria? (ii) o resultado é limpo ou de mão dupla? (iii) o custo de escrever
é proporcional?

---

## 1. Tier S — carregam a seção; sem eles o veredito é revisão

### S1. Confound soberano no filtro JK

`output/instrument/jk_sovereign_confound.{md,csv}` · nota
[`2026-07-31_confound_soberano_jk`](2026-07-31_confound_soberano_jk.md) ·
**rodado, não escrito**

Responde à objeção mais letal contra este desenho: o filtro JK descarta o
efeito-informação (juros↑, ações↑) mas **retém exatamente a assinatura fiscal
doméstica** (juros↑, ações↓, câmbio↑), e os placebos não a descartam porque um
choque fiscal brasileiro também não move o S&P 500.

- ΔEMBI carrega a surpresa a **0,326** (t = 3,97, R² 0,13) nas 498 quintas
  não-Copom contra **0,099** (t = 1,74, R² 0,04) nos 62 dias retidos.
- Interações `x:1(jk_bs)` **negativas** nas quatro proxies da janela do evento
  (BRL −0,036, p_boot 0,066).
- Ortogonalizar ao risco diário **melhora** ξ_mp (10,72 vs 10,43) e mantém todas
  as manchetes sig90.
- A frase que carrega a subseção: os **31** dias classificados como "política"
  foram selecionados por **apreciação do BRL no dia do evento**, e a IRF mensal
  deles ainda dá **depreciação**. Falsificável por construção, e não inverteu.

⚠ Ressalvas obrigatórias **no corpo**, não em rodapé: o coeficiente nos 62 dias é
positivo e marginal (p = 0,097), então a afirmação é "menos risco que um dia
comum", **não** "zero risco"; e os 5 dias de maior alavancagem valem **28,6% de
Σ|z|**, o maior (6,6%) sendo 2021-10-27, a semana da PEC dos Precatórios.
Declarar em uma frase que o teste roda em EMBI+ porque não há CDS 5a diário.

### S2. Reconciliação com Gonçalves-Rodrigues-Genta por frequência

[`2026-08-01_robustez_heterocedasticidade`](2026-08-01_robustez_heterocedasticidade.md) §6 ·
**rodado, não escrito, zero estimação nova**

O paper contradiz em **sinal** o único trabalho brasileiro recente sobre a mesma
pergunta, em câmbio *e* em risco soberano. Um parecerista de ANPEC abre por aí.
Hoje o §4 tem três hipóteses de explicação e elas estão **comentadas** (linha 363).

- A réplica em Python do referee2 sobre os **nossos** dados diários dá o real
  **apreciando 4,53% por 100bp**, **dentro do IC 95% do GRG** ([−6,57; −3,63]).
- O mesmo teste de proporcionalidade dá **LR = 135,1, p_boot = 0,005** no diário
  contra **nenhuma rejeição em 252 células mensais**.
- Logo o desacordo é de **frequência e propagação, não de identificação** — e
  isso passa a ser afirmação medida, não conjectura.

⚠ Incluir a variável inconveniente: o mesmo `b₁` diário dá **IBOV +2,83%** por
100bp (sinal errado), participação espectral 0,0015. Ações não estão
identificadas naquele sistema, e por isso a comparação de ações entre os dois
exercícios **não é possível**.

### S3. Exogeneidade do instrumento — dois blocos

`diagnostics/diagnostico_dfm.md` Tarefa 1 · **(a) rodado e não escrito; (b)
escrito e comentado**

**(a) Previsibilidade.** Cinco especificações (fatores L1/L3/L6, retornos globais
L3/L6), Wald HC1 com p por wild bootstrap sob H0 (o instrumento é
zero-censurado, então o p assintótico não decide): **nenhuma rejeita**, p_boot
entre 0,199 e 0,854. Ljung-Box não rejeita até lag 12 (Q(1) = 0,187 …
Q(12) = 0,813), o que justifica `nw_lags = 0`. Hoje o paper afirma o R² = 0,024
da purificação diária e **nunca mostra que o instrumento mensal é imprevisível**
— é lacuna de reporte, não de trabalho.
⚠ Declarar: `cambio_usd` defasado fica em p_boot = **0,064**, o único abaixo de
0,10, e defasagens de câmbio **não** estão entre os preditores pré-evento do
Bauer-Swanson.

**(b) `commodity_metal` não é violação de placebo.** O IC-Br do BCB é denominado
em R$ e herda mecanicamente a resposta cambial: os três índices em R$ violam, os
três em US$ passam limpo — o de metais **0 de 25 horizontes** significativos.
Já redigido em `tex/main.tex:453-455`, **comentado enquanto a linha 365 ativa
afirma o +3,43%**: como compilado hoje, o PDF lê como falha de exogeneidade sem
resposta.

### S4. Placebos

`tex/main.tex:480-490` · **escrito, comentado**

Padrão, barato, passa — e passa nas **duas** barras: 90% → 1/49, 0/49, 0/49;
68% → 3, 0, 2 = 5 de 147 contra os ~47 que um nível nominal de 32% daria.
Reportar nos dois níveis (como já está redigido) é o que impede a acusação de
escolher a régua onde se passa melhor.

---

## 2. Tier A — robustez forte, entra

### A1. Benchmark VAR pequeno

`output/var/var_benchmark.md` · nota
[`2026-07-31_benchmark_var_vs_dfm`](2026-07-31_benchmark_var_vs_dfm.md) ·
**rodado, não escrito**

Responde a "o que o DFM compra?", que é a **tese declarada** do paper. Hoje
`tex/main.tex:183` credita "mais forte e mais rápido" a Alessi-Kerssenfischer sem
o benchmark ter sido estimado aqui.

- *Mais forte* se sustenta: **16 de 18**, razão mediana **2,32** no impacto e
  **1,61** no pico de mesmo sinal.
- *Mais rápido* só nas ações (**7 de 8**; **9 de 18** no total).

⚠ De mão dupla, e a redação tem que assumir: a banda de 68% do DFM **nunca** é
mais estreita (razão mediana 4,35) e o DFM tem **37 células sig90 contra 266 do
VAR** (0 contra 132 nas ações). O argumento pró-DFM que funciona não é nenhum dos
dois — é que as respostas *core* do VAR pequeno variam entre especificações
**mais que a própria magnitude** (`ind_transformacao` em h=0 tem amplitude 0,952
em torno de mediana −0,746; `price_ipca` inverte de sinal) e o VAR com `ibc_br` é
**explosivo** (max|λ| = 1,008). Escrever como **conjunto de informação, não como
precisão**. E com identificação fixa nos dois lados isto compara **DFM contra VAR
pequeno**, não contra a literatura, que usa Cholesky.

### A2. Robustez do próprio ξ_mp — leave-one-month-out e HAC

`output/instrument/xi_mp_robustness.md` · **rodado, parcialmente escrito** (está
no rascunho de Limitações)

**0 de 147** descartes mensais levam ξ_mp abaixo de 3,84 (conjunto AR sempre
limitado), mas **24 de 147** o levam abaixo de 10. Contraste que confirma a
máscara: `z_jk_purif` fica 147/147 abaixo de 10. HAC: ξ_mp é **crescente** em NW
no full (10,43 → 15,64 em NW(6)), logo NW(0) é a escolha conservadora.

Honestidade que vira força — **desde que acompanhada das bandas AR** (lacuna F1).
Sem AR, o parágrafo confessa o problema e não o resolve.

### A3. Varredura da construção do instrumento (vértice × agregação)

`output/instrument/instrument_construction_sweep.md` · **rodado, não escrito**

260 células (13 vértices × 2 esquemas × 5 variantes × 2 janelas). 126 du **não é
o argmax em nenhuma janela**, mas a maior margem de um desafiante elegível
(1,16) fica abaixo do limiar **pré-registrado antes de rodar** (2,00) — a regra
não dispara e a produção fica. E **os 13 vértices dão essencialmente a mesma
IRF**: é o análogo da Figura A4 de AK que faltava, e mata a acusação de garimpo
de vértice. Bônus previsto antes de rodar: a agregação GK **colapsa ξ_mp para
0,30** no vértice de produção, porque a nota 11 do GK condiciona a ponderação a
um indicador de média mensal e `yield_6m` aqui é de fim de mês.

### A4. Grade MOSW completa em `tab:rq_sweep`

`output/instrument/mosw_strength_grid.{md,csv}` · **dado pronto, tabela escrita
com 4 células**

A tabela atual mostra 4 células escolhidas e expõe o paper a *specification
hunting*. A grade completa mostra que **(7,5), (7,7), (8,5) e (8,6) também cruzam
ξ_mp ≥ 10 nas duas janelas** — r = 7 é **platô, não borda de faca**. Trocar 4
linhas por 14 resolve com dado que já existe. Já é item aberto em
`pendencias.md` (Tema A).

### A5. Estacionariedade, cointegração e espectro da companion

`output/factors/factor_stationarity.md` · nota
[`2026-07-31_estacionariedade_fatores`](2026-07-31_estacionariedade_fatores.md) ·
**rodado, não escrito**

Fecha as objeções de raiz unitária e de módulo dos autovalores: **4 de 7 fatores
I(1)**, 2 I(0), 1 ambíguo, **nenhum I(2)** (PP concorda com ADF em 14/14).
Cointegração existe mas o **posto não é identificado** (2 em K=6, 4 em K=2, 0 sob
Reinsel-Ahn), e o VAR em nível é consistente sob qualquer um deles
(Sims-Stock-Watson 1990) — **nenhum VECM precisa ser estimado**, e isso precisa
estar dito.

⚠ Este item **condena parte do §4** e por isso é caro: apagar o par complexo
dominante (|λ| = 0,976794, período 117,9 meses) de `B` **inverte o sinal do vale
de médio prazo em 12 de 14 séries** e deixa ~37% da magnitude, enquanto apagar o
*segundo* par não muda nada (razão mediana 1,009 contra 0,366). A reversão de
h ≈ 25-34 **é** aquele modo; `cambio_usd` é a única exceção (1,004). A afirmação
defensável é estreita: o paper pode reportar a reversão como **o que o modelo
implica**, mas não pode citá-la como evidência separada da dinâmica que a produz.

### A6. O impacto cambial **não** é dependente de estado

`diagnostics/diagnostico_dfm.md` Tarefa 7 · **escrito, comentado** (hoje colado
em `sec:estado`)

Este é o pedaço da subseção de estado que **é robustez**: o resultado de manchete
não é fenômeno de regime. |t_dif| do câmbio em h=0 nunca passa de **1,13/1,14**
em **7 indicadores de risco**. Resultado negativo, e mais forte que um positivo
frágil. **Separar de B3** — hoje as duas metades estão escritas como uma só e têm
qualidade muito diferente.

### A7. Duplicatas do painel não dirigem o resultado

`diagnostics/diagnostico_dfm.md` Tarefa 3.4 · **rodado, não escrito**

Remover `juros_cdi` e `asset_mlcx` move as variáveis centrais **menos de 6%** e
**eleva ξ_mp para 10,57**. Uma frase, custo zero, cobre a objeção de colinearidade
interna do painel.

---

## 3. Tier B — entram, mas a redação decide se ajudam ou machucam

### B1. Representação do bloco acionário — o item de maior risco da lista

`output/assets/asset_representation.md` · nota
[`2026-07-31_acoes_representacao`](2026-07-31_acoes_representacao.md) ·
**rodado, não escrito**

O paper se chama *Choques monetários nos preços dos ativos* e o bloco acionário
tem **0 células sig90 em 392**. Este teste mostra que isso é **mecânico**: as 8
séries da B3 entram como retorno mensal enquanto as outras 98 entram em nível,
então o `diff()` do BLL estima o loading na **segunda** diferença do log-preço.
Sob representação em nível o bloco vai de **0 para 39** células sig90 (28 em
nível simples), todas em h=0-5, em **7 dos 8** índices; Ibovespa
−1,67 [−7,77; 1,76] → **−3,68 [−8,70; −0,86]**; proxy de |t| em h=0 de 0,676
para **1,826**.

⚠ Por que é perigoso: a decisão do autor (2026-07-31,
`historico_decisoes.md` §3.1) foi **manter o painel em retorno**, porque
log-nível derruba ξ_mp para 8,94 no full e **quebra a pré-COVID** (3,91,
companion explosiva 1,0030). Escrever isto convida a pergunta óbvia — *"então por
que não reportar a versão em nível?"* — e a resposta precisa ser numérica e
completa: **nível simples mantém ξ_mp em 10,23** no full mas cai a 5,73 na
pré-COVID; **log-nível, a variante fiel a AK, é a mais fraca das duas**. É um
trade-off declarado entre representação do bloco e força do instrumento nas duas
janelas, não uma preferência.

**Leitura de parecerista: omitir é pior.** Um referee que rodar o painel em nível
encontra 39 células e conclui que o resultado nulo foi conveniência. Reportar como
limitação medida, com os dois ξ_mp, é a única saída que sobrevive.

### B2. Rigobon (2003) no DFM mensal — a identificação alternativa não existe

`output/het/het_robustness.md` · nota
[`2026-08-01_robustez_heterocedasticidade`](2026-08-01_robustez_heterocedasticidade.md) ·
**rodado, não escrito**

Todo o resto da §5 varia a *receita do instrumento*; este é o único item que varia
a **identificação**. 252 células (`p ∈ {5..8} × q ∈ {5..8} × r ∈ {7,8}` × 2
janelas) × 5 desenhos de regime: **zero identificam**, e não é severidade de
correção — sob Holm interno ao desenho (28 testes em vez de 252) continua zero nos
cinco. `calendario` rejeita proporcionalidade em **0% das células nas duas
janelas**.

O diagnóstico é a parte boa: `volatilidade_juros` concentra o regime C no
pós-2020 (`share_C` **0,478 contra 0,051**) e mesmo assim **não rejeita em nenhuma
das 56 células** — o surto de volatilidade pós-2020 é **fator de escala comum**,
levanta todas as variâncias sem girar a covariância. E `quebra_livre`, varrendo a
data livremente, *encontra* 2020-2022 em 25 de 28 células da janela cheia.

⚠ Três regras de escrita: (i) **não é corroboração** — nenhuma IRF foi produzida,
de propósito, porque a segunda condição necessária (autovalores generalizados
distintos) falha em separado (gap relativo mediano **0,11-0,17** contra corte
0,20); dizer isso explicitamente para o leitor não procurar figura. (ii) **Não
citar as 21 células** que passam as duas condições em nível bruto — **17 estão em
`q = 5`**, o menor da grade. (iii) É *justificativa de desenho* e o veículo de S2,
não um resultado positivo.

### B3. Persistência cambial dependente de estado

`tex/main.tex:457-478` · **escrito, comentado**

Sob CDS alto a depreciação persiste em h=6/7/8 (+0,059/+0,112/+0,054) contra
reversão para apreciação sob risco baixo, t_dif 2,81/3,60/3,15, confirmado por
ΔDBGG.

⚠ Quatro problemas que o próprio rascunho já declara e que um parecerista soma:
p_boot conjunto **0,046** é marginal; achado **pós-hoc**, não pré-registrado;
multiplicidade de 2 indicadores × 7 variáveis × 9 horizontes; e a **conclusão
inverte com o indicador** — sob EMBI, a medida convencional de EM, não se detecta
nada (0,19 / 0,32 / 1,43). Achado metodológico reaproveitável que precisa
aparecer: o χ² assintótico **super-rejeita nesta amostra por fator de 2,3 a 5,3**,
e por isso todo p vem de bootstrap de blocos.

**Recomendação: não é robustez, é resultado novo e sugestivo.** Ou vira parágrafo
curto no §4 com as quatro ressalvas, ou sai. Mantê-la como subseção de robustez dá
ao referee um alvo grande em troca de pouco.

### B4. O GMR rejeita o esquema recursivo

`output/nongaussian/results.md` §2.2 · nota
[`2026-08-01_robustez_identificacao`](2026-08-01_robustez_identificacao.md) ·
**rodado, não escrito**

ξ = **149,3**, gl = 15, p = 0,0000: a decomposição de Cholesky nas inovações
fatoriais é rejeitada. Conversa diretamente com o argumento anti-VAR-pequeno do
paper, e é a restrição que a literatura de menor dimensão impõe **sem testar**.

⚠ Vem obrigatoriamente com o gate: **3 de 6** componentes não rejeitam
normalidade no full e **5 de 6** na pré-COVID — identificação **parcial**, e
**inexistente** na janela pré-COVID. E a rejeição *da restrição do proxy*
(ξ = 122,9) é **provavelmente espúria**: a Prop. 4 cobre 0,79 contra 0,95 nominal
em T = 150, n = 6. Reportar só a rejeição do recursivo e declarar o resto.

---

## 4. Tier C — apêndice, rodapé, ou uma linha

| item | onde | por quê C |
|---|---|---|
| **Varredura de especificação IRF (etapas 1 e 2)** | `output/irf/spec_sweep_*` | Superada pela grade MOSW como régua; a seleção da etapa 2 está contaminada pela janela pré-COVID (23 células empatam em score, desempate só por ξ_mp, sistematicamente maior pré-COVID) |
| **Verificação de coerência (53 vars × 49 horizontes)** | `output/irf/irf_coherence_*` | A régua são janelas teóricas escritas à mão; o referee questiona as janelas, não os vereditos. No máximo: "22 coerente_forte, 1 incoerente (`price_core_ipca_ex0`), 3 placebos aprovados" |
| **Validações de código** | `script/validate_{hac_kernel,olea_kilian,gmr_ica}.R`, `output/instrument/olea_alignment_audit.md` | Kernel NW exato contra `NW_hac_STATA.m` e 2,6e-10 contra `TaxSVARIV.m`; bloco Wald contra os números publicados do petróleo de Kilian (ξ₁ = 4,4, F robusta 9,4). **Replicabilidade, não robustez de resultado** |
| **Mecânica do bootstrap** | `impulse_responde.R:568,636-637,645-647` | Mesmo draw Rademacher para instrumento e resíduos, DFM **reestimado dentro de cada réplica** — dois pontos frequentemente errados na literatura aplicada e nenhum afirmado no texto. Vai para **§3**, não §5, com o número de réplicas falhas em 800 e a ressalva de `Idio` fixo |
| **LP-IV agregado reproduz a cadeia sem passar por Λ** | Tarefa 7.0 | `cambio_usd` +0,095 (t=2,80), `embi_perc` +0,144 (t=2,45), `cds_5y` +17,7 (t=2,57), `price_ipp` +0,363 (t=1,75), 61-72% da magnitude do DFM. ⚠ **Robustez de especificação, não de identificação** — mesmo `z`, mesma hipótese, exatamente identificados, mesmo limite de probabilidade sob IV fraco. Se escrito como validação da exogeneidade, é erro |

---

## 5. Tier D — não usar como robustez

| item | por quê |
|---|---|
| **Concordância de sinal do GMR (0,971 nas 140 células sig90)** | Morre no nulo: **2.000 direções aleatórias** normalizadas ao mesmo +50bp dão concordância mediana **0,786**, e **um quarto delas iguala ou supera** a coluna rotulada (p = 0,179). No bloco da curva o nulo tem mediana **exatamente 1,000** — normalizar na taxa força a curva a co-mover. A métrica **satura**. Não prova que o GMR não corrobora; prova que **concordância de sinal não é evidência de que corrobora**. Sobrevive só o "não contradiz" (proxy dentro do CI90 em 100% das 5.194 células), que é fraco: bandas 5,4× mais largas e **1 célula sig90 em 5.194**, sendo essa a própria normalização |
| **Heterocedasticidade como corroboração** | Não há IRF. Não existe concordância de sinal para reportar |
| **A reversão de médio prazo como evidência independente** | É o par dominante da companion (A5). Reportável como implicação do modelo, nunca como evidência separada |
| **Qualquer coisa do bloco acionário em h > 12** | O pico de +20,3% do Ibovespa em h ≈ 24 é **erro de estimação acumulado** (vai a +1,40 sob representação em nível). Já está na lista "não reportar" da auditoria de 07-28 |
| **Rotulagem da coluna monetária sem o instrumento** | As quatro regras **discordam**: R0 e R3 escolhem a coluna 2, R1 e R2 escolhem a coluna 1 (concorda só 0,600, responde a um quinto da magnitude), e a coluna que melhor corrobora — a 3 — **nenhuma regra escolhe**. A coluna monetária não é bem definida sem `z` neste painel |

---

## 6. Lacunas — o que o parecerista vai pedir e não existe

1. **Bandas de Anderson-Rubin.** Primeiro pedido, e o único que pode custar o
   paper. ξ_mp = 10,43 raspa o limiar, e o LOO mostra **24 de 147** meses
   derrubando abaixo de 10 — mas **nenhum** abaixo de 3,84, então a inversão
   entrega um **intervalo limitado**, não uma reta. Alvo de tradução já no repo
   (`codigo_olea/MSWfunction.m`); o bloco Wald já foi validado ponta a ponta.
   Item aberto em `pendencias.md` Tema B.
2. **Validade do wild bootstrap (Jentsch-Lunsford).** O código multiplica o
   instrumento pelo **mesmo** draw Rademacher dos resíduos — esquema
   Mertens-Ravn, que JL mostram inválido para proxy-SVAR **independentemente da
   força do instrumento**. Atinge **todas** as bandas, inclusive as pré-COVID.
   Mínimo aceitável: um parágrafo no §3 declarando a escolha e citando o debate
   (AK usam wild bootstrap e este projeto é replicação fiel — é escolha, não bug).
   Um parecerista atento a método enxerga `inst_sel * rr_sel` de imediato.
3. **Comparação de subamostra nas IRFs (full × pré-COVID).** Existe como grade de
   *força* e como `.rds` (`output/irf/irf_spec_pre_covid_r7q6_*.rds`), mas **nunca
   como overlay de IRF**. É a robustez mais convencional que existe, é quase de
   graça, e responde à pergunta óbvia "quanto disso é COVID?", que hoje só tem
   resposta indireta via gate não-gaussiano. **Não estava registrado em
   `pendencias.md`.**
4. **Bandas simultâneas ao longo do caminho** (Montiel Olea-Plagborg-Møller 2021).
   A decomposição espectral **eleva** a prioridade: se a reversão é dominada por um
   único modo, h ≈ 20-40 são quase perfeitamente correlacionados e banda pontual
   horizonte a horizonte é especialmente enganosa para afirmações de
   **trajetória** — que é o que o tier de 68% do §4 faz. Exige referência nova
   (regra das 25 chaves).
5. **Comparação cross-instrumento do IPCA sob (7,6).** Fonte já regenerada (320
   células, 8 instrumentos). Sem ela o paper não pode afirmar que a corcova de
   preços em h2-h8 é amostral.

---

## 7. Composição recomendada da §5

Seis subseções, nesta ordem, em prosa com IC:

1. **Exogeneidade** — S3a + S3b + S4 (previsibilidade, autocorrelação,
   `commodity_metal` R$/US$, placebos nas duas barras).
2. **O filtro de sinal seleciona risco soberano?** — S1, com as duas ressalvas no
   corpo.
3. **Identificação alternativa e a divergência com a literatura brasileira** —
   B2 + S2: Rigobon não identifica em 252 células mensais, rejeita com folga no
   diário, e é isso que reconcilia com GRG. Com o IBOV +2,83% declarado.
4. **Construção do instrumento e dimensão do sistema** — A3 + A4 + A2.
5. **Especificação do modelo** — A5 + A1 + A7 + C5 (LP-IV com o rótulo certo).
6. **Limitações** — rascunho existente + B1 + F1 + F2.

Sai da §5: B3 (persistência dependente de estado → §4 encurtada ou fora) e todo o
tier D.

**Bloqueio operacional.** Os itens 1, 2 e o próprio §4 ativo dependem de
descomentar `tex/main.tex:447-500`. Enquanto a seção estiver comentada, a linha
365 afirma o +3,43% do `commodity_metal` sem a frase que o desarma, e a nota da
`fig:acoes` promete uma discussão "no texto" que não existe no PDF. É isso que um
parecerista lê hoje. Mesmo bloqueio já registrado como item em
`pendencias.md` Tema A.
