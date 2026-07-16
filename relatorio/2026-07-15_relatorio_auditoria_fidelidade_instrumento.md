# Relatório — Auditoria de fidelidade do instrumento: filtro Jarociński-Karadi e purificação Bauer-Swanson

**Data:** 2026-07-15 (trabalho iniciado 2026-07-14)
**Escopo:** `script/instrument.R` e artefatos derivados
**Nota técnica resumida:** `relatorio/working-notes/2026-07-14_auditoria_fidelidade_jk_bs.md`

---

## 0. Sumário executivo

A auditoria respondeu quatro perguntas:

| # | Pergunta | Resposta curta |
|---|---|---|
| a | O filtro JK é fiel ao original? | **Parcialmente.** A regra de classificação e a agregação mensal são fiéis; mas o original classifica e agrega valores *brutos*, e o default do projeto usa *resíduos*. A variante literal (`z_jk_raw`) não existia — foi criada. |
| b | A purificação é a de Bauer-Swanson? | **Não.** O que o projeto chama de "purificação BS" é uma limpeza de fator global *contemporâneo* — procedimento válido, mas diferente. BS regridem a surpresa em notícias *pré-anúncio*. A versão fiel foi construída (`z_bs_purif`, `z_jk_bs_purif`). |
| c | Faltavam variáveis na regressão? | **Sim, no sentido BS**: preditores pré-Copom (financeiros de 13 semanas + revisões Focus). Variáveis domésticas *contemporâneas* continuam proibidas (bad control). O único candidato contemporâneo exógeno adicional (UST 2y) é redundante. |
| d | Isso impacta a força (ξ_mp de Olea et al.)? | **Sim — pelo canal da máscara, não dos valores.** Máscaras predeterminadas elevam ξ_mp de 5.20 para ≈ 6.9–7.0 na célula de produção full-sample e destravam 6/14 células ≥ 10 (o default não cruza em nenhuma). No pre-COVID o default segue líder (13.25 vs 12.49). |

**Default (`z_jk_purif`) não foi alterado.** O candidato metodologicamente mais limpo identificado é `z_jk_bs_purif`; a decisão de troca é do autor.

---

## 1. Contexto: por que existem filtro e purificação

O instrumento externo do projeto é a surpresa do DI futuro (~6 meses) na janela quarta-fechamento → quinta-fechamento em dias de Copom, agregada mensalmente. Duas contaminações conhecidas motivam camadas de tratamento:

1. **Choque informacional do BCB** (Jarociński & Karadi 2020): parte das surpresas de juros não é choque monetário, mas revelação de informação do banco central sobre a economia. A assinatura empírica é o co-movimento *positivo* entre surpresa de juros e bolsa (juros sobem E bolsa sobe = "boa notícia" revelada). No nosso painel, **31,6% dos 95 dias Copom** são wrong-signed — quase idêntico ao ~1/3 que JK reportam para o FOMC. O **filtro JK** ("poor man's sign restrictions") zera os dias de co-movimento positivo.

2. **Contaminação por outras notícias**: a surpresa medida pode carregar componentes que não são o choque monetário. O projeto trata isso com uma regressão de "purificação" cujos resíduos substituem a surpresa bruta. A auditoria mostrou que essa regressão fazia algo diferente do que o rótulo ("Bauer-Swanson") prometia — ver §3.

A força do instrumento é medida pela régua rigorosa adotada em 2026-07-14: **ξ_mp**, a estatística de Wald de Montiel Olea, Stock & Watson (2021) na direção do impacto em `yield_6m`, com erros Eicker-White e correção Shat, validada contra o código oficial dos autores (`codigo_olea/`). Interpretação: ξ_mp > 3.84 garante que o conjunto de confiança Anderson-Rubin de 95% é um intervalo limitado; ξ_mp ≥ 10 é o análogo do limiar Stock-Yogo para inferência padrão.

---

## 2. Auditoria do filtro JK

### 2.1 O que os autores fazem

