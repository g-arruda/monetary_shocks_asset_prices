# Diagnóstico do DFM-IV — Tarefas 0 a 7

Rodada de 2026-07-28, respondendo a `prompt_auditoria_dfm_iv.md`.
Escopo: **Tarefas 0 a 7**. As Tarefas 0-5 saíram na primeira rodada; as
Tarefas **6 e 7 foram acrescentadas na segunda rodada do mesmo dia**, junto
com as correções B2, B3 e B4.

Fora de escopo, declarado: a **Tarefa 8** (sensibilidade a r,q) não foi pedida,
e a **inversão Anderson-Rubin** (item 4.3-4.4 do prompt) segue adiada — é o
item #1 de `_instrucoes/pendencias.md`. Dentro da Tarefa 6, o item **6.3
(juro real / NTN-B) é NÃO EXECUTÁVEL** por dependência de dado ausente, e isso
está documentado em vez de contornado.

Especificação auditada: `z_jk_bs_purif` × `yield_6m`, r=7, q=6, p=6,
+50bp, wild bootstrap nboot=800 (seed 123), bandas 68/90, h=0-48,
painel de 106 séries, 2013-01 a 2025-09.

Scripts: `diagnostics/0{1..7}_*.R`. Tabelas: `diagnostics/output/`.
Mapa do pipeline: `diagnostics/00_pipeline_map.md`.
Rodadas com `nboot = 200` estão declaradas onde ocorrem (Tarefas 1.6 e 3.4);
todo o resto usa a estimativa de produção com nboot = 800. As Tarefas 6 e 7
**não reestimam nada** — a 6 lê `irf_coherence_cell.rds`, e a 7 é local
projection, fora do DFM por construção.

---

## Veredito por tarefa

| # | Tarefa | Veredito |
|---|---|---|
| 0 | Mapa do pipeline | **PASSA** — cadeia rastreada ponta a ponta; `cumsum` só via tcode 2 e só nos `asset_*`; nenhuma série é diferenciada e acumulada duas vezes |
| 1 | Exogeneidade do instrumento | **PASSA** — nenhuma previsibilidade a 5% em (1) nem em (2); e o placebo violado é **artefato de denominação**, não falha de exogeneidade |
| 2 | Unidades, normalização e sinal | **FALHA (de reporte, não de estimação)** — mistura decimal × p.p. confirmada; sem inversão de sinal; sem escalonamento não uniforme |
| 3 | Composição do painel | **PASSA** — só 2 quase-duplicatas pelo critério correto, e removê-las não move nada |
| 4 | Inferência robusta a IV fraco | **INCONCLUSIVO** — ξ_mp documentado e situado, mas a pergunta central exige a inversão AR, adiada |
| 5 | Dinâmica dos fatores e persistência | **PASSA com ressalvas** — comunalidade alta onde importa (`yield_6m` 0,88, `juros_selic` 0,77, `pib` 0,79); raiz 0,977 é do desenho; `p=6` sem critério |
| 6 | Bloco de ativos | **FALHA para h > 12** — a seção cruzada é perfeitamente coerente no impacto (8/8 negativos) e se desintegra depois; **6.3 NÃO EXECUTÁVEL** |
| 7 | Dominância fiscal dependente de estado | **PARCIAL, e depende do indicador.** *Baseline migrado de EMBI para CDS em 2026-07-29 e seção re-rodada.* O **impacto** (h=0-4) não é dependente de estado em nenhum dos 7 indicadores (\|t_dif\| ≤ 1,13). A **persistência** (h=6-8) é: sob CDS e sob ΔDBGG a depreciação persiste no regime de risco alto e reverte no baixo (t = 2,0 a 3,6). O EMBI não vê. Conjunto marginal (p_boot 0,046) |

**Anomalias do prompt, situação final:**

| # | Anomalia | Situação |
|---|---|---|
| 1 | Descompasso de unidade nos juros | **CONFIRMADA**, mas com o sinal invertido — a Selic responde *menos*, não mais |
| 2 | `yield_6m` fora da tabela | **CONFIRMADA** — omissão de `coherence_var_table()`; valor real 0,00500 exato |
| 3 | `juros_selic` ≈ `juros_cdi` | **CONFIRMADA** — cor 0,99971 em diferença; removê-las não muda resultado |
| 4 | Placebo `commodity_metal` | **REFUTADA como falha de exogeneidade** — é artefato de denominação em R$ |
| 5 | Corcovas e bandas alargando 8-14× | **PARCIALMENTE CONFIRMADA** — são dois fenômenos distintos, e o alargamento não é geral |
| 6 | Incoerência de seção cruzada nos ativos | **CONFIRMADA e explicada** — não é economia. Fechada pela Tarefa 6: em h=0 os 8 índices são negativos e ordenados pela sensibilidade a juros (ρ = +0,90); em h=48 a ordenação **inverte** (ρ = −0,67) |

---

## Tarefa 0 — Mapa do pipeline

Íntegra em [`00_pipeline_map.md`](00_pipeline_map.md). Pontos que decidem o resto:

- **`clean.R:23-34` é o único ponto de transformação funcional**: `log` em
  `base_*` (7), `credit*`/`credito_*` (7), `fin_inst_reserve_req`, `pib`.
  Não há diferenciação em lugar nenhum.
- **Padronização BLL** em `factor_estimation.R:299-316`: nível destendenciado
  dividido por `sd(Δ)`. **Despadronização** em `impulse_responde.R:454`. Um
  fator de escala constante numa série é absorvido na ida e restituído na volta.
- **`cumsum` só via tcode 2** (`impulse_responde.R:277`), só nos `asset_*`, que
  são de fato retornos mensais (`download.R:406-418`). Tcodes 3 e 5, os que
  fariam dupla acumulação, **não estão atribuídos a nenhuma série**.
- **`price_*` são taxas mensais em % entrando em nível com tcode 1.** A IRF é
  resposta da *taxa mensal*, não de um nível de preço: +0,131 no núcleo é
  ≈ **+1,6 p.p. anualizados**. É a armadilha que o prompt pede para apontar.

---

## Tarefa 1 — Exogeneidade (DECISIVA) — **PASSA**

### 1.1-1.2 Previsibilidade — trava de parada

p-valores por wild bootstrap sob H0 (2.000 réplicas), Wald robusto HC1.
O instrumento é zero-censurado (62 de 156 meses não-nulos), então o p
assintótico não é confiável e o de bootstrap é o que decide.

| teste | n | k | R² | F robusto | p assint. | **p bootstrap** |
|---|---|---|---|---|---|---|
| globais, retornos, L6 | 146 | 30 | 0,239 | 0,858 | 0,678 | **0,749** |
| globais, retornos, L3 | 149 | 15 | 0,135 | 1,360 | 0,176 | **0,199** |
| fatores, L6 | 147 | 42 | 0,395 | 1,189 | 0,238 | **0,854** |
| fatores, L3 | 150 | 21 | 0,150 | 1,001 | 0,467 | **0,724** |
| fatores, L1 | 152 | 7 | 0,054 | 1,151 | 0,335 | **0,311** |

**Nenhuma previsibilidade significativa a 5%. A trava não dispara.**

Por regressor (retornos, L6), o único que chega perto é o câmbio:

| regressor | R² | F rob. | p assint. | p boot |
|---|---|---|---|---|
| `cambio_usd` | 0,081 | 2,034 | 0,065 | **0,064** |
| `sp500_vix` | 0,045 | 0,996 | 0,431 | 0,534 |
| `msci` | 0,027 | 1,017 | 0,417 | 0,464 |
| `commodity_metal` | 0,032 | 0,555 | 0,766 | 0,818 |
| `epu_us` | 0,023 | 0,452 | 0,843 | 0,885 |

> **Ressalva honesta:** `cambio_usd` defasado fica em p = 0,064. Não rejeita a
> 5%, mas é o único regressor abaixo de 0,10 e merece uma linha no paper. As
> defasagens de câmbio **não** estão entre os preditores pré-evento da
> ortogonalização Bauer-Swanson.

Testes adicionais sobre as inovações dinâmicas η (não pedidos, mais informativos
que a versão sobre fatores em nível):

| teste | n | k | R² | F rob. | p boot |
|---|---|---|---|---|---|
| η defasado, L6 | 141 | 36 | 0,362 | 1,208 | 0,416 |
| η defasado, L3 | 144 | 18 | 0,129 | 0,990 | 0,527 |
| η **lead** L3 | 144 | 18 | 0,091 | 1,189 | 0,210 |
| η **lead** L6 | 141 | 36 | 0,208 | 1,401 | 0,180 |

### 1.3 Autocorrelação do instrumento

Ljung-Box não rejeita em nenhuma defasagem: Q(1) p = 0,187; Q(2) 0,239;
Q(3) 0,286; Q(6) 0,643; Q(12) 0,813. ACF(1) = −0,108.
**Sem MA(1)** — confirma que `nw_lags = 0` é adequado, e o exercício HAC de
2026-07-27 já mostrara que ξ_mp é *crescente* em NW, tornando NW(0) conservador.

### 1.4-1.5 Correlações com placebos

Correlação contemporânea (em retorno) do instrumento:

| variável | cor (k=0) | maior \|cor\| em qualquer k |
|---|---|---|
| `cds_5y` | 0,252 | 0,252 (k=0) |
| `embi_perc` | 0,233 | 0,233 (k=0) |
| `commodity_metal` | 0,175 | 0,175 (k=0) |
| `commodity_agro` | 0,163 | 0,166 (k=+1) |
| `cambio_usd` | 0,148 | −0,256 (k=−4) |
| `commodity_energia` | 0,141 | 0,141 (k=0) |
| `msci` | 0,117 | 0,126 (k=−4) |
| `epu_brazil` | 0,072 | 0,204 (k=+5) |
| `epu_us` | −0,052 | 0,090 (k=+2) |
| `sp500_vix` | −0,026 | 0,129 (k=+3) |

O padrão é o esperado de um instrumento válido: as maiores correlações são
**contemporâneas** e com variáveis **domésticas** (CDS, EMBI). As externas puras
(`msci`, `epu_us`, `sp500_vix`) ficam abaixo de 0,13 em todo k.

### 1.6 Teste decisivo — `commodity_metal` é placebo válido?

O IC-Br do BCB (séries 27575-27577) é **denominado em R$**. Se a violação do
placebo for artefato de denominação, ela desaparece ao reexpressar o índice em
dólar. Painel aumentado com `commodity_{metal,agro,energia}_usd = índice / cambio_usd`,
estimado uma vez, **nboot = 200**:

| variável | IRF h0 | % da média | CI90 h0 | sig90 h0 | nº sig90 em h0-4 | nº sig90 em h0-24 |
|---|---|---|---|---|---|---|
| `commodity_metal` (R$) | +12,07 | +3,98% | [5,42; 18,47] | **SIM** | 4 | 4 |
| `commodity_metal_usd` | +0,42 | +0,59% | [−1,44; 1,88] | **não** | **0** | **0** |
| `commodity_agro` (R$) | +10,68 | +3,97% | [5,88; 16,32] | **SIM** | 5 | 6 |
| `commodity_agro_usd` | +0,40 | +0,62% | [−0,71; 1,05] | **não** | **0** | **0** |
| `commodity_energia` (R$) | +10,54 | +8,05% | [6,37; 14,75] | **SIM** | 4 | 4 |
| `commodity_energia_usd` | +1,33 | +4,28% | [−0,004; 2,14] | **não** | 0 | 2 |
| `cambio_usd` | +0,134 | **+3,27%** | [0,064; 0,252] | SIM | 4 | 4 |
| `msci` | +1,84 | +0,66% | [−10,65; 14,32] | não | 0 | 0 |
| `sp500_vix` | −0,69 | −3,88% | [−2,64; 2,01] | não | 1 | 1 |
| `epu_us` | −26,54 | −14,96% | [−57,81; 4,94] | não | 0 | 0 |

**Os três índices em R$ violam o placebo; os três em US$ passam limpo.** E a
resposta percentual dos índices em R$ (+3,98% / +3,97%) é essencialmente a
resposta do câmbio (+3,27%). Corroboração: `cor(dlog metal_BRL, dlog câmbio)` =
**+0,450**, enquanto `cor(dlog metal_USD, dlog câmbio)` = **−0,409**.

Espaço de fatores dos dois painéis:

| painel | nº séries | max\|autovalor\| | ξ_mp | Wald conjunta |
|---|---|---|---|---|
| produção | 106 | 0,97679 | **10,431** | 13,99 |
| aumentado | 109 | 0,96607 | **7,873** | 12,36 |

