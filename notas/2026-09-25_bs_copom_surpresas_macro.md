# Ortogonalização Bauer-Swanson só nas reuniões do Copom, com o bloco de surpresas macro

> **BRANCH `feature/bs-copom-surpresas-macro`, 2026-09-25 — NÃO é produção.**
> - Fecha os dois itens do Tema D de `registro/pendencias.md` abertos no mesmo dia: estimar a
>   ortogonalização só nos dias de Copom, sem tendência, e acrescentar o bloco de surpresas macro.
> - Escopo decidido pelo autor: **medir e parar**. O instrumento, a força, a grade e a IRF de
>   produção foram reestimados na branch. O paper, as figuras, o benchmark VAR, os pins de
>   `validate_production_spec.R` e o smoke test do `CLAUDE.md` **não** migraram. Promover ou não é
>   decisão aberta (Tema D).
> - Decisões do autor na abertura: PIB na primeira divulgação; mercado de trabalho como lacuna
>   declarada; BBK fora.
> - Base de comparação: `main` em `63eea36`, que tem ξ_mp 6,848035 na janela cheia e 8,643436 na
>   pré-COVID.
> - ⚠ `data/processed/` é gitignored e não troca com a branch. Depois desta rodada ele carrega o
>   instrumento da branch. Para voltar a `main`, rodar `Rscript script/instrument.R` em `main` antes
>   de qualquer estimação ou do smoke test.

## 1. O que muda em relação a Bauer-Swanson

A Tabela 3 de BS (2023) regride a surpresa `mps_t = α + β'news_t + ε_t` com **só a constante** e
**uma observação por mês com FOMC** (N = 217, 1990-01 a 2019-06). Em `table_3.m` o `trend` é criado
mas não entra no `X`. A tendência e a revisão defasada do Blue Chip são da **Tabela 2**, e a
atribuição antiga foi corrigida em `registro/metodo.md` (commit `63eea36`, em `main`).

Até aqui, `R/instrument/build_variants.R` estimava nas **638 quintas válidas**, das quais 102 são
pós-Copom, com tendência. O instrumento só soma resíduos de dias de Copom, mas os coeficientes vinham
sobretudo dos 536 dias sem reunião. A rodada tem dois passos, cada um num commit da branch:

1. a mesma regressão, com os mesmos oito preditores, **só nas 102 reuniões e sem tendência**
   (`a808f36`);
2. mais **quatro regressores de notícia macroeconômica** da Tabela 3 (`17de001`).

A amostra de eventos não muda. O filtro de mesma sessão S&P/VIX/Brent continua definindo quais das
111 quartas de Copom da janela entram (102), e `z_bruto` sai **idêntico em bytes** ao de `main` nos
dois passos.

## 2. Passo 1: só as reuniões, sem tendência

| | `main` (638 quintas, tendência) | passo 1 (102 reuniões, constante) |
|---|---|---|
| `R²` DI / Ibovespa | 0,022 / 0,015 | **0,227** / 0,096 |
| Wald conjunta HC1, p (DI / Ibovespa) | 0,131 / 0,326 | **0,005** / 0,102 |
| revisão Focus da Selic no DI (coef., t) | 1,209 (2,0) | **9,77 (4,3)** |
| reuniões monetárias / informacionais | 67 / 35 | 59 / 43 (20 trocam de classe) |
| cor. mensal com `main`: `z_bs_purif` / `z_jk_bs_purif` | — | 0,912 / 0,852 |
| ξ_mp cheia: bruta / ortog. / produção | 6,68 / 6,16 / 6,85 | 6,68 / **2,22** / **2,43** |
| ξ_mp pré-COVID: bruta / ortog. / produção | 6,66 / 6,32 / 8,64 | 6,66 / **2,30** / **1,89** |

Fontes: `output/instrument/bs_orthogonalization.csv`, `instrument_diagnostics.csv` e
`mosw_strength_grid.csv`, no commit `a808f36`.

**A surpresa do Copom é previsível.** Na amostra de 638 quintas a Wald não rejeitava (p 0,131),
porque a pergunta era outra: se a variação quarta→quinta do DI é previsível numa quinta qualquer.
Nas reuniões, que é a pergunta de BS, a Wald rejeita a 1%. O `R²` de 0,227 fica **acima** da faixa
de 0,12 a 0,20 de BS. Quem carrega a previsibilidade é a revisão de 20 pregões da mediana Focus da
Selic do ano seguinte, com coeficiente oito vezes maior nas reuniões do que no painel de quintas.

## 3. Passo 2: o bloco macro

### 3.1 Dados