JK (2020, *AEJ: Macro*) têm duas implementações. A baseline é um VAR bayesiano com restrições de sinal (identificação por conjunto). A variante simples — **"poor man's sign restrictions"** — é a que o projeto (e a literatura aplicada) usa como "filtro JK":

> Se a surpresa de juros e a surpresa de bolsa têm sinais **opostos** → o dia é "monetário": mantenha a surpresa de juros **bruta**. Se têm o **mesmo** sinal → o dia é "informacional": zere. Agregue somando dentro do mês; meses sem reunião = 0.

Isso foi verificado diretamente no dataset de replicação dos autores (`codigo_Jarocinski_e_Karadi/data/data_var/us_ea_variables_shocks/us_shocks.csv`). Exemplo concreto — fevereiro de 1990: surpresa de juros ff4 = −0.02 e surpresa de bolsa sp500 = −0.167 (mesmo sinal, ambos negativos) ⇒ a coluna monetária `pmnegm_ff4sp500` = 0 e a informacional `pmposm_ff4sp500` = −0.02. Ou seja: **a classificação usa os sinais brutos e o valor mantido é o bruto** — não há nenhuma etapa de purificação antes do filtro no procedimento original.

### 2.2 Comparação componente a componente

| componente | JK original | projeto (default `z_jk_purif`) | veredito |
|---|---|---|---|
| regra zero-out | co-mov. negativo mantém; positivo zera | idem | ✅ fiel |
| agregação mensal | soma das surpresas do mês; 0 sem reunião | idem | ✅ fiel |
| janela de evento | 30 minutos em torno do anúncio | qua fechamento → qui fechamento | ⚠️ desvio documentado — não há dados intradiários de DI; é a mesma janela de Gonçalves, Rodrigues & Genta (2025) para o Brasil |
| sinais usados na classificação | **brutos** | resíduos da purificação contemporânea | ❌ desvio |
| valores agregados | **brutos** | resíduos | ❌ desvio |

### 2.3 A matriz 2×2 e a célula que faltava

O desvio tem duas dimensões independentes — *qual sinal decide a máscara* e *qual valor é agregado*. Cruzando-as:

| | valores brutos | valores purificados |
|---|---|---|
| **máscara bruta** (JK original) | **`z_jk_raw`** ← criada nesta auditoria | `z_jk_raw_purif` (criada 2026-07-14, nota de ordenação) |
| **máscara residual** | `z_jk` | `z_jk_purif` (default) |

Antes da auditoria, a célula do JK **literal** (máscara bruta + valores brutos) não existia no projeto. Ela foi adicionada como `z_jk_raw` — custo de implementação ~zero, pois a máscara bruta (`jk_monetary_raw`) já existia desde a nota de ordenação de 2026-07-14.

### 2.4 Correção de atribuição (achado colateral)

A agregação por **soma dentro do mês** é a de **JK**. Gertler & Karadi (2015) usam outro esquema: cumulam as surpresas diárias numa série de nível, tiram a **média mensal** e depois a **primeira diferença** — assim uma surpresa no fim do mês pesa menos no mês corrente. O `CLAUDE.md` atribuía a agregação a GK; a atribuição foi corrigida. (Não é um erro de código — apenas de rótulo na documentação.)

---

## 3. Auditoria da purificação "Bauer-Swanson"

### 3.1 O que Bauer & Swanson realmente fazem

BS (2023, *AER*) documentam que as surpresas de política monetária são **previsíveis ex-post por informação pública anterior ao anúncio** — o canal "Fed response to news": o mercado subestimava o quanto o Fed responde às notícias, então notícias boas entre a survey Blue Chip e o FOMC predizem surpresa hawkish. Isso viola a exogeneidade exigida de um instrumento externo (correlação com choques estruturais *defasados*). O remédio (eq. 7 / Table 3) é:

> Regredir a surpresa `mps_t` num vetor `news_t` de variáveis **todas observáveis antes do anúncio** e usar o **resíduo** como instrumento.

