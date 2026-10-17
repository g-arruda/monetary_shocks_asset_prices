# Auditoria das janelas do Copom: a tabela corrigida e a comparação das três bases

> **CURRENT — 2026-10-17.** Resposta ao e-mail do orientador de 17-10
> (`email/email_professor_17-10_10h54.md`), que fecha a auditoria das janelas. Branch
> `feature/auditoria-janelas-copom`, criada a partir de `feature/focus-horizonte-fixo` (`3676c20`),
> **não mergeada**.
> - **A produção da branch mudou: o instrumento tem as 111 reuniões.** As 2 de Ação de Graças entram com
>   a janela de quarta a quinta, e as 7 de véspera de feriado no Brasil com a janela de quarta a sexta. A
>   regressão Bauer-Swanson é refeita sobre as 111. A sensibilidade que o e-mail pede é a base de 104, sem
>   as 7 janelas longas. Os pinos dos validadores e o smoke test foram refixados.
> - Decisões do autor em 17-10:
>   - as 111 são a amostra principal, e a de 104 é a sensibilidade (linha 29 do e-mail). A primeira
>     decisão do dia, 104 na produção, foi revista na releitura do e-mail;
>   - uma cotação é ambígua quando fica a 30 minutos ou menos do anúncio, ou quando a ordem não pode ser
>     estabelecida;
>   - na base anterior e na de 104, os meses das reuniões que ficam de fora têm z = 0, como nas rodadas
>     de influência e de extremos;
>   - o Ibovespa das 7, que só alimenta o filtro JK, segue a janela do DI;
>   - o filtro `drop_na(delta_di, r_ibov, r_sp500, d_vix, r_brent)` sai inteiro;
>   - saem o que o e-mail não pede: o F_rob da comparação, a classificação das 111 reuniões
>     (`quote_classification.csv`) e a janela do Yahoo pela convenção na tabela das 9;
>   - a tabela das 9 vai sem as datas pré e pós, que estão nos horários, sem o país do feriado e com o
>     status do horário enxuto: no Yahoo e no CDS, "não documentado" pelo provedor. Que esses horários
>     são hipóteses o e-mail diz.
> - A regra de classificação foi commitada antes de rodar (`8edc3a2`).
> - Scripts: `script/copom_timing.R`, `script/instrument.R` e `script/copom_window_comparison.R` (novo).
>   Funções: `R/instrument/build_variants.R` e `R/instrument/di_surprise.R`.
> - ⚠ As saídas a jusante não rodaram de novo e estão na base de 102: `ar_precision`, `daily_event`, as
>   duas pontes, influência, placebos, `mosw_strength_grid`, `model_var`, `instrument_diagnostics` e os
>   anexos. O e-mail diz que não é preciso repetir influência e placebos agora.

## 1. O que o e-mail pede e o que foi feito

| item do e-mail | feito |
|---|---|
| 1. A janela ampliada do CDS é a estreita com uma variação a mais de cada lado | É a leitura "estreita mais um" de 16-10: de terça a sexta, ou de segunda a quinta quando a estreita vai de terça a quarta, no calendário do CDS. A leitura "larga" saiu do código. |
| 2. O anúncio como intervalo onde só há o término da ata | [término da ata, primeira notícia do G1] nas 3 da lista da Bloomberg (174ª, 186ª, 196ª). Nas outras 32 anteriores a 2016-07, [término da ata, fim da quarta]. |
| 2. Classificar cada cotação como pré, pós ou ambígua | Cada ponta de cada janela das 9 reuniões (`excluded_meetings_advisor.csv`). |
| 2. Documentar o encerramento do DI1 e dizer se a série é o último negócio ou o ajuste | Seção 2. |
| 2. Dizer se os horários do Yahoo e do CDS são documentados pelo provedor | São hipóteses, e a tabela as marca assim (seção 2). |
| 2. A correspondência com Brasília em cada data | Pelo fuso de cada data. As quatro contas do orientador batem (seção 3). |
| 3. As 2 de Ação de Graças de volta, com o filtro ajustado e sem preencher controle com zero | Seção 4. |
| 3. Conferir o CDS e o Yahoo nos feriados dos EUA | Têm observação própria (seção 4). |
| 3. Recuperar as 7 de quarta a sexta, com o mesmo contrato, e apresentar a exclusão delas como sensibilidade | Seção 4. |
| 4. A tabela corrigida e a comparação das três bases | Seções 3 e 5. |

