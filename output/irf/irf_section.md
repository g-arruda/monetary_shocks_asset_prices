# Resultados das IRFs na rodada de produção

> **CURRENT — 2026-09-24.** Lido de `output/irf/irf_coherence_cell.rds` e
> `output/irf/irf_coherence_h.csv`, escritos por `script/irf_coherence_check.R`
> na produção corrente. É a fonte dos números da §4 de `paper/paper_anpec.tex`,
> migrada nesta data (`notas/2026-09-24_migracao_secao_4.md`), e da §5.2.
> As bandas abaixo são **conjuntos Anderson--Rubin**, e as colunas
> `set_type68`/`set_type90` do CSV dizem que tipo de conjunto é cada uma. Nas 58
> séries pontuadas, todos são `interval` a 68% e 90%, com exceção do `singleton`
> que a normalização fixa em `yield_6m`, `h=0`.

## Especificação

O painel de produção tem 115 séries mensais de 2012-03 a 2025-12, com 166
observações e 162 inovações fatoriais depois das quatro defasagens. A produção
usa `(r,q,p)=(5,5,4)` e `z_jk_bs_purif`, com normalização de +50 pontos-base em
`yield_6m`. O VAR fatorial carrega a escala de volatilidade COVID de
Lenza-Primiceri, com θ̂ lido de `output/factors/covid_volatility_theta.csv`. A
inferência são os conjuntos AR de 68% e 90%, com NW(0). O IC2 de Bai--Ng BLL
seleciona `r=5`. O AIC seleciona `p=4` (8,231267) na amostra comum de 154
observações, com tendência só no critério, e o BIC seleciona `p=2`.
Amengual--Watson, condicionado a `r=5,p=4`, seleciona `q=2`, resultado
reportado que não altera a decisão explícita de `q=5`.

Na amostra completa, `xi_mp=6,847997`, `F_rob,mp=11,765250` e a maior raiz da
companheira é 0,983677. Os conjuntos são limitados a 68% e 90% porque `xi_mp`
supera os dois valores críticos. A janela pré-COVID tem `xi_mp=8,643436`, mas
não tem inferência, porque `hac_dim` 135 ≥ 90 barra os conjuntos.

## Impactos

| variável | ponto h=0 | conjunto 68% | conjunto 90% |
|---|---:|---:|---:|
| DI 6 meses (p.b.) | 50,0 | {50,0} | {50,0} |
| DI 2 anos (p.b.) | 70,1 | [61,6; 79,5] | [54,3; 89,7] |
| DI 5 anos (p.b.) | 72,9 | [58,4; 90,2] | [46,8; 110,1] |
| Ibovespa (%, retorno mensal) | -1,502 | [-4,718; 1,244] | [-8,327; 3,504] |
| BRL/USD (% da média) | 3,23 | [2,29; 4,43] | [1,57; 5,86] |
| EMBI+ (p.b.) | 25,07 | [16,02; 36,61] | [9,22; 50,54] |
| CDS 5 anos (p.b.) | 30,49 | [21,04; 42,72] | [14,05; 57,69] |

## Fiscal e expectativas

No impacto, a DLSP cai 0,669 ponto percentual do PIB, com conjunto de 90% de
[-1,121; -0,420]. A DBGG cai 0,168, e seu conjunto de 90% [-0,441; 0,167]
contém zero, enquanto o de 68% [-0,314; -0,006] o exclui. A NFSP primária cai
R$ 1,473 bilhão, com conjunto de 90% que contém zero no impacto e o exclui em
h=1 e em h=18–32, já com ponto positivo. O ajuste cambial cai R$ 20,803
bilhões. Seu conjunto de 68% é [-45,401; -1,049] bilhões, e o de 90%,
[-74,537; 14,187], contém zero em todos os horizontes.

As expectativas Focus respondem no impacto em 0,093 ponto para o IPCA, 0,448
para a Selic, -0,179 para o PIB e R$ 0,074 para o câmbio. No bloco fiscal, as
respostas são -0,208 para a DLSP, -0,020 para o resultado primário e -0,123
para o resultado nominal, em pontos percentuais do PIB. Os conjuntos de 90%
excluem zero no impacto para Selic, PIB, câmbio, DLSP e resultado nominal, mas
não para o IPCA, que exclui zero a 90% de h=1 a h=3 e, com sinal negativo, de
h=28 a h=36, nem para o resultado
primário, que não exclui zero a 90% em nenhum horizonte. Esses conjuntos são
inferência robusta a instrumento fraco sobre o DFM e não estabelecem a validade
do instrumento.

## O que mudou contra a vintage anterior

A vintage de 2013-01--2025-09 em `(4,4,4)`, com bandas de *wild bootstrap*,
tinha a curva com pico entre h=4 e h=6 e cruzamento entre h=17 e h=22, o
IBC-Br positivo de h=2 a h=13 e uma corcova positiva no IPCA. Na produção
corrente, todos os vértices têm pico em h=3 e cruzam zero entre h=14 e h=16, o
IBC-Br não muda de sinal em 36 meses e o IPCA não fica positivo em nenhum
horizonte. A tabela completa está na nota da migração.