O vetor `news_t` deles: surpresas de releases macro do próprio país (nonfarm payrolls, desemprego, GDP, CPI core, índice de atividade BBK) + variações financeiras acumuladas nas **13 semanas anteriores** (Δlog S&P500, Δ inclinação da curva, Δlog commodities) + constante + **tendência temporal** + revisão defasada do Blue Chip. R² entre 0.12 e 0.20.

### 3.2 O que o projeto fazia

```
ΔDI_t = a0 + a1·ΔSP500_t + a2·ΔVIX_t + a3·ΔBrent_t + e_DI_t
```

com todas as variações medidas **na mesma janela qua→qui do evento**. Isso não é a ortogonalização de BS — é uma limpeza de fator global contemporâneo. A distinção importa porque os dois procedimentos tratam **contaminações diferentes**:

| | purificação contemporânea (projeto) | ortogonalização BS (original) |
|---|---|---|
| contaminação tratada | choques globais que entram na **janela diária larga** (com janela de 30 min isso seria desnecessário) | previsibilidade **ex-ante** — correlação da surpresa com notícias defasadas |
| condição de identificação afetada | restrição-zero do HFI (só os choques do anúncio movem a surpresa) | exogeneidade do instrumento (não correlação com outros choques estruturais) |
| regressores | contemporâneos à janela | estritamente predeterminados |

A limpeza contemporânea do projeto **é defensável em si**: como o Brasil é economia pequena, o Copom não move SP500/VIX/Brent na mesma sessão — não há "bad control". Mas ela não faz o que BS propõem, e o texto do projeto usava o rótulo errado.

### 3.3 Por que não simplesmente "adicionar mais variáveis"?

A pergunta original era se a regressão deveria ter outras variáveis além das globais. A resposta tem uma armadilha didática importante:

- **Variáveis domésticas contemporâneas (BRL, EMBI, curva DI na janela qua→qui): NUNCA.** Elas respondem ao próprio choque do Copom; regredir a surpresa nelas absorve parte do choque que queremos medir — o clássico *bad control*.
- **Variáveis domésticas predeterminadas (medidas até a quarta): SIM.** É exatamente o que BS fazem — o vetor de notícias deles é majoritariamente doméstico (dos EUA, no caso deles). Predeterminação elimina o problema de bad control por construção.
- **Variáveis globais contemporâneas adicionais: em princípio ok (exógenas ao Brasil), mas na prática redundantes** — ver o teste com UST 2y em §5.4.

---

## 4. O que foi construído

### 4.1 Novos dados (`R/data_download/focus_fred.R`, novo)

| série | fonte | escolhas | resultado |
|---|---|---|---|
| Mediana Focus IPCA 12 meses à frente, suavizada | API olinda do BCB (`ExpectativasMercadoInflacao12Meses`, baseCalculo 0) | horizonte fixo, diária — o análogo mais limpo da revisão de forecast do Blue Chip | 3.412 dias, 0 NA (2012-06 a 2025-12) |
| Mediana Focus Selic fim de ano | API olinda (`ExpectativasMercadoAnuais`) | ano de referência = **ano seguinte** ao da observação — evita a resolução mecânica da expectativa do ano corrente em dezembro | idem |
| Treasury 2 anos (DGS2) | FRED (CSV público) | variação qua→qui; quintas sem sessão nos EUA (feriado) recebem 0 — mercado fechado = sem notícia de juros americano na sessão | 3.395 dias |

### 4.2 Preditores pré-evento (estilo BS, adaptados ao que existe em frequência diária)

Para cada quinta-feira do painel, medidos **até a quarta-feira** (portanto predeterminados no anúncio):

- **Bloco financeiro, Δ acumulada em 65 pregões (= 13 semanas, a janela exata de BS):** Ibov, SP500, VIX, Brent, BRL e inclinação da curva DI (vértice 2y − vértice 3m, construída de `data/di.csv`);
- **Bloco macro, Δ em 20 dias de survey (~4 semanas, a cadência mensal do Blue Chip):** revisões das medianas Focus (IPCA-12m e Selic ano seguinte);
- **Tendência temporal** (BS incluem trend).

