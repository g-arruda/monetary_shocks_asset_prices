# Instrumento.md — Construção do Instrumento Externo para o Proxy-SVAR/DFM

## Status (2026-04-25, pós-auditoria)

> **A estratégia principal mudou.** A auditoria (`output/instrument_audit_report.md`) mostrou que as quatro variantes GK descritas neste documento sofrem atenuação severa por descasamento de maturidade contra `juros_selic` (BCB 4189, fluxo) e por contaminação por *information shocks*. A estratégia adotada é **identificação por heterocedasticidade** (Rigobon-Sack 2003), com a variante **`z_het_jk`** como instrumento e **`yield_6m`** como variável de política para normalização. Documentação completa em `_instrucoes/Heteroscedasticidade.md`.
>
> Este documento permanece como referência para as 4 variantes GK legacy (`z_bruto`, `z_bruto_purif`, `z_jk`, `z_jk_purif`), que continuam sendo construídas por `script/instrument.R` e usadas como benchmark na comparação cross-instrument do diagnostics.

## Objetivo

Construir um instrumento externo baseado em surpresas de DI futuro nos dias pós-Copom para identificação de choques monetários no proxy-SVAR do DFM. O pipeline de estimação (painel → fatores → VAR nos fatores → identificação por instrumento externo → IRFs) **já existe e não deve ser alterado**. Este documento trata exclusivamente da construção do instrumento $z_t$ que alimenta o primeiro estágio.

O produto desta linha são **quatro variantes** do instrumento mensal, mantidas como benchmark:

1. **$z^{bruto}_t$** — surpresa de DI pós-Copom agregada mensalmente (sem filtro)
2. **$z^{purif}_t$** — surpresa de DI purificada por SP500/VIX/Brent (Bauer-Swanson)
3. **$z^{JK}_t$** — surpresa de DI apenas nos dias com co-movimento negativo DI×Ibovespa (filtro Jarociński-Karadi)
4. **$z^{JK,purif}_t$** — combinação dos dois filtros

---

## Etapa 1 — Coleta de Dados

### 1.1 Surpresas de alta frequência (diário, preço de fechamento)

- **DI futuro — vértice curto (~3 meses):** Swap DI×Pré 90 dias da B3.
  - `data/di.csv` (verificar se é o mesmo)
  - Unidade: taxa em % a.a. (252 d.u.)

- **Ibovespa (IBOV):** índice de fechamento diário.
  - Esta dentro da base: `data/raw_data.csv`, verificar se teve transformaçao em: `script/download.R`
  - Unidade necessaria: retorno percentual diário

### 1.2 Calendário do Copom

- `data/copom_historico.csv`
- Extrair todas as datas de decisão do Copom (quarta-feira)
- Janela de evento: **quarta (fechamento) → quinta (fechamento)**
- Criar dummy: `copom_day = 1` para as quintas-feiras pós-Copom

### 1.3 Fatores externos (para purificação)

Séries diárias, mesmo período, variação quarta → quinta:

- **S&P 500:** Yahoo Finance (`^GSPC`)
- **VIX:** Yahoo Finance (`^VIX`)
- **Petróleo Brent:** Yahoo Finance (`BZ=F`)

### 1.4 Datas FOMC

- Coletar datas de decisão do FOMC no período
- Criar dummy `fomc_coincide = 1` para semanas com Copom e FOMC simultâneos (~32 ocorrências)

---

## Etapa 2 — Surpresas Brutas

Para **toda quinta-feira** da amostra:

```
ΔDI_t   = DI_fecha(quinta) - DI_fecha(quarta)                          [pontos-base]
ΔIbov_t = 100 × [ln(Ibov_fecha(quinta)) - ln(Ibov_fecha(quarta))]      [log-retorno %]
```

Salvar dataframe: `date`, `delta_di`, `delta_ibov`, `copom_day`, `fomc_coincide`.

---

## Etapa 3 — Purificação por Fatores Externos

Estimar na **amostra completa** (todas as quintas-feiras):

