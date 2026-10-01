# Resultados das IRFs na rodada de produção

> **CURRENT — 2026-09-26.** Lido de `output/irf/irf_coherence_cell.rds` e
> `output/irf/irf_coherence_h.csv`, escritos por `script/irf_coherence_check.R` na produção corrente
> (`z_bs_purif`, conjuntos de 80% e 90%), promovida para `main` nesta data. É a fonte dos números da
> §4 e da §5 de `paper/paper.tex`, migrado nesta data
> (`notas/2026-09-26_migracao_paper_bs_purif.md`). A leitura anterior, de `z_jk_bs_purif` a 68/90%,
> está em `notas/2026-09-24_migracao_secao_4.md`.
> As bandas abaixo são **conjuntos Anderson--Rubin**, e as colunas `set_type80`/`set_type90` do CSV
> dizem que tipo de conjunto é cada uma. Nas 58 séries pontuadas, todos são `interval` a 80% e 90%,
> com exceção do `singleton` que a normalização fixa em `yield_6m`, `h=0`.
> Desde 2026-09-27 as séries em nível saem na própria unidade: o câmbio em R$/US$, não mais em %
> da média amostral (`notas/2026-09-27_unidades_nativas.md`).

## Especificação

O painel de produção tem 115 séries mensais de 2012-03 a 2025-12, com 166 observações e 162 inovações
fatoriais depois das quatro defasagens. A produção usa `(r,q,p)=(5,5,4)` e `z_bs_purif`, a surpresa
do Copom ortogonalizada à Bauer-Swanson, sem o filtro de sinal de Jarociński-Karadi. A normalização
é de +50 pontos-base em `yield_6m`. O VAR fatorial carrega a escala de volatilidade COVID de
Lenza-Primiceri, com θ̂ lido de `output/factors/covid_volatility_theta.csv`. A inferência são os
conjuntos AR de 80% e 90%, com NW(0).

A seleção dos parâmetros:
- o IC2 de Bai--Ng BLL seleciona `r=5`;
- o AIC seleciona `p=4` (8,231267) na amostra comum de 154 observações, com tendência só no
  critério, e o BIC seleciona `p=2`;
- Amengual--Watson, condicionado a `r=5,p=4`, seleciona `q=2`, resultado reportado que não altera a
  decisão explícita de `q=5`.

Na amostra completa, `xi_mp=7,018990`, `F_rob,mp=8,616330` e a maior raiz da companheira é 0,983676.
Os conjuntos são limitados a 80% e 90% porque `xi_mp` supera os dois valores críticos (1,64 e 2,71).
A janela pré-COVID tem `xi_mp=6,836682`, mas não tem inferência, porque `hac_dim` 135 ≥ 90 barra os
conjuntos.

## Impactos

| variável | ponto h=0 | conjunto 80% | conjunto 90% |
|---|---:|---:|---:|
| DI 6 meses (p.b.) | 50,0 | {50,0} | {50,0} |
| DI 2 anos (p.b.) | 72,1 | [59,5; 87,9] | [54,9; 95,9] |
| DI 5 anos (p.b.) | 77,3 | [55,8; 107,0] | [48,6; 123,0] |
| Ibovespa (%, retorno mensal) | -2,465 | [-8,106; 1,781] | [-11,055; 3,260] |
| BRL/USD (R$/US$) | 0,141 | [0,086; 0,226] | [0,069; 0,275] |
| EMBI+ (p.b.) | 28,27 | [14,87; 48,19] | [10,61; 59,32] |
| CDS 5 anos (p.b.) | 34,02 | [20,01; 55,46] | [15,67; 67,63] |

## Fiscal e expectativas

**Fiscal, no impacto:**
- a DLSP cai 0,736 ponto percentual do PIB, com conjunto de 90% de [-1,310; -0,449];
- a DBGG cai 0,136, e seus conjuntos contêm zero nos dois níveis (80% [-0,354; 0,134], 90%
  [-0,435; 0,269]);
- a NFSP primária cai R$ 1,768 bilhão. Seu conjunto de 90% contém zero no impacto e o exclui em h=1 e
  em h=16–33, já com ponto positivo;
- o ajuste cambial cai R$ 28,497 bilhões, mas o conjunto de 80% contém zero, [-71,742; 1,540]
  bilhões, e o de 90% também, [-95,452; 11,339]. O de 90% só exclui zero em h=35–36, com sinal
  negativo.

**Expectativas Focus, no impacto:**
- IPCA 0,077 ponto, Selic 0,471, PIB -0,189 e câmbio R$ 0,075;
- no bloco fiscal, DLSP -0,241, resultado primário -0,014 e resultado nominal -0,122, em pontos
  percentuais do PIB.

Os conjuntos de 90% excluem zero no impacto para Selic, PIB, câmbio, DLSP e resultado nominal.
- O do IPCA não exclui no impacto. Exclui zero a 90% de h=1 a h=2 e, com sinal negativo, de h=24 a
  h=36.
- O do resultado primário não exclui zero a 90% em nenhum horizonte, e o de 80% só em h=2.

Esses conjuntos são inferência robusta a instrumento fraco sobre o DFM e não estabelecem a validade do
instrumento.

## O que mudou contra a produção anterior

Contra `z_jk_bs_purif` a 68/90%, a forma se mantém:
- todos os vértices da curva têm pico em h=3;
- o IBC-Br não muda de sinal em 36 meses;
- o IPCA não fica positivo em nenhum horizonte.

As magnitudes sobem, e os cruzamentos da curva antecipam um mês (h=13–15, Selic em h=16). O câmbio e
o CDS passam a ter pico em h=1. Os sete índices acionários caem no impacto, porque o IMAT troca de
sinal. O conjunto de 90% do câmbio volta a excluir zero em h=32–36. A lista completa está na nota da
migração.
