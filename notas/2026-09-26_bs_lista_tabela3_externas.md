# Ortogonalização Bauer-Swanson com a lista da Tabela 3, mais S&P 500 e VIX

> **BRANCH `feature/bs-copom-surpresas-macro`, 2026-09-26: construção escolhida pelo autor, paper
> NÃO migrado.**
> - Substitui a lista de preditores de `2026-09-25_bs_copom_surpresas_macro`. Daquela nota continuam
>   valendo a amostra (102 reuniões, só constante, sem tendência), os dados, o timing e as definições
>   do bloco macro (§§1 e 3).
> - O paper, as figuras da §4, os Anexos C e D (salvo a figura do Anexo D, redesenhada aqui), o
>   benchmark VAR, os pins de `validate_production_spec.R` e o smoke test do `CLAUDE.md` seguem a
>   produção de `main`. A migração é o item aberto do Tema D de `registro/pendencias.md`.
> - Base de comparação: `main` em `63eea36` (ξ_mp 6,848035 na cheia, 8,643436 na pré-COVID).
> - ⚠ `data/processed/` é gitignored e não troca com a branch. Para voltar a `main`, rodar
>   `Rscript script/instrument.R` em `main` antes de qualquer estimação ou do smoke test.

## 1. A decisão

A regressão pré-evento passa a ter os preditores da Tabela 3 de BS que têm contrapartida brasileira,
mais dois externos (commit `8d42203`):

| regressor | janela | papel |
|---|---|---|
| `pre_ibov` | 65 pregões até o fechamento da quarta | "SP500 ret" de BS, o mercado acionário doméstico |
| `pre_slope` (DI 2 anos − 3 meses) | idem | "chg slope" |
| `pre_brent` | idem | "commod ret" |
| `news_ipca`, `news_gdp`, `news_core_accel`, `news_ipca_expected` | desde o Copom anterior | o bloco macro da nota de 2026-09-25, §3 |
| `pre_sp500`, `pre_vix` | 65 pregões | condições externas a que uma economia pequena e aberta responde; não estão em BS |

Saem da regressão:
- **as revisões Focus de 20 pregões, de IPCA e de Selic.** Não são da Tabela 3. Vêm da Tabela 2, em
  que as revisões Blue Chip defasadas explicam outras revisões Blue Chip, e não a surpresa. Entraram na
  auditoria de 2026-07-15 por essa atribuição, corrigida em `registro/metodo.md` no commit `63eea36`.
- **o câmbio**, que não tem análogo na Tabela 3.

Por decisão do autor, a variante com a revisão da Selic **não é reportada no paper**. Os números dela
ficam na nota de 2026-09-25, §§2 e 4–6.

⚠ A lista foi fixada depois de medir aquela variante (ξ_mp 1,78) e de comparar no scratchpad seis
conjuntos de preditores. A justificativa registrada é a fidelidade à Tabela 3, não o resultado. As
duas escolhas finalistas quase não diferem: sem S&P e VIX, o ξ_mp de produção seria 5,11 na cheia e
5,00 na pré-COVID.

⚠ **S&P 500 e VIX não tratam a super quarta.** 34 das 102 reuniões caem no mesmo dia do FOMC. Uma
tendência de 65 pregões que termina no fechamento da quarta não alcança o que acontece dentro da
janela quarta→quinta. Medido: acrescentar os dois move os resíduos do DI em média 0,75 p.b., o mesmo
nas super quartas e nas outras reuniões, e troca a classe de 2 das 34 super quartas. A contaminação
contemporânea pelo FOMC tem registro próprio, em `historico_decisoes.md` §16: sinal fraco, que o
paper não reporta.

## 2. A regressão

Coeficientes com EP HC1, N = 102, 10 parâmetros (`output/instrument/bs_orthogonalization.csv`):

