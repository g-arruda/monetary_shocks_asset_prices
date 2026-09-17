# A escala de volatilidade COVID entra em produção

> **CURRENT — 2026-09-17.** Decisão do autor: o tratamento de Lenza & Primiceri (2022, *JAE*
> 37(4), Apêndice B) deixa de ser exercício desligado e passa a ser o estimador de produção
> do VAR dos fatores, descrito na §3.1 do paper.
> - Painel de produção de 115 séries, 2012-03 a 2025-12, `(r, q, p) = (5, 5, 4)`, 162 inovações.
> - Supersede o "sem veredito" de `2026-09-14_inferencia_volatilidade_covid_q`. **Não** supersede
>   `2026-09-16_fidelidade_lenza_primiceri`, cuja auditoria equação por equação segue valendo
>   integralmente — nada nela mudou, porque nenhuma equação mudou.
> - Escrita na branch `feature/lp-volatilidade-producao`.

## 1. O veredito

| | sem tratamento | **com tratamento** |
|---|---|---|
| ξ_mp, cheia | 6,0570142714031245 | **6,847996589177567** |
| ξ_mp, pré-COVID | 8,643436347247281 | 8,643436347247281 (inalterado) |
| F_rob,mp, cheia | 9,625427632173636 | **11,765249688123488** |
| F_rob,mp, pré-COVID | 13,809985106266108 | 13,809985106266108 (inalterado) |
| raiz máxima, cheia | 0,9700904794964803 | **0,9836766921623673** |
| raiz máxima, pré-COVID | 0,9933587954932864 | 0,9933587954932864 (inalterado) |

O tratamento **eleva** a força do instrumento e mantém todos os conjuntos limitados. Em
`output/irf/irf_coherence_h.csv`, 2841 das 2842 linhas saem `interval` a 68% e a 90%; a única
exceção é o `singleton` que a normalização fixa em h=0. Nenhum `real_line`, nenhum `empty`.

ξ_mp = 6,85 **segue abaixo de 10**: a regra de dois níveis continua valendo integralmente e
68% nunca é "significativo".

θ̂ não se moveu: `covid_volatility_theta.csv` reproduz bit a bit os literais congelados em
`production_spec()`, e a guarda nova de `validate_production_spec.R` re-deriva θ̂ a partir de
`data/processed/` e para se ele mudar.

## 2. A pré-COVID fica OLS, e isso não é concessão

A janela pré-COVID é 2012-03 a 2019-12 e `t*` é 2020-03. **Todo mês dela tem `s_t = 1` por
construção**: a WLS de produção restrita a essa janela *é* a OLS, com pesos literalmente 1 —
não uma aproximação. As três linhas da tabela acima que saem "inalterado" são a medição disso,
e os checks N1/N2 de `validate_covid_volatility.R` já provavam o caso geral (`identical()` em
resíduos, companion e covariância sob θ neutro; 1e-12 pelo `main_sdfm()` inteiro).

Consequência: **os contrastes cheia × pré-COVID seguem contrastes de janela, não de
estimador**, e nada no paper precisa de ressalva nova por causa disso. A guarda
`covid_start ∈ residual_dates` não foi relaxada, porque passar a lista naquela janela não
mudaria número algum.

## 3. O que o roteamento teve de resolver

`spec$covid_volatility` era lido em **um único lugar**, `main_sdfm()`. `estimate_dfm()` e
`run_stage2_cell()` tinham `NULL` hard-coded. Virar só o campo do spec produziria a §4 em WLS
e a **§5 em OLS**, porque `irf_coherence_check.R` entra por `run_stage2_cell()` — incoerência
silenciosa entre duas seções do mesmo paper.