```
ΔDI_t   = a0 + a1·ΔSP500_t + a2·ΔVIX_t + a3·ΔBrent_t + e_DI_t
ΔIbov_t = b0 + b1·ΔSP500_t + b2·ΔVIX_t + b3·ΔBrent_t + e_Ibov_t
```

Produto: resíduos `e_DI_t` e `e_Ibov_t` — surpresas purificadas.

---

## Etapa 4 — Diagnóstico

### 4.1 Scatterplot

Plotar `e_DI_t` (eixo x) vs. `e_Ibov_t` (eixo y) **apenas nos dias Copom**.

Quadrantes:
- **II e IV** (co-movimento negativo): consistente com choque monetário puro
- **I e III** (co-movimento positivo, "wrong-signed"): evidência de choque informacional do BCB

Reportar proporção de wrong-signed:
- \>25%: filtro JK fortemente motivado
- 15-25%: filtro JK defensável
- <10%: filtro JK provavelmente desnecessário, usar surpresa bruta

**Resultado observado (2013-01–2025-12):** ~31.6% wrong-signed nos resíduos purificados — filtro JK fortemente motivado. Isso explica em parte o ganho dramático ao aplicar JK também sobre o instrumento por heterocedasticidade (`z_het_jk` triplica o F sobre `yield_6m` vs `z_het` puro).

Salvar figura: `output/scatterplot_surpresas_copom.png`

### 4.2 Testes de variância

Testar (teste F, razão de variâncias, IC 99%):

| Variável | H0 | Esperado |
|---|---|---|
| `e_DI` | Var(Copom) = Var(não-Copom) | **Rejeitar** — variância maior em dias Copom |
| `e_Ibov` | Var(Copom) = Var(não-Copom) | Idealmente não rejeitar |

Formato de reporte: replicar Tabela 1 de Gonçalves, Rodrigues & Genta (2025).

---

## Etapa 5 — Construção dos Instrumentos

### 5.1 Instrumento bruto (sem filtro JK)

Para cada mês $t$:

```
z_bruto_t = Σ ΔDI_τ     para todo τ ∈ {dias Copom do mês t}
z_bruto_t = 0            se não houve Copom no mês t
```

Variante purificada: usar `e_DI_τ` em vez de `ΔDI_τ`.

### 5.2 Instrumento JK (com filtro por co-movimento)

Classificar cada dia Copom:

```
Se (e_DI > 0 e e_Ibov < 0) ou (e_DI < 0 e e_Ibov > 0):
    → classificar como "choque monetário"
    → manter e_DI_τ

Se (e_DI > 0 e e_Ibov > 0) ou (e_DI < 0 e e_Ibov < 0):
    → classificar como "choque informacional"
    → zerar: e_DI_τ = 0
```

Agregar mensalmente:

```
z_JK_t = Σ e_DI_τ     para todo τ ∈ {dias Copom monetários do mês t}
z_JK_t = 0            se não houve Copom monetário no mês t
```

### 5.3 Output final

Salvar `data/processed/instrumentos_mensais.csv` com colunas (incluindo as duas variantes por heterocedasticidade adicionadas posteriormente):

| month | z_bruto | z_bruto_purif | z_jk | z_jk_purif | z_het | z_het_jk |
|---|---|---|---|---|---|---|

As primeiras quatro são produzidas por `script/instrument.R`; `z_het` e `z_het_jk` por `script/instrument_het.R` (ver `_instrucoes/Heteroscedasticidade.md`). Qualquer variante pode ser plugada no proxy-SVAR existente via `DEFAULT_VARIANT` em `script/instrument.R`.

---

## Etapa 6 — Teste de Força do Instrumento

Para cada variante de $z_t$:

- Plugar no proxy-SVAR/DFM existente como instrumento externo
- Computar estatística F efetiva de Montiel Olea, Stock & Watson (2021)
- Implementação: `script/instrument_diagnostics.R` (regride contra `dfm$var_residuals[, 1]`) e `script/instrument_audit.R` (regride contra a inovação AR(6) de cada candidato a variável de política mensal — útil quando o alvo de normalização não é o primeiro fator).