Limitação honesta: não temos, em frequência diária, surpresas de *releases* macro domésticos (IPCA efetivo vs esperado no dia da divulgação) — as revisões Focus são a proxy disponível do fluxo de notícias macro incorporado pelo mercado. É o análogo funcional, não literal, do bloco de releases de BS.

### 4.3 Novas variantes (4 colunas novas em `instrumentos_mensais.csv`, total 14)

| variante | máscara JK | valores | o que testa |
|---|---|---|---|
| `z_jk_raw` | sinais brutos | brutos | fidelidade literal a JK |
| `z_bs_purif` | nenhuma | resíduo pré-evento | ortogonalização BS sem filtro de sinal |
| `z_jk_bs_purif` | sinais dos resíduos pré-evento | resíduo pré-evento | BS fiel + JK |
| `z_jk_purif_us` | sinais dos resíduos contemp.+UST2y | resíduo contemp.+UST2y | se faltava um controle global contemporâneo |

### 4.4 Verificações de sanidade (todas passaram)

- **Variantes legadas intactas**: contagens de máscara (65 residual / 55 bruta / 51 interseção), desvios-padrão e os ξ_mp do grid idênticos aos da nota de 2026-07-14 — o DFM e as células antigas não mudaram.
- **R² da regressão pré-evento baixo**: 0.024 (`delta_di`) e 0.015 (`r_ibov`). É o esperado — BS obtêm 0.12–0.20 *com* surpresas de release que não temos; um R² alto aqui indicaria vazamento de informação contemporânea (erro de janela). Não há.
- **Correlações mensais coerentes**: cor(`z_jk_raw`, `z_jk_raw_purif`) = 0.998; cor(`z_bs_purif`, `z_bruto`) = 0.994; cor(`z_jk_bs_purif`, `z_jk_raw_purif`) = 0.986; cor(`z_jk_purif_us`, `z_jk_purif`) = **0.999**.
- Máscaras novas: BS-residual = 62 dias monetários (∩ bruta = 53, ∩ residual = 56); US-residual = 63.

---

## 5. Resultados: impacto na força do instrumento (ξ_mp)

Grid MOSW re-rodado com 14 instrumentos × 14 combinações (r,q) × 2 amostras = **392 células** (`output/instrument/mosw_strength_grid.{csv,md}`).

### 5.1 Célula de produção (r=6, q=5)

| amostra | instrumento | ξ_mp | F conjunta | p |
|---|---|---:|---:|---:|
| full | **z_jk_raw** | **7.05** | 1.87 | 0.10 |
| full | z_jk_bs_purif | 6.94 | 1.75 | 0.12 |
| full | z_jk_raw_purif | 6.61 | 1.85 | 0.10 |
| full | z_jk | 5.47 | 2.09 | 0.06 |
| full | **z_jk_purif (default)** | **5.20** | 2.06 | 0.07 |
| full | z_jk_purif_us | 5.06 | 2.07 | 0.07 |
| full | z_bruto_purif | 4.81 | 2.37 | 0.04 |
| full | z_bs_purif | 4.34 | 2.04 | 0.07 |
| pre_covid | z_jk_purif_us | 13.26 | 3.52 | 0.003 |
| pre_covid | **z_jk_purif (default)** | **13.25** | 3.61 | 0.003 |
| pre_covid | z_jk | 12.72 | 3.48 | 0.004 |
| pre_covid | z_jk_bs_purif | 12.49 | 2.74 | 0.018 |
| pre_covid | z_bruto_purif | 12.04 | 2.57 | 0.025 |
| pre_covid | z_bs_purif | 11.53 | 2.61 | 0.023 |
| pre_covid | z_jk_raw_purif | 10.80 | 2.53 | 0.027 |
| pre_covid | z_jk_raw | 10.53 | 2.56 | 0.025 |

