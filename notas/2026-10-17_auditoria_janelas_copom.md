# Auditoria das janelas do Copom: a tabela corrigida e a comparação das três bases

> **CURRENT — 2026-10-17.** Resposta ao e-mail do orientador de 17-10
> (`email/email_professor_17-10_10h54.md`), que fecha a auditoria das janelas. Branch
> `feature/auditoria-janelas-copom`, criada a partir de `feature/focus-horizonte-fixo` (`3676c20`),
> **não mergeada**.
> - **A produção da branch mudou.** As 2 reuniões de Ação de Graças entram no instrumento (102 → 104), e a
>   regressão Bauer-Swanson é refeita sobre as 104. Os pinos dos validadores e o smoke test foram
>   refixados.
> - Decisões do autor em 17-10, antes de rodar:
>   - só as 2 de Ação de Graças voltam à amostra principal. As 7 de feriado no Brasil são a terceira
>     coluna da comparação e, fora dela, ficam com z = 0;
>   - uma cotação é ambígua quando fica a 30 minutos ou menos do anúncio, ou quando a ordem não pode ser
>     estabelecida;
>   - na base anterior e na de 104, os meses das reuniões que ficam de fora têm z = 0, como nas rodadas
>     de influência e de extremos;
>   - o Ibovespa das 7, que só alimenta o filtro JK, segue a janela do DI;
>   - o filtro `drop_na(delta_di, r_ibov, r_sp500, d_vix, r_brent)` sai inteiro.
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
| 2. Classificar cada cotação como pré, pós ou ambígua | Cada ponta de cada janela, nas 111 reuniões (`quote_classification.csv`) e nas 9 (`excluded_meetings_advisor.csv`). |
| 2. Documentar o encerramento do DI1 e dizer se a série é o último negócio ou o ajuste | Seção 2. |
| 2. Dizer se os horários do Yahoo e do CDS são documentados pelo provedor | São hipóteses, e a tabela as marca assim (seção 2). |
| 2. A correspondência com Brasília em cada data | Pelo fuso de cada data. As quatro contas do orientador batem (seção 3). |
| 3. As 2 de Ação de Graças de volta, com o filtro ajustado e sem preencher controle com zero | Seção 4. |
| 3. Conferir o CDS e o Yahoo nos feriados dos EUA | Têm observação própria (seção 4). |
| 3. Reconstruir as 7 de quarta a sexta, com o mesmo contrato | Seção 4. |
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

**Nas 111 reuniões** (janelas):

| série | janela | contém o anúncio | ambígua |
|---|---|---|---|
| DI | fechamento de quarta ao primeiro pregão seguinte | 69 | 42 |
| PTAX | a de quarta à primeira seguinte | 111 | 0 |
| Yahoo | convenção, pela hora inferida | 80 | 31 |
| Yahoo | larga, da linha de terça à de quinta | 99 | 12 |
| CDS | estreita, 17h de NY | 61 | 50 |
| CDS | ampliada | 111 | 0 |

- **DI.** As 42 ambíguas são todas a ponta de quarta, sempre no período de anúncio às 18h:
  - 2016-07 a 2018-12: 20 de 20, contra o limite de 18h15;
  - 2019 a 2022-12: 16 de 32;
  - desde 2022-12: 6 de 24.

  Antes de 2016-07, com anúncio a partir das 19h19, as 35 contêm o anúncio.
- **Yahoo largo.** As 12 ambíguas são anteriores a 2016-07 e caem no inverno europeu. A linha de quinta
  traz a noite de quarta, às 22h, antes do fim do intervalo.
