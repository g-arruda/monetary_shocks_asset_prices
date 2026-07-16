# Gates de viabilidade — het-ID primária (arquitetura A, regimes mensais)

Gerado por `script/het_primary_feasibility.R` em 2026-07-16. Grid: (r,q) em {(5,4),(6,5),(7,6),(8,8)} x {full, pre_covid} x p em {6,3}; mp_var = `yield_6m`; n_boot = 1000, n_perm = 1000, seed = 123.

Regimes mensais: C = mes com reuniao do Copom, NC = sem. G1 exige salto de variancia na direcao de politica (placebo por permutacao de labels + CI 99% do ratio); G2 exige nao-proporcionalidade (LR Rigobon Prop. 1) — juntos sao a rank condition. G5 e a triagem weak-ID; G6 conta variaveis globais com salto de variancia proprio (K > 0) e reporta o rerun com eta purgado. Spanning e o R2 do componente comum de yield_6m (SW 2016 §7.5.1: named-factor quebra se fraco). iv_cos e o cross-check IV regime-signed (SW eq. 46).

## Grid completo

| sample | r | q | p | n_C/n_NC | lambda_1 [CI] | rank1 | ratio_dir [CI] | p_perm | prop p | crossp | A2 viol | A3 cos | K flag | p_perm purg | span R2 | iv_cos | G5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| full | 5 | 4 | 6 |  98/49 | 0.72 [0.30, 1.68] | 0.31 | 2.37 [1.47, 5.13] | 0.421 | 0.096 | 0/4 | 0 | 0.78 | 0 | 0.778 | 0.70 | 0.87 | weak |
| full | 5 | 4 | 3 | 100/50 | 0.68 [0.29, 1.58] | 0.28 | 2.23 [1.42, 5.27] | 0.631 | 0.112 | 0/4 | 0 | 0.59 | 0 | 0.672 | 0.70 | 0.91 | weak |
| full | 6 | 5 | 6 |  98/49 | 0.78 [0.52, 1.81] | 0.30 | 2.62 [1.91, 5.41] | 0.380 | 0.152 | 0/5 | 0 | 0.22 | 0 | 0.482 | 0.83 | 0.71 | weak |
| full | 6 | 5 | 3 | 100/50 | 0.62 [0.44, 1.72] | 0.26 | 2.06 [1.67, 4.97] | 0.861 | 0.433 | 0/5 | 0 | 0.16 | 0 | 0.836 | 0.83 | 0.69 | weak |
| full | 7 | 6 | 6 |  98/49 | 0.86 [0.59, 1.92] | 0.30 | 2.99 [2.13, 6.12] | 0.268 | 0.228 | 0/6 | 0 | 0.43 | 0 | 0.426 | 0.87 | 0.66 | weak |
| full | 7 | 6 | 3 | 100/50 | 0.77 [0.56, 2.08] | 0.25 | 2.55 [1.97, 6.22] | 0.651 | 0.385 | 0/6 | 0 | 0.14 | 0 | 0.603 | 0.87 | 0.35 | weak |
| full | 8 | 8 | 6 |  98/49 | 4.04 [2.07, 10.30] | 0.32 | 2.01 [1.67, 4.54] | 0.257 | 0.619 | 0/8 | 0 | 0.74 | 0 | 0.660 | 0.84 | 0.61 | weak |
| full | 8 | 8 | 3 | 100/50 | 4.76 [2.39, 12.24] | 0.29 | 1.92 [1.71, 4.29] | 0.471 | 0.435 | 0/8 | 0 | 0.55 | 0 | 0.697 | 0.84 | 0.41 | weak |
| pre_covid | 5 | 4 | 6 |  52/26 | 0.78 [0.59, 1.60] | 0.51 | 2.61 [2.00, 6.84] | 0.330 | 0.605 | 0/4 | 0 | - | 0 | 0.760 | 0.97 | 0.98 | weak |
| pre_covid | 5 | 4 | 3 |  54/27 | 0.77 [0.61, 1.82] | 0.40 | 2.55 [2.05, 7.00] | 0.370 | 0.762 | 0/4 | 0 | - | 0 | 0.165 | 0.97 | 0.91 | weak |
| pre_covid | 6 | 5 | 6 |  52/26 | 0.88 [0.74, 1.82] | 0.38 | 3.19 [2.42, 9.09] | 0.370 | 0.659 | 0/5 | 0 | - | 0 | 0.319 | 0.97 | 0.91 | weak |
| pre_covid | 6 | 5 | 3 |  54/27 | 0.89 [0.69, 2.14] | 0.48 | 3.13 [2.28, 8.39] | 0.374 | 0.864 | 0/5 | 0 | - | 0 | 0.498 | 0.97 | 0.94 | weak |
| pre_covid | 7 | 6 | 6 |  52/26 | 0.83 [0.78, 1.84] | 0.28 | 2.84 [2.44, 8.95] | 0.661 | 0.838 | 0/6 | 0 | - | 0 | 0.538 | 0.97 | 0.30 | weak |
| pre_covid | 7 | 6 | 3 |  54/27 | 0.97 [0.82, 2.16] | 0.42 | 3.79 [2.71, 9.74] | 0.266 | 0.697 | 0/6 | 0 | - | 0 | 0.146 | 0.97 | 0.86 | weak |
| pre_covid | 8 | 8 | 6 |  52/26 | 2.78 [1.81, 5.00] | 0.38 | 2.74 [2.33, 6.09] | 0.037 | 0.190 | 0/8 | 0 | - | 0 | 0.061 | 0.97 | 0.71 | marginal |
| pre_covid | 8 | 8 | 3 |  54/27 | 4.80 [3.11, 9.38] | 0.42 | 2.70 [2.31, 6.66] | 0.101 | 0.737 | 0/8 | 0 | - | 0 | 0.131 | 0.97 | 0.89 | weak |

