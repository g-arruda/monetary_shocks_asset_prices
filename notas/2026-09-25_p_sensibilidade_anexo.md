# Sensibilidade a `p` no Anexo C e o θ̂ reestimado com gradiente mais fino

> **CURRENT — 2026-09-25.** Rodada de apêndice que **reestimou θ̂ de produção**.
> - Produção de 115 séries, 2012-03 a 2025-12, `(r,q,p) = (5,5,4)`, escala de
>   volatilidade COVID de Lenza-Primiceri e conjuntos Anderson--Rubin de 68% e 90%
>   com NW(0).
> - θ̂ de produção passou de (6,611429; 12,468338; 1,760352; 0,943926) para
>   **(6,611488; 12,468194; 1,760038; 0,943951)**, decisão do autor. A cadeia que o
>   lê foi rerodada. Nenhum número impresso no paper mudou (§3).
> - O Anexo C ganhou `fig:p_sensibilidade`, sem frase nova no corpo (decisão do autor:
>   "apenas coloque os anexos").

## 1. Por que θ̂ mudou

A figura pede θ estimado em cada `p` de 2 a 6 (decisão do autor), e
`script/covid_volatility_theta.R` passou a rodar uma passada por `p`, com todas as
travas em cada uma. Em `p = 5` a trava da condição de primeira ordem barrou o θ̂ do
início único: o otimizador convergiu (`convergence` 0), mas `|m − 1|` em t* e t*+1
ficou em 1,16e-3 e 0,91e-3, contra a tolerância de 1e-4.

O diagnóstico, feito fora do projeto, mostrou que não havia um segundo máximo. O
`optim` do L-BFGS-B calcula o gradiente por diferenças finitas com passo `ndeps` =
1e-3, e com esse passo o gradiente numérico se anula antes do verdadeiro. O gradiente
central com passo 1e-6 no ponto de parada era (−8e-4, −3e-4, 1e-3, 5e-3). Com `ndeps`
= 1e-6 ou com Nelder-Mead, os dois chegam ao mesmo ponto, 3e-6 log-pontos acima, e a
condição fecha em 1e-6.

O mesmo passo curto existe em todo `p`, produção inclusive, só que abaixo da
tolerância. Em `p = 4` o ganho é de 5e-7 log-pontos e o gradiente em ρ era 0,04. É o
"+3,8e-7, precisão do otimizador" que `2026-09-24_otimo_global_theta` já registrava.

Havia três saídas: corrigir só fora da produção, corrigir em todo `p`, ou tirar
`p = 5` da figura. **O autor escolheu corrigir em todo `p`.** `estimate_covid_theta()`
passa `ndeps = rep(1e-6, 4)`. O perfil em ρ e o multi-start do script usam o mesmo
passo (`NDEPS`), e o perfil do S5 de `validate_covid_volatility.R` também.

## 2. θ̂ por `p`

Todas as travas passam em todo `p`:
- a condição de primeira ordem;
- o perfil em ρ;
- nenhum dos 750 inícios acima de θ̂ (maior folga 8,5e-10);
- nenhum empate a mais de 5% de θ̂.

| `p` | s̄0 | s̄1 | s̄2 | ρ | ℓ | LR contra s = 1 | inícios em θ̂ |
|---|---|---|---|---|---|---|---|
| 2 | 6,5035 | 12,5263 | 2,5200 | 0,9143 | −1652,535 | 262,4 | 716 |
| 3 | 6,7503 | 12,6644 | 2,1984 | 0,9211 | −1613,549 | 248,4 | 387 |
| **4** | **6,6115** | **12,4682** | **1,7600** | **0,9440** | **−1579,591** | **223,9** | **138** |
| 5 | 6,8486 | 13,5096 | 2,3894 | 0,9230 | −1550,053 | 235,2 | 175 |
| 6 | 7,1067 | 13,3227 | 1,9950 | 0,9373 | −1525,087 | 232,5 | 102 |

Arquivos: `output/factors/covid_volatility_theta.csv` e
`covid_volatility_multistart.csv` para `p = 4`, e
`output/factors/theta_by_p/covid_volatility_{theta,multistart}_p<p>.csv` para os demais.