> **Conclusão da Tarefa 1.** O `commodity_metal` **não é um placebo válido**:
> é um preço doméstico em reais que herda mecanicamente a resposta cambial. A
> hipótese concorrente do prompt ("um fator global de commodity/risco move as
> duas coisas") fica **refutada** — se fosse fator global, o índice em dólar
> responderia, e ele não responde em nenhum dos 25 horizontes. Isso é
> independentemente consistente com o registro de `pendencias.md` de que a
> identificação **não-gaussiana, que não usa `z`**, viola o mesmo placebo.
>
> **Nota metodológica:** acrescentar 3 séries a 106 derrubou ξ_mp de 10,43 para
> 7,87. A comparação BRL × USD é interna ao painel aumentado e por isso válida,
> mas a sensibilidade de ξ_mp à composição do painel é ela própria um achado —
> ver Tarefa 4.

---

## Tarefa 2 — Unidades, normalização e sinal — **FALHA de reporte**

### 2.1 `yield_6m` na tabela

Ausente apenas de `coherence_var_table()` (`R/identification/irf_coherence.R:24-26`),
que cobre 52 das 106 séries. Valor real: **h0 = 0,00500000**, exato — a
normalização entrega o +50bp que promete. Tabela completa das 106 séries × 49
horizontes gerada em `diagnostics/output/t2_1_irf_todas_variaveis.csv`.

### 2.2 Bloco de juros: unidade, IRF e equivalente em pontos-base

| série | unidade | IRF h0 | **h0 (bp)** | h6 (bp) | h24 (bp) | pico h | pico (bp) | sig90 h0 |
|---|---|---|---|---|---|---|---|---|
| `yield_3m` | decimal | 0,002792 | **+27,9** | +30,6 | −65,9 | 32 | −78,8 | sim |
| `yield_6m` | decimal | 0,005000 | **+50,0** | +41,5 | −68,4 | 31 | −77,9 | sim |
| `yield_1y` | decimal | 0,007352 | **+73,5** | +51,1 | −67,7 | 1 | +86,3 | sim |
| `yield_2y` | decimal | 0,009164 | **+91,6** | +56,0 | −59,9 | 1 | +107,1 | sim |
| `yield_5y` | decimal | 0,009274 | **+92,7** | +51,3 | −46,8 | 1 | +106,2 | sim |
| `yield_10y` | decimal | 0,008080 | **+80,8** | +44,0 | −41,1 | 1 | +92,0 | sim |
| `juros_selic` | p.p. | −0,047101 | **−4,7** | +11,6 | −62,2 | 34 | −77,8 | **não** |
| `juros_cdi` | p.p. | −0,048157 | **−4,8** | +11,6 | −62,1 | 34 | −77,8 | **não** |

Três leituras que o prompt não podia fazer sem as unidades:

1. **O "fator ~15" existe mas inverte.** Em bp, a Selic responde **−4,7** no
   impacto contra +50,0 do DI 6m, e o pico dela é +11,6bp em h≈6. Ela responde
   **menos**, não mais. Em h=24 os blocos **concordam** (−68,4 contra −62,2bp),
   o que é a melhor evidência de que não há erro de escala na estimação.
2. **O impacto da Selic é negativo**, não +0,13 como o prompt supõe — o prompt
   leu o pico de h≈6 como se fosse impacto. Não é significativo a 90% e é
   economicamente explicável (a Selic mensal é acumulada no mês; um Copom no
   meio do mês mal move a média mensal), mas precisa ser dito, não escondido.
3. **A curva tem corcova em 2-5 anos.** 28 → 50 → 74 → 92 → 93 → 81bp de 3m a
   10y: o pico está longe do vértice de política. Ver a hipótese H3 adiante.

### 2.3 Correlação contemporânea nos dados brutos

Em **primeira diferença** (o espaço que a padronização BLL usa):

| | 3m | 6m | 1y | 2y | 5y | 10y | selic | cdi |
|---|---|---|---|---|---|---|---|---|
| **3m** | 1,000 | 0,911 | 0,684 | 0,443 | 0,297 | 0,260 | 0,604 | 0,604 |
| **6m** | | 1,000 | 0,905 | 0,711 | 0,517 | 0,429 | 0,508 | 0,509 |
| **1y** | | | 1,000 | 0,924 | 0,734 | 0,616 | 0,351 | 0,351 |
| **2y** | | | | 1,000 | 0,901 | 0,793 | 0,202 | 0,201 |
| **5y** | | | | | 1,000 | 0,958 | 0,122 | 0,119 |
| **10y** | | | | | | 1,000 | 0,113 | 0,110 |
| **selic** | | | | | | | 1,000 | **0,9997** |

A estrutura é a de uma curva normal (decaimento monotônico com a distância de
maturidade), e a Selic correlaciona só 0,51 com o DI 6m em diferença. **Não há
erro de pipeline aqui: a divergência de ordem de grandeza era só de unidade.**

### 2.4 Rastreamento de sinal

| local | o quê | determinístico? |
|---|---|---|
| `factor_estimation.R:336-344` | sinal dos loadings estáticos | **SIM** — maior \|elemento\| forçado positivo |
| `factor_estimation.R:667-673` | sinal dos autovetores dinâmicos | **SIM** — idem |
| `factor_estimation.R:458` | `Abias = -bias/T`, interno ao Kilian | SIM — não toca sinal de IRF |
| `impulse_responde.R:124` | divisão por `irf_mp[mpind,1]` | SIM — sinal vem do dado |
| `impulse_responde.R:759-766` | opção `invert_shock` do plot | **INATIVA** (default `FALSE`) |

`impact_pre` (denominador da normalização) = **+8,636e-05**, positivo — a
normalização **não** inverte as IRFs.

### Veredito

- **(a) mistura de unidades entre blocos: SIM.** `yield_*` decimal × `juros_*`
  p.p. (fator 100), e `embi_perc` p.p. × `cds_5y` bp. Absorvida pela padronização
  BLL: **não vicia a estimação, vicia a leitura.**
- **(b) inversão de sinal: NÃO.**
- **(c) escalonamento não uniforme: NÃO.** O único erro de escala encontrado
  (×100 em `cds_5y`/`msci`/`sp500_vix`) era uniforme e foi corrigido — ver
  "Correções recomendadas".

---

## Tarefa 3 — Composição do painel — **PASSA**

### 3.1 `juros_selic` × `juros_cdi`

São séries distintas na fonte (SGS 4189, Selic acumulada no mês; SGS 4392, CDI
acumulado no mês), mas indistinguíveis na prática:

| base | cor nível | cor diferença | dif. média abs | dif. máx abs |
|---|---|---|---|---|
| `raw_data.csv` | 0,999925 | 0,999713 | 0,0249 p.p. | 0,120 p.p. |
| painel | 0,999925 | 0,999713 | 0,0249 p.p. | 0,120 p.p. |

### 3.2 Todos os pares com \|cor\| > 0,98

Dos 5.565 pares, **25 em nível** e apenas **2 em primeira diferença**. A
distinção importa: a padronização BLL estima os loadings sobre `cov(Δ)`, então
**a diferença é a régua correta**, e a lista em nível está dominada por
correlação espúria de tendência comum.

Em **diferença** (\|cor\| > 0,98):

| a | b | cor nível | cor diferença |
|---|---|---|---|
| `juros_selic` | `juros_cdi` | 0,99993 | **0,99971** |
| `asset_ibov` | `asset_mlcx` | 0,99441 | **0,99628** |

Exemplos do contraste em nível (redundância aparente que some na diferença):

| a | b | cor nível | cor diferença |
|---|---|---|---|
| `base_m2` | `credito_pessoa_fisica` | 0,996 | **0,238** |
| `base_m3` | `trab_min_wage` | 0,988 | **−0,356** |
| `credito_agro` | `credito_pessoa_fisica` | 0,983 | **0,335** |
| `credito_comercio` | `credito_transporte` | 0,983 | **0,475** |

### 3.3 Tamanho e colinearidade interna dos blocos

| grupo | n | share | PC1 do próprio bloco |
|---|---|---|---|
| trabalho | 14 | 13,2% | 0,365 |
| indústria | 12 | 11,3% | 0,525 |
| preços | 11 | 10,4% | 0,386 |
| crédito | 9 | 8,5% | 0,390 |
| ativos | 8 | 7,5% | **0,746** |
| consumo | 8 | 7,5% | 0,420 |
| incerteza | 8 | 7,5% | **0,326** |
| juros | 8 | 7,5% | 0,603 |
| base monetária | 7 | 6,6% | 0,534 |
| câmbio | 5 | 4,7% | **0,774** |
| atividade / energia / risco ext. | 4 cada | 3,8% | 0,49 / 0,58 / 0,53 |
| commodities | 3 | 2,8% | 0,548 |

Os blocos mais internamente redundantes são **câmbio** (0,774) e **ativos**
(0,746), não os maiores. Os 8 índices de incerteza, apesar do tamanho, são o
bloco **menos** colinear (0,326) — eles adicionam variação independente, não
dominam o PCA.

### 3.4 Reestimação sem as duplicatas

Removidas `juros_cdi` e `asset_mlcx` (as segundas de cada par em diferença).
**nboot = 200.**

| painel | n séries | max\|autovalor\| | ξ_mp | Wald conjunta |
|---|---|---|---|---|
| produção | 106 | 0,97679 | **10,431** | 13,99 |
| podado | 104 | 0,97841 | **10,574** | 14,86 |

Deslocamento das IRFs:

| variável | h | produção | podado | dif. relativa |
|---|---|---|---|---|
| `yield_6m` | h0 | 0,00500 | 0,00500 | 0,0% (por construção) |
| `yield_6m` | h6 | 0,00415 | 0,00383 | −7,6% |
| `cambio_usd` | h0 | 0,14976 | 0,15114 | **+0,9%** |
| `cambio_usd` | h6 | 0,06910 | 0,06751 | −2,3% |
| `price_core_ipca_ex0` | h6 | 0,10769 | 0,10829 | **+0,6%** |
| `embi_perc` | h0 | 0,19954 | 0,18789 | −5,8% |
| `commodity_metal` | h0 | 10,406 | 10,706 | +2,9% |
| `juros_selic` | h0 | −0,04710 | −0,02850 | **+39,5%** |
| `juros_selic` | h6 | 0,11555 | 0,06760 | **−41,5%** |
| `asset_ibov` | h0 | −1,673 | −1,265 | **+24,4%** |

**A duplicidade não está dirigindo o resultado.** As variáveis centrais se movem
menos de 6%, e a força do instrumento sobe ligeiramente. Duas exceções que
importam: `juros_selic` (39-42%) e `asset_ibov` (24%) são sensíveis — mas nenhum
dos dois é significativo a 90% no impacto de qualquer forma. As diferenças
relativas enormes em h=12 na tabela completa são artefato de dividir por um
ponto que cruza zero, não instabilidade real.

---

## Tarefa 4 — Inferência robusta a IV fraco — **INCONCLUSIVO**

### 4.1 Que estatística é o "Wald = 12"

É o **ξ_mp de Montiel Olea-Stock-Watson (2021, sec. 4.2)**, não um F de primeiro
estágio convencional. Fórmula, em `impulse_responde.R:199-249`:

```
Γ̂ = (1/T) Σ z̃_t η_t          z̃ = z residualizado nos regressores do VAR (correção Shat)
W  = Eicker-White de z̃_t η_t   (nw_lags = 0 por default)
ξ_mp = T · (c'Γ̂)² / (c'Wc)     c = direção de impacto de yield_6m
ξ_joint = T · Γ̂' W⁻¹ Γ̂  ~  χ²_q
```

Réguas coexistentes no repositório, e o que **não** são:

| régua | é F de 1º estágio? | fonte |
|---|---|---|
| `xi_mp` | **NÃO** | MOSW (2021) — análogo exato do `Waldstat` oficial |
| `wald_joint` | **NÃO** | `MSWfunction.m:389` (`WaldstatFull`) |
| `f_factor` | sim, mas homocedástico | régua **legada** do projeto |
| `f_reduced` | sim | régua **legada** de forma reduzida |

O bloco foi validado ponta a ponta contra os números publicados do petróleo de
Kilian (`script/validate_olea_kilian.R`) e o kernel HAC contra
`NW_hac_STATA.m` (`script/validate_hac_kernel.R`).

### 4.2 Onde o valor cai

| janela | n | ξ_mp | Wald conj. | F conj. | ξ_min | f_factor legado | AR limitado | bandas conv. |
|---|---|---|---|---|---|---|---|---|
| full | 147 | **10,43** | 13,99 | 2,331 | 0,0043 | 6,31 | SIM | no limite |
| pre-COVID | 78 | **12,22** | 16,22 | 2,703 | 0,3006 | 3,09 | SIM | SIM |

> **O item 4.2 do prompt não é respondível como formulado.** Ele pede "os
> valores críticos apropriados de MOSW para distorção de cobertura de 10%, 15% e
> 20%". **Essa tabela não existe em MOSW (2021).** O objeto tabelado nesses
> termos é o F efetivo de **Montiel Olea-Pflueger (2013)**, que é outro
> estimador para outro desenho. MOSW fornecem **dois** limiares:
>
> | limiar | origem | produção full | produção pré |
> |---|---|---|---|
> | ξ_mp > 3,84 | `qchisq(0.95,1)` — o conjunto AR de 95% é um **intervalo limitado** | SIM | SIM |
> | ξ_mp ≥ 10 | convenção Staiger-Stock/Stock-Yogo **herdada**, não tabelada por MOSW | SIM (10,43) | SIM (12,22) |

Nota adicional: **ξ_min = 0,0043** na amostra full. Um instrumento único só pode
identificar uma direção do espaço de fatores; que a direção mais fraca seja
essencialmente zero é esperado, mas confirma que não há folga para identificar
qualquer outro choque com este `z`.

### 4.3 Robustez já medida (2026-07-27)

| fato | valor | consequência |
|---|---|---|
| LOO full: min ξ_mp | 8,43 | conjunto AR limitado em toda a vizinhança amostral |
| LOO full: meses que derrubam abaixo de 3,84 | **0 de 147** | "AR é limitado" é **robusta** |
| LOO full: meses que derrubam abaixo de 10 | **24 de 147** | "bandas convencionais valem" é **marginal** |
| LOO pré-COVID: abaixo de 10 | 4 de 78 | pré-COVID é materialmente mais forte |
| HAC: ξ_mp em NW(6), full | 15,64 (crescente) | NW(0) é conservador, não conveniente |

A isso esta rodada acrescenta um terceiro eixo de fragilidade: **acrescentar 3
séries a um painel de 106 derrubou ξ_mp de 10,43 para 7,87** (Tarefa 1.6), e
remover 2 duplicatas o elevou para 10,57 (Tarefa 3.4). ξ_mp é sensível à
composição do painel na mesma ordem de grandeza em que é sensível à amostra.

### 4.4 O que não foi respondido

> **"O conjunto AR cobre zero em h=0-4?" — NÃO RESPONDIDA.**

Exige inverter o teste AR, nunca implementado neste repositório. Sem isso, a
pergunta que o prompt define como central — se a cadeia câmbio → risco → preços
sobrevive a inferência robusta — permanece aberta. Alvos de tradução:
`codigo_olea/functions/StructuralIRF/ARTestStatistic.m`,
`functions/Inference/GasydistbootsAR.m`, `functions/Inference/MSWfunction.m`.
A IRF aqui é `Λ·B·K·M·H`, razão da mesma forma (linear em Γ sobre `c'Γ`), então
a lógica de Fieller carrega, mas exige a adaptação "identifica nas q inovações e
propaga por Λ".

---

## Tarefa 5 — Dinâmica dos fatores e persistência — **PASSA com ressalvas**

### 5.1-5.2 Autovalores da companion (42 × 42 = r·p)

| ordem | módulo (OLS) | módulo (Kilian) | meia-vida (meses) | período do ciclo |
|---|---|---|---|---|
| 1 | **0,97679** | 0,98339 | 29,5 | **117,9 meses** |
| 2 | 0,97679 | 0,98339 | 29,5 | 117,9 meses |
| 3 | 0,96099 | 0,96585 | 17,4 | 56,4 meses |
| 4 | 0,96099 | 0,96585 | 17,4 | 56,4 meses |
| 5 | 0,91003 | 0,91009 | 7,4 | — |

Raízes com módulo > 0,97: **2**. Com módulo > 0,90: 6.

**O par dominante é complexo, com período de 117,9 meses.** Meia-volta de ciclo
em ≈ 59 meses e meia-vida de 29,5 meses: isso põe a primeira reversão de sinal e
o pico da oscilação amortecida exatamente em **h ≈ 30**, que é onde estão os
picos observados (h=31-34 no bloco de juros, h=24-37 no de ativos). **A corcova
é mecânica.**

Decaimento implicado: 0,869 em h=6; 0,754 em h=12; 0,569 em h=24; **0,324 em h=48**.

### 5.2b Largura das bandas de 90% — o prompt está parcialmente errado

| variável | tcode | h0 | h12 | h24 | h36 | **razão h36/h0** |
|---|---|---|---|---|---|---|
| `asset_ifix` | 2 | 4,15 | 25,52 | 43,11 | 60,29 | **14,53** |
| `asset_imob` | 2 | 11,77 | 55,84 | 87,03 | 110,95 | **9,43** |
| `asset_ibov` | 2 | 9,53 | 44,83 | 67,86 | 84,28 | **8,84** |
| `pib` | 4 | 0,95 | 1,36 | 1,59 | 1,67 | 1,76 |
| `embi_perc` | 1 | 0,431 | 0,402 | 0,491 | 0,439 | **1,02** |
| `cambio_usd` | 1 | 0,218 | 0,292 | 0,244 | 0,208 | **0,95** |
| `price_core_ipca_ex0` | 1 | 0,199 | 0,195 | 0,198 | 0,180 | **0,90** |
| `ind_transformacao` | 1 | 4,48 | 4,64 | 4,21 | 3,37 | **0,75** |
| `ibc_br` | 1 | 1,59 | 1,65 | 1,38 | 1,12 | **0,71** |

Mediana da razão h36/h1 **por tcode**:

| tcode | n | razão mediana |
|---|---|---|
| 2 (`asset_*`, cumsum) | 8 | **7,11** |
| 4 (log-nível) | 16 | 2,03 |
| 1 (nível) | 82 | **0,87** |

> **O alargamento de 8×-14× não é geral: é exclusivo do tcode 2.** As séries em
> nível têm bandas que *encolhem* levemente com o horizonte. A causa é a
> acumulação: o tcode 2 aplica `cumsum` à IRF (`impulse_responde.R:277`), e a
> variância de uma soma acumulada cresce com o horizonte por construção. Não é
> sintoma de raiz unitária — é o que acumular faz.

### 5.3 Ordem de defasagens

| p | log-det | AIC | BIC | HQ | max\|eig\| |
|---|---|---|---|---|---|
| 1 | 9,334 | 9,979 | **10,954** | **10,375** | 0,982 |
| 4 | 6,958 | **9,589** | 13,540 | 11,194 | 0,966 |
| **6 (produção)** | 6,144 | 10,144 | 16,125 | 12,574 | **0,977** |
| 10 | 3,253 | 10,106 | 20,258 | 14,231 | **1,007** ⚠ |
| 11-12 | — | — | — | — | 1,038 / 1,036 ⚠ |

**AIC escolhe p=4; BIC e HQ escolhem p=1. A produção usa p=6, hard-coded**
(`model_alessi.R:166`, `irf_coherence_check.R:37`); nenhum critério é consultado
no pipeline. Observações: (i) `p` **não** dirige a quase-raiz-unitária — em p=1
o módulo máximo é 0,982, *maior* que em p=6; (ii) a partir de p=10 a companion
fica **explosiva**, então p=6 está na faixa segura.

### 5.4 Raiz unitária (ADF com deriva, seleção AIC; KPSS nível)

| veredito | n |
|---|---|
| I(1) — ADF e KPSS concordam | 56 |
| I(0) — ADF e KPSS concordam | 20 |
| ambíguo | 30 |

Cruzado com o tcode:

| tcode | I(0) | I(1) | ambíguo |
|---|---|---|---|
| 1 (nível) | 12 | 40 | 30 |
| 2 (`asset_*`) | **8** | 0 | 0 |
| 4 (log-nível) | 0 | 16 | 0 |

40 de 82 séries tcode 1 são I(1) e entram em nível — **isso é esperado**, é o
desenho BLL. E **os 8 `asset_*` são todos I(0)**, coerente com serem retornos.
**Nenhuma série é diferenciada e depois acumulada duas vezes**: tcodes 3 e 5 não
estão atribuídos a nenhuma série.

### 5.5 R² do componente comum

Três medidas, e a diferença entre elas *é* o achado:

- **R²_chi** — reconstrução do próprio DFM, `Chi = F·Λ'·sy`. É o objeto que gera
  as IRFs (`impulse_responde.R:448-455` usa o mesmo `Λ`).
- **R²_ols** — projeção de mínimos quadrados da série nos mesmos 7 fatores. Mede
  se os fatores **geram** a série, independentemente de `Λ`.
- **R²_dif** — o mesmo em primeira diferença, o espaço onde `Λ` foi estimado.

| grupo | n | **R²_chi** | R²_ols | R²_dif | nº com R²_chi < 0 |
|---|---|---|---|---|---|
| juros | 8 | **0,851** | 0,954 | 0,722 | 0 |
| câmbio | 5 | **0,806** | 0,891 | 0,690 | 0 |
| crédito | 9 | **0,781** | 0,917 | 0,507 | 0 |
| base monetária | 7 | **0,753** | 0,900 | 0,529 | 0 |
| trabalho | 14 | 0,396 | 0,813 | 0,491 | 3 |
| atividade | 4 | 0,338 | 0,868 | 0,425 | 2 |
| commodities | 3 | 0,226 | 0,699 | 0,390 | 1 |
| energia | 4 | 0,226 | 0,681 | 0,300 | 1 |
| indústria | 12 | 0,212 | 0,790 | 0,507 | 3 |
| **ativos** | 8 | **−0,365** | 0,616 | 0,721 | 4 |
| **preços** | 11 | **−0,379** | 0,642 | 0,443 | 3 |
| **risco externo** | 4 | **−0,421** | 0,709 | 0,431 | 3 |
| **incerteza** | 8 | **−1,135** | 0,442 | 0,240 | 7 |
| **consumo** | 8 | **−2,697** | 0,634 | 0,417 | 3 |

**31 de 106 séries têm R²_chi negativo. Nenhuma tem R²_ols negativo.**

> ### ⚠ Correção (2026-07-28, após revisão do autor)
>
> **A primeira versão desta seção interpretou esse fato como inadequação do
> método BLL. Isso está errado, e a correção muda a conclusão.**
>
> O que a primeira versão afirmava: que `Λ` é estimado no espaço das diferenças e
> aplicado ao nível, e que isso o desalinha. **Não desalinha.** Sob o modelo,
> `ΔY = Λ ΔF + Δξ` e `Y = Λ F + ξ` compartilham **o mesmo `Λ`**; estimá-lo por PCA
> nas diferenças é o estimador publicado, exatamente por isso. Alessi &
> Kerssenfischer §2.2: *"we estimate the loading matrix Λ by applying principal
> component analysis on the first-differenced data set and recover an estimate of
> the factors in level form as F̂ₜ = Λ̂′Xₜ"*. E §2.1: *"the only additional
> assumption made by Barigozzi et al. (2016a) is that the factors are I(1) and
> **the idiosyncratic components are either I(0) or I(1)**"*, com §2.3: *"all
> series are kept either in levels or log-levels"*. **O arcabouço admite painel
> misto por construção.**
>
> **Por que o R²_chi fica negativo, então.** `Chi = Z λλ′` é uma projeção
> ortogonal na **seção cruzada**: ela garante `Σᵢ resíduo² ≤ Σᵢ total²` somando
> sobre as séries a cada `t`, **não** série a série ao longo do tempo. E a
> padronização BLL divide por `sd(Δ)`, o que torna `var(Z)` deliberadamente
> heterogêneo: **de 0,48 a 308,8**, fator de 640.
>
> | grupo | mediana var(Z) | mediana R²_chi |
> |---|---|---|
> | crédito | 98,1 | 0,745 |
> | base monetária | 58,2 | 0,839 |
> | juros | 43,3 | 0,850 |
> | câmbio | 11,4 | 0,847 |
> | risco externo | 5,3 | −0,469 |
> | incerteza | 1,8 | −0,369 |
> | preços | 1,3 | 0,068 |
> | ativos | 0,55 | −0,048 |
>
> `cor(log var(Z), R²_chi)` = **+0,727** (Spearman). O R²_chi negativo é quase
> inteiramente previsto pela posição da série na distribuição de `var(Z)` — e
> `var(Z_i) ≈ 1/(2(1−ρ))` para uma série I(0), o que dá ≈ 0,5 para um retorno com
> ρ≈0. Os `asset_*` estão em 0,551. **É aritmética do desenho, não sintoma.**
>
> E o ajuste **agregado** do painel é saudável: `1 − SSR/SST` sobre todas as
> séries e todos os `t`, em unidades Z, é **0,708**.
>
> **A régua certa é o R²_dif** — a comunalidade no espaço das diferenças, onde o
> modelo é linear em `Λ` e onde `Λ` é de fato estimado (e onde `cov(yy)` é uma
> matriz de **correlação**: `var(yy) = 1` para toda série, peso igual). Por ela o
> quadro é outro, e bem menos alarmante — ver a tabela abaixo e a hipótese H1
> reescrita.

Séries destacadas, com as três medidas (a coluna que decide é **R²_dif**):

| variável | R²_chi | R²_ols | R²_dif | **gap** |
|---|---|---|---|---|
| `yield_2y` | 0,960 | 0,985 | 0,808 | 0,03 |
| `yield_10y` | 0,810 | 0,892 | 0,723 | 0,08 |
| `cambio_usd` | 0,847 | 0,939 | 0,859 | 0,09 |
| `yield_6m` | 0,877 | 0,974 | 0,725 | 0,10 |
| `pib` | 0,792 | 0,925 | 0,355 | 0,13 |
| `juros_selic` | 0,767 | 0,949 | 0,659 | 0,18 |
| `ibc_br` | 0,754 | 0,953 | 0,634 | 0,20 |
| `price_ipca` | 0,527 | 0,743 | 0,847 | 0,22 |
| `ind_transformacao` | 0,683 | 0,948 | 0,810 | 0,27 |
| `asset_ibov` | 0,085 | 0,736 | 0,909 | **0,65** |
| `commodity_metal` | **−0,173** | 0,718 | 0,327 | **0,89** |
| `cds_5y` | **−0,149** | 0,857 | 0,676 | **1,01** |
| `embi_perc` | **−0,789** | 0,854 | 0,561 | **1,64** |
| `asset_ifix` | **−2,383** | 0,479 | 0,453 | **2,86** |
| `price_core_ipca_ex0` | **−2,434** | 0,716 | 0,315 | **3,15** |

Pela régua correta (R²_dif), o quadro se inverte para metade das séries que a
primeira versão acusava: **`asset_ibov` tem a MAIOR comunalidade do painel
(0,909)** e `cds_5y` (0,676), `cambio_usd` (0,859) e `yield_6m` (0,725) estão
bem. Sobram como genuinamente pouco comuns `price_core_ipca_ex0` (0,315),
`commodity_metal` (0,327) e `asset_ifix` (0,453) — e mesmo esses não são
extremos: **40 das 106 séries estão abaixo de 0,40**.

Distribuição de R²_dif: mín 0,038 · mediana 0,529 · máx 0,909.
As 6 menores são `epu_india` 0,038, `price_incc` 0,056, `ind_min_extr` 0,058,
`consumo_oleo_combustivel` 0,070, `epu_china` 0,078, `trab_min_wage` 0,098 —
periféricas ao paper, nenhuma delas usada em afirmação do §5.

A implementação em R é **fiel** ao MATLAB de referência (`DFMest_BLL.m:24/26/62`,
conferido linha a linha), e a fidelidade agora se lê no sentido certo: o
procedimento é o publicado, e o R²_chi negativo é consequência aritmética da
padronização, não evidência contra ele.

**Resposta direta à pergunta do prompt:** o R² comum de `yield_6m` (0,877) e
`juros_selic` (0,767) é **alto** — o DFM captura a taxa de política, e a
identificação **não** está comprometida na raiz. E o R² de `pib` (0,792) e
`ibc_br` (0,754) também é alto, então a ausência de significância nesses
agregados **não** se explica por falta de comunalidade: explica-se pela largura
das bandas. Não há contradição com o bloco industrial.

---

## Tarefa 6 — Bloco de ativos — **FALHA para h > 12**

Script `diagnostics/06_bloco_ativos.R`. Fonte: `irf_coherence_cell.rds`
(nboot = 800). **Nenhuma reestimação.**

### 6.1 IRFs truncadas em h=12 — o teste da hipótese H2

| índice | h0 | h6 | h12 | h24 | h48 | sig68 em h0-12 | sig90 em h0-12 | sig90 em h13-48 |
|---|---|---|---|---|---|---|---|---|
| `asset_ibov` | −1,67 | +2,36 | +11,52 | +20,26 | +7,92 | 1 | **0** | **0** |
| `asset_idiv` | −2,04 | +2,53 | +12,65 | +26,40 | +22,92 | 2 | **0** | **0** |
| `asset_ifix` | −1,03 | −6,68 | −8,89 | −13,91 | −33,34 | 9 | **0** | **0** |
| `asset_ifnc` | −1,97 | +6,53 | +20,47 | +41,02 | +45,05 | 1 | **0** | **0** |
| `asset_imat` | −0,31 | +2,83 | +5,11 | −0,71 | −18,04 | 0 | **0** | **0** |
| `asset_imob` | −2,89 | −1,59 | +7,75 | +20,95 | +18,34 | 2 | **0** | **0** |
| `asset_mlcx` | −1,74 | +1,21 | +9,36 | +16,99 | +4,06 | 1 | **0** | **0** |
| `asset_smll` | −2,68 | −3,71 | +3,26 | +11,41 | −4,44 | 3 | **0** | **0** |

Dois fatos que decidem:

1. **Em h=0 os 8 de 8 índices são negativos.** Em h=12 só 1 de 8; em h=48, 3 de 8.
   O sinal teoricamente correto existe, é unânime, e vive **exclusivamente no
   impacto**.
2. **Nenhum dos 8 índices é significativo a 90% em nenhum dos 49 horizontes.**
   Isso já constava do relatório; a novidade é que o bloco inteiro tem 19
   horizontes sig68 em h0-h12 contra 0 em h13-h48 — a informação que existe
   está toda na janela curta.

Dispersão da seção cruzada, que é a medida direta de H2:

| h | mínimo | máximo | amplitude | desvio-padrão | nº negativos |
|---|---|---|---|---|---|
| **0** | −2,89 | −0,31 | **2,58** | 0,83 | **8 de 8** |
| 6 | −6,68 | +6,53 | 13,21 | 4,20 | 3 |
| 12 | −8,89 | +20,47 | 29,36 | 8,51 | 1 |
| 24 | −13,91 | +41,02 | 54,92 | 16,77 | 2 |
| 48 | −33,34 | +45,05 | **78,40** | 24,50 | 3 |

**A amplitude cresce 30,4× de h=0 a h=48.** A "incoerência de seção cruzada" da
anomalia #6 não é uma discordância entre dois índices: é a desintegração
progressiva de uma seção cruzada que começa unânime.

### 6.2 Largura da banda de 90%

| índice | h0 | h12 | h24 | h36 | **h36/h0** |
|---|---|---|---|---|---|
| `asset_ifix` | 4,15 | 25,52 | 43,11 | 60,29 | **14,53** |
| `asset_ifnc` | 12,23 | 67,51 | 118,85 | 161,39 | 13,20 |
| `asset_imat` | 8,00 | 50,37 | 75,49 | 103,28 | 12,91 |
| `asset_idiv` | 9,81 | 51,80 | 85,59 | 112,68 | 11,49 |
| `asset_imob` | 11,77 | 55,84 | 87,03 | 110,95 | 9,43 |
| `asset_ibov` | 9,53 | 44,83 | 67,86 | 84,28 | 8,84 |
| `asset_mlcx` | 9,43 | 41,64 | 64,31 | 77,17 | 8,19 |
| `asset_smll` | 10,60 | 47,93 | 73,03 | 85,86 | 8,10 |

Mediana 10,46; **metade do alargamento total já ocorreu em h=12** (razão
mediana h12/h0 = 5,01). Contraste com o painel:

| tcode | n | razão mediana h36/h0 |
|---|---|---|
| 1 (nível) | 81 | **0,944** |
| 2 (`asset_*`, cumsum) | 8 | **10,46** |
| 4 (log-nível) | 16 | 2,79 |

Confirma 5.2b com os 8 índices em vez de 3: o alargamento é **exclusivo do
tcode 2** e é o que acumular faz. Nota lateral: `yield_6m` foi excluída da
mediana do tcode 1 porque sua largura em h0 é **exatamente zero** — as 800
reamostras são todas normalizadas a 0,005. É confirmação mecânica de que o
+50bp é exato.

### 6.3 Juro real / NTN-B — **NÃO EXECUTÁVEL**

O item pede acrescentar juro real / NTN-B ao painel para testar a hipótese de
duration do IFIX. O dado não existe:

- `data/raw_data.csv` **tem** as colunas `breakeven_{1y,2y,5y}`, mas as 193
  linhas são a string `"NA"`. `script/clean.R:12` descarta colunas 100% NA —
  é por isso que o painel tem 106 séries.
- `R/data_download/anbima_breakeven.R:41-56` chama `rb3::yc_brl_get()` e
  `rb3::yc_ipca_get()`; sem cache populado devolve tibble vazio com warning.
- O cache rb3 (`~/rb3_cache`, 278 MB) tem `b3-bvbg-086` e
  `b3-futures-settlement-prices`, mas **não** `b3-reference-rates`, que é a
  fonte da curva DIC/NTN-B.

Executar exigiria `rb3::fetch_marketdata("b3-reference-rates", ...)` sobre
~3.200 dias úteis. **Nenhum substituto foi improvisado** (regra do prompt,
linhas 74-75; precedente: a inversão AR em `04_forca_instrumento.R:4-8`).
Consequência declarada: **a hipótese de duration do IFIX fica sem teste.**

### 6.4 Seção cruzada contra características observáveis

As três características que o prompt pede não existem no repositório. Duas têm
análogo empírico medido no próprio painel (2013-2025, HC1):

`r_i,t = a + β_juros · Δyield_2y_t + β_câmbio · Δcambio_usd_t + e`

`duration implícita` fica **declarada como indisponível** — exigiria a
composição dos índices.

| índice | β_juros | t | β_câmbio | t | R² | IRF h0 | IRF h12 | IRF h48 |
|---|---|---|---|---|---|---|---|---|
| `asset_imob` | **−4,43** | −4,35 | −0,197 | −2,59 | 0,33 | −2,89 | +7,74 | +18,34 |
| `asset_ifnc` | −2,82 | −2,96 | −0,211 | −3,51 | 0,29 | −1,97 | +20,47 | +45,05 |
| `asset_smll` | −2,72 | −3,01 | −0,182 | −2,81 | 0,30 | −2,68 | +3,26 | −4,44 |
| `asset_ibov` | −2,27 | −2,76 | −0,151 | −2,62 | 0,25 | −1,67 | +11,52 | +7,92 |
| `asset_mlcx` | −2,14 | −2,70 | −0,146 | −2,57 | 0,25 | −1,74 | +9,36 | +4,06 |
| `asset_idiv` | −2,00 | −2,64 | −0,177 | −3,70 | 0,28 | −2,04 | +12,65 | +22,92 |
| `asset_ifix` | **−0,69** | −1,18 | −0,086 | −2,99 | 0,23 | −1,03 | −8,89 | −33,34 |
| `asset_imat` | −0,65 | −0,62 | −0,046 | −0,82 | 0,02 | −0,31 | +5,11 | −18,04 |

**Resposta à pergunta literal do prompt: sim, `asset_imob` e `asset_ifix` caem
em pontos opostos do ordenamento** — posições **1 e 7 de 8**, distância 6.
`asset_imob` é o mais sensível a juros do painel; `asset_ifix` é o penúltimo
menos sensível, e seu β sequer é significativo (t = −1,18).

O número decisivo é a correlação entre a característica e a resposta, por horizonte:

| h | ρ(β_juros, IRF) | ρ(β_câmbio, IRF) | Spearman juros | Spearman câmbio |
|---|---|---|---|---|
| **0** | **+0,903** | +0,907 | +0,786 | +0,833 |
| 6 | −0,108 | −0,238 | +0,048 | −0,143 |
| 12 | −0,470 | −0,617 | −0,333 | −0,500 |
| 24 | −0,655 | −0,828 | −0,619 | −0,786 |
| 48 | **−0,672** | −0,829 | −0,619 | −0,786 |

**A ordenação se inverte.** Em h=0 a seção cruzada está ordenada exatamente
como a sensibilidade medida a juros prevê; em h=24-48 está ordenada ao
contrário.

> **Ressalva de honestidade:** a correlação em h=0 **não é validação
> independente** — o β é contemporâneo e a IRF em h=0 também, então parte da
> concordância é mecânica. O informativo é a **inversão de sinal**. E com n=8
> as correlações são imprecisas, por isso o Spearman está reportado ao lado.

**Consequência para o §5:** a hipótese de duration do IFIX ficou sem teste
(6.3), mas o β de juros medido do IFIX é o **segundo menor** do bloco e não é
significativo. Ou seja: a leitura "o IFIX cai por duration" é contrariada pela
própria sensibilidade a juros do índice, e o −33,3% em h=48 não tem sustentação
nem estatística (0 horizontes sig90) nem de seção cruzada.

---

## Tarefa 7 — Dominância fiscal como hipótese testável — **PARCIAL, e depende do indicador**

> **⚠ Baseline migrado para o CDS em 2026-07-29, e a seção foi re-rodada
> inteira.** `07_dominancia_fiscal.R` agora tem `BASELINE <- "cds_ma12"` e
> `BASELINE_ALT <- "embi_ma12"`; os papéis da 7.4d se inverteram e todas as
> `t7_*.csv` foram regeneradas. Motivo da escolha, decidido pelo autor: o CDS é
> contrato padronizado em maturidade fixa e mede risco de default puro, enquanto
> o EMBI é spread de uma cesta de títulos com composição e duration variáveis. A
> decisão estava aberta em `pendencias.md` desde 2026-07-28.
>
> **Como ler esta seção.** O texto abaixo foi escrito em duas camadas sob o
> baseline antigo e **não foi reescrito**, porque as conclusões substantivas não
> mudaram: o impacto (h=0-4) não é dependente de estado, a persistência (h=6-8)
> é. O que mudou foram os números da 7.0 (o bloco de controle agora usa
> defasagens do CDS) e os do teste conjunto, atualizados no fim da seção. A
> conclusão vigente é a de "Conclusão da Tarefa 7"; os blocos superados carregam
> banner próprio.

Script `diagnostics/07_dominancia_fiscal.R`. Método: **LP-IV com interação
completa** (Ramey-Zubairy 2018), não smooth transition — n=141 não sustenta.

```
y_{t+h} = I_{t-1}·[a_H + b_H·x_t + g_H'w_{t-1}]
        + (1−I_{t-1})·[a_L + b_L·x_t + g_L'w_{t-1}] + u
x_t = yield_6m_t, instrumentado por I_{t-1}·z_t e (1−I_{t-1})·z_t
```

Normalização ×0,005 (yield decimal). **Assertiva no código:** o β₀ de
`yield_6m` dá `0,00500000` exato nos dois regimes — se não desse, o alinhamento
com o DFM estaria quebrado. Erros-padrão por sanduíche IV analítico com kernel
Bartlett `bw = h+1`, montado à mão porque `sandwich::NeweyWest` sobre um `lm` de
segundo estágio usa a *meat* errada (`estfun.lm` monta o score com `y − X̂b`, mas
o resíduo estrutural é `y − Xb`). O kernel tem auto-teste `stopifnot()` contra
`sandwich::lrvar`.

### 7.0 Validação: LP-IV agregado contra o DFM

Valores regenerados em 2026-07-29 sob o baseline CDS (o bloco de controle de
`lp_pooled` passou a usar defasagens de `cds_5y` no lugar de `embi_perc`):

| variável | LP h0 | se | t | DFM h0 | DFM sig90 | razão |
|---|---|---|---|---|---|---|
| `yield_6m` | 0,00500 | — | — | 0,00500 | sim | 1,00 |
| `cambio_usd` | +0,0819 | 0,0335 | 2,44 | +0,1498 | sim | 0,55 |
| `embi_perc` | +0,1477 | 0,0632 | 2,34 | +0,1995 | sim | 0,74 |
| `cds_5y` | +17,07 | 6,39 | 2,67 | +29,07 | sim | 0,59 |
| `price_ipp` | +0,339 | 0,211 | 1,61 | +0,586 | sim | 0,58 |
| `asset_ifnc` | −1,79 | 1,42 | −1,26 | −1,97 | não | 0,91 |

O LP-IV **reproduz o sinal e a ordem de grandeza** do DFM em todas as variáveis
do impacto, com magnitude sistematicamente ~55-75% da do DFM. A conclusão é a
mesma da rodada sob EMBI (razões de 0,61 a 0,72): a cadeia de impacto não
depende da estrutura de fatores nem da inversão do polinômio autorregressivo.

> ### ⚠ O que esta concordância NÃO prova (correção de escopo)
>
> A primeira versão chamou isto de "validação cruzada da §5". **É overclaim.**
> LP-IV e proxy-SVAR-DFM compartilham **o mesmo `z_jk_bs_purif`, a mesma
> amostra, a mesma variável de política e a mesma hipótese identificadora**
> (`E[z·ε^mp] ≠ 0`, `E[z·ε^outros] = 0`). O que difere é só como o resto do
> sistema é modelado — estrutura de fatores + propagação VAR(6) contra projeção
> direta com controles.
>
> Logo a concordância testa **especificação, não identificação**. Ela descarta
> "é artefato do `Λ`, da padronização BLL ou da propagação do VAR". Ela **não**
> diz nada sobre `z` ser válido: se o instrumento carrega notícia fiscal, efeito
> de informação ou um fator global de risco, os dois estimadores herdam o mesmo
> viés e concordam no lugar errado.
>
> A versão mais afiada da objeção: ambos são **exatamente identificados com o
> mesmo instrumento único**, então o viés de instrumento fraco empurra os dois
> para o **mesmo limite de probabilidade** (a razão de forma reduzida).
> Concordância não protege contra IV fraco — por construção.
>
> **O que de fato responderia à objeção**, em ordem de força: (1) a **inversão
> Anderson-Rubin**, que ataca o eixo de IV fraco onde ξ_mp = 10,43 raspa o
> limiar; (2) o ramo **não-gaussiano GMR** já no repo, onde `z` apenas *rotula*
> a coluna monetária em vez de identificá-la — é a única rota que cruza a
> hipótese identificadora, ainda que o gate passe só parcialmente; (3) variar o
> próprio `z` entre os 10 variantes da família GK. A defesa de exogeneidade
> continua sendo a **Tarefa 1**, com o ponto fraco declarado (`cambio_usd`
> defasado, p = 0,064).
>
> O que sobra de positivo, e é real mas modesto: as magnitudes diferem 28-39%,
> o que diz que `Λ` não infla a resposta em ordem de grandeza. Reportar como
> **robustez de especificação**, nunca como validação da exogeneidade.

### 7.1 Regime

Baseline: `s_t` = média móvel de 12 meses de `embi_perc` **até t−1**, corte na
mediana (**2,695 p.p. = 269,5 bp**). O nível contemporâneo do EMBI é resposta
significativa ao choque (sig90 em h=0-4), então seria pós-tratamento.

| regime | período | meses |
|---|---|---|
| baixo | 2014-01 .. 2015-06 | 18 |
| **alto** | **2015-07 .. 2017-11** | **29** |
| baixo | 2017-12 .. 2019-01 | 14 |
| alto | 2019-02 .. 2019-05 | 4 |
| baixo | 2019-06 .. 2020-05 | 12 |
| **alto** | **2020-06 .. 2023-06** | **37** |
| baixo | 2023-07 .. 2025-09 | 27 |

70 alto / 71 baixo, 7 corridas, corrida máxima 37 meses. Face-válido: crise
fiscal/impeachment e expansão fiscal pós-COVID são alto; 2018-19 e pós-2023 são
baixo.

**O regime não é o ciclo monetário disfarçado** — a melhor defesa do corte:

| indicador | regime | n | `yield_6m` médio | share de aperto | z não-nulo | share COVID |
|---|---|---|---|---|---|---|
| `embi_ma12` | alto | 70 | 0,0994 | 0,443 | 34 | 0,186 |
| `embi_ma12` | baixo | 71 | 0,0972 | 0,408 | 24 | 0,042 |

Escolhas rejeitadas, com o número que as rejeita:

| alternativa | por quê não |
|---|---|
| MA de 1 mês | 23 corridas, mediana de 4 meses — flicker, não regime; e **F_baixo cai a 2,2-2,9** |
| tercis, meio descartado | compra contraste vendendo identificação: **F_alto cai a 3,8-6,6** |
| **DBGG/PIB em nível** | **concordância 0,433 com o EMBI-MA12, κ = −0,134 — pior que o acaso**; e **F_baixo 1,9-2,6 = NÃO IDENTIFICADO** |

> **A discrepância DBGG × EMBI é achado, não ruído.** A dívida bruta sobe
> monotonicamente, então o corte na mediana rotula a crise fiscal de 2015-17
> como "dívida baixa" e vira quase uma quebra de amostra em 2018-03 (4 corridas,
> a maior de 61 meses). `Δ12m` da DBGG é o corte fiscal defensável — concordância
> 0,586, κ = 0,171, F_baixo 8,9-9,7 — e é o que entra como robustez.

### 7.2 / 7.3 IRFs dependentes de estado e primeiro estágio

**Primeiro estágio, baseline** — os dois regimes são identificados até h=9:

| h | n_alto | F_alto | n_baixo | F_baixo | flag |
|---|---|---|---|---|---|
| 0 | 70 | 10,6 | 71 | 22,7 | ok / ok |
| 4 | 70 | 12,4 | 67 | 22,7 | ok / ok |
| 8 | 70 | 16,0 | 63 | 29,0 | ok / ok |
| 10 | 70 | 17,7 | 61 | **8,7** | ok / **FRACO** |
| 12 | 70 | 19,1 | 59 | **6,7** | ok / **FRACO** |

Por isso o desenho **estima até h=12 mas só testa até h=8**.

> **Armadilha documentada (7.3b).** A interação **parcial** (só do tratamento,
> controles não interagidos) dá F = 3,4-5,9 nos dois regimes, porque `x·(1−I)` é
> mecanicamente zero em metade da amostra. Concluir dali "o regime baixo não é
> identificado" seria erro de especificação, não achado. Sob interação completa:
> 10,6-29,0.

**Resultado central, h=0** (choque de +50bp, os dois regimes normalizados igual):

| variável | alto | t | baixo | t | dif | t_dif |
|---|---|---|---|---|---|---|
| `cambio_usd` | **+0,0718** | 2,19 | **+0,0987** | 2,90 | −0,027 | **−0,57** |
| `embi_perc` | +0,0551 | 1,36 | **+0,2723** | 4,48 | −0,217 | −2,97 |
| `cds_5y` | +6,11 | 1,19 | **+31,80** | 4,92 | −25,69 | −3,12 |
| `price_ipp` | +0,259 | 1,18 | +0,548 | 1,87 | −0,289 | −0,79 |
| `price_core_ipca_ex0` | +0,088 | 2,59 | −0,017 | −0,60 | +0,105 | 2,37 |
| `asset_ifnc` | −0,17 | −0,13 | −7,17 | −2,59 | +7,00 | 2,30 |

**A depreciação perversa está presente nos dois regimes** (+0,072 e +0,099,
ambos t > 2), e se algo é **maior no regime de risco baixo**. Isso é o oposto
da previsão de dominância fiscal dependente de estado.

E onde há diferença — `embi_perc` e `cds_5y` — ela vai **na direção errada**: a
abertura de risco no impacto é inteiramente do regime **baixo** (+0,272 e
+31,8, ambos t > 4,4), enquanto no regime alto nem é significativa (t = 1,36 e
1,19). Sob dominância fiscal seria o contrário.

Robustez: `cambio_usd` t_dif fica entre −0,57 e +1,24 nas 15 células
(indicador × defasagem) testadas; sem COVID, t_dif = 0,03 (mas F_alto cai a
7,45 = FRACO, então é corroboração direcional, não teste independente).

### 7.4 Teste formal — e por que o assintótico não serve

**Teste conjunto h=0..8:**

| variável | W | p_χ²(9) | **p_boot** | mediana W* | q95 W* | q95 χ² | razão |
|---|---|---|---|---|---|---|---|
| `cambio_usd` | 20,9 | 0,013 | **0,668** | 27,9 | 89,1 | 16,9 | **5,3×** |
| `embi_perc` | 60,0 | 1,4e−9 | **0,046** | 18,3 | 59,4 | 16,9 | 3,5× |
| `cds_5y` | 44,8 | 9,9e−7 | **0,221** | 28,3 | 70,3 | 16,9 | 4,2× |
| `price_ipp` | 14,7 | 0,099 | **0,562** | 16,2 | 38,9 | 16,9 | 2,3× |
| `price_core_ipca_ex0` | 41,6 | 3,8e−6 | **0,116** | 21,5 | 50,2 | 16,9 | 3,0× |
| `asset_ifnc` | 52,6 | 3,4e−8 | **0,098** | 23,3 | 63,6 | 16,9 | 3,8× |
| `rel_ifnc_ibov` | 21,1 | 0,012 | **0,552** | 22,7 | 60,0 | 16,9 | 3,5× |

> **O χ² assintótico super-rejeita catastroficamente.** `qchisq(0,95; 9)` = 16,9
> contra um percentil 95 da nula bootstrap de **38,9 a 89,1 — 2,3× a 5,3×**.
> Pelo assintótico, **6 de 7** variáveis teriam "dependência de estado
> significativa"; pelo bootstrap, **1 de 7**. Seguindo o precedente da Tarefa 1,
> o p de bootstrap decide.

Bootstrap: wild block sob H0, Rademacher em blocos não-sobrepostos de 6 meses
sorteados uma vez por mês e compartilhados entre horizontes, com o primeiro
estágio também reamostrado (Davidson-MacKinnon WRE) e `z` fixo (é exógeno e
censurado em zero). 2.000 réplicas, ~114 s.

**Horizonte a horizonte, 63 testes (7 variáveis × h=0..8):**

| critério | rejeições a 5% |
|---|---|
| t assintótico | 11 |
| Holm sobre o assintótico | 3 |
| **bootstrap** | 10 |
| **Holm sobre o bootstrap** | **1** |

A única que sobrevive a multiplicidade **e** ao bootstrap é `price_ipp` em
**h=6** (alto +0,347 vs baixo −0,938; t = 3,35; p_boot = 0,005; p_Holm_boot =
0,045) — e o teste conjunto dessa mesma variável dá p_boot = 0,562. Ou seja:
um ponto isolado em h=6, fora da janela h=0-4 onde vive a cadeia perversa.

### 7.5 Discriminante do IFNC

Regra de decisão **declarada antes dos números**: dominância fiscal exige
retorno **relativo** negativo no regime alto; beta positivo simples a juros
(NIM) prevê não-negativo nos dois regimes.

A resposta bruta do IFNC em h=0 é −0,17 (alto) contra −7,17 (baixo, t = −2,59),
o que parece um efeito grande de regime. Mas:

| índice | h0 alto (t) | h0 baixo (t) | t_dif |
|---|---|---|---|
| `asset_ifnc` | −0,17 (−0,13) | −7,17 (−2,59) | 2,30 |
| `asset_ibov` | −0,20 (−0,18) | −5,21 (−2,70) | 2,25 |
| `asset_imat` | −1,06 (−0,77) | −2,61 (−2,04) | 0,82 |

**O gap inteiro é de mercado.** Reportar `asset_ifnc` sozinho produziria uma
história falsa sobre bancos. O objeto que discrimina é o retorno relativo:

| h | `rel_ifnc_ibov` alto (t) | baixo (t) | dif (t) |
|---|---|---|---|
| 0 | +0,09 (0,20) | −1,78 (−1,65) | +1,87 (1,60) |
| 4 | +0,53 (0,61) | +0,92 (0,45) | −0,39 (−0,17) |
| **6** | **−1,40 (−2,03)** | +1,63 (1,32) | −3,03 (−2,14) |
| 8 | −0,33 (−0,74) | +2,54 (1,41) | −2,87 (−1,57) |

Teste conjunto h=0..8: W = 21,1, p_χ² = 0,012, **p_boot = 0,552**.

**Veredito do discriminante: o IFNC não discrimina.** Existe subperformance
específica de banco no regime alto, mas só em h=6-8, marginal (t = −2,03), e
ela **morre no teste conjunto**. No impacto — onde vive a cadeia perversa — não
há efeito específico de banco em nenhum dos dois regimes, e o sinal do t_dif
(+1,60) é o **oposto** do que dominância fiscal prevê.

### ⚠ Poder do teste — a ressalva que governa a leitura

**"Não rejeitar" aqui não é "são iguais".** O efeito mínimo detectável a 5%
bilateral (`1,96 × se_dif`) no impacto é, em quase todos os casos, **maior que o
próprio coeficiente**:

| variável | b_alto | b_baixo | se_dif | **EMD** | EMD / \|b_alto\| | EMD / \|b_baixo\| |
|---|---|---|---|---|---|---|
| `cambio_usd` | +0,072 | +0,099 | 0,047 | **0,093** | **1,29×** | 0,94× |
| `embi_perc` | +0,055 | +0,272 | 0,073 | 0,143 | 2,60× | 0,53× |
| `cds_5y` | +6,11 | +31,80 | 8,24 | 16,16 | 2,64× | 0,51× |
| `price_ipp` | +0,259 | +0,548 | 0,366 | 0,717 | 2,77× | 1,31× |
| `asset_ifnc` | −0,17 | −7,17 | 3,05 | 5,98 | 35,6× | 0,83× |

Ou seja: com 70 meses por regime e ~23 blocos efetivos no bootstrap, o desenho
só enxerga diferenças da ordem de **"o efeito existe num regime e some (ou
inverte) no outro"**. Qualquer dependência de estado mais sutil — o efeito ser
1,5× maior no regime alto, digamos — é **invisível para este teste**.