## Elegibilidade e veredito

**NENHUMA celula elegivel.** Regra de parada do plano: a arquitetura A (regimes mensais) nao encontra salto de variancia identificavel nas inovacoes do factor-VAR em nenhuma celula do grid. NAO alterar a producao — decisao entre fallback B (sistema diario RS-2004 + ponte proxy explicita) e manter proxy volta ao autor.

## Leitura e diagnóstico (2026-07-16, apensado manualmente)

**Por que o grid reprova.** As razões de variância na direção estimada parecem
grandes (2.0–3.8, CIs bootstrap acima de 1), mas são artefato de estimação da
direção: o autovetor líder de ΔΣ é *escolhido* para maximizar a diferença de
covariância entre os grupos, então qualquer split 2:1 de meses produz razões
dessa ordem. O placebo de permutação — que preserva a distribuição de η e
destrói apenas o calendário — não distingue os labels verdadeiros dos
permutados em 15 de 16 células (p_perm 0.26–0.86; única exceção marginal
pre_covid (8,8) p=6 com p_perm = 0.037, cuja proporcionalidade ainda assim não
rejeita, p = 0.19). O LR de proporcionalidade (Rigobon 2003 Prop. 1, o gate
formal da rank condition) **nunca rejeita** H₀: Σ_C ∝ Σ_NC. Zero rejeições no
produto cruzado (eq. 7), zero violações A2, zero K-flags — não há sinal de
heterocedasticidade de calendário na frequência mensal, e portanto nada a ser
contaminado.

**Interpretação econômica.** A elevação de variância do choque de política é
um fenômeno de *dia de anúncio* (o bloco diário a detecta com folga — Tabela 1
do GRG, razões >> 1 no DI curto). Na agregação mensal ela dilui: um anúncio
contribui horas/dias de variância extra dentro de ~21 pregões, e os meses NC
(4/ano) são vizinhos imediatos de reuniões a ±3 semanas — antecipação e
digestão vazam para os meses sem reunião (Prop. 3 de Rigobon protege contra o
vazamento *moderado*, mas aqui ele apaga o próprio salto de variância que
identifica). O spanning do `yield_6m` é bom (R² 0.70–0.97): o problema não é o
espaço dos fatores, é a frequência.

**Consequência (regra de parada do plano, decisão do autor 2026-07-16):** a
arquitetura A (Rigobon mensal end-to-end) é empiricamente inviável neste
painel. A produção segue inalterada (proxy `z_jk_bs_purif`). A escolha entre o
fallback B — sistema diário RS-2004 como identificação declarada (`z_het` sem
filtro JK) + ponte proxy explícita para o DFM — e manter o desenho atual volta
ao autor. O código do ramo het (`R/identification/het_primary.R`,
`identification = "het"` em `compute_irf_dfm`/`main_sdfm`) fica implementado,
validado por simulação (harness 100%) e disponível para painéis/frequências em
que A1 valha.