## 3. O que a reestimação moveu na produção

- **ξ_mp** 6,847997 → **6,848035**; F_rob,mp 11,765250 → **11,765564**; raiz máxima
  0,983677 → **0,983676**. A pré-COVID não usa θ̂ e não mudou.
- **Impactos do smoke test**:
  - `yield_2y` 0,0070090326 → 0,0070090430;
  - `yield_5y` 0,0072900543 → 0,0072900596;
  - `asset_ibov` −1,5020158 → −1,5019377;
  - `cambio_usd` 0,12942167 → 0,12942378.

  Pinados em `validate_production_spec.R`, e o valor anterior ficou no comentário.
- **Respostas**: em `irf_coherence_h.csv`, até h36, a maior mudança de ponto é 3,8e-5
  da escala da série, e a de limite de conjunto, 8e-5. Nenhuma troca de `sig68`, `sig90`,
  sinal ou `set_type`.
- **Paper**: nenhum número muda na precisão impressa. Foram conferidos:
  - `tab:first_stage`;
  - a linha fatorial do Anexo B: `Q_r` 5,15, p 0,076; sem correção 6,72, p 0,035;
    os testes conjuntos 0,021 e 0,013; λ 4,03 e 1,68;
  - `het_rigobon`: +9,60 p.b. e +1,52%;
  - os 156 números decimais do resumo, da introdução, da §4 e da §5, contra toda
    resposta e todo limite em cinco escalas. As únicas coincidências de arredondamento
    são de outras séries ou horizontes, que o texto não cita.
- **Rerodados**:
  - `irf_coherence_check.R`, `fig_section5.R` (oito figuras da §4 e placebos);
  - `mosw_strength_grid.R`, `instrument_diagnostics.R`, `model_alessi.R`;
  - `het_conditions.R`, `het_rigobon/02_irf.R`, cuja raiz de produção fixada em
    `_common.R` foi atualizada;
  - `q_sensitivity.R --window=cheia`, `instrument_layers_irf.R`, `p_sensitivity.R`.

  As sete travas de `script/validation/` passam.

## 4. A figura

`script/p_sensitivity.R`: cinco `run_stage2_cell()` com `(5,5,p)`, janela cheia,
`z_jk_bs_purif`, cada `p` com o seu θ̂. `p = 4` tem conjuntos AR e confere com
`irf_coherence_h.csv` a 1e-10. Os demais `p` são pontuais. Todos os companions são
estáveis: raiz máxima de 0,981, 0,976, 0,984, 0,985 e 0,990 para `p` de 2 a 6.

**Contenção.** Nas oito séries da figura, até h36, nenhum ponto de `p ≠ 4` sai do
conjunto de 90% de `p = 4`. Do conjunto de 68% saem só pontos do Ibovespa: um em
`p = 2` e três em `p = 6`.

Impactos, nas unidades da §4:

| série | p=4 | p=2 | p=3 | p=5 | p=6 |
|---|---|---|---|---|---|
| DI 2 anos (p.b.) | 70,1 | 68,5 | 69,9 | 70,9 | 71,6 |
| DI 5 anos (p.b.) | 72,9 | 70,2 | 72,8 | 74,8 | 75,9 |
| Câmbio (%) | 3,23 | 3,40 | 3,49 | 3,50 | 3,55 |
| CDS (p.b.) | 30,5 | 29,3 | 31,0 | 32,2 | 33,0 |
| IBC-Br (%) | −0,66 | −0,67 | −0,69 | −0,74 | −0,79 |
| IPCA (p.p.) | −0,045 | −0,094 | −0,091 | −0,075 | −0,065 |
| Ibovespa (%) | −1,50 | −0,56 | −1,22 | −1,62 | −1,68 |
| DLSP (p.p. PIB) | −0,67 | −0,66 | −0,68 | −0,70 | −0,71 |

A forma é a mesma em todas as ordens. Os impactos de câmbio, CDS e juros longos
crescem com `p`, e o Ibovespa é a série mais sensível: em `p = 2` o impacto é um terço
do de produção. O texto não cita nenhum desses números.