## 2. Os horários

| série | o que é a cotação | horário | status |
|---|---|---|---|
| DI | `CloseRate`, o **último negócio** do dia (coluna "ÚLT. PREÇO" do boletim da B3, pelo mapeamento de `pyield/b3/futures/historical/historical_bmf.py`), não o ajuste (`SettlementRate`, "AJUSTE") | no máximo o fim do pregão | ver a grade abaixo |
| PTAX | média das consultas das 10h às 13h | 13h | documentado (Circular 3.506) |
| Yahoo `BRL=X` | taxa na meia-noite de Londres que abre a barra | 20h em Brasília no verão europeu, 21h–22h fora dele | **hipótese**, inferida dos dados; o Yahoo não documenta o horário |
| CDS 5 anos | `PX_LAST` da Bloomberg | 17h de Nova York | **hipótese**, decisão do autor de 14-10; o arquivo não traz a fonte de preço nem o horário |

**O fim do pregão do DI1:**

| período | fim do pregão | status | fonte |
|---|---|---|---|
| 2012-03 a 2018-12 | 18h15 | limite superior: é o fim do segmento BM&F, porque a grade do DI1 não foi encontrada | Exame, 19/10/2012; Jornal do Comércio, 14/10/2016 |
| 2019-01 a 2022-12-09 | 18h00, com a sessão estendida de 16h50 a 18h00 | documentado | grade da B3 arquivada no Wayback Machine de 2019-01-07 a 2022-01-24; os ofícios do horário de verão dos EUA deixam o DI1 inalterado (OC 094/2020-PRE) |
| desde 2022-12-12 | 18h00, negociação contínua das 9h às 18h | documentado | grade atual da B3; InfoMoney, 23/11/2022 |

- O ajuste fica antes do anúncio em todo o período. Até 2022-12 ele saía do call de fechamento a partir
  das 16h10; desde então sai do VWAP das 16h10 às 16h20.
- O último negócio pode sair antes do fim do pregão. Por isso o fim do pregão é o limite superior do
  horário da cotação de quarta.

## 3. A classificação

A regra (`8edc3a2`):
- uma cotação é **pré** se vem antes do início do intervalo do anúncio menos 30 minutos;
- é **pós** se vem depois do fim do intervalo mais 30 minutos;
- é **ambígua** em qualquer outro caso;
- uma janela é ambígua se uma das pontas for ambígua.

**As quatro contas do orientador** batem, e as quatro reuniões ficam ambíguas no CDS estreito:

| reunião | data | CDS de quarta em Brasília | anúncio | situação |
|---|---|---|---|---|
| 179ª | 27/11/2013 | 20h | 20h07 (limite inferior) | 7 min antes |
| 195ª | 25/11/2015 | 20h | 19h47 (limite inferior) | 13 min depois, sem teto |
| 209ª | 06/09/2017 | 18h | 18h00 | coincide |
| 223ª | 19/06/2019 | 18h | 18h05 | 5 min antes |

O script confere as quatro.

**Nas 9 reuniões da tabela** (classe da janela), todas na amostra principal:

| reunião | janela do DI | DI | PTAX | Yahoo, de terça a quinta | CDS, estreita | CDS, ampliada |
|---|---|---|---|---|---|---|
| 175ª | quarta a sexta | contém | contém | contém | contém | contém |
| 179ª | quarta a quinta | contém | contém | ambígua | ambígua | contém |
| 191ª | quarta a sexta | contém | contém | contém | contém | contém |
| 195ª | quarta a quinta | contém | contém | ambígua | ambígua | contém |
| 209ª | quarta a sexta | ambígua | contém | contém | ambígua | contém |
| 223ª | quarta a sexta | ambígua | contém | contém | ambígua | contém |
| 247ª | quarta a sexta | contém | contém | contém | contém | contém |
| 258ª | quarta a sexta | ambígua | contém | contém | ambígua | contém |
| 271ª | quarta a sexta | contém | contém | contém | contém | contém |