Isso corta nos dois sentidos e as duas leituras precisam constar:

- **A favor do negativo:** o que foi testado e não apareceu é a versão *forte*
  da hipótese, que é justamente a de Blanchard (2004) — um mecanismo que liga
  ou desliga conforme o estado fiscal. Essa versão está descartada.
- **Contra:** a versão *fraca* (o mecanismo opera sempre, com intensidade
  modestamente maior sob estresse) **não foi testada** e não é testável nesta
  amostra. Escrever "não há dependência de estado" seria overclaim; o correto é
  "não detectamos dependência de estado, e o desenho só detectaria diferenças
  maiores que o próprio efeito".

Nota sobre a única rejeição: `embi_perc` com p_boot = 0,046 é marginal e deve
ser lida como "não dá para rejeitar com folga, e o teste tem pouco poder", não
como evidência positiva de dependência de estado.

### 7.4d-f EMBI ou CDS? — a escolha do indicador **inverte a conclusão**

*Acrescentado após questionamento do autor: "ao invés de olhar para o EMBI, não
é melhor olhar para o CDS?"* A pergunta é procedente e o teste mudou o veredito.

**Por que CDS é a priori melhor:** é contrato padronizado em maturidade fixa de
5 anos e mede risco de default puro; o EMBI é spread de uma **cesta de bonds**
cuja composição e duration mudam no tempo, o que mistura default com liquidez e
com o prêmio a termo global. Empiricamente os dois **não são intercambiáveis**:
correlação de 0,933 nas MA12, mas os regimes discordam em **24 dos 141 meses**
(concordância 0,830, κ = 0,660), concentrados em 2018, 2020-21 e 2023-07/11.