(Em todas essas células o conjunto AR de 95% é um intervalo limitado — ξ_mp > 3.84.)

### 5.2 Padrão cell-by-cell (amostra full, 14 células)

| (r,q) | z_jk_purif | z_jk_raw | z_jk_bs_purif |
|---|---:|---:|---:|
| (5,4) | 4.78 | 5.26 | 5.22 |
| (5,5) | 4.87 | 6.29 | 6.18 |
| (6,4) | 5.98 | 6.21 | 6.05 |
| (6,5) | 5.20 | 7.05 | 6.94 |
| (6,6) | 5.97 | 8.80 | 8.79 |
| (7,4) | 5.85 | 9.24 | 9.40 |
| (7,5) | 5.18 | 9.61 | 9.78 |
| (7,6) | 5.00 | 9.49 | 9.67 |
| (7,7) | 5.78 | 11.11 | 11.50 |
| (8,4) | 6.67 | 11.63 | 11.96 |
| (8,5) | 5.84 | 12.01 | 12.29 |
| (8,6) | 6.15 | 12.25 | 12.47 |
| (8,7) | 4.97 | 11.23 | 11.42 |
| (8,8) | 5.28 | 12.60 | 13.13 |

Resumo por contagem (full): `z_jk_bs_purif` cruza ξ_mp ≥ 10 em **6/14** células (mediana 9.73), `z_jk_raw` em 6/14 (9.55), `z_jk_raw_purif` em 6/14 (9.41); o default em **0/14** (mediana 5.53). No pre_covid o ranking inverte nas células r=6 — o default lidera — e r ∈ {7,8} colapsa para todos (T=84, restrição mecânica de amostra).

### 5.3 O mecanismo: a força mora na máscara, não nos valores

Três fatos do grid fecham o diagnóstico:

1. `z_jk_raw` ≈ `z_jk_raw_purif` ≈ `z_jk_bs_purif` em **toda** célula (Δ < 0.5): purificar os *valores* — seja contemporâneo, seja pré-evento — quase não move ξ_mp, coerente com as correlações ≥ 0.986. O que muda a força é **quais dias entram**.
2. A máscara residual-contemporânea é a única que classifica **2020-03-19** como monetário. Nesse dia o ΔDI foi +15,5 bp e o Ibov bruto subiu +2,13% — co-movimento positivo, dia de pânico/informação da COVID. A regressão contemporânea em SP500/VIX/Brent (que despencavam) virou o sinal do resíduo do Ibov para negativo e "monetizou" o dia. As máscaras bruta e BS-pré-evento o excluem — e é exatamente na janela COVID que o default perdia força full-sample. Conclusão geral: **qualquer máscara que não dependa de resíduos contemporâneos limpa o first stage na amostra completa**.
3. `z_bs_purif` (ortogonalização sem filtro de sinal) é a mais fraca das oito — ilustra a divisão de trabalho: **a ortogonalização de BS serve à exogeneidade, não à relevância**; sem o filtro JK o instrumento segue diluído pelos 31,6% de dias informacionais.

### 5.4 O controle UST 2y é redundante

`z_jk_purif_us` tem cor 0.999 com o default e ξ_mp praticamente idêntico (5.20 → 5.06 full; 13.25 → 13.26 pre_covid). SP500 e VIX já absorvem o spillover do FOMC na mesma sessão. E o controle **não corrige** a má-classificação de 2020-03-19 (a máscara `us` também o marca como monetário). Pode ser descartada.

---

## 6. Veredito e recomendação