- **As quatro contas do orientador** batem, e as quatro reuniões ficam ambíguas no CDS estreito:

  | reunião | data | CDS de quarta em Brasília | anúncio | situação |
  |---|---|---|---|---|
  | 179ª | 27/11/2013 | 20h | 20h07 (limite inferior) | 7 min antes |
  | 195ª | 25/11/2015 | 20h | 19h47 (limite inferior) | 13 min depois, sem teto |
  | 209ª | 06/09/2017 | 18h | 18h00 | coincide |
  | 223ª | 19/06/2019 | 18h | 18h05 | 5 min antes |

  O script confere as quatro.

**Nas 9 reuniões da tabela** (classe da janela):

| reunião | amostra | DI | PTAX | Yahoo, convenção | Yahoo, larga | CDS, estreita | CDS, ampliada |
|---|---|---|---|---|---|---|---|
| 175ª | sensibilidade | contém | contém | ambígua | contém | contém | contém |
| 179ª | principal | contém | contém | ambígua | ambígua | ambígua | contém |
| 191ª | sensibilidade | contém | contém | ambígua | contém | contém | contém |
| 195ª | principal | contém | contém | ambígua | ambígua | ambígua | contém |
| 209ª | sensibilidade | ambígua | contém | contém | contém | ambígua | contém |
| 223ª | sensibilidade | ambígua | contém | contém | contém | ambígua | contém |
| 247ª | sensibilidade | contém | contém | contém | contém | contém | contém |
| 258ª | sensibilidade | ambígua | contém | contém | contém | ambígua | contém |
| 271ª | sensibilidade | contém | contém | contém | contém | contém | contém |

A janela ampliada do CDS contém o anúncio nas 9. Nas reuniões em que o CDS estreito é ambíguo, ela é a
conferência.

## 4. As reuniões recuperadas

**Ação de Graças (179ª e 195ª).**
- Entram na amostra principal com a janela habitual, de quarta a quinta.
- O filtro que as tirava exigia a variação de S&P 500, VIX e Brent na quinta, que não entra em regressão
  alguma. Ele saiu inteiro, junto com o cálculo dessas variações.
- A amostra passa a ser o conjunto das reuniões do Copom com surpresa de DI medida. Uma reunião sem
  surpresa ou com preditor ausente aborta o script. Nada é preenchido com zero.
- Fora delas, as surpresas brutas das 102 saem iguais bit a bit, e `z_bruto` muda só em 2013-11 e 2015-11.
- A regressão BS refeita sobre as 104 dá R² 0,119, Wald conjunto p 0,148 e bloco macro p 0,066. Sobre as
  102 dava 0,124, 0,122 e 0,059.

**O CDS e o Yahoo nos feriados dos EUA têm observação própria.** Nenhuma cotação de sexta substitui a do
feriado, e o script confere isso.
- 28/11/2013 (Thanksgiving): CDS 205,0, contra 205,168 na quarta. ⚠ É um valor redondo.
- 26/11/2015 (Thanksgiving): CDS 426,274, contra 423,523.
- 19/06/2025 (Juneteenth): CDS 158,872, contra 157,823.
- O Yahoo tem cotação nas três datas, lidas em Brasília.

**As 7 de feriado no Brasil.**
- A surpresa vai do fechamento de quarta ao de sexta, com o mesmo contrato e a regra de vencimento de
  sempre (`build_event_surprises()`), e reproduz as variações da conferência 1/4.
- O Ibovespa usa a mesma janela.
- Os controles da ortogonalização são tendências de 65 pregões que terminam no fechamento de quarta, no
  início da janela, e não mudam com a duração dela.
- `copom_event_diagnostics.csv` marca a janela longa (`long_window`).
- As 111 têm surpresa medida. Nenhuma fica ausente.

## 5. A comparação

DFM de produção, `(5,5,4)`, escala de Lenza-Primiceri, janela cheia. Muda só o instrumento, o `z_bs_purif`
de cada base, com a regressão BS refeita na própria amostra. Impacto de +50 p.b. em `yield_6m`, com os
conjuntos Anderson-Rubin de 80 e 90% (`output/copom_windows/comparison.csv`).