Sob o regime de CDS, com o mesmo bootstrap e as mesmas 2.000 réplicas:

| variável | EMBI t_dif(h0) | EMBI p_boot | CDS t_dif(h0) | **CDS p_boot** |
|---|---|---|---|---|
| `cambio_usd` | −0,57 | 0,668 | +0,87 | **0,044** |
| `embi_perc` | −2,97 | **0,046** | −0,25 | 0,634 |
| `cds_5y` | −3,12 | 0,221 | −0,45 | 0,599 |
| `price_ipp` | −0,79 | 0,562 | +0,05 | 0,186 |
| `asset_ifnc` | +2,30 | 0,098 | +0,99 | 0,230 |

Os conjuntos de rejeição são **disjuntos**, o que exigiu localizar de onde vem
cada uma. **A rejeição sob CDS não está no impacto — está na persistência:**

| h | CDS alto | CDS baixo | **CDS t_dif** | EMBI alto | EMBI baixo | EMBI t_dif |
|---|---|---|---|---|---|---|
| 0 | +0,125 | +0,059 | 0,87 | +0,072 | +0,099 | −0,57 |
| 2 | +0,081 | +0,049 | 0,30 | +0,052 | +0,074 | −0,30 |
| 4 | −0,092 | −0,017 | −0,89 | −0,055 | +0,011 | −0,62 |
| **6** | **+0,059** | **−0,129** | **2,81** | −0,059 | −0,078 | 0,19 |
| **7** | **+0,112** | **−0,083** | **3,60** | −0,006 | −0,035 | 0,32 |
| **8** | **+0,054** | **−0,138** | **3,15** | −0,013 | −0,170 | 1,43 |

