# Tarefa 0 — Mapa do pipeline, do dado bruto ao gráfico

Rodada de auditoria de 2026-07-28 (`prompt_auditoria_dfm_iv.md`). Sem execução:
tudo abaixo é leitura de código, com âncora `arquivo:linha`.

---

## 1. A cadeia em cinco estágios

```
download.R ──► data/raw_data.csv
     │            (painel mensal bruto, unidades NATIVAS de cada fonte)
     ▼
clean.R ─────► data/processed/data_log_deseasonalized.csv
     │            (log em 4 blocos + X-13; NENHUMA diferenciação)
     ▼
estimate_static_factors()  (factor_estimation.R:285-364)
     │            destendencia o NÍVEL e divide por sd(Δ) — padronização BLL
     ▼
estimate_var_ols() → estimate_dynamic_factors()
     │            VAR(6) nos r=7 fatores; η = u·K·M⁻¹ (q=6 inovações)
     ▼
compute_irf_dfm() → ident_ext_instr() → cumimp_transform()
                  IRF em unidades nativas, normalizada a +50bp
```

## 2. Que transformação cada série sofre, e onde

**`script/clean.R:23-34`** é o único ponto do pipeline onde uma série muda de
forma funcional. Aplica `log` a quatro blocos:

| bloco | seletor | nº de séries |
|---|---|---|
| base monetária | `dplyr::contains("base_")` | 7 |
| crédito (volumes) | `dplyr::contains("credit")` | 7 |
| reservas bancárias | `fin_inst_reserve_req` | 1 |
| PIB | `pib` | 1 |

**Todo o resto entra em nível, na unidade da fonte.** Não há `diff()`, `lag()`
nem taxa de crescimento em lugar nenhum de `clean.R`. O `source()` de
`R/preprocessing/stationarity.R` está comentado na linha 4 e o arquivo nunca
existiu — não há estágio de estacionarização.

`clean.R:42-128` roda X-13 (`seasonal::seas`, `x11 = ""`,
`transform.function = "none"`) só nas séries que `check_seasonality()` marca,
com três níveis de fallback. É decomposição **aditiva** e, verificado nesta
rodada, escala-equivariante nas séries afetadas.

> **Nota de escopo.** `spread_icc_juridica` e `spread_icc_fisica` estão no vetor
> `vec_credito` de `download.R:95-96`, mas **não** são logadas: o seletor
> `contains("credit")` não casa com `spread_icc_*`. Estão em ponto percentual e
> em nível. O `infer_tcode_from_varnames` é consistente com isso (`^credit`).

## 3. Padronização e despadronização

**Padronização — `factor_estimation.R:299-316`** (Barigozzi-Lippi-Luciani):

```r
y  <- diff(data);  sy <- apply(y, 2, sd)          # :300-301
regX <- cbind(1, 1:T)                             # :309
X  <- data - regX %*% beta                        # :313   nível destendenciado
Z  <- sweep(X, 2, sy, "/")                        # :316   X / sd(Δ)
```

O objeto que vai ao PCA é o **nível destendenciado dividido pelo desvio-padrão
da primeira diferença** — não a série diferenciada. É aqui que o modelo assume
não-estacionariedade: os autovetores saem de `cov(yy)` (:323-330), a covariância
das **diferenças** padronizadas, mas os fatores são `F = Z·λ` (:347), em nível.
Essa assimetria é o desenho de BLL, e é a razão pela qual Bai-Ng simples seria a
régua errada (já registrado em `CLAUDE.md`).

**Despadronização — `impulse_responde.R:454`:**

```r
rawimp[, , i] <- sweep(temp, 1, sy, "*")
```

O mesmo `sy` que dividiu multiplica de volta. **Consequência que importa para
esta auditoria:** qualquer fator de escala constante aplicado a uma série é
absorvido na ida e restituído na volta. É por isso que o bug ×100 de
`cds_5y`/`msci`/`sp500_vix` (ver §6) não moveu nenhum fator nem nenhuma IRF —
verificado empiricamente, `max|eig|` = 0,9767937 antes e depois.

## 4. Unidade de cada série de juros — série a série

Verificado com `summary()` sobre `data/processed/data_log_deseasonalized.csv`,
não por suposição:

| série | fonte | unidade no painel | faixa observada | tcode |
|---|---|---|---|---|
| `yield_3m` | `yields_dia.csv` (orientador) | **proporção decimal** | 0,019 – 0,149 | 1 |
| `yield_6m` | idem | **proporção decimal** | 0,020 – 0,151 | 1 |
| `yield_1y` | idem | **proporção decimal** | 0,023 – 0,158 | 1 |
| `yield_2y` | idem | **proporção decimal** | 0,034 – 0,165 | 1 |
| `yield_5y` | idem | **proporção decimal** | 0,056 – 0,166 | 1 |
| `yield_10y` | idem | **proporção decimal** | 0,068 – 0,165 | 1 |
| `juros_selic` | BCB SGS 4189 | **ponto percentual** | 1,90 – 14,90 | 1 |
| `juros_cdi` | BCB SGS 4392 | **ponto percentual** | 1,90 – 14,90 | 1 |

**O bloco não é homogêneo: fator 100 entre a curva DI e o par Selic/CDI.** A
origem é dupla e está em `download.R`: a curva vem pronta de
`data/yields/yields_dia.csv` (:34-46, arquivo externo em decimal) e o par
Selic/CDI vem da API do BCB (:23-30), que publica em % a.a. Nada no pipeline
harmoniza os dois.

Séries vizinhas com a mesma armadilha:

| série | unidade | observação |
|---|---|---|
| `embi_perc` | ponto percentual (2,73 = 273bp) | ×100 vs `cds_5y` |
| `cds_5y` | ponto-base (208 = 208bp) | corrigido em 2026-07-28, ver §6 |
| `price_*` | **taxa mensal em %** (0,47 = 0,47% no mês) | ver §7 |

## 5. Onde entra o +50bp, e sobre que objeto

Dois pontos, e só dois:

1. **`script/model_alessi.R:92`** — `normalize_value <- shock_size_bps / 10000`.
   Com `shock_size_bps = 50` e `mp_var = "yield_6m"` (decimal), dá `0,005`.
   O helper equivalente da varredura é `norm_value_for()`
   (`spec_sweep.R:19-21`), que trata `juros_selic` à parte com `/100` porque
   aquela série está em p.p. — a única concessão explícita ao descompasso do §4.
2. **`impulse_responde.R:124`** — `irf_mp <- irf_mp / irf_mp[mpind, 1] * normalize_value`.

O escalonamento é aplicado à **matriz IRF inteira** (todas as variáveis, todos
os horizontes), dividindo pela resposta de impacto da variável de política. É
uma renormalização global, portanto:

- não introduz descompasso de unidade — cada linha continua na sua unidade
  nativa, apenas reescalada pelo mesmo escalar;
- acontece **antes** do `cumimp_transform` (:127), então tcode 2 e 4 operam
  sobre a IRF já normalizada.

## 6. Há `cumsum` de IRFs?

Sim, e **apenas via tcode**, em `cumimp_transform` (`impulse_responde.R:257-291`):

| tcode | tratamento | quem recebe |
|---|---|---|
| 1 | nada (nível) | **default** — juros, câmbio, preços, risco, commodities, EPU, atividade, indústria, trabalho |
| 2 | `cumsum` × 100 (:277) | `^asset_` — 8 índices B3 |
| 4 | `(exp(x) − 1)` × 100 (:287) | `^base_`, `^credit`, `^credito_`, `fin_inst_reserve_req`, `pib` |
| 3, 5 | dupla acumulação / cumsum em log | **não atribuídos a nenhuma série** |

A atribuição está em `infer_tcode_from_varnames` (:304-320) e é coerente com
`clean.R`:

- **tcode 2 é aplicado exatamente às séries efetivamente diferenciadas.** Os
  `asset_*` são construídos como retorno mensal composto em
  `download.R:406-418` (`prod(1 + return) - 1`), então acumular recupera o nível
  de preço. Correto.
- **tcode 4 é aplicado exatamente às séries logadas em `clean.R`.** Correto, e
  a conversão `(exp−1)×100` dá variação percentual, não dupla acumulação.
- **Nenhuma série é diferenciada e depois acumulada duas vezes.** Os códigos 3 e
  5, que fariam isso, não são atribuídos.