| | DI (1) | Ibovespa (2) |
|---|---|---|
| `R²` | 0,124 | 0,053 |
| Wald conjunta (9 preditores), p | 0,122 | 0,699 |
| Wald só do bloco macro (4), p | 0,059 | 0,997 |
| surpresa do PIB | **6,74 (3,07)**, t 2,19 | −0,16 (0,39) |
| Brent | 0,19 (0,10), t 1,82 | −0,01 (0,01) |
| surpresa do IPCA | 14,6 (15,0) | 0,04 (1,80) |
| IPCA esperado | 5,85 (4,99) | −0,04 (0,60) |
| aceleração do núcleo | −0,65 (0,70) | 0,01 (0,07) |
| Ibovespa, S&P 500, VIX, inclinação | todos com \|t\| < 0,8 | todos com \|t\| < 0,5 |

- O conjunto não é significativo nas duas colunas. O `R²` do DI, 0,124, cai no piso da faixa de 0,12
  a 0,20 de BS.
- O bloco macro fica no limite de 10% no DI (p 0,059). A surpresa do PIB é a única significativa a
  5%, com o sinal de BS: crescimento acima do esperado antecede surpresa de aperto.
- S&P 500 e VIX juntos: p 0,72 no DI.

## 3. Instrumento e força

| | `main` | branch, 2026-09-25 | **branch, 2026-09-26** |
|---|---|---|---|
| reuniões monetárias / informacionais | 67 / 35 | 60 / 42 | **62 / 40**; 21 trocam de classe contra `main` |
| meses com instrumento não nulo | 65 | — | 60 |
| 2020-03-19 (pânico COVID) | fora da máscara | fora | fora |
| cor. mensal com `main`: `z_bs_purif` / `z_jk_bs_purif` | — | 0,885 / 0,769 | 0,945 / 0,902 |
| ξ_mp cheia: bruta / ortog. / produção | 6,68 / 6,16 / 6,85 | 6,68 / 3,21 / 1,78 | 6,68 / 7,02 / **5,01** |
| F_rob,mp cheia: ortog. / produção | 7,89 / 11,77 | 3,04 / 1,81 | 8,62 / 7,59 |
| ξ_mp pré-COVID: bruta / ortog. / produção | 6,66 / 6,32 / 8,64 | 6,66 / 3,77 / 3,22 | 6,66 / 6,84 / **4,73** |
| grade `z_jk_bs_purif` acima de 3,84, cheia / pré-COVID | 12 / 25 | 0 / 17 | 12 / 25 |

Fontes: `instrument_diagnostics.csv` e `mosw_strength_grid.csv`. `z_bruto` sai idêntico em bytes ao de
`main`.

- ξ_mp de produção fica acima de 3,84 nas duas janelas, logo os conjuntos são limitados a 95%, e
  abaixo de 10, como em `main`.
- Na grade cheia, a célula de produção passa a ser a **mais fraca** das 12 (5,01, com máximo de 9,24).
  Na pré-COVID o intervalo é de 4,38 a 8,63.
- A camada ortogonalizada sem máscara fica mais forte que a de produção (7,02 contra 5,01). Em `main`
  era o contrário (6,16 contra 6,85).

## 4. Consequências a jusante

`irf_coherence_check.R` e `instrument_layers_irf.R` foram re-rodados (commit `d781183`).

**Todos os conjuntos voltam a ser intervalos** a 68 e 90%: 2841 `interval` mais o `singleton` da
normalização. A guarda da topologia passa.

**Nenhum ponto sai do conjunto de 90% de `main`** nas oito séries da §4 até h36 (0 de 296). Nas 58
variáveis, sai 1 de 2842: `asset_imat` em h0, −4,20 contra [−4,03; 3,67]. Os conjuntos de 90% ficam, na
mediana, 1,43 vez mais largos, e as células significativas a 90% caem de 808 para 366.

Impactos em h0 nas unidades da §4, `main` → branch (todos com conjunto de 90% `interval`):