`run_stage2_cell(covid_volatility=)` passou a ser **argumento obrigatório**, com `stop()` em
`missing()`. Os 24 sítios de chamada declaram sua escolha um a um, pela regra de que escolha
não feita vira argumento obrigatório. Recebem o tratamento na janela cheia:
`irf_coherence_check.R`, `q_selection.R`, `p_selection.R`, `price_cross_instrument.R`,
`asset_representation.R` (os quatro últimos porque se autotestam contra
`irf_coherence_h.csv`), mais `mosw_strength_grid.R`, `xi_mp_robustness.R` e
`instrument_diagnostics.R`. Ficam OLS, com o motivo escrito no sítio: as células pré-COVID,
as rodadas fechadas, e os dois casos abaixo.

- **`irf_spec_stage2.R`** fica OLS inteiro: é diagnóstico de bootstrap, e o DGP do bootstrap
  não existe sob a escala.
- **`ar_bands.R`** fica OLS inteiro: a rodada existe para pôr AR, delta e bootstrap lado a lado
  sobre **um** ponto estimado, e tratá-la perderia exatamente a perna que ela documenta. Seus
  alvos `XI_MP_TARGET` são, deliberadamente, os do modelo não tratado, e **não devem ser
  sincronizados** com `mosw_strength_grid.csv`.

Kilian se desligou sozinho (`apply_kilian = is.null(covid_volatility)`). `--bootstrap` de
`validate_production_spec.R` agora para com mensagem, em vez de portar um modelo não tratado.

## 4. `r ≥ 7` é explosivo sob a escala

Varredura de estabilidade sobre `r = 4:8 × q = 2:8`, `q ≤ r`, `p = 4`:

| janela | células instáveis | raiz |
|---|---|---|
| cheia, tratada | `r = 7`, todo `q` | 1,001362 |
| cheia, tratada | `r = 8`, todo `q` | 1,001318 |
| cheia, tratada | `r = 4, 5, 6` | estáveis |
| pré-COVID | nenhuma | estáveis, máx. 0,993736 |

Produção é `r = 5`, longe dessa borda. `mosw_strength_grid.R` passou a varrer `r = 4:6` na
cheia e manter `r = 4:8` na pré-COVID — 111 células. O `stop()` de instabilidade **não** foi
afrouxado: continua fail-loud para qualquer célula inesperada.

## 5. O que mudou no ponto publicado

Impactos em h=0, precisão cheia (`output/validation/production_spec_impact_smoke.csv`):

| série | sem tratamento | com tratamento |
|---|---|---|
| `yield_6m` | 0,0050000000000000001 | 0,0050000000000000001 |
| `yield_2y` | 0,0070263642339699903 | 0,0070090326083686542 |
| `yield_5y` | 0,0072457194488358932 | 0,0072900543327283655 |
| `asset_ibov` | −0,99650483088005848 | **−1,5020158375666013** |
| `cambio_usd` | 0,13424190947918324 | 0,12942167379213612 |

A estrutura a termo praticamente não se move; o impacto do Ibovespa cresce cerca de 50% em
módulo. Câmbio cai 3,6%.

## 6. Não verificado

1. **A leitura substantiva das IRFs tratadas não foi feita** nesta rodada. O que está aqui é o
   veredito de *viabilidade* — força, topologia dos conjuntos, estabilidade —, não a leitura
   econômica. A §4 do paper ficou deliberadamente fora (decisão do autor).
2. **Ótimo global de θ̂ segue não confirmado**: o perfil varre só ρ, sem multi-start em
   `(s̄0, s̄1, s̄2)`. Era lacuna sobre um exercício; **agora é lacuna sobre o número publicado**.
   Registrado em `2026-09-16_fidelidade_lenza_primiceri` §5.3.
3. **Cobertura dos conjuntos AR sob θ̂ plug-in** continua sem derivação e sem simulação. A §3.6
   do paper agora declara a propriedade; declarar não é resolver.
4. **As rodadas fechadas que não recebem o tratamento** (`fomc_coincidence`, `jk_sovereign_confound`,
   `fiscal_*`, `q_narrative_overlay*`, `asset_representation` fora da célula de produção) não
   foram reexecutadas. Seus números seguem os das notas que as documentam.