- A janela ampliada do CDS contém o anúncio nas 9. Nas reuniões em que o CDS estreito é ambíguo, ela é a
  conferência.
- Nas três em que o DI é ambíguo (209ª, 223ª, 258ª), o anúncio sai às 18h00, 18h05 e 18h30, a 30
  minutos ou menos do fim do pregão.

## 4. As reuniões recuperadas

**Ação de Graças (179ª e 195ª).**
- Entram na amostra principal com a janela habitual, de quarta a quinta.
- O filtro que as tirava exigia a variação de S&P 500, VIX e Brent na quinta, que não entra em regressão
  alguma. Ele saiu inteiro, junto com o cálculo dessas variações.
- A amostra passa a ser o conjunto das reuniões do Copom com surpresa de DI medida. Uma reunião sem
  surpresa ou com preditor ausente aborta o script. Nada é preenchido com zero.
- As surpresas brutas das 102 saem iguais bit a bit.

**O CDS e o Yahoo nos feriados dos EUA têm observação própria.** Nenhuma cotação de sexta substitui a do
feriado, e o script confere isso.
- 28/11/2013 (Thanksgiving): CDS 205,0, contra 205,168 na quarta. ⚠ É um valor redondo.
- 26/11/2015 (Thanksgiving): CDS 426,274, contra 423,523.
- 19/06/2025 (Juneteenth): CDS 158,872, contra 157,823.
- O Yahoo tem cotação nas três datas, lidas em Brasília.

**As 7 de feriado no Brasil.**
- Entram na amostra principal. A surpresa vai do fechamento de quarta ao de sexta, com o mesmo contrato
  e a regra de vencimento de sempre (`build_event_surprises()`), e reproduz as variações da conferência
  1/4.
- O Ibovespa usa a mesma janela.
- Os controles da ortogonalização são tendências de 65 pregões que terminam no fechamento de quarta, no
  início da janela, e não mudam com a duração dela.
- `copom_event_diagnostics.csv` e `meetings.csv` marcam a janela longa (`long_window`).
- As 111 têm surpresa medida. Nenhuma fica ausente.
- A sensibilidade sem elas (`holiday_windows = FALSE`) vai para
  `data/processed/instrument_no_holiday_windows.csv`, com os 7 meses em z = 0.

**A regressão BS** refeita sobre as 111 dá R² 0,094, Wald conjunto p 0,232 e bloco macro p 0,148. Sobre
as 102 dava 0,124, 0,122 e 0,059.

## 5. A comparação

DFM de produção, `(5,5,4)`, escala de Lenza-Primiceri, janela cheia. Muda só o instrumento, o `z_bs_purif`
de cada base, com a regressão BS refeita na própria amostra. Impacto de +50 p.b. em `yield_6m`, com os
conjuntos Anderson-Rubin de 80 e 90% (`output/copom_windows/comparison.csv`).

| base | reuniões | ξ_mp | câmbio h0 (R$/US$) | 80% | 90% | CDS h0 (p.b.) | 80% | 90% |
|---|---|---|---|---|---|---|---|---|
| anterior | 102 | 6,661 | 0,145 | [0,087; 0,231] | [0,068; 0,281] | 33,5 | [19,5; 54,3] | [15,0; 66,4] |
| + Ação de Graças (sensibilidade) | 104 | 6,549 | 0,136 | [0,077; 0,221] | [0,056; 0,269] | 32,4 | [18,3; 53,2] | [13,7; 65,2] |
| + 7 de feriado (produção) | 111 | 7,282 | 0,125 | [0,069; 0,194] | [0,048; 0,228] | 30,6 | [17,4; 47,9] | [12,9; 56,8] |