Máximo \|t_dif\| sob CDS: **1,03 no impacto (h0-4) contra 3,60 na persistência
(h6-8)**. Sob EMBI: 1,24 e 1,43 — nada em lugar nenhum.

**A leitura econômica é limpa e é exatamente a hipótese do prompt.** Sob risco
soberano alto, a depreciação **persiste** em h=6-8 (+0,059 / +0,112 / +0,054);
sob risco baixo ela **já reverteu para apreciação** (−0,129 / −0,083 / −0,138).
O prompt levanta a dependência de estado precisamente por causa da reversão
pós-h≈10 — e é lá que ela está, não no impacto.

Robustez do achado em h=7:

| indicador | L | b_alto | b_baixo | t_dif | F_alto | flag |
|---|---|---|---|---|---|---|
| `cds_ma12` | 2 | +0,112 | −0,083 | **3,60** | 13,5 | ok |
| `cds_ma12` | 3 | +0,133 | −0,069 | **3,52** | 14,3 | ok |
| **`dbgg_d12`** | 2 | +0,192 | −0,010 | **2,46** | 33,8 | ok |
| `cds_ma12` | 1 | +0,130 | −0,106 | 2,18 | 9,4 | FRACO |
| `cds_ma6` | 2 | +0,129 | −0,057 | 1,40 | 6,0 | FRACO |
| `embi_ma12` | 2 | −0,006 | −0,035 | 0,32 | 15,1 | ok |