**Critérios:**
- **F > 10:** inferência padrão válida
- **F ∈ [5, 10]:** usar intervalos Anderson-Rubin (robustos a instrumento fraco)
- **F < 5:** instrumento fraco

**Resultados observados na amostra 2013-01–2025-12 (auditoria de 2026-04-25, contra inovação AR(6) de yield_6m):**

| Variante       | F     | Veredito |
|----------------|------:|----------|
| z_bruto        |   ~5  | fraco/limite |
| z_bruto_purif  |   ~5  | fraco/limite |
| z_jk           |   ~3  | fraco |
| z_jk_purif     |   ~3  | fraco |
| z_het          |   ~8  | limite |
| **z_het_jk**   |  **21** | **forte** |

Tabela completa (4 variantes het × 7 candidatos a alvo) em `output/instrument_audit_grid.csv`.

---

## Etapa 7 — Comparação de IRFs

Estimar IRFs no DFM usando cada variante do instrumento. A comparação central é:

1. **$z^{bruto}_t$** vs. **$z^{JK}_t$**: o filtro JK muda as IRFs? Se sim, a decomposição importa — essa é a contribuição empírica principal.
2. **Sem purificação** vs. **com purificação por fatores externos**: a limpeza do componente global importa?

Variáveis de resposta: taxa de câmbio (BRL/USD), Ibovespa, spreads corporativos, CDS Brasil, curva de juros (DI longo), break-even inflation.

Horizonte: 0 a 24 meses. Bandas: 68% e 90%.

---

## Etapa 8 — Robustez

1. **Vértice do DI:** substituir DI 3m por DI 6m e DI 12m
2. **Excluir datas FOMC coincidentes** (dropar observações com `fomc_coincide = 1`)
3. **Subamostras temporais:** janelas móveis de 10 anos (2009-2019, ..., 2014-2024)
4. **Threshold de classificação:** excluir dias Copom com surpresas próximas de zero (dentro de ±1 d.p. de um dia não-Copom típico) para reduzir ruído na classificação JK

---

## Escreva um relatório em .md

---

## Referências para implementação

- **Instrumento base (surpresas de DI):** Gertler & Karadi (2015, AEJ:Macro) — lógica do proxy-SVAR com surpresas de futuros
- **Filtro JK:** Jarociński & Karadi (2020, AEJ:Macro) — classificação por co-movimento, restrições de sinal
- **Purificação:** Bauer & Swanson (2023, AER) — controle por fatores pré-anúncio
- **Identificação por heterocedasticidade (estratégia atual):** Rigobon (2003, *RES*); Rigobon & Sack (2003 *QJE*; 2004 *JME*); Stock & Watson (2018, *EJ*) §4.7
- **Recuperação do choque por GLS:** Mertens & Ravn (2013, *AER*) §II.B
- **Contexto brasileiro:** Gonçalves, Rodrigues & Genta (2025, IMF WP/25/48) — janela Wed→Thu, dados de DI, testes de Rigobon
- **Teste de instrumento fraco:** Montiel Olea, Stock & Watson (2021, *JoE*) — estatística F robusta
- **DFM + proxy-SVAR:** Alessi & Kerssenfischer (2019) — "The Response of Asset Prices to Monetary Policy Shocks: Stronger than Thought" — pipeline de estimação replicado neste projeto
- **Wild bootstrap sob heterocedasticidade MD:** Gonçalves & Kilian (2004)

---

## Informaçoes importantes:

- Todos os artigos de referencia podem ser encontrados em: `artigos/`
- o trabalho de JK ja tem o script original dos autores, mas em matlab em: `codigo_Jarocinski_e_Karadi`
- Os testes do artigo de Montiel Olea, Stock & Watson, ja foram implementados em: `script/instrument_diagnostics.R`
- Código original dos autores Bauer & Swanson em: `codigo_bauer_swanson/`