`script/download_macro_news.R` é um estágio de rede próprio (`macro_news` em `run_all.R`). Ele roda
sem re-baixar o painel de `download.R`, o que moveria a produção por revisões de BCB e Yahoo, e
escreve dois arquivos:

- **`data/raw/focus_macro_expectations.csv`**: os painéis Focus diários do IPCA mensal
  (`ExpectativaMercadoMensais`, `baseCalculo` 0) e do PIB trimestral
  (`ExpectativasMercadoTrimestrais`, "PIB Total"), por data e período de referência, de 2010-01 a
  2026-01.
- **`data/raw/macro_released.csv`**:
  - o IPCA (SGS 433) e o núcleo EX0 (SGS 11427, que exclui alimentação no domicílio e monitorados,
    o análogo do CPIX de BS), com o nome da série conferido no web service do SGS;
  - o **PIB na primeira divulgação**, 2011T4–2025T3, 56 trimestres. É lido pelo `pdftotext` da
    linha "Trimestre / mesmo trimestre do ano anterior" da Tabela I.1 do caderno de cada divulgação
    no FTP do IBGE (`Fasciculo_Indicadores_IBGE/<ano>/`). Usa-se a primeira divulgação porque o
    SIDRA só guarda a safra revisada, e uma revisão posterior ao Copom não é notícia que o mercado
    tinha antes dele.
  - O `pdftools` não instala sem a `libpoppler-cpp-dev`, que exige sudo; o `pdftotext` do poppler
    já estava na máquina.

**A unidade do PIB no Focus confere.** A mediana trimestral é a variação contra o mesmo trimestre do
ano anterior, e não a comparação com ajuste sazonal. Contra a primeira divulgação, a correlação é
0,991, com surpresa média −0,007 p.p. e DP 0,45 (1T2019: 0,54 contra 0,5 divulgado; a comparação com
ajuste foi −0,2). A maior surpresa é a de 1T2023, +1,4 p.p. (2,6 esperado, 4,0 divulgado).

### 3.2 Timing

**A data de divulgação sai do próprio Focus.** A pesquisa de um período de referência para no dia
anterior à divulgação: 03/2019 tem a última pesquisa em 09/04, e o IPCA saiu em 10/04. Então a
divulgação ocorreu até a quarta `W` se e só se a última pesquisa é anterior a `W`.

⚠ A regra não foi conferida contra o calendário do IBGE, porque a API de calendário só serve datas
atuais e futuras. As datas derivadas do IPCA caem entre os dias 5 e 12 do mês seguinte, de terça a
sexta, que é o padrão da divulgação.

As definições por reunião `k`, com `W_{k−1}` a quarta do Copom anterior:

| regressor | definição | análogo em BS (`constructomittedvars.m`) |
|---|---|---|
| `news_ipca` | Σ (divulgado − mediana da última pesquisa) dos IPCAs com última pesquisa em `[W_{k−1}, W_k)` | "core CPI news" |
| `news_gdp` | a mesma regra, com o PIB na primeira divulgação; 0 sem divulgação na janela | "GDP news" |
| `news_core_accel` | ((c_{t−2} − c_{t−8}) − (c_{t−8} − c_{t−14})) × 200, com c o log do índice EX0 e t o mês da reunião | "6m chg core CPI" |
| `news_ipca_expected` | mediana Focus, na última data ≤ `W_k`, do próximo IPCA ainda não divulgado | "exp core CPI" |

Escolhas declaradas:
- **Divulgação na própria quarta conta como notícia**, como BS contam a do dia do FOMC
  (`mmsdy <= mpdy`). A pendência falava em "estritamente antes da quarta". IPCA e PIB saem às 9h,
  antes do fechamento que abre a janela do evento. São 6 casos: 4 IPCA e 2 PIB.
- **Duas divulgações entre reuniões se somam.** No IPCA, 50 reuniões têm uma divulgação na janela e
  52 têm duas; no PIB, 50 reuniões têm uma (49 com surpresa não nula) e 52 nenhuma.
- **O IPCA é o cheio**, porque a expectativa mensal de núcleo do Focus não cobre a amostra. A
  aceleração usa o núcleo, como em BS.
- **Lacunas**: mercado de trabalho (a desocupação no Focus começa em 2021-09, e o CAGED não tem
  expectativa) e o índice BBK, que BS mostram poder sair.

⚠ **Quatro divulgações caem na própria quinta do Copom**, dentro da janela quarta→quinta: o PIB de
4T2013 (27/02/2014), de 4T2015 (03/03/2016) e de 1T2017 (01/06/2017), e o IPCA de 01/2018
(08/02/2018). Nesses dias a surpresa do DI mistura o Copom com a divulgação. É contaminação
contemporânea, que a ortogonalização pré-evento não trata por construção, e fica registrada só como
contagem.