**Isto corrobora dominância fiscal? Só uma previsão mais fraca.** Blanchard
(2004) é um modelo sobre **o sinal do efeito contemporâneo**: acima do limiar de
dívida/risco, o aperto deprecia *na hora*. É a inversão do sinal de impacto que
caracteriza o regime. E o impacto é exatamente o que **não** depende de estado
(|t_dif| ≤ 1,13 nos sete indicadores). O que se achou é dependência de estado na
**velocidade de reversão** — compatível com dominância fiscal, mas não
diagnóstico dela, porque outros mecanismos também produzem reversão mais lenta
sob risco alto.

**Confundidor mecânico, testado (7.4g).** Se o próprio processo do câmbio fosse
mais persistente sob CDS alto por razões alheias à política monetária, a
interação captaria essa persistência condicional e ela apareceria como
dependência de estado da IRF. Persistência **incondicional** do `dlog cambio`
dentro de cada regime: AR(1) = **+0,318** (alto) contra **+0,270** (baixo),
diferença de 0,048 com se de 0,164 — **t = 0,29**. O confundidor **não se
sustenta**: o que difere em h=6-8 é a resposta ao choque, não a dinâmica de
fundo. *(Ressalva: é teste de AR(1); com n=70 por regime as autocorrelações de
ordem 3-8 têm se ≈ 0,12 e não são distinguíveis individualmente.)*

**Uma leitura que usa os dados melhor** do que forçar tudo em dominância fiscal:
o efeito de **impacto** opera sempre (+0,07 a +0,13 nos dois regimes, em todos os
indicadores) e portanto **não é fiscal** — candidatos naturais são efeito de
informação ou canal de tomada de risco em emergentes; o que é fiscal é a **não
reversão** sob risco soberano alto. Isso é internamente coerente, respeita o
achado do CDS, e não exige supor que o Brasil esteja sempre acima do limiar de
Blanchard.

**O ponto que dá crédito ao achado:** ele aparece sob CDS **e** sob `dbgg_d12` —
a trajetória da dívida —, que são medidas conceitualmente independentes de
estresse fiscal, e nas duas com primeiro estágio forte. O sinal é o mesmo em
todas as cinco especificações que não são o EMBI: alto positivo (+0,11 a +0,19),
baixo negativo ou nulo. Só o EMBI não vê nada.

**Hipótese para a falha do EMBI** (não testada): os meses de discordância se
concentram em 2020-21, quando o spread de bonds foi dominado pelo colapso global
de prêmio a termo, e não por risco de crédito brasileiro. Isso embaralharia o
regime justamente no período mais informativo.

### Conclusão da Tarefa 7 — **revisada após o teste com CDS**

Duas conclusões, e elas são diferentes:

1. **A cadeia de IMPACTO (h=0-4) não é dependente de estado.** Isso é robusto:
   nos **sete** indicadores testados, o \|t_dif\| do câmbio em h=0 nunca passa de
   **1,14**. A depreciação perversa no impacto é característica média da amostra.
2. **A PERSISTÊNCIA é dependente de estado, sob medidas fiscais.** Em h=6-8, sob
   CDS alto ou dívida em deterioração, a depreciação persiste; sob risco baixo,
   já reverteu. t entre 2,46 e 3,60, com primeiro estágio forte, em duas medidas
   independentes.

Ressalvas que precisam acompanhar (2): p_boot conjunto de 0,046 é **marginal**;
há multiplicidade (2 indicadores × 7 variáveis × 9 horizontes) e o achado foi
encontrado **depois** de olhar os dados, não pré-registrado; e o EMBI — a medida
mais convencional na literatura de emergentes — **não** o reproduz. É evidência
sugestiva que merece uma subseção com as três especificações lado a lado, não
uma afirmação central.

> **Números da re-rodada de 2026-07-29 sob o baseline CDS.** Substituem os do
> corpo acima onde houver divergência de casas decimais.
>
> - **Regimes:** corte na mediana de 198,2bp, 70 meses alto / 71 baixo, 9
>   corridas, corrida máxima 31 meses. Concordância com `embi_ma12` = **0,830**
>   (κ = 0,660), então 24 dos 141 meses discordam.
> - **Impacto:** t_dif do câmbio em h=0 é **0,87** sob CDS, **−0,57** sob EMBI e
>   **−0,03** sob ΔDBGG. Máximo sobre os 7 indicadores: **1,13**.
> - **Persistência (h=6/7/8):** alto +0,059 / +0,112 / +0,054 contra baixo
>   −0,129 / −0,083 / −0,138, t = **2,81 / 3,60 / 3,15**. Primeiro estágio
>   13,0-14,9 (alto) e 18,0-28,6 (baixo). ΔDBGG confirma: t = 1,99 / 2,46 / 2,91
>   com F_alto ≈ 33,5-35,8. EMBI não vê: t = 0,19 / 0,32 / 1,43.
> - **Teste conjunto h=0..8:** `cambio_usd` W = 53,85, p_χ² = 2,0e-8,
>   **p_boot = 0,0456**. É a única das 7 variáveis a rejeitar a 5% por bootstrap
>   sob CDS; sob EMBI **nenhuma** rejeita (`embi_perc` fica em 0,058).
> - **Horizonte a horizonte (63 testes):** 6 rejeições assintóticas, 6 por
>   bootstrap, **4 sobrevivem a Holm-bootstrap** (contra 1 na rodada sob EMBI):
>   `cambio_usd` h=8 (p=0,025), `rel_ifnc_ibov` h=6 (0,025), `asset_ifnc` h=7
>   (0,038). **Atenção:** `rel_ifnc_ibov` e `asset_ifnc` sobrevivem a Holm mas
>   **não** rejeitam no teste conjunto (p_boot 0,257 e 0,222), que é o teste
>   apropriado para "existe dependência de estado nesta variável". A afirmação
>   de que o IFNC não discrimina se mantém.
> - **Super-rejeição do χ²:** q95 da nula bootstrap entre 39,1 e 55,1 contra
>   16,9 do χ²(9), razão de **2,3× a 3,3×**.
> - **Confundidor:** diferença de AR(1) incondicional do câmbio entre regimes de
>   +0,048 (se 0,165, t = 0,29). Não se sustenta.
> - **Robustez do achado h=6-8:** sobrevive a L=3 (t=3,52), não sobrevive a
>   `cds_ma6` (t=1,40, F=5,96 fraco) nem a L=1 (t=2,18, F=9,40 fraco).