| série | `main` | branch | significativo a 90%, `main` → branch |
|---|---|---|---|
| DI 2 anos (p.b.) | 70,1 | 87,7 | sim → sim |
| DI 5 anos (p.b.) | 72,9 | 105 | sim → sim |
| Câmbio BRL/USD (%) | 3,23 | 4,56 | sim → sim |
| CDS 5 anos (p.b.) | 30,5 | 50,9 | sim → sim |
| IBC-Br (%) | −0,67 | −1,06 | sim → sim |
| IPCA (p.p. ao mês) | −0,045 | −0,002 | não → não |
| Ibovespa (%) | −1,50 | **−8,17** | **não → sim** |
| DLSP (p.p. do PIB) | −0,67 | −0,99 | sim → sim |

Os impactos crescem com o denominador menor (`denom_vs_prod`, `.claude/rules/instrument.md`).

O que muda na leitura da §4:
- **A curva:** o pico em h3 se mantém do vértice de 3 meses ao de 5 anos. O de 10 anos passa a atingir
  o pico em h1.
- **O IBC-Br** segue negativo nos 36 meses.
- **O IPCA:** "nunca positivo" deixa de valer, porque o ponto é positivo em h4 e h5 (+0,03). As células
  significativas a 90%, que em `main` iam de h20 a h34, somem todas.
- **O Ibovespa** passa a ser significativo a 90% **no impacto e em h1, negativo**. Em `main` só a fase
  positiva era significativa, em h5–h10 e h39–h45, e o impacto não era.
- **O resultado primário:** a significância a 90% de h18 a h32, um dos números inconvenientes da §4,
  desaparece. O ponto continua positivo e maior (h24: 4557 → 5169), mas o conjunto passa a conter o
  zero. Só h1 segue significativo.
- Cinco variáveis trocam de sinal em h0: `asset_imat`, `msci`, `price_core_ipca_ex1`, `price_inpc` e
  `fiscal_dbgg`.

**O Anexo D volta a ser desenhado.** `paper/fig_instrumento_camadas.pdf` e `instrument_layers_irf.csv`
foram regravados. A frase de `main` de que nenhum ponto das camadas alternativas sai do conjunto de
90% de produção deixa de valer. Saem 19 de 4255 pontos de `z_bs_purif` e 123 de `z_bruto`. O
impacto no Ibovespa vai de +0,27% na surpresa bruta a −2,47% com a ortogonalização e a −8,17% com o
filtro de sinal.

**Validadores.** Os cinco que rodam sobre fixture passam: `amengual_watson`, `hac_kernel`, `het_cv`,
`mosw_ar` e `olea_kilian`. Falham, como esperado, os dois que fixam números do instrumento de
produção: `validate_production_spec.R` ("The recalculated initial production-instrument values
changed") e o N2 de `validate_covid_volatility.R`.

## 5. O que a promoção tocaria

- **§3.3:** a descrição da regressão (tendência e 638 quintas saem; saem as revisões Focus; entram as
  notícias macro), a frase do `R²` de 0,022 "sem contrapartida diária", e 67/35 → 62/40.
- **`tab:first_stage`, `tab:bs_ortogonalizacao` e §3.4:** ξ_mp de 6,85 para 5,01 na cheia e de 8,64
  para 4,73 na pré-COVID.
- **A §4 e suas oito figuras:** números e as três leituras acima (IPCA, Ibovespa, resultado primário).
- **Resumo, introdução e conclusão:** números e as frases de argumento que dependem dessas leituras.
- **Anexo C:** re-rodar `q_sensitivity.R` e `p_sensitivity.R`.
- **Anexo D:** tabela e texto; a figura já está redesenhada na branch.
- **O benchmark VAR e `fig:weak_iv_main`**, que usam o mesmo instrumento.
- **Os pins:** `validate_production_spec.R`, o N2 de `validate_covid_volatility.R`, o smoke test e a
  especificação do `CLAUDE.md`.

⚠ Continuam valendo dois avisos da nota de 2026-09-25:
- quatro divulgações (PIB de 4T2013, 4T2015 e 1T2017; IPCA de 01/2018) caem na própria quinta do
  Copom, dentro da janela do evento;
- `data/processed/` não troca com a branch.
