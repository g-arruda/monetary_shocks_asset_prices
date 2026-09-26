# Produção sem o filtro JK (`z_bs_purif`) e bandas de 80/90%

> **BRANCH `feature/bs-copom-surpresas-macro`, 2026-09-26: código, outputs e figuras migrados; o
> `.tex` NÃO foi tocado, por decisão do autor.**
> - Duas decisões do autor, executadas juntas: o instrumento de produção passa de `z_jk_bs_purif` a
>   `z_bs_purif` (o filtro de sinal de Jarociński-Karadi sai da produção, por ora), e as bandas das
>   IRFs passam de 68/90% a 80/90%, como em Alessi-Kerssenfischer.
> - A ortogonalização é a da branch: 102 reuniões, só constante, lista da Tabela 3 mais S&P 500 e
>   VIX (`2026-09-26_bs_lista_tabela3_externas`). Esta nota não muda a construção, só a camada que a
>   produção usa.
> - As figuras `paper/fig_*.pdf` estão na produção nova, e o texto do paper ainda traz os números de
>   `main` (`z_jk_bs_purif`, 68/90%). O que o paper precisa mudar está no item de migração do Tema A
>   de `registro/pendencias.md`.
> - Base de comparação: a branch em `da4cdf6`.
> - ⚠ `data/processed/` é gitignored e não troca com a branch. Para voltar a `main`, rodar
>   `Rscript script/instrument.R` em `main` antes de qualquer estimação.

## 1. As decisões

**Filtro JK fora da produção.** Na construção da branch, o filtro de sinal **reduz** ξ_mp, de 7,02
sem máscara para 5,01 com ela (pré-COVID, de 6,84 para 4,73), ao contrário de `main`, onde elevava
de 6,16 para 6,85. A produção passa a ser a surpresa ortogonalizada, a linha 2 da
`tab:first_stage`. O código continua construindo as três camadas (`R/instrument/build_variants.R`
não mudou), porque a grade de força, os diagnósticos e o Anexo D usam as três.

**Bandas de 80/90%.** AK (2019) sombreiam 80% e 90% em todas as figuras. A significância continua a
90%; o nível inferior, que só dá direção e magnitude, passa de 68% a 80%, mais exigente, porque o
conjunto de 80% contém o de 68%. O conjunto AR de 80% é limitado sse ξ > 1,64. O benchmark VAR
acompanha, para que a `fig:weak_iv_main` mostre os mesmos níveis nos dois modelos;
`validate_mosw_ar.R` continua em 68/95%, os níveis do código de referência.

## 2. O que mudou no código

- Instrumento: `PRODUCTION_VARIANT` de `script/instrument.R` (que grava
  `data/processed/instrument.csv`, lido por `main_sdfm()`), e o literal `INSTRUMENT` de
  `irf_coherence_check.R`, `model_var.R`, `q_sensitivity.R`, `p_sensitivity.R` e
  `validation/validate_production_spec.R`.
- `instrument_layers_irf.R`: a linha sombreada da `fig:instrumento_camadas` passa a ser
  `z_bs_purif`; as tracejadas, a bruta e a com filtro de sinal.
- Níveis: `c(0.68, 0.90)` → `c(0.80, 0.90)` nos sete scripts e no default de `main_sdfm()`; as
  colunas `lo68/hi68/sig68/set_type68` e o `right_sig68` de `evaluate_irf_path()` viraram `*80`.
- Pins: `validate_production_spec.R` (os oito primeiros valores do instrumento, o contrato de zeros,
  que passa a ser "zero sse o mês não tem reunião do Copom", 64 meses, ξ_mp, F_rob e os impactos
  em h0) e o ponto sem tratamento do N2 de `validate_covid_volatility.R`.

## 3. Números

**Força** (`mosw_strength_grid.csv`, célula (5,5); a grade não mudou, só a escolha da produção):

| janela | ξ_mp | F_rob,mp | ξ_mp com filtro JK |
|---|---|---|---|
| cheia (162) | 7,018990 | 8,616330 | 5,012514 |
| pré-COVID (90) | 6,836682 | 8,306648 | 4,733036 |

