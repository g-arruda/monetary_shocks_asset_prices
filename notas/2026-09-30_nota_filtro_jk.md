# Rodapé sobre a saída do filtro de Jarociński-Karadi

> **CURRENT — 2026-09-30.** Rodada de texto em `paper/paper_anpec.tex`, **nada reestimado**.
> Branch `feature/robustez-pandemia`, não mergeada.
> - Produção de 2026-09-26: `z_bs_purif`, `(r,q,p) = (5,5,4)`, escala COVID de Lenza-Primiceri,
>   conjuntos Anderson--Rubin de 80% e 90% com NW(0).
> - Fecha o item do e-mail do orientador de 28-09 (`email/email_professor_28-09_21h15.md`): a saída
>   do filtro não pode ficar silenciosa, porque os autores são citados na §2.
> - Decisão do autor: o rodapé fala da força do instrumento e da perda de significância.

## 1. O que entrou no paper

**Rodapé na §3.4**, no fim da frase que compara a força das duas camadas da `tab:first_stage`. Diz
que o filtro retém 62 das 102 reuniões, as de sinais opostos entre a surpresa ortogonalizada do DI e
o retorno ortogonalizado do Ibovespa, e dá os números da seção 2: a força cai, nenhum ponto sai do
conjunto de 90% de produção, os conjuntos se alargam e a significância a 90% cai quase à metade. Por
isso o filtro não entra no instrumento de produção.

**§1 e resumos.** O commit `6e0bc00` (2026-09-29) tinha devolvido à introdução e aos dois resumos a
redação anterior a 2026-09-26, que descreve o filtro como parte do instrumento. As três passagens
voltaram à redação de 2026-09-26: surpresas do Copom ortogonalizadas em relação à informação
predeterminada, como em Bauer-Swanson. No resumo em português isso também devolve "115 séries …
entre 2012 e 2025" no lugar de "106 séries … entre 2013 e 2025". ⚠ O resumo em inglês ainda traz
"3.64%" para o câmbio, que não é número da produção. Ficou para o item do Tema A sobre resumo,
introdução e conclusão.

A §2 continua citando `jarocinski2020` como literatura, e o rodapé é a única outra menção.

## 2. Números

**Força**, `output/instrument/mosw_strength_grid.csv`, célula (5,5):

| janela | ξ_mp sem → com filtro | F_rob,mp sem → com filtro |
|---|---|---|
| cheia (162) | 7,018990 → 5,012514 | 8,616330 → 7,594384 |
| pré-COVID (90) | 6,836682 → 4,733036 | 8,306648 → 7,782403 |

**Respostas.** O `output/irf/instrument_layers_irf.csv` corrente perdeu as linhas JK em 2026-09-26
(commit `c3a6536`). As contagens vêm da versão do commit `3b9e402`, a primeira com a produção em
`z_bs_purif`, que tem as três camadas. As linhas `z_bs_purif` dessa versão coincidem com
`output/irf/irf_coherence_h.csv` (ponto a 0, conjuntos de 90% a 1e-12 nas 2146 linhas comuns). São
115 séries em h0–h36, 4255 pares, todos `interval` a 90% salvo o `singleton` da normalização:

- pontos de `z_jk_bs_purif` fora do conjunto de 90% de produção: **0 de 4255**;
- razão mediana das larguras dos conjuntos de 90%, filtro sobre produção: **1,32**;
- pares com conjunto de 90% excluindo zero, sem o `singleton`: **1587 → 856** de 4254 (surpresa
  bruta: 1886).

Por série, pares significativos a 90% até h36, produção → filtro: DI 2 anos 16 → 5, câmbio BRL/USD
10 → 7, CDS 5 anos 16 → 8, DLSP 17 → 7, IBC-Br 24 → 27, IPCA 20 → 0, DBGG 10 → 0, Ibovespa 8 → 2,
Focus IPCA 12 meses 15 → 1.

⚠ **Os números que o rodapé não carrega.** Com o filtro, o impacto no Ibovespa é −8,17%, com
conjunto de 90% [−28,4; −3,0], e passa a excluir zero. Na produção é −2,47%, [−11,1; 3,3]. Parte
disso é mecânica, porque o filtro retém as reuniões em que DI e Ibovespa andam em sentidos
opostos. O IBC-Br é a única das séries acima que ganha horizontes significativos. Os placebos
externos também respondem mais com o filtro (`2026-09-26_bs_lista_tabela3_externas`, seção 4).

## 3. Reprodução

```r
d <- readr::read_csv(pipe("git show 3b9e402:output/irf/instrument_layers_irf.csv"))
```

Filtrar `h <= 36`, casar `z_jk_bs_purif` com `z_bs_purif` por série e horizonte, e contar
`point` do filtro fora de `[lo90, hi90]` da produção. A significância é `lo90 > 0 | hi90 < 0` nas
linhas `interval`, que é o que `ar_excludes_zero()` decide para essa topologia.