## 7. Onde uma série de juros e uma série real podem receber o mesmo tratamento indevidamente

Três pontos, em ordem de risco.

### 7.1 `price_*` são taxas mensais entrando em nível com tcode 1 — e não são acumuladas

`download.R:261-281` puxa IPCA, núcleos, IGP-M, INPC etc. das séries do SGS que
publicam **variação percentual mensal** (IPCA = série 433). Confirmado nos
dados: `price_ipca` tem média 0,469 e faixa [−0,68, 1,62] — é a taxa mensal em %,
não um índice.

Essas séries recebem tcode 1 e **nenhuma acumulação**. Portanto:

> A IRF de `price_core_ipca_ex0` é a resposta da **taxa mensal de inflação em
> p.p.**, não de um nível de preço. O pico de +0,131 em h=5 significa
> +0,131 p.p. na inflação **daquele mês** — cerca de **+1,6 p.p. anualizados**.

Isso não é um bug: é a única leitura consistente com o dado de entrada. Mas é a
armadilha que o prompt pede para apontar, porque a mesma matriz IRF contém, lado
a lado e sem marcação, respostas de nível (juros, câmbio) e respostas de taxa de
variação (preços). Qualquer texto que fale de "resposta do IPCA" sem dizer
"da taxa mensal" está ambíguo. **Acumular essas séries mudaria o objeto** — não
deve ser feito sem reescrever a interpretação declarada no §5 do paper.

### 7.2 O descompasso decimal × p.p. do §4 é invisível na saída

Como a normalização (§5) é um escalar global e a despadronização (§3) é por
série, nada no pipeline sinaliza que `yield_6m = 0,005` e `juros_selic = 0,13`
estão em escalas diferentes. Quem lê a tabela de IRFs sem consultar
`download.R` conclui que a Selic responde 26× mais que o DI de 6 meses, quando
em pontos-base ela responde **menos** (13bp contra 50bp). O único guard-rail
existente é o `norm_value_for()` da varredura, e ele só protege o caso em que
`juros_selic` é a **variável de política**, não o caso em que ela é resposta.

### 7.3 O grupo `spread_icc_*` está em p.p. dentro de um bloco logado

`spread_icc_juridica` e `spread_icc_fisica` convivem no bloco "crédito" com
sete volumes logados (tcode 4, saída em %). Elas são tcode 1, em p.p. O
tratamento está **correto** em ambos os lados, mas a saída do grupo mistura
"variação percentual do volume" com "variação em p.p. do spread" sob o mesmo
cabeçalho em `irf_coherence_report.md`.

---

## 8. Correção aplicada nesta rodada

`script/download.R:222-243` lia os três CSVs da investing.com
(`cds5y.csv`, `msci.csv`, `sp500_vix.csv`) sob o locale default do `readr`.
Esses arquivos são pt-BR (`"138,19"`) e o locale default trata `,` como
separador de **milhar**, então cada valor entrava **100× inflado** (13819).

- Confirmado: `cds_5y` ia ao painel na faixa [9911, 48899] para um spread que
  vive em [99, 489] bp; `sp500_vix` em [951, 5354] para o VIX.
- Nenhum dos três arquivos tem valor com separador de milhar de verdade, então
  o erro era **uniforme** (fator 100 exato, sem casos de borda).
- Corrigido com `locale = readr::locale(decimal_mark = ",", grouping_mark = ".")`.
- **Preflight de vintage:** `download.R` re-rodado em cópia de rascunho e
  diferenciado coluna a coluna contra o painel congelado — **95 de 98 colunas
  comparáveis bit-idênticas**, e exatamente as três alvo com razão mediana 0,01.
  Não houve revisão de vintage, então a correção foi aplicada preservando o
  painel de 2026-07-24.
- **Invariância verificada:** `max|eig|` da companion = 0,9767937 antes e
  depois; smoke test do `CLAUDE.md` reproduzido nos cinco valores; contagem de
  vereditos da coerência inalterada (21/5/11/1/6/4/3/1).

Efeito prático: nenhum resultado muda; passam a ser legíveis os números das três
séries. `cds_5y` no impacto era reportado como "+2907" e é **+29,07 bp** — que
agora bate com o EMBI (+0,1995 p.p. = **+19,95 bp**), como tem de bater.