As duas estatísticas ficam abaixo de 10 nas duas janelas. A raiz máxima da companheira não depende
do instrumento e não mudou (0,983676 cheia, 0,993359 pré-COVID). O instrumento tem 99 meses não
nulos nas 162 inovações (60 com o filtro, 95 na surpresa bruta).

**Impactos** (smoke test do `CLAUDE.md`, bit-idênticos entre `main_sdfm()` e
`irf_coherence_check.R`):

| série | `z_jk_bs_purif` de `main` | `z_bs_purif` |
|---|---|---|
| `yield_2y` | 0,00700904 | 0,00720694 |
| `yield_5y` | 0,00729006 | 0,00773054 |
| `asset_ibov` | −1,50194 | −2,46543 |
| `cambio_usd` | 0,12942 | 0,14142 |

Em unidades do paper: BRL/USD 3,53% (3,23% em `main`), CDS +34,0 p.b. (+30,5), EMBI+ +28,3 p.b.
(+25,1), IBC-Br −0,77% (−0,66%).

**Conjuntos.** Todos `interval` a 80% e a 90%: 2841 linhas por nível, mais o `singleton` que a
normalização fixa em h0. O conjunto de 80% está contido no de 90% em toda linha. Horizontes até
h36 em que o conjunto exclui zero:

| série | 80% | 90% |
|---|---|---|
| DI 2 anos | 23 | 16 |
| câmbio BRL/USD | 22 | 10 |
| CDS 5 anos | 23 | 16 |
| DLSP | 23 | 17 |
| IBC-Br | 33 | 24 |
| IPCA | 24 | 20 |
| Ibovespa | 17 | 8 |

**Benchmark VAR** (`svar_iv_weak_robust.csv`): `xi_var` 7,189765 (7,258325 em `main`), todos os
conjuntos `interval` a 80 e 90%. No impacto, IBC-Br −1,28%, IPCA −0,080, câmbio 2,49%, CDS +23,3 p.b.

## 4. Verificações

- `instrumentos_mensais.csv`, `copom_event_diagnostics.csv`, `bs_orthogonalization.csv`,
  `mosw_strength_grid.csv` e `instrument_diagnostics.csv`: byte-idênticos ao anterior. Só
  `instrument.csv` mudou, e é igual à coluna `z_bs_purif`.
- O ponto de produção novo é igual à linha `z_bs_purif` do `instrument_layers_irf.csv` anterior
  (diferença máxima 0; conjuntos de 90% a 9e-13). A linha `z_jk_bs_purif` nova é igual à produção
  anterior da branch (ponto a 0, 90% a 1e-11). A troca, portanto, só escolheu outra camada e mudou o
  nível inferior; nada mais se moveu.
- Os sete validadores passam; a checagem de limitação (`ahat > 0` ⇔ `xi_den > critval`) passa nos dois
  níveis; as figuras dos Anexos C e D conferem a produção contra `irf_coherence_h.csv` a 1e-10.

## 5. Leituras

- A forma das respostas não muda: a curva tem pico em h3 em todos os vértices, o IBC-Br fica negativo
  por 36 meses e o IPCA nunca fica positivo. As magnitudes sobem, e os cruzamentos de zero da curva
  antecipam um mês.
- O câmbio volta a excluir zero a 90% em h32–h36, no ramo da apreciação, o que em `main` não ocorria.
- O ajuste cambial no impacto tem conjunto de 80% com zero, [−71,7; 1,5] bilhões. A frase da §4 que
  citava o conjunto de 68% não sobrevive.
- Os sete índices de ações caem no impacto (o IMAT passa a −0,39%), e nenhum é significativo a 90% no
  impacto.
- Nos vereditos de `irf_coherence_summary.csv`, a comparação com a versão anterior mistura as duas
  trocas (camada e nível), e não é decomposta aqui. A tabela nova tem 27 `coerente_forte`, 5
  `parcial`, 5 `incoerente` e 14 `ambigua`.
- ⚠ **Placebo.** A incerteza de política econômica dos EUA sobe 11,8 pontos em h1, com conjunto de
  90% [0,7; 31,9], e exclui zero de h1 a h3: `placebo_viola`. MSCI emergentes e VIX passam a
  `placebo_ok`, com significância só em horizontes longos. O item está aberto no Tema D.