## 4. Resultado final: passos 1 e 2

Coeficientes com EP HC1, N = 102, 13 parâmetros (`output/instrument/bs_orthogonalization.csv`):

| | DI (1) | Ibovespa (2) |
|---|---|---|
| `R²` | **0,273** | 0,099 |
| Wald conjunta (12 preditores), p | **0,009** | 0,273 |
| Wald só do bloco macro (4), p | 0,159 | 0,982 |
| revisão Focus da Selic | **9,24 (2,23)** | −0,40 (0,28) |
| surpresa do PIB | 6,17 (3,16), t 1,95 | −0,06 (0,40) |
| surpresa do IPCA | 3,63 (14,4) | 0,84 (1,85) |
| aceleração do núcleo | −0,75 (0,63) | −0,01 (0,07) |
| IPCA esperado | 5,05 (4,60) | −0,26 (0,60) |

- **O bloco macro não é significativo em conjunto** (p 0,159 no DI). A surpresa do PIB é a única
  perto de 10%, com o sinal de BS: notícia de crescimento maior antecede surpresa de aperto. A
  previsibilidade continua vindo da revisão Focus da Selic.
- O `R²` passa de 0,227 a 0,273 com o bloco.
- A notícia de IPCA se correlaciona com a revisão da Selic (0,31) e com o IPCA esperado (0,44).
  Parte dela já estava nos preditores Focus, como a pendência antecipava.

Instrumento e força, contra `main` (`instrument_diagnostics.csv` e `mosw_strength_grid.csv`):

| | `main` | branch (passos 1 e 2) |
|---|---|---|
| reuniões monetárias / informacionais | 67 / 35 | 60 / 42; 23 trocam (15 monetárias → informação, 8 ao contrário) |
| 2020-03-19 (pânico COVID) | fora da máscara | fora da máscara |
| cor. mensal com `main`: `z_bs_purif` / `z_jk_bs_purif` | — | 0,885 / 0,769 |
| ξ_mp cheia: bruta / ortog. / produção | 6,68 / 6,16 / 6,85 | 6,68 / **3,21** / **1,78** |
| F_rob,mp cheia: ortog. / produção | 7,89 / 11,77 | 3,04 / 1,81 |
| ξ_mp pré-COVID: bruta / ortog. / produção | 6,66 / 6,32 / 8,64 | 6,66 / 3,77 / 3,22 |
| grade cheia, `z_jk_bs_purif` (12 células `r=4:6`) | — | máx. 3,83; **nenhuma** acima de 3,84 |
| grade pré-COVID, `z_jk_bs_purif` (25 células) | — | 17 acima de 3,84 |

## 5. Consequências a jusante

**Os conjuntos de 90% deixam de ser limitados.** `irf_coherence_check.R` foi re-rodado com o
instrumento da branch (commit `563f797`). ξ_mp de produção é 1,78, abaixo do crítico de 90% (2,71) e
acima do de 68% (0,99). Por isso:
- os conjuntos de 68% seguem `interval` (2841 + o `singleton` da normalização);
- os de 90% viram **2160 `real_line` e 681 `two_rays`**, sem nenhum intervalo;
- a guarda de `irf_coherence_check.R` (conjunto limitado ⇔ ξ_mp > crítico) passa;
- as células significativas a 90%, lidas pela topologia, caem de 808 para 209: 208 `two_rays` com
  o zero no vão e o `singleton` da normalização.

**Os pontos crescem**, como a armadilha `denom_vs_prod` de `.claude/rules/instrument.md` prevê: com o
denominador da normalização menor, parte da magnitude é aritmética. Impactos nas unidades da §4,
`main` → branch:

| série | `main` | branch | conjunto 90% da branch |
|---|---|---|---|
| DI 2 anos (p.b.) | 70,1 | 103 | `two_rays` |
| DI 5 anos (p.b.) | 72,9 | 145 | `two_rays` |
| Câmbio BRL/USD (%) | 3,23 | 6,09 | `real_line` |
| CDS 5 anos (p.b.) | 30,5 | 85,1 | `two_rays` |
| IBC-Br (%) | −0,67 | −2,95 | `two_rays` |
| IPCA (p.p. ao mês) | −0,045 | −0,062 | `real_line` |
| Ibovespa (%) | −1,50 | −15,7 | `two_rays` |
| DLSP (p.p. do PIB) | −0,67 | −1,56 | `two_rays` |

- Nas oito séries até h36, **104 de 296 pontos** da branch saem do conjunto de 90% de `main`; nas
  58 variáveis, 934 de 2146.