- Câmbio e CDS são significantes a 90% nas três bases, com o mesmo sinal.
- Com as 2 de Ação de Graças, o câmbio cai 6% (0,145 → 0,136) e o CDS 3% (33,5 → 32,4). O ξ_mp passa
  de 6,66 a 6,55.
- Com as 7 de feriado, o câmbio cai mais 8% (0,125) e o CDS mais 6% (30,6). O ξ_mp sobe a 7,28, e os
  conjuntos de 90% ficam mais estreitos.
- Todo conjunto é um intervalo. Os três ξ_mp ficam abaixo de 10.
- Os números das três células são os mesmos da primeira passada do dia, quando a produção era a de 104.
  Só mudou qual base é a produção.
- Na janela pré-COVID, fora da comparação pedida, a produção de 111 tem ξ_mp 4,874 e F_rob 4,456
  (`validate_production_spec.R`). Na base de 102 eram 5,597 e 5,161.
- O smoke test (h0, produção de 111) dá `yield_6m` 0,005, `yield_2y` 0,0069287523305703071, `yield_5y`
  0,0072664956806669234, `asset_ibov` −0,79437838165600416 e `cambio_usd` 0,12500959582800081.

## 6. O que pode e o que não pode ser dito

- Pode: nas três bases, câmbio e CDS sobem no impacto e são significantes a 90%. As correções reduzem os
  dois impactos em até 14% e 9% e não mudam o sinal.
- Pode: a cotação de quarta do DI é o último negócio, que sai no máximo às 18h00 desde 2019. Com anúncio
  entre 18h00 e 18h30, a ordem entre o fim do pregão e o comunicado não fica estabelecida pela regra dos
  30 minutos.
- Não pode: dizer que o Yahoo cota à meia-noite de Londres ou que o CDS fecha às 17h de Nova York. São
  hipóteses.
- Não pode: dizer que o DI1 fechava às 18h15 antes de 2019. É o limite do segmento BM&F, por fonte
  secundária.
- Não pode: ler a janela de quarta a sexta das 7 como janela estreita. Ela incorpora mais um dia de
  notícias.

## 7. O que mudou

- `R/instrument/di_surprise.R`:
  - `build_thursday_surprises()` virou `build_event_surprises()`, com as datas pré e pós explícitas;
  - `R/identification/het_tests.R` passou a chamá-la com quarta e quinta, o mesmo cálculo de antes.
- `R/instrument/build_variants.R`:
  - a amostra são as reuniões, não as quintas;
  - a surpresa vai até o primeiro pregão de DI;
  - argumento obrigatório novo, `holiday_windows`; a produção passa `TRUE`;
  - o filtro de S&P 500, VIX e Brent e `diag$n_thursdays`/`n_valid` saíram, sem leitores.
- `script/instrument.R`:
  - escreve a produção (111) e `data/processed/instrument_no_holiday_windows.csv` (104);
  - `copom_event_diagnostics.csv` ganhou `wednesday` e `long_window`.
- `script/copom_timing.R`:
  - intervalo do anúncio, grade do DI1 e classificação, que sai só na tabela das 9;
  - CDS ampliado na leitura do orientador;
  - tabela das 9 com o status de cada uma e a conferência dos feriados dos EUA;
  - os eventos são chaveados pela quarta, e as 111 estão neles. O teste do fechamento contra o ajuste do
    DI fica nos 104 pares de quarta a quinta, e o teste (C) do CDS passa às 111.
- `script/copom_window_comparison.R`, novo. A base anterior sai da cópia congelada
  `output/copom_windows/instrument_base_102.csv` e reproduz os pinos antigos (ξ_mp a 2e-11, câmbio bit a
  bit). A célula de 111 reproduz `irf_coherence_cell.rds`.
- Rodaram de novo `instrument.R`, `irf_coherence_check.R`, `copom_timing.R` e os sete validadores (pinos
  de `validate_production_spec.R` e `validate_covid_volatility.R` refixados, os antigos nos comentários).
