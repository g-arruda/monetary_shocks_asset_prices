# Conferência 1/4: as 9 reuniões fora das 102, horários, janelas e feriados

> **CURRENT — 2026-10-15.** Primeira entrega da conferência do e-mail do orientador de 14-10
> (`email/email_professor_14-10_17h44.md`, "Entrega desta conferência", item 1). Branch
> `feature/focus-horizonte-fixo`, **não mergeada**.
> - Nada foi reestimado. Instrumento, painel e produção ficaram intocados, e o smoke test sai
>   bit-idêntico ao da branch (câmbio `0.1448646415797471`).
> - Decisões do autor em 15-10, antes de rodar:
>   - "reuniões afetadas", que o e-mail não define, são as 9 que ficam fora das 102;
>   - a janela larga do Yahoo vai da linha datada terça à linha datada quinta, pelas datas das linhas e
>     pelo calendário do próprio Yahoo, sem usar a hora inferida;
>   - a janela ampliada do CDS fica fora desta entrega e espera uma pergunta ao orientador, porque o
>     e-mail não tem o item 2. A tabela traz só a janela estreita, com o fechamento às 17h de Nova York
>     (decisão de 14-10);
>   - a duração vai em dias de calendário e em cotações do próprio mercado em todas as janelas, e em
>     horas só onde o horário é documentado ou é hipótese declarada.
> - Os horários do Yahoo e do CDS seguem como hipóteses, à espera de dado melhor. As janelas saem de
>   `load_yahoo_brl()`, `CDS_CLOSE_NY` e `RELEASE_FLOORS`, e uma mudança neles pede só rodar de novo.
> - Script: `script/copom_timing.R`. Saída nova: `output/copom_timing/excluded_meetings.csv`.
>   `meetings.csv` ganhou colunas. Nada no `.tex` nem em `paper/img/`.

## 1. O que a tabela cobre

As 9 reuniões de 2012-03 a 2025-12 que ficam fora das 102 do instrumento, e cinco janelas por reunião:

| série | janela | pré | pós |
|---|---|---|---|
| DI | convenção | fechamento de quarta | primeiro pregão de DI depois do anúncio |
| PTAX de venda | convenção | a de quarta, apurada antes do anúncio | a primeira depois da quarta |
| Yahoo `BRL=X` | convenção | última cotação antes do anúncio, pela hora inferida | primeira depois dele |
| Yahoo `BRL=X` | larga | linha datada terça | linha datada quinta |
| CDS 5 anos | 17h de NY | último fechamento antes do anúncio, pela hipótese | primeiro depois dele |

- A PTAX e o Yahoo largo são as janelas do e-mail para a conferência 2/4. São janelas diárias mais
  amplas, que incorporam outras notícias.
- A tabela não tem a surpresa ortogonalizada, que exige refazer a regressão Bauer-Swanson
  (conferência 4/4).
- `meetings.csv` traz as mesmas colunas novas para as 111 reuniões: o status do anúncio, o contrato do
  DI, a PTAX e o Yahoo largo. A conferência 2/4 lê as janelas dali.

## 2. O horário de cada cotação

| série | horário | status |
|---|---|---|
| anúncio, 2012-03 a 2016-06 | término da última sessão de quarta, pela ata | limite inferior: o comunicado sai depois, a um intervalo não registrado |
| anúncio, desde 2016-07-20 | término da ata ou horário mínimo do BCB, o que vier depois | documentado (nota `2026-10-13_ponte_horarios_copom`, seção 2) |
| DI | fechamento do pregão (`CloseRate`) | desconhecido data a data: a grade da B3 não foi reconstruída; o BCB põe o anúncio depois do fechamento doméstico |
| PTAX | média das consultas das 10h às 13h | documentado (Circular 3.506); a duração é contada de 13h a 13h |
| Yahoo | meia-noite de Londres: 20h em Brasília no verão europeu, 21h–22h fora dele | inferido do carimbo das barras, não declarado pelo Yahoo |
| CDS | 17h de Nova York | hipótese, decisão do autor de 14-10; não está no arquivo |