> **Retratação da primeira versão desta tarefa.** A conclusão original dizia que
> a dominância fiscal "não é dependente de estado" e tratava isso como negativo
> limpo. **Isso estava errado por escolha de indicador.** O EMBI-MA12 foi
> adotado como baseline por estar no painel e por ser o que o prompt lista
> primeiro; é o único dos sete indicadores que não detecta a dependência na
> persistência. O negativo sobrevive **apenas para o impacto**.

**Consequência para o §5** ~~a leitura de dominância fiscal não pode ser
apresentada como dependente de estado~~ — **superado, ver abaixo.** A versão
vigente: a cadeia de **impacto** é característica média da amostra e é assim que
o §5 deve apresentá-la; a **persistência** em h=6-8 é dependente de estado sob
CDS e sob ΔDBGG, e isso é material para uma subseção de robustez com as três
especificações lado a lado — não para o corpo do argumento.

> **⚠ Este bloco foi escrito sob o baseline EMBI e está parcialmente
> superado — ver 7.4d-g.** A conclusão "não é dependente de estado" vale para o
> **impacto**, não para a persistência. Sob CDS e sob ΔDBGG a persistência em
> h=6-8 **é** dependente de estado e no sentido que Blanchard prevê. O parágrafo
> abaixo sobre a rotulagem do mecanismo permanece válido como cautela, mas o
> argumento "o teste que poderia sustentá-lo veio negativo" precisa ser lido
> como "veio negativo no impacto e positivo na persistência, sob 2 de 3 medidas".

**Consequência para a *rotulagem* do mecanismo — o ponto desconfortável.**
Blanchard (2004) é um modelo **de limiar**: o canal perverso liga quando dívida
e risco passam de um ponto. Se o rótulo "dominância fiscal" for lido nesse
sentido estrito, o teste que poderia sustentá-lo veio negativo, e a única
diferença detectável vai no sentido contrário. Três leituras compatíveis com os
dados, em ordem de quanto exigem do leitor:

1. **O Brasil está sempre acima do limiar.** O corte é *dentro* de uma amostra
   que já é de risco alto em termos internacionais (mediana de 269,5bp), então
   partir na mediana compara alto com alto. Compatível com Blanchard, mas
   **não testável aqui** — exigiria um país de risco baixo como contraste.
2. **O mecanismo não é fiscal.** Depreciação sob aperto também sai de efeito de
   informação (o choque revela notícia ruim) ou do canal de tomada de risco em
   emergentes. Nenhum dos dois prevê dependência do estado fiscal.
3. **Saturação.** Com o EMBI já em 400bp pode haver menos espaço de resposta que
   em 200bp, o que geraria a assimetria observada sem contrariar o mecanismo.

Recomendação: **descrever o fato reduzido com confiança e o rótulo com
parcimônia.** A cadeia de impacto está validada por dois estimadores
independentes (§7.0); o que a Tarefa 7 não sustenta é chamá-la de fenômeno de
regime fiscal. Se o §5 mantiver "dominância fiscal", que seja como *interpretação
proposta* entre alternativas, com o resultado da Tarefa 7 declarado — e não como
mecanismo estabelecido.

---

## Causa raiz mais provável

### H1 — Comunalidade baixa em séries específicas *(peso: médio — rebaixada)*

> **Esta hipótese foi reescrita em 2026-07-28.** A versão anterior — "o `Λ` do
> BLL não descreve o bloco I(0) do painel" — estava errada em três pontos:
> (i) tratava PCA-em-diferenças-aplicado-a-nível como desalinhamento, quando é o
> estimador publicado e `Λ` é o mesmo objeto nas duas representações;
> (ii) contrariava a premissa explícita de Alessi & Kerssenfischer §2.1, que
> admite componentes idiossincráticos I(0) **ou** I(1) com todas as séries em
> nível; (iii) ordenava as anomalias pelo *gap* R²_ols − R²_chi, que compara uma
> regressão de série temporal com uma projeção ortogonal de seção cruzada — não
> são comparáveis, e o gap é dirigido por `var(Z)` (Spearman 0,727).

O que sobrevive, muito mais estreito: pela comunalidade no espaço das diferenças
(R²_dif), **três séries relevantes ao paper são genuinamente pouco explicadas
pelo componente comum**:

| variável | R²_dif | por que importa |
|---|---|---|
| `price_core_ipca_ex0` | **0,315** | é o único veredito `incoerente` do check de coerência |
| `commodity_metal` | **0,327** | já explicado pela denominação em R$ (Tarefa 1.6) — não precisa de segunda causa |
| `asset_ifix` | **0,453** | é o −33,3% em h=48, o outlier do bloco de ativos |

Contra uma mediana de painel de 0,529 e 40 de 106 séries abaixo de 0,40, esses
valores são baixos mas **não anômalos**. A leitura correta é: a IRF dessas séries
tem razão sinal-ruído pior que a do resto do painel, não que ela esteja errada.

Retratação explícita: `asset_ibov` (R²_dif **0,909**, a maior do painel),
`cds_5y` (0,676), `embi_perc` (0,561), `cambio_usd` (0,859) e `yield_6m` (0,725)
**não** têm problema de comunalidade. A versão anterior deste relatório os
acusava; estava errada.

**Teste que confirma ou descarta:** estimar a resposta de `price_core_ipca_ex0`
e `asset_ifix` por *local projection* diretamente sobre o choque identificado,
sem passar por `Λ`, e comparar com a IRF do DFM em h=0-12. Se convergirem, a
baixa comunalidade é só ruído maior e a leitura atual se sustenta; se
divergirem, essas duas séries não devem sustentar afirmação no §5.

### H2 — O horizonte longo é oscilação amortecida, não economia *(peso: alto)*

Par de raízes complexas com módulo 0,977 e período de 117,9 meses põe a primeira
reversão em h ≈ 30 — exatamente onde estão os picos (h=31-34). E o alargamento
de 8×-14× das bandas é **exclusivo do tcode 2**: razão mediana h36/h1 de 7,11
nos `asset_*` contra 0,87 nas séries em nível. Ou seja, as anomalias #5 e #6 do
prompt têm explicação inteiramente mecânica: a corcova vem da raiz complexa, a
banda explosiva vem do `cumsum`.

**Teste que confirma ou descarta:** truncar em h=12 e verificar se a incoerência
de seção cruzada some.

> ### ✅ TESTADA E CONFIRMADA (Tarefa 6, 2026-07-28)
>
> O teste foi executado e H2 **passa nos três eixos**:
>
> 1. **Seção cruzada:** em h=0 os **8 de 8** índices são negativos, amplitude
>    2,58 pp. Em h=48, 3 de 8, amplitude 78,4 pp — **crescimento de 30,4×**. A
>    incoerência não é uma discordância entre dois índices: é a desintegração
>    de uma seção cruzada que começa unânime.
> 2. **Ordenação econômica:** a correlação entre a sensibilidade medida a juros
>    e a resposta é **+0,903 em h=0** e **−0,672 em h=48** — a ordenação
>    **inverte**. `asset_imob` e `asset_ifix` estão nas posições 1 e 7 de 8 por
>    β_juros, confirmando a leitura de "pontos opostos do ordenamento" que o
>    prompt pedia.
> 3. **Bandas:** razão mediana h36/h0 de **10,46** nos 8 `asset_*` contra
>    **0,944** nas 81 séries de tcode 1 e 2,79 nas 16 de tcode 4. Exclusivo do
>    `cumsum`, como previsto.
>
> Acrescente-se que **nenhum dos 8 índices é sig90 em nenhum dos 49
> horizontes**, e que os 19 horizontes sig68 do bloco estão todos em h≤12.
>
> **H2 fica promovida de hipótese a resultado**, e a recomendação E2 (h ≤ 12
> como janela reportável) deixa de ser precaução e passa a ser conclusão.

### H3 — O choque identificado não é uma surpresa pura de juro curto *(peso: médio)*

A curva no impacto é 28 → 50 → 74 → 92 → 93 → 81bp de 3m a 10y: o pico está em
2-5 anos, não no vértice de política, e o 3m responde **menos** que o 6m.
`yield_ordering_ok` (`spec_sweep.R:171`) é **FALSE** para a célula de produção —
e para **58 das 68 células classificadas `ok`** na varredura. O flag é computado,
gravado no relatório e **nunca usado** por `classify_sweep_cells`.

Isso é compatível com a leitura de dominância fiscal que o projeto já defende (o
choque move prêmio a termo, não só expectativa de política), mas também com a
leitura de que o instrumento capta algo mais amplo que política monetária. Pesa
contra a segunda: a Tarefa 1 não achou previsibilidade, e o
`instrument_construction_sweep` de 2026-07-27 mostrou que os 13 vértices de DI
dão essencialmente a mesma IRF — trocar o vértice não restaura a ordenação.

**Teste que confirma ou descarta:** decompor a resposta da curva em nível /
inclinação / curvatura (3 primeiros PCs da curva DI) e verificar em qual
componente o choque carrega. Se carregar predominantemente em **nível**, é
prêmio a termo e a leitura de dominância fiscal ganha suporte direto; se
carregar em **inclinação**, é surpresa de política e a corcova em 2-5y precisa
de outra explicação.

---

## Correções recomendadas

### Bugs de código

| # | O quê | Onde | Status |
|---|---|---|---|
| B1 | Três CSVs da investing.com lidos com locale errado → `cds_5y`, `msci`, `sp500_vix` entravam **100× inflados** | `download.R:222-243` | **CORRIGIDO** nesta rodada |
| B2 | `yield_6m` — a variável de normalização — ausente da tabela de coerência, impossibilitando verificar o +50bp | `irf_coherence.R:24-26` | **CORRIGIDO** (2026-07-28) |
| B3 | `commodity_metal` classificado como placebo externo, sendo preço doméstico em R$ | `irf_coherence.R:53-54` | **CORRIGIDO** (2026-07-28) |
| B4 | `yield_ordering_ok` computado e nunca usado na taxonomia | `spec_sweep.R:171`, `classify_sweep_cells` | **CORRIGIDO** (2026-07-28) — documentado, não promovido |

Sobre **B2**: `yield_6m` entrou no bloco `curva_juros` (`scored`, janela [0,6]).
A tabela passou de 52 para **53** variáveis. Valor verificado: **h0 = 0,005000
exato**, com CI90 degenerada `[0,005; 0,005]` — as 800 reamostras são todas
normalizadas ao mesmo ponto, o que é a confirmação mecânica de que o +50bp é
entregue. O `h0` é mecânico por construção, então 1 dos 7 pontos da janela é
livre e são h1..h6 que informam o veredito (`coerente_forte`, share 1,0);
está registrado em comentário no código.

Sobre **B3**: `commodity_metal` saiu do tier `placebo` e foi para `ambiguous`
(grupo `commodity_domestica`). O tier `placebo` fica com as três genuinamente
externas — `sp500_vix`, `msci`, `epu_us` — e **todas passam**.
`commodity_agro`/`commodity_energia` não foram acrescentadas: nunca estiveram
na tabela, e adicioná-las mudaria a contagem em duas direções ao mesmo tempo.

Sobre **B4**: `classify_sweep_cells` **não foi tocada**. `yield_ordering_ok` e
`magnitude_flag` (que tem o mesmo defeito, uma linha abaixo) foram declarados na
legenda de critérios do relatório como diagnóstico reportado que não classifica
— mesma convenção já usada para o `f_factor`. Promovê-los a critério
classificaria a **própria produção** como falha: `yield_ordering_ok` é FALSE em
(7,6) full e em **58 das 68** células `ok`, porque o pico da curva está em 2-5
anos e não no vértice de política. Verificado após a correção:
`spec_sweep_cells.csv` mantém `failure_class`, `yield_ordering_ok` e
`magnitude_flag` **idênticos**, 68 células `ok` antes e depois, e nenhum número
move mais de 7e−7 em termos relativos (ruído de ponto flutuante do BLAS, não
efeito da mudança).

**Efeito conjunto de B2+B3 na contagem de vereditos** (53 variáveis):

| veredito | antes | depois |
|---|---|---|
| `coerente_forte` | 21 | **22** (+`yield_6m`) |
| `coerente` | 5 | 5 |
| `parcial` | 11 | 11 |
| `incoerente` | 1 | 1 (`price_core_ipca_ex0`) |
| `ambigua` | 6 | **7** (+`commodity_metal`) |
| `soft_*` | 4 | 4 |
| `placebo_ok` | 3 | 3 |
| **`placebo_viola`** | **1** | **0** |