| base | reuniões | ξ_mp | F_rob | câmbio h0 (R$/US$) | 80% | 90% | CDS h0 (p.b.) | 80% | 90% |
|---|---|---|---|---|---|---|---|---|---|
| anterior | 102 | 6,661 | 8,068 | 0,145 | [0,087; 0,231] | [0,068; 0,281] | 33,5 | [19,5; 54,3] | [15,0; 66,4] |
| + Ação de Graças (produção) | 104 | 6,549 | 7,917 | 0,136 | [0,077; 0,221] | [0,056; 0,269] | 32,4 | [18,3; 53,2] | [13,7; 65,2] |
| + 7 de feriado | 111 | 7,282 | 9,344 | 0,125 | [0,069; 0,194] | [0,048; 0,228] | 30,6 | [17,4; 47,9] | [12,9; 56,8] |

- Câmbio e CDS são significantes a 90% nas três bases, com o mesmo sinal.
- Com as 2 de Ação de Graças, o câmbio cai 6% (0,145 → 0,136) e o CDS 3% (33,5 → 32,4). O ξ_mp passa
  de 6,66 a 6,55.
- Com as 7 de feriado, o câmbio cai mais 8% (0,125) e o CDS mais 6% (30,6). O ξ_mp sobe a 7,28, e os
  conjuntos de 90% ficam mais estreitos.
- Todo conjunto é um intervalo. Os três ξ_mp ficam abaixo de 10.
- ⚠ **Pré-COVID, a produção nova enfraquece:** ξ_mp 5,597 → 3,770 e F_rob 5,161 → 3,300, ambos abaixo de
  3,84 (`validate_production_spec.R`). As 2 reuniões são de 2013 e 2015, dentro dessa janela. A
  comparação pedida é a da janela cheia, e o pré-COVID não foi calculado na base de 111.
- O smoke test (h0, produção nova) dá `yield_6m` 0,005, `yield_2y` 0,0070302063989873959, `yield_5y`
  0,0074823305079855466, `asset_ibov` −1,3189930569660355 e `cambio_usd` 0,13632013559132808.

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
- Não pode: dizer que a força do instrumento se mantém na janela pré-COVID. Lá o ξ_mp cai a 3,77.

## 7. O que mudou

- `R/instrument/di_surprise.R`:
  - `build_thursday_surprises()` virou `build_event_surprises()`, com as datas pré e pós explícitas;
  - `R/identification/het_tests.R` passou a chamá-la com quarta e quinta, o mesmo cálculo de antes.
- `R/instrument/build_variants.R`:
  - a amostra são as reuniões, não as quintas;
  - a surpresa vai até o primeiro pregão de DI;
  - argumento obrigatório novo, `holiday_windows`;
  - o filtro de S&P 500, VIX e Brent e `diag$n_thursdays`/`n_valid` saíram, sem leitores.
- `script/instrument.R`:
  - escreve a produção (104) e `data/processed/instrument_holiday_windows.csv` (111);
  - `copom_event_diagnostics.csv` ganhou `wednesday` e `long_window`.
- `script/copom_timing.R`:
  - intervalo do anúncio, grade do DI1, classificação e a saída nova `quote_classification.csv`;
  - CDS ampliado na leitura do orientador;
  - tabela das 9 com o status de cada uma e a conferência dos feriados dos EUA;
  - `N_EVENTS` 104.
- `script/copom_window_comparison.R`, novo. A base anterior sai da cópia congelada
  `output/copom_windows/instrument_base_102.csv` e reproduz os pinos antigos (ξ_mp a 2e-11, câmbio bit a
  bit). A célula de 104 reproduz `irf_coherence_cell.rds`.
- Rodaram de novo `instrument.R`, `irf_coherence_check.R`, `copom_timing.R` e os sete validadores (pinos
  de `validate_production_spec.R` e `validate_covid_volatility.R` refixados, os antigos nos comentários).