O orientador não aceita o fuso da API como confirmação do horário do Yahoo (e-mail de 14-10). As horas
do Yahoo e do CDS abaixo valem só sob as hipóteses da tabela.

## 3. As reuniões, o feriado e o motivo

| reunião | quarta | anúncio | status do anúncio | feriado na quinta | DI e PTAX na quinta | Yahoo e CDS na quinta | S&P 500, VIX e Brent na quinta |
|---|---|---|---|---|---|---|---|
| 175ª | 2013-05-29 | 20h25 | limite inferior | Corpus Christi (Brasil) | não | sim | sim |
| 179ª | 2013-11-27 | 20h07 | limite inferior | Thanksgiving (EUA) | sim | sim | não |
| 191ª | 2015-06-03 | 20h06 | limite inferior | Corpus Christi (Brasil) | não | sim | sim |
| 195ª | 2015-11-25 | 19h47 | limite inferior | Thanksgiving (EUA) | sim | sim | não |
| 209ª | 2017-09-06 | 18h00 | documentado | Independência (Brasil) | não | sim | sim |
| 223ª | 2019-06-19 | 18h05 | documentado | Corpus Christi (Brasil) | não | sim | sim |
| 247ª | 2022-06-15 | 18h36 | documentado | Corpus Christi (Brasil) | não | sim | sim |
| 258ª | 2023-11-01 | 18h30 | documentado | Finados (Brasil) | não | sim | sim |
| 271ª | 2025-06-18 | 18h32 | documentado | Corpus Christi (Brasil) e Juneteenth (EUA) | não | sim | não |

**Os motivos são dois.**
- **7 reuniões, quinta feriado no Brasil.** Não há DI nem PTAX na quinta.
  `build_thursday_surprises()` exige uma cotação de DI na quinta de calendário, e a reunião cai da
  amostra.
- **2 reuniões, Thanksgiving.** DI, PTAX, Yahoo e CDS cotam na quinta, e as janelas da convenção são as
  do instrumento. As duas caem só porque falta a variação de S&P 500, VIX e Brent na quinta. Essa
  variação não entra em regressão alguma: serve apenas para fixar a amostra (`.claude/rules/instrument.md`).

**Feriados.** De terça a sexta, nas 9, os únicos dias sem DI ou sem S&P 500 são as quintas da tabela,
com o país indicado. O script trava isso contra os dados. O Yahoo e o CDS cotam nos 9 feriados.

## 4. As janelas

Horários em Brasília. Entre parênteses, a duração em dias de calendário e, onde há horário, em horas.
Toda janela cobre uma única cotação do próprio mercado, menos o Yahoo largo, que cobre duas linhas.

| reunião | DI | PTAX | Yahoo, convenção | Yahoo, larga | CDS, 17h NY |
|---|---|---|---|---|---|
| 175ª | qua → sex (2 d) | qua 13h → sex 13h (2 d, 48 h) | qua 20h → qui 20h (24 h) | ter 20h → qui 20h (48 h) | qua 18h → qui 18h (24 h) |
| 179ª | qua → qui (1 d) | qua 13h → qui 13h (1 d, 24 h) | ter 22h → qua 22h (24 h) | seg 22h → qua 22h (48 h) | qua 20h → qui 20h (24 h) |
| 191ª | qua → sex (2 d) | qua 13h → sex 13h (2 d, 48 h) | qua 20h → qui 20h (24 h) | ter 20h → qui 20h (48 h) | qua 18h → qui 18h (24 h) |
| 195ª | qua → qui (1 d) | qua 13h → qui 13h (1 d, 24 h) | ter 22h → qua 22h (24 h) | seg 22h → qua 22h (48 h) | ter 20h → qua 20h (24 h) |
| 209ª | qua → sex (2 d) | qua 13h → sex 13h (2 d, 48 h) | ter 20h → qua 20h (24 h) | ter 20h → qui 20h (48 h) | qua 18h → qui 18h (24 h) |
| 223ª | qua → sex (2 d) | qua 13h → sex 13h (2 d, 48 h) | ter 20h → qua 20h (24 h) | ter 20h → qui 20h (48 h) | qua 18h → qui 18h (24 h) |
| 247ª | qua → sex (2 d) | qua 13h → sex 13h (2 d, 48 h) | ter 20h → qua 20h (24 h) | ter 20h → qui 20h (48 h) | qua 18h → qui 18h (24 h) |
| 258ª | qua → sex (2 d) | qua 13h → sex 13h (2 d, 48 h) | ter 21h → qua 21h (24 h) | seg 21h → qua 21h (48 h) | qua 18h → qui 18h (24 h) |
| 271ª | qua → sex (2 d) | qua 13h → sex 13h (2 d, 48 h) | ter 20h → qua 20h (24 h) | ter 20h → qui 20h (48 h) | qua 18h → qui 18h (24 h) |