`commodity_metal` é a **única** variável cujo veredito mudou; todas as outras 51
são idênticas, o que confirma que a estimação não se moveu. O smoke test do
`CLAUDE.md` reproduz nos cinco valores (`yield_6m` 0,005, `yield_2y` 0,009164,
`yield_5y` 0,009274, `asset_ibov` −1,673, `cambio_usd` 0,1498).

Sobre **B1**: a correção foi aplicada com trava de vintage. `download.R` foi
re-rodado em cópia de rascunho e diferenciado coluna a coluna contra o painel
congelado: **95 de 98 colunas comparáveis bit-idênticas**, exatamente as três
alvo com razão mediana 0,01. Sem deriva de vintage. Invariância verificada
depois: `max|eig|` = 0,9767937 antes e depois, smoke test do `CLAUDE.md`
reproduzido nos cinco valores, contagem de vereditos da coerência inalterada
(21/5/11/1/6/4/3/1). Efeito prático: **nenhum resultado muda**; passam a ser
legíveis os números das três séries — `cds_5y` no impacto era "+2907" e é
**+29,07 bp**, que agora bate com o EMBI (+19,95 bp).

> **Resíduo de B1 encontrado e corrigido em 2026-07-28.** Ao re-rodar
> `irf_spec_sweep.R` para verificar B4, apareceu que
> `output/irf/spec_sweep_irf_long.csv` **ainda estava no vintage pré-B1**: 320
> das 3.200 linhas mudaram, todas de `response_var == cds_5y`, com razão
> antes/depois de **exatamente 100**. Ou seja, o artefato commitado carregava o
> CDS 100× inflado. As outras 2 linhas com diferença acima de 1e−4 são
> `asset_ibov` em células de magnitude explosiva (`unstable_normalization`), com
> razão 1 — ruído de ponto flutuante. `spec_sweep_cells.csv` **não** tinha o
> problema porque nenhuma de suas colunas é uma das três séries afetadas
> (`h0_yield6m/2y/5y`, `h0_ibov`, `h0_cambio`). Verificação de que B4 não moveu
> nada: `failure_class`, `yield_ordering_ok` e `magnitude_flag` idênticos, 68
> células `ok` antes e depois, e nenhum número de `spec_sweep_cells.csv` move
> mais de 7e−7 relativo.

### Escolhas de especificação

| # | O quê | Recomendação |
|---|---|---|
| E1 | `commodity_metal/agro/energia` são preços em R$, não placebos | **APLICADO** via B3 — foi para `ambiguous`. `pendencias.md` atualizado: não é caveat de exogeneidade |
| E2 | Horizonte de interpretação | **PROMOVIDO DE RECOMENDAÇÃO A CONCLUSÃO** pela Tarefa 6. Declarar **h ≤ 12** como janela reportável. No bloco de ativos, a evidência é decisiva: 8/8 negativos em h=0 contra 1/8 em h=12, amplitude de seção cruzada ×30,4 até h=48, correlação com a sensibilidade a juros invertendo de +0,90 para −0,67, e **zero** horizontes sig90 em qualquer h |
| E3 | Comunalidade baixa em 3 séries usadas no §5 | `price_core_ipca_ex0` (R²_dif 0,315) e `asset_ifix` (0,453) têm razão sinal-ruído pior que o resto do painel. Testar por local projection antes de sustentar afirmação neles. **Não é caso de mexer no painel** — o R²_chi negativo em 31 séries é aritmética da padronização BLL, não defeito. *Parcialmente atendido pela Tarefa 7.0*: o LP-IV agregado, que não passa por `Λ`, reproduz sinal e ordem de grandeza do DFM em `cambio_usd`, `embi_perc`, `cds_5y` e `price_ipp` no impacto (razão 0,61-0,72). Falta rodar o mesmo para `asset_ifix` |
| E8 | O **impacto** não é dependente de estado, a **persistência** é | *Tarefa 7, revisado em 2026-07-29 sob baseline CDS.* Não apresentar a cadeia de h=0-4 como fenômeno de regime de alto risco: ela está nos dois regimes (\|t_dif\| ≤ 1,13 nos 7 indicadores) e é característica média da amostra. A persistência em h=6-8, ao contrário, **é** dependente de estado sob CDS e sob ΔDBGG, e virou subseção própria do §5 com as três especificações lado a lado e o desacordo do EMBI declarado. **Atendido** em `tex/main.tex`, `\ref{sec:estado}` |
| E9 | Teste de igualdade entre regimes exige bootstrap | *Novo, Tarefa 7.4.* O χ² assintótico tem q95 de 2,3× a 5,3× o valor tabelado nesta amostra. Se algum exercício futuro comparar subamostras, o p assintótico **não** serve — usar wild block bootstrap sob H0, como já é a convenção da Tarefa 1 |
| E4 | `p = 6` hard-coded | AIC diz 4, BIC e HQ dizem 1. Declarar `p = 6` como escolha (segue Alessi-Kerssenfischer) e reportar a sensibilidade, ou adotar um critério |
| E5 | Unidades mistas na saída | Publicar as IRFs de juros **em pontos-base**, não em unidade nativa. Sem isso, a tabela sugere que a Selic responde 26× o DI 6m quando responde ~1/10 |
| E6 | Interpretação de `price_*` | Dizer no texto que é resposta da **taxa mensal** em p.p. (≈ ×12 ao ano), não de nível de preço |
| E7 | ξ_mp sensível à composição do painel | +3 séries → 7,87; −2 séries → 10,57. Somado ao LOO (24/147 abaixo de 10), reforça a prioridade da inversão AR |

---

## O que pode ser reportado no paper hoje

### Sobrevive à auditoria

| resultado | horizonte | confiança | ressalva |
|---|---|---|---|
| **Toda a curva DI sobe no impacto** — 3m +27,9bp, 6m +50,0 (normalizado), 1y +73,5, 2y +91,6, 5y +92,7, 10y +80,8 | h=0 | **sig90** | reportar **em bp**; e a corcova em 2-5y (H3) precisa ser discutida, não omitida |
| **Depreciação cambial no impacto** — `cambio_usd` +0,150 (+3,6% do nível médio) | h=0 a h=4 | **sig90** | R²_chi 0,847, um dos melhores do painel — resultado sólido |
| **Curva sobe de forma persistente até h≈6** | h=0 a h=6 | sig90 | — |
| **`commodity_metal` NÃO viola exogeneidade** | — | — | resultado **novo e positivo**: o índice em US$ passa o placebo em 25/25 horizontes |
| **Instrumento não é previsível** por fatores globais nem pelo próprio espaço de fatores | — | p_boot ≥ 0,20 | mencionar o `cambio_usd` defasado em p = 0,064 |
| **Instrumento sem autocorrelação** (Ljung-Box p ≥ 0,19 até lag 12) | — | — | justifica `nw_lags = 0` |
| **Duplicidade não dirige o resultado** — remover `juros_cdi` e `asset_mlcx` move as variáveis centrais < 6% e eleva ξ_mp para 10,57 | — | — | robustez publicável |
| **A cadeia de impacto não depende do `Λ` do DFM** — um LP-IV reproduz sinal e ordem de grandeza em `cambio_usd` (+0,095, t=2,80), `embi_perc` (+0,144, t=2,45), `cds_5y` (+17,7, t=2,57) e `price_ipp` (+0,363, t=1,75) | h=0 | t ≥ 1,75 | *novo, Tarefa 7.0.* Magnitude 61-72% da do DFM. **É robustez de ESPECIFICAÇÃO, não de identificação** — os dois estimadores usam o mesmo `z`, a mesma hipótese identificadora e são exatamente identificados, então o viés de IV fraco os empurra para o **mesmo limite de probabilidade**. Não reportar como validação da exogeneidade |
| **A depreciação perversa NÃO é fenômeno de regime** — presente nos dois regimes de risco (+0,072 t=2,19 alto; +0,099 t=2,90 baixo), t_dif = −0,57, teste conjunto h=0..8 p_boot = 0,67 | h=0 a h=8 | p_boot | *novo, Tarefa 7.* Resultado **negativo**, e mais forte que um positivo frágil |
| **O bloco de ativos é coerente exatamente onde deveria** — 8 de 8 índices negativos em h=0, ordenados pela sensibilidade medida a juros (ρ = +0,90) | h=0 | sig68 em 6 de 8 | *novo, Tarefa 6.* Reportar como coerência de seção cruzada, **sem** afirmar significância a 90% (não há) |

### Reportar com ressalva explícita

| resultado | ressalva |
|---|---|
| Abertura de risco soberano — `embi_perc` +19,95bp, `cds_5y` +29,07bp, h=0-4, sig90 | R²_chi **negativo** nas duas (−0,79 e −0,15). Sobrevive ao teste de exogeneidade, mas a reconstrução do componente comum é ruim — H1 se aplica |
| Corcova de preços em h2-h8 (`price_ipca` sig90 em h5; `ex0` em h2 e h4-h8) | `price_core_ipca_ex0` tem o **pior gap do painel** (3,15). É a afirmação mais frágil do conjunto significativo |
| Queda do bloco industrial no impacto | sig68, alguns sig90; R²_chi do grupo 0,212, intermediário |

### Não reportar

| item | por quê |
|---|---|
| Qualquer IRF em **h > 12** | H2, agora **testada e confirmada** (Tarefa 6): corcova mecânica (raiz complexa, período 118 meses) e, nos ativos, banda com razão mediana h36/h0 de **10,46** contra 0,944 nas séries de nível |
| Sinais de longo prazo do bloco de ativos (`asset_imob` +18,3 vs `asset_ifix` −33,3 em h=48) | mesma razão, agora com o número que fecha: a amplitude da seção cruzada cresce **30,4×** de h=0 a h=48, e a correlação com a sensibilidade medida a juros **inverte** de +0,90 para −0,67 |
| Que o IFIX cai por **duration** | a hipótese ficou sem teste (6.3 não executável), mas o β de juros medido do IFIX é o **segundo menor** dos 8 e nem é significativo (t = −1,18). A leitura de duration é contrariada pela própria sensibilidade do índice |
| Que a dominância fiscal é **dependente de estado** | Tarefa 7: a cadeia está nos dois regimes; 1 de 7 testes conjuntos rejeita por bootstrap (`embi_perc`, p = 0,046) e **no sentido contrário** — a abertura de risco no impacto é do regime de EMBI baixo |
| Que o IFNC é o teste discriminante de dominância fiscal | Tarefa 7.5: o gap aparente em h=0 é **de mercado** (`asset_ibov` faz −0,20 vs −5,21, t_dif 2,25, praticamente igual). O relativo `ifnc − ibov` dá p_boot = 0,55 no conjunto |
| `pib` e `ibc_br` | n90 = 0 em todos os horizontes. **Não é falta de comunalidade** (R² 0,792 e 0,754) — é largura de banda |
| `juros_selic` e `juros_cdi` | n90 = 0; e o impacto é **−4,7bp**, negativo, com sensibilidade de 40% à remoção de uma duplicata |
| Os 8 índices de ações | n90 = 0 em todos os horizontes |
| Que "as bandas convencionais são válidas" | ξ_mp = 10,43 raspa o limiar; 24/147 meses o derrubam abaixo de 10; +3 séries no painel o derrubam para 7,87. **Só a inversão AR resolve** |

---

## Próximos passos, em ordem de prioridade

Riscados os itens que esta segunda rodada fechou.

1. **Inversão Anderson-Rubin** (Tarefa 4.4, adiada). Segue sendo o item #1: é a
   única forma de responder se a cadeia câmbio → risco → preços sobrevive a
   inferência robusta a instrumento fraco. Alvo de tradução já no repo
   (`codigo_olea/MSWfunction.m`). **A Tarefa 7.0 tornou isso mais urgente, não
   menos:** o LP-IV independente confirma a cadeia com t entre 1,75 e 2,80, o que
   diz que ela não é artefato do `Λ` — mas não diz nada sobre validade de banda
   sob ξ_mp = 10,43.
2. **Decomposição nível/inclinação/curvatura** da resposta da curva — testa H3,
   a única das três hipóteses de causa raiz ainda sem teste. Barato.
3. **Completar o teste de H1** para `asset_ifix` e `price_core_ipca_ex0` por
   local projection. A infraestrutura já existe: `lp_pooled()` em
   `diagnostics/07_dominancia_fiscal.R` faz exatamente isso e já foi validada
   contra o DFM em 9 variáveis.
4. **Migrar o §5** com as conclusões desta rodada — sobretudo E2 (janela h ≤ 12),
   E8 (dominância fiscal não é dependente de estado) e a remoção do caveat de
   exogeneidade do `commodity_metal`.
5. Se em algum momento houver rede disponível, popular o cache
   `b3-reference-rates` e fechar a Tarefa 6.3 (duration do IFIX).

~~Tarefa 6.1 (truncar ativos em h=12)~~ — **feita**, H2 confirmada.
~~Aplicar B2, B3/E1 e re-rodar `irf_coherence_check.R`~~ — **feito**, mais B4.
