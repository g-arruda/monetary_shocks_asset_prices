# Migração da produção DFM para `p=4`

> **CURRENT — decisão e migração concluídas em 2026-08-24.** Painel de 111
> séries, 2013-01 a 2025-09, `(r,q,p)=(5,5,4)`, `z_jk_bs_purif`, choque de
> +50 pb em `yield_6m`, horizonte 0--48, wild bootstrap de 800 réplicas e
> semente 123. Esta nota substitui a ordem `p=6` como produção corrente; as
> grades históricas condicionais a `p=6` permanecem preservadas como vintage.

## Decisão

A ordem foi escolhida pelo AIC calculado para `p=1,...,12` sobre uma amostra
comum de 141 observações, com constante e tendência linear. Duas
implementações — `var_lag_criteria(..., deterministic="trend")` e
`vars::VARselect(type="both")` — reproduzem a tabela completa com desvio
máximo de `3,553e-15`. O AIC atinge o mínimo `8,073206897326` em `p=4`; o BIC
seleciona `p=2`. A produção segue o AIC e reporta a escolha distinta do BIC.

A tendência pertence somente ao exercício de seleção. O VAR efetivamente
estimado nos cinco fatores conserva intercepto apenas. A correção de Kilian
continua aplicada somente ao DGP do wild bootstrap; painel, `r`, `q`, proxy,
normalização, horizonte e esquema de bandas não mudaram.

## Gates e diagnósticos

| amostra | meses | inovações | `xi_mp` | `F_rob,mp` | raiz máxima | estável |
|---|---:|---:|---:|---:|---:|:---:|
| completa | 153 | 149 | 5,240158 | 10,060922 | 0,968126 | sim |
| pré-COVID | 84 | 80 | 7,478324 | 11,874945 | 0,992483 | sim |

O instrumento tem 60 valores mensais não nulos na amostra de estimação. O gate
canônico completou 800 de 800 réplicas, sem falhas, com bandas de 68% e 90%
finitas e ordenadas em todos os horizontes e normalização exata
`yield_6m(h=0)=0,005`. A raiz dominante da companion cheia é real; portanto,
a decomposição histórica do par complexo dominante em `p=6` não descreve a
produção corrente.

Os testes diários não confirmam que o filtro selecione mais notícia soberana
ou americana. As máscaras rederivadas, porém, enfraquecem a relevância: no
exercício soberano `xi_mp` cai a 3,438, e no exercício FOMC cai a 3,671. Pela
regra pré-fixada deste último, o veredito passa a **sinal fraco de contaminação
FOMC**. Os sinais de impacto são preservados, mas esses resultados impedem
tratar os nulos diários como absolvição das duas ameaças.

## Impactos e inferência corrente

| variável | impacto | banda 68% | banda 90% |
|---|---:|---:|---:|
| `yield_2y` | 72,8 pb | [63,6; 80,7] | [57,9; 87,0] |
| `yield_5y` | 74,8 pb | [60,8; 88,0] | [53,5; 99,1] |
| `cambio_usd` | 3,742% | [2,759; 4,566] | [2,308; 5,269] |
| `embi_perc` | 24,5 pb | [18,9; 32,6] | [14,5; 39,2] |
| `cds_5y` | 30,7 pb | [24,1; 38,7] | [19,2; 46,2] |
| `asset_ibov` | -0,968% | [-3,410; 0,308] | [-5,033; 1,563] |

Câmbio, EMBI+ e CDS excluem zero a 90% no impacto; o Ibovespa não. A cautela
de instrumento fraco permanece porque `xi_mp=5,24` fica abaixo de 10. O DFM
continua usando somente as bandas wild-bootstrap como inferência operacional;
os conjuntos Anderson--Rubin/MOSW pertencem exclusivamente ao benchmark VAR
observável.

## Proveniência e escopo

Produzem esta rodada `script/p_selection.R`, `script/model_alessi.R`,
`script/irf_coherence_check.R`, `script/validate_production_spec.R`,
`script/mosw_strength_grid.R`, `script/q_selection.R`,
`script/factor_stationarity.R`, `script/xi_mp_robustness.R`,
`script/instrument_construction_sweep.R`,
`script/price_cross_instrument.R`, `script/irf_spec_sweep.R` e
`script/fig_section5.R`. Os pontos da célula de produção coincidem entre o
gate, o cache de coerência e a varredura de `p`.

Não foram reestimadas as grades históricas de escolha de painel, de `(r,q)` ou
de instrumento construídas condicionalmente a `p=6`. A nota histórica
`2026-08-24_var_p2_vs_p6.md` também permanece intacta: ela trata do benchmark
VAR observável e não é determinada por `production_spec()$p`.