- **DI e PTAX.** Nas 7 de feriado no Brasil, a janela vai de quarta a sexta: dois dias de calendário e
  um único pregão, o que inclui o feriado, em que os mercados de fora operam. Nas 2 de Thanksgiving, de
  quarta a quinta.
- **Yahoo, convenção.** Na 175ª e na 191ª, com anúncio depois das 20h, a cotação posterior é a da noite
  de quinta, o feriado. Nas outras 7 é a da noite de quarta.
- **Yahoo, larga.** Pelas datas das linhas vai sempre de terça a quinta. Pela hora inferida, no inverno
  europeu (179ª, 195ª, 258ª) isso é da noite de segunda à de quarta. Contém o anúncio nas 111 reuniões
  (guarda do script).
- **CDS.** Na 195ª, o fechamento de quarta às 17h de NY (20h em Brasília) vem depois do anúncio
  (19h47), e a janela vai de terça a quarta. Nas outras 8, de quarta a quinta.

## 5. As variações e o contrato do DI

| reunião | ΔDI bruta (p.b.) | contrato (d.u. na quarta) | ΔPTAX, R$/US$ (%) | ΔYahoo convenção, R$/US$ (%) | ΔYahoo larga, R$/US$ (%) | ΔCDS 17h NY (p.b.) |
|---|---|---|---|---|---|---|
| 175ª | +37,0 | DI1F14 (152) | +0,0425 (+2,01) | +0,0004 (+0,02) | +0,0339 (+1,62) | −0,2 |
| 179ª | −19,0 | DI1N14 (146) | +0,0150 (+0,65) | +0,0332 (+1,44) | +0,0462 (+2,01) | −0,2 |
| 191ª | +9,0 | DI1Z15 (125) | +0,0500 (+1,59) | +0,0070 (+0,22) | +0,0116 (+0,37) | +4,3 |
| 195ª | +8,5 | DI1M16 (128) | −0,0082 (−0,22) | +0,0432 (+1,16) | +0,0105 (+0,28) | +23,9 |
| 209ª | −2,5 | DI1H18 (118) | −0,0225 (−0,73) | −0,0179 (−0,58) | −0,0182 (−0,59) | −3,6 |
| 223ª | −10,0 | DI1Z19 (116) | −0,0468 (−1,22) | −0,0241 (−0,63) | −0,0218 (−0,57) | −3,8 |
| 247ª | −1,0 | DI1Z22 (116) | +0,0194 (+0,38) | −0,0641 (−1,26) | −0,0639 (−1,26) | +12,9 |
| 258ª | −4,5 | DI1K24 (123) | −0,1284 (−2,59) | −0,0804 (−1,61) | −0,0924 (−1,85) | −9,1 |
| 271ª | +8,5 | DI1Z25 (116) | +0,0078 (+0,14) | −0,0078 (−0,14) | −0,0030 (−0,05) | +1,0 |