1. **JK**: fiel na regra e na agregação; infiel no insumo (resíduos vs brutos). O JK literal agora existe (`z_jk_raw`) e é o instrumento mais forte da família GK na amostra completa em (6,5).
2. **BS**: o rótulo estava errado. A regressão contemporânea é uma limpeza de fator global — válida, mas outra coisa. A versão fiel existe agora (`z_bs_purif`/`z_jk_bs_purif`).
3. **Covariáveis**: faltavam preditores pré-evento (financeiros 65d + Focus 20d + tendência); domésticas contemporâneas seriam bad control; globais contemporâneas adicionais são redundantes.
4. **Força**: o canal é a máscara. Trocar a classificação residual-contemporânea por qualquer classificação predeterminada eleva ξ_mp full (6,5) de 5.20 para ≈ 6.9–7.0 e destrava 6/14 células ≥ 10; no pre_covid o default mantém a liderança (13.25 vs 12.49).

**Recomendação (não aplicada):** `z_jk_bs_purif` é o candidato metodologicamente mais limpo — único que simultaneamente (i) implementa a ortogonalização de BS como descrita no artigo, (ii) usa máscara livre de resíduos contemporâneos e (iii) fica a Δ0.1 do máximo full-sample com ≥ 12 no pre_covid. Se a prioridade for fidelidade literal a JK sem camada de purificação, `z_jk_raw` empata em força (mas abre o flanco de exogeneidade que BS documentam). A troca de `DEFAULT_VARIANT` exigiria re-rodar a cadeia IRF (stage 2 do sweep, coherence check) — decisão em aberto.

---

## 7. Arquivos criados e modificados

**Criados**
- `R/data_download/focus_fred.R` — downloader Focus (olinda) + FRED DGS2
- `data/processed/focus_daily.csv`, `data/fred_dgs2.csv` — novos insumos diários
- `data/processed/instrument_{jk_raw,bs_purif,jk_bs_purif,jk_purif_us}.csv` — CSVs individuais das 4 variantes
- `relatorio/working-notes/2026-07-14_auditoria_fidelidade_jk_bs.md` — nota técnica
- este relatório

**Modificados**
- `script/instrument.R` — preditores pré-evento, regressões BS e US, 4 variantes novas, checagens de NA, sumário estendido
- `script/mosw_strength_grid.R` — lista `VARIANTS` 10 → 14
- `script/instrument_diagnostics.R` — lista de variantes 8 → 13
- `data/processed/instrumentos_mensais.csv` — 14 colunas z_*
- `data/processed/copom_event_diagnostics.csv` — colunas `e_di_bs`, `e_ibov_bs`, `e_di_us`, `e_ibov_us`, `jk_monetary_bs`, `jk_monetary_us`
- `output/instrument/mosw_strength_grid.{csv,md}` — regenerados (392 células)
- `output/instrument/instrument_diagnostics_report.md` — regenerado (13 variantes)
- `_instrucoes/Instrumento.md` — bloco de status 2026-07-14, lista de variantes 6 → 10, nota na Etapa 3
- `CLAUDE.md` — descrição do estágio 4, comandos, data layout, correção da atribuição GK→JK da agregação

## 8. Como reproduzir

```bash
Rscript R/data_download/focus_fred.R         # Focus + FRED (novos insumos)
Rscript script/instrument.R                  # 10 variantes GK-family
Rscript script/mosw_strength_grid.R          # grid ξ_mp, 392 células
Rscript script/instrument_diagnostics.R      # relatório F combinado
```

## 9. Fontes da auditoria

- Notas de leitura `split-pdf-md` (reusadas, cobertura verificada): `artigos/{Jarociński-Karadi, Bauer-Swanson, Gertler-Karadi, Olea-Stock-Watson}/..._notes.md`
- Código de replicação dos autores (read-only): `codigo_Jarocinski_e_Karadi/data/data_var/us_ea_variables_shocks/us_shocks.csv` (séries poor man's), `codigo_bauer_swanson/MATLAB/{table_3.m, constructomittedvars.m}` (regressão eq. 7 e construção dos preditores)
- Régua de força: `compute_factor_space_wald` (`R/modeling/impulse_responde.R`), validada contra `codigo_olea/` em `output/instrument/olea_alignment_audit.md`
