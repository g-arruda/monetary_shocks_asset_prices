# IRFs narrativas: q = 2 a 5 com r = 5, p = 4, amostra cheia com a volatilidade COVID

As vinte variáveis cobrem a curva, câmbio e risco soberano, expectativas,
atividade, preços, ações e todas as séries fiscais e de expectativa que
estruturam a narrativa empírica do artigo. Janela 2012-03 a 2025-12, p = 4,
com a escala de volatilidade COVID de Lenza-Primiceri (2022) no VAR dos fatores:
θ̂ = (s̄0 = 6,611; s̄1 = 12,468; s̄2 = 1,760; ρ = 0,9439) de `production_spec()`, `innovations = "standardized"`,
sem centragem. A linha q=5 traz conjuntos de Anderson-Rubin de 68% e 90% na
regressão transformada; q=2, q=3 e q=4 são sobreposições pontuais. Horizonte h = 0..48.

A outra janela do passo 4/4 é `q_narrative_r5p2_precovid.*` (pré-COVID, p = 2);
a cheia sem tratamento é `q_narrative_r5p4.*`.

Artefatos: `q_narrative_r5p4_covid_paths.csv`, `q_narrative_r5p4_covid_summary.csv`
e `q_narrative_r5p4_covid.pdf`.
