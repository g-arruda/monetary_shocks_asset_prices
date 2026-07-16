# Viabilidade — het de EPISÓDIO (arquitetura A-episódio, BPSS 2021)

Gerado por `script/het_episode_feasibility.R` em 2026-07-16. Sistema completo Σ_s = B Λ_s B′ nas inovações do factor-VAR mensal; S2 = pré-2020 vs 2020+; S4 = 2013-16 / 2017-19 / 2020-21 / 2022-25; p = 6; n_boot = 1000; seed = 123. Instrumentos abandonados por decisão do autor — a correlação com surpresas Copom reportada abaixo é evidência DESCRITIVA de rotulagem, não identificação.

## S2: rank condition, distinctness e placebo

| r | q | n_pre/n_post | LR prop | p_boot | p_rot (placebo circular) | min gap rel [CI] | λ range | shock candidato | λ_cand | impacto y6m | cor(ε_cand, surpresa Copom) | S4 pares rejeitando | offdiag máx |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5 | 4 | 78/69 | 16.8 | 0.438 | 0.883 | 0.18 [0.05, 0.46] | [1.09, 3.68] | 3 | 1.32 | 0.0016 | 0.23 | 0/6 | 0.20 |
| 6 | 5 | 78/69 | 30.4 | 0.239 | 0.766 | 0.19 [0.05, 0.39] | [0.50, 2.92] | 4 | 1.13 | 0.0017 | 0.34 | 0/6 | 0.24 |
| 7 | 6 | 78/69 | 46.5 | 0.065 | 0.197 | 0.04 [0.04, 0.32] | [0.39, 3.72] | 5 | 1.05 | 0.0017 | 0.24 | 0/6 | 0.25 |
| 8 | 8 | 78/69 | 64.5 | 0.143 | 0.248 | 0.07 [0.03, 0.25] | [0.30, 3.41] | 7 | 0.85 | 0.0012 | 0.20 | 0/6 | 0.31 |

Colunas: `LR prop`/`p_boot` = teste de proporcionalidade Rigobon Prop. 1 entre os dois episódios (rejeitar = rank condition satisfeita); `p_rot` = placebo por rotação circular das fronteiras (preserva tamanhos e persistência); `min gap rel` = menor gap relativo entre autovalores generalizados adjacentes (distinctness ⇒ identificação ponto a ponto do B, a menos de sinal/permutação); `λ range` = variâncias relativas 2020+/pré-2020 por choque; `impacto y6m` = impacto do choque candidato (1 s.d. pré-2020) sobre yield_6m; `offdiag máx` = massa fora da diagonal de B⁻¹Σ_sB⁻¹′ nos episódios finos (constância de B).

## Rotulagem (impactos por coluna estrutural, 1 s.d. pré-2020)

Ver `episode_labeling.csv` (todas as células) e `episode_lambda_profiles.csv` (caminho de variância por episódio). Candidato = coluna com maior |impacto| em yield_6m.


## Leitura e diagnóstico (2026-07-16, apensado manualmente)

**O A-episódio também reprova, e por uma razão mais informativa que o
calendário.** Três fatos, consistentes nas quatro células:

1. **A proporcionalidade nunca é rejeitada** (S2 p_boot 0.065–0.44; S4: 0/6
   pares em todas as células) e o placebo circular confirma que a partição
   pré/pós-2020 não é especial (p_rot 0.20–0.88). A volatilidade mensal das
   inovações dos fatores brasileiros se move como **fator de escala comum** —
   o COVID (e 2015-16) infla tudo aproximadamente na mesma proporção. É
   exatamente o caso degenerado de Rigobon (2003): Σ_2 = a·Σ_1 não identifica
   nada.
2. **Os autovalores generalizados são estatisticamente indistinguíveis**
   (min gap relativo 0.04–0.19, CI inferior 0.03–0.05) — mesmo que a rank
   condition passasse, o B não seria ponto-identificado (mistura de colunas).
3. **A coluna candidata a "monetária" tem λ ≈ 1** (0.85–1.32): a direção que
   carrega em yield_6m é justamente a que NÃO mudou de variância relativa
   entre episódios. O que muda (λ_max ≈ 3–3.7) são direções sem cara de
   política monetária. A correlação descritiva do choque candidato com as
   surpresas de Copom é fraca (0.20–0.34). O var(innov)↑3.6× do T4 era o
   componente de escala comum — não uma rotação identificadora.

**Contraste com BPSS (2021):** lá a identificação funciona porque as
variâncias RELATIVAS dos choques americanos mudam entre episódios (Volcker
vs Grande Moderação vs 2008). No painel mensal brasileiro 2013-2025, não
mudam — os episódios re-escalam o sistema inteiro.

**Veredito consolidado da frequência mensal:** heterocedasticidade NÃO
identifica choque monetário neste painel em nenhuma variante testada —
calendário rank-1 (16 células, `feasibility_report.md`) e episódio
sistema-completo S2/S4 (este relatório). Com instrumentos abandonados por
decisão do autor (2026-07-16), o menu de identificação mensal restante:
sign restrictions (set-ID, com inferência frequentista — Gafarov-Meier-
Montiel Olea — ou bayesiana à la Uhlig), ordenação recursiva,
não-gaussianidade/ICA (Lanne-Meitz-Saikkonen 2017), e het condicional
GARCH (Sentana-Fiorentini 2001 — não testada; T=147 mensal é curto).