- Sete das 58 trocam de sinal em h0.
- O formato também muda. O DI de 2 anos atinge o pico em h1 (140 p.b.) e fica negativo a partir de
  h9; em `main` o pico é em h3 e o sinal só inverte em h14.

**O Anexo D não pode ser redesenhado.** `instrument_layers_irf.R` para em `stop_unless_interval_sets()`
já na camada de produção e não grava nada. A figura sombreia bandas, e um conjunto `real_line` não
tem banda. `fig:instrumento_camadas` e `instrument_layers_irf.csv` ficam como em `main`.

**Validadores.** Os cinco que rodam sobre fixture passam: `amengual_watson`, `hac_kernel`,
`het_cv`, `mosw_ar` e `olea_kilian`. Falham, como esperado nesta branch, os dois que fixam números
calculados com o instrumento de produção:
- `validate_production_spec.R` para em "The recalculated initial production-instrument values
  changed";
- `validate_covid_volatility.R` para no N2, cujo ponto sem tratamento é estimado com
  `data/processed/instrument.csv`. As checagens depois do N2 não rodaram na branch.

## 6. Leitura

**A força do instrumento de produção estava no componente previsível da surpresa.** Estimada como BS
estimam, na amostra de reuniões, a ortogonalização remove exatamente o que carregava a relevância: a
parte da surpresa antecipada pela revisão Focus da Selic. Nenhuma das duas camadas ortogonalizadas
passa de 3,84 na janela cheia, em nenhuma célula `(r, q)` da grade (máximos 3,63 e 3,83). A
surpresa bruta, que não passa pela regressão, segue em 6,68. Pela leitura de BS, esse componente é o que
contamina: o mercado subestima a resposta do Copom às notícias, a surpresa carrega essa notícia, e a
notícia também move as variáveis de resposta.

O bloco macro não é o que derruba a força; o passo 1 sozinho já leva ξ_mp de produção a 2,43. O
bloco é fraco em conjunto, mas move os resíduos. A camada ortogonalizada, que não tem máscara, sobe de
2,22 para 3,21. A de produção, que também troca a composição da máscara, cai de 2,43 para 1,78.

⚠ **O que esta rodada não mostra**:
- que a revisão da Selic é contaminação e não informação legítima de política. BS tratam a
  previsibilidade como contaminação, e a branch segue BS;
- se a queda sobrevive a uma janela de revisão Focus diferente de 20 pregões ou à retirada desse
  preditor. Não foi testado, e seria o próximo exercício se o autor quiser separar o preditor da
  especificação.

## 7. O que a promoção tocaria

Se a construção da branch virar produção:
- `tab:first_stage` e §3.3 (a frase do `R²` de 0,022 "sem contrapartida diária" deixa de valer;
  67/35 viram 60/42);
- `tab:bs_ortogonalizacao` (nova amostra, novo bloco, duas Walds);
- a §3.4, com ξ_mp abaixo de 3,84 e os conjuntos de 90% ilimitados;
- a §4 inteira: 140 números e oito figuras, que hoje sombreiam bandas de 90%;
- os Anexos C e D, cujas figuras exigem conjuntos `interval`;
- o benchmark VAR, que usa o mesmo instrumento;
- os pins de `validate_production_spec.R` e do N2 de `validate_covid_volatility.R`;
- o smoke test e a especificação do `CLAUDE.md`;
- o resumo, a introdução e a conclusão.

Com ξ_mp 1,78, os conjuntos de 90% são ilimitados em toda a §4. A significância a 90% passaria a vir
só de conjuntos `two_rays` com o zero no vão, que a regra da topologia conta, mas que nenhuma figura
atual consegue desenhar como banda.

## 8. Código

- `R/instrument/build_variants.R`:
  - as regressões rodam em `events`, as 102 reuniões, sem tendência;
  - `daily` devolve `events`;
  - o bloco macro é construído por joins de desigualdade: `between()` para a janela entre reuniões
    e `closest()` para a mediana do próximo IPCA;
  - a guarda de `NA` cobre os prefixos `pre_` e `news_`, de modo que um PIB não lido do PDF chega a
    ela como `NA` (`values_fill` só preenche a ausência de divulgação).
- `script/instrument.R`:
  - lê os dois insumos novos;
  - `copom_event_diagnostics.csv` tem 102 linhas e perdeu `copom_day`;
  - `bs_orthogonalization.csv` ganhou `macro_f` e `macro_p`.
- `script/download_macro_news.R` é novo, e `script/run_all.R` ganhou o estágio `macro_news` e os
  insumos novos do estágio `instrument`.
