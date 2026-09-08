# Resultados das IRFs na rodada canônica

> **VINTAGE DE BOOTSTRAP — escrito em 2026-09-01, defasado desde 2026-09-08.**
> Produzido a partir de `output/irf/irf_coherence_cell.rds` por
> `script/irf_coherence_check.R`; os números de impacto abaixo foram lidos desse
> cache quando ele carregava bandas do *wild bootstrap* de 800 réplicas.
>
> **Duas defasagens contra a produção corrente, não uma.** (i) a janela: o corpo
> descreve 2013-01--2025-09 em `(4,4,4)`; (ii) a inferência: desde 2026-09-08 a
> produção publica **conjuntos Anderson-Rubin**, e o cache foi regenerado com
> eles. Os pontos são estáveis à troca — ela não toca `irf_point_matrix` — mas
> **toda banda e toda afirmação de significância abaixo pertencem à régua
> anterior**. Fonte corrente: `output/irf/irf_coherence_h.csv`, cujas colunas
> `set_type68`/`set_type90` dizem que tipo de conjunto é cada banda. Nota da
> troca: `notas/2026-09-08_bandas_anderson_rubin_producao.md`. A sincronização é
> item aberto no Tema A de `registro/pendencias.md`.

## Especificação

O painel canônico tem 115 séries mensais, 2013-01--2025-09 (153 observações),
e inclui o ajuste cambial da DLSP e as três expectativas fiscais Focus. A
produção usa `(r,q,p)=(4,4,4)`, `z_jk_bs_purif`, normalização de +50 pontos-base
em `yield_6m`, e bandas de 68% e 90%. O IC2 Bai--Ng BLL seleciona `r=4`; o AIC
seleciona `p=4` (6,826217) na amostra comum de 141 observações, com tendência
apenas no critério. O BIC seleciona `p=2`. Amengual--Watson BLL, condicionado a
`r=4,p=4`, seleciona `q=2` (IC2 = -0,420423), resultado reportado mas que não
altera a decisão explícita de `q=4`.

Na amostra completa, `xi_mp=6,383502`, `F_rob,mp=14,162509` e a maior raiz é
0,972109. Na pré-COVID, os valores são 7,188089, 12,707070 e 0,984677. As duas
companions são estáveis. O gate bootstrap concluiu 800 réplicas sem falhas,
com bandas finitas e ordenadas e `yield_6m(h=0)=0,005` exatamente.

## Impactos

| variável | ponto h=0 | banda 68% | banda 90% |
|---|---:|---:|---:|
| DI 6 meses (p.b.) | 50,0 | [50,0; 50,0] | [50,0; 50,0] |
| DI 2 anos (p.b.) | 70,8 | [62,5; 78,9] | [57,9; 85,5] |
| DI 5 anos (p.b.) | 70,6 | [59,1; 83,2] | [52,3; 92,7] |
| Ibovespa | -1,168 | [-3,275; -0,198] | [-4,346; 0,736] |
| BRL/USD (% da média) | 13,55 | [9,55; 16,39] | [7,91; 19,47] |
| EMBI+ (p.b.) | 21,49 | [16,85; 28,48] | [13,23; 34,07] |
| CDS 5 anos (p.b.) | 27,61 | [21,90; 35,04] | [18,27; 40,67] |

## Fiscal e expectativas

No impacto, a DLSP cai 0,614 ponto percentual do PIB e a DBGG cai 0,165; as
bandas de 90% são, respectivamente, [-0,876; -0,417] e [-0,361; 0,113]. A
NFSP primária cai R$ 3,334 bilhões, com banda de 90% que inclui zero. O ajuste
cambial cai R$ 14,678 bilhões; sua banda de 68% é [-29,368; -6,152] bilhões e
a de 90% é [-38,427; -0,145] bilhões.

As expectativas Focus respondem, no impacto, em 0,117 ponto para IPCA, 0,500
para Selic, -0,222 para PIB e R$ 0,080 para câmbio. Para o bloco promovido,
as respostas são -0,262 para DLSP, -0,039 para o resultado primário e -0,161
para o resultado nominal (pontos percentuais do PIB). As bandas de 90% excluem
zero no impacto para PIB, câmbio e resultado nominal, mas não para a expectativa
de DLSP nem para o resultado primário. Essas bandas descrevem incerteza do DFM;
não são inferência Anderson--Rubin nem estabelecem validade do instrumento.