- **O contrato.** É o mais próximo de 126 d.u. cotado nos dois dias, o mesmo nas duas pontas por
  construção. Nas 102 ele vai de 106 a 154 d.u., com mediana 126 e percentil 95 de 146.
  - ⚠ Na 175ª, o DI1F14 está a 152 d.u., acima do percentil 95 das 102. Nas 7 de feriado, as janelas de
    quarta a sexta mantêm o contrato da quarta.
- **A variação do DI** é a surpresa bruta pela mesma função do instrumento, com a primeira sessão
  posterior no papel da quinta. ⚠ A 175ª tem +37 p.b., 2,8 desvios-padrão das 102, cujo máximo é +41.
- Os números da PTAX, do Yahoo pela convenção e do CDS reproduzem os das notas de 10-13
  (`2026-10-13_ponte_horarios_copom`, seção 6, e `2026-10-13_cambio_yahoo_convencao`, seção 5).

## 6. O que pode e o que não pode ser dito

- Pode: das 9 reuniões fora das 102, 7 caem porque a quinta é feriado no Brasil e não há DI nem PTAX
  nela. As 2 de Thanksgiving têm DI, PTAX, Yahoo e CDS na quinta e caem só pela falta da variação de
  S&P 500, VIX e Brent, que não entra em regressão alguma.
- Pode: nas 7 de feriado no Brasil, a janela da última cotação válida antes do anúncio à primeira depois
  vai, no DI e na PTAX, de quarta a sexta. São dois dias de calendário e um pregão, com o mesmo contrato
  de DI nas duas pontas.
- Pode: o anúncio é documentado nas 5 reuniões desde 2016-07 e é limite inferior nas 4 anteriores.
- Não pode: apresentar a janela do Yahoo pela convenção como estreita e comprovadamente anterior e
  posterior ao anúncio. A hora do Yahoo é inferida (e-mail de 14-10).
- Não pode: apresentar a PTAX ou o Yahoo largo como janelas estreitas. São janelas diárias mais amplas,
  que incorporam outras notícias.
- Não pode: dizer que o CDS fecha às 17h de Nova York. É hipótese.
- Não pode: ler as variações desta tabela como resposta à surpresa. Nenhuma regressão rodou, e a surpresa
  ortogonalizada dessas reuniões exige refazer a regressão Bauer-Swanson (conferência 4/4).

## 7. O que mudou

- `R/instrument/di_surprise.R`: `build_thursday_surprises()` devolve também o contrato que já escolhia
  (`ticker`, `bdays`). Com `script/instrument.R` rodado de novo, `data/processed/instrumentos_mensais.csv`,
  `copom_event_diagnostics.csv`, `instrument.csv` e `output/instrument/` saem byte-idênticos.
- `script/copom_timing.R`: constantes `PTAX_CLOCK` e `HOLIDAYS`, a janela da PTAX e a larga do Yahoo, o
  status do anúncio, o contrato do DI e a tabela `excluded_meetings.csv`.
  - `meetings.csv` ganhou `announcement_status`, `ptax_pre`, `ptax_post`, `d_ptax`, `d_ptax_pct`,
    `yahoo_wide_pre`, `yahoo_wide_post`, `yahoo_wide_pre_brasilia`, `yahoo_wide_post_brasilia`,
    `d_fx_wide`, `d_fx_wide_pct`, `di_contract` e `di_contract_bdays`. As colunas antigas saem iguais,
    e as demais saídas de `output/copom_timing/` não mudam.
  - Guardas novas: há PTAX em toda quarta e linha do Yahoo em toda terça e quinta; a janela larga do
    Yahoo contém o anúncio nas 111; os feriados de terça a sexta das 9 são as quintas de `HOLIDAYS`.
- `script/daily_event.R`, `script/event_trajectory.R` e `script/monthly_reduced_form.R` rodaram de novo
  e saíram byte-idênticos. `script/het_conditions.R` lê três colunas de `meetings.csv` por nome e não
  rodou.
