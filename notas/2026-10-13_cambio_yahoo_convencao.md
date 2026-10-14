# Câmbio diário do Yahoo pela convenção do anúncio: evento diário, conferência e Anexo B

> **CURRENT — 2026-10-13.** Branch `feature/focus-horizonte-fixo`, **não mergeada**.
> - **Decisão do autor em 10-13:** todo o câmbio diário dos resultados passa ao Yahoo `BRL=X`. Motivos
>   dados pelo autor: coerência com os resultados que o orientador já conhece, que são o câmbio mensal
>   do DFM e a linha diária do Anexo B, ambos do Yahoo; e uma cotação posterior mais próxima do anúncio
>   que a da PTAX.
> - O Yahoo é lido **pela convenção** do orientador (e-mail de 12-10, item 2): a última cotação antes
>   do anúncio e a primeira depois. Também por decisão do autor, tomada depois de ver as contas da
>   seção 3, feitas no scratchpad: a regra de leitura não foi fixada antes de rodar.
> - Supera o câmbio das notas `2026-10-05_evento_diario` (o R$ 0,048 reportado ao orientador em 12-10)
>   e `2026-10-13_ponte_horarios_copom` (seções 4 e 6, e a frase da seção 7 sobre o câmbio do painel).
>   ⚠ Corrige a leitura do horário do Yahoo daquelas notas, de `.claude/rules/data.md`, de
>   `pendencias.md` e do `CLAUDE.md`.
> - O instrumento, o painel e a produção não mudam. O smoke test sai bit-idêntico ao da branch
>   (câmbio `0.1448646415797471`).
> - Scripts: `R/instrument/di_surprise.R` (`load_yahoo_brl()`, nova), `script/copom_timing.R`,
>   `script/daily_event.R` e `script/het_conditions.R`. Nada no `.tex` nem em `paper/img/`.

## 1. A hora da cotação do Yahoo

- O Yahoo carimba cada barra de câmbio na meia-noite de Londres que abre o dia da barra, e o fechamento
  é a taxa nesse instante. A data gravada em `data/raw/brl_usd_daily.csv` é a desse instante em UTC.
- No horário de verão britânico, essa meia-noite cai às 23h UTC da véspera. Por isso as linhas vão de
  domingo a quinta no verão europeu e de segunda a sexta fora dele. Conferido nas 3644 linhas de 2012 a
  2025: a regra classifica 2130 linhas como de verão, todas de domingo a quinta, e 1514 como de
  inverno, todas de segunda a sexta.
- Em Brasília, a linha datada d traz:
  - no verão europeu, a cotação de d às 20h;
  - no inverno europeu, a cotação de d−1 às 21h, ou às 22h quando vigora o horário de verão
    brasileiro.

  `load_yahoo_brl()` anexa essa hora a cada linha.
- **A hora é inferida, não declarada.** As correlações diárias de `output/daily_event/fx_alignment.csv`,
  que se mantêm, situam a cotação depois do pregão brasileiro e antes do seguinte, mas não fixam a
  hora dentro da noite. O que a fixa é o evento (seção 3).

## 2. A janela pela convenção

- **Hora da cotação de quarta à noite.** Nas 102 reuniões, ela é 20h em 54, 21h em 35 e 22h em 13.
- **Cotação de quarta depois do anúncio (96 das 102).** A janela vai da noite de terça à de quarta.
  - A cotação posterior sai de 1 a 220 minutos depois do anúncio, com mediana de 116.
  - Na PTAX, a primeira cotação posterior era a de quinta, com consultas até as 13h, ou seja, 16 a 19
    horas depois.
- **Cotação de quarta antes do anúncio (as outras 6).** A janela vai da noite de quarta à de quinta.
  - São reuniões de verão europeu de 2012 a 2015, com anúncio às 20h ou depois: 168ª, 169ª, 183ª,
    184ª, 192ª e 193ª.
  - Na 169ª (2012-08-29), a sessão terminou às 20h00, a mesma hora da cotação. A cotação conta como
    anterior, porque o comunicado sai depois do fim da sessão.
- **2013-01-16.** Falta a linha da noite de terça, e a cotação anterior é a de segunda à noite: a
  janela tem dois dias.
- A cotação anterior fica, na mediana, 22 horas antes do anúncio. O intervalo entre as duas cotações é
  de 24 horas, como na PTAX. O que muda é a posição do anúncio na janela.
- **A correção.** A janela de quarta a quinta pelas datas das linhas, a do Anexo B até agora, coincide
  com a da convenção só em 50 das 102 reuniões: as 44 de inverno com linha e as 6 acima.
  - Nas 51 de verão com anúncio antes das 20h, a linha datada quarta já traz a cotação posterior ao
    anúncio, e a janela pelas datas, de quarta 20h a quinta 20h, perde o anúncio.
  - A leitura anterior ("em 45 das 102, a variação de quarta a quinta acompanha o pregão de quarta,
    anterior ao anúncio") tomava a cotação pelo fechamento do pregão. Estava errada.

## 3. A evidência no evento

`output/daily_event/fx_event_windows.csv`: forma reduzida, em % por +50 p.b. e HC1, da variação do
Yahoo na surpresa bruta, por janela e por horário europeu.

| janela | inverno (45) | verão (57) | todas (102) |
|---|---|---|---|
| linhas de terça a quarta | −0,75 (p 0,15) | **−1,02 (p 0,023)** | −0,89 (p 0,009) |
| linhas de quarta a quinta (o Anexo B até agora) | −0,35 (p 0,38) | **−0,00 (p 0,99)** | −0,23 (p 0,60) |
| convenção | −0,35 (p 0,37) | **−1,21 (p 0,007)** | −0,80 (p 0,008) |

As linhas de terça a quarta e as de quarta a quinta têm 44 reuniões no inverno e 101 no total, porque
falta a linha de 2013-01-16.

- **No verão, a evidência fixa a hora.** As linhas de terça a quarta respondem à surpresa, e as de
  quarta a quinta não respondem. A linha datada quarta, às 20h, já traz o anúncio.
- **No inverno, ela não informa.**
  - A janela da convenção (as linhas de quarta e quinta, da noite de terça à de quarta) responde pouco:
    −0,35, sem significância.
  - ⚠ A janela anterior a ela, de segunda à noite a terça à noite, que pela hora inferida fica toda
    antes do anúncio, dá −0,75 (p 0,15).
  - Em 45 reuniões nenhuma das duas é significante, e nada separa ruído de antecipação.
  - Com a PTAX, o inverno também respondia menos: −0,80 por +50 p.b. contra −1,20 no verão, numa conta
    do scratchpad que não está no repositório.

## 4. O passo 2 refeito com o Yahoo

`output/daily_event/regressions.csv`, 102 reuniões, HC1, por +50 p.b.:

| surpresa | câmbio | efeito | p | significância |
|---|---|---|---|---|
| bruta | PTAX (nota de 10-05) | −R$ 0,048 (−1,04%) | 0,019 | 95% |
| bruta | **Yahoo pela convenção** | **−R$ 0,037 (−0,80%)** | **0,012** | 95% |
| ortogonalizada | PTAX (nota de 10-05) | −R$ 0,048 (−1,04%) | 0,021 | 95% |
| ortogonalizada | **Yahoo pela convenção** | **−R$ 0,029 (−0,66%)** | **0,088** | **só 90%** |

- **Conjuntos AR.**
  - Bruta: [−0,061; −0,013] a 90% e [−0,065; −0,008] a 95%.
  - Ortogonalizada: [−0,055; −0,001] a 90% e [−0,060; +0,004] a 95%.
- ⚠ **Com o Yahoo, a apreciação na surpresa ortogonalizada deixa de ser significante a 95%** (p 0,088;
  0,058 em %). Com a PTAX, as duas surpresas eram significantes a 95%.
- O ponto cai cerca de um quarto na bruta e quatro décimos na ortogonalizada.
- **Sem mudança.**
  - O primeiro estágio é a identidade na bruta e tem F 656 na ortogonalizada.
  - O CDS (+0,9 e −0,5 p.b., não significante a 90%) e as linhas do DFM de `comparison.csv` saíram
    byte-idênticos.
  - O sinal: o real aprecia no dia do Copom e deprecia no DFM mensal (+0,096 com a bruta e +0,145 na
    produção).
- A troca de sinal entre o evento diário e o DFM continua sem decomposição: a passagem muda frequência,
  janela, normalização, medida e modelo ao mesmo tempo.

## 5. A conferência (`copom_timing.R`)

- `output/copom_timing/meetings.csv` traz, por reunião:
  - `yahoo_pre` e `yahoo_post`, as linhas;
  - `yahoo_pre_brasilia` e `yahoo_post_brasilia`, as horas;
  - `yahoo_wednesday_after`;
  - `d_fx` e `d_fx_pct`;
  - `yahoo_pre_month` e `yahoo_post_month`.

  Saíram as colunas da PTAX. As demais saídas e colunas não mudaram.
- **Ordem de execução.** `copom_timing.R` roda antes de `daily_event.R` e de `het_conditions.R`, que
  leem a janela dele. Ele deixou de ler `output/daily_event/events.csv`. O `d_cds_used` (quarta a
  quinta, nas 102) passou a ser calculado ali mesmo e saiu igual.
- **A PTAX fica só como relógio das 13h**, em dois diagnósticos:
  - o alinhamento que data o Yahoo (`fx_alignment.csv`);
  - o teste (B) do CDS, cuja regra foi commitada antes de rodar (`5048a09`) e não muda.

**As 9 reuniões fora das 102, pela convenção.** Substitui as colunas de PTAX da seção 6 da nota de
10-13.

| reunião | quarta | motivo | janela do Yahoo (Brasília) | ΔR$/US$ | Δ% |
|---|---|---|---|---|---|
| 175ª | 2013-05-29 | quinta feriado | qua 20h → qui 20h | +0,0004 | +0,02 |
| 179ª | 2013-11-27 | Thanksgiving | ter 22h → qua 22h | +0,0332 | +1,44 |
| 191ª | 2015-06-03 | quinta feriado | qua 20h → qui 20h | +0,0070 | +0,22 |
| 195ª | 2015-11-25 | Thanksgiving | ter 22h → qua 22h | +0,0432 | +1,16 |
| 209ª | 2017-09-06 | quinta feriado | ter 20h → qua 20h | −0,0179 | −0,58 |
| 223ª | 2019-06-19 | quinta feriado | ter 20h → qua 20h | −0,0241 | −0,63 |
| 247ª | 2022-06-15 | quinta feriado | ter 20h → qua 20h | −0,0641 | −1,26 |
| 258ª | 2023-11-01 | quinta feriado | ter 21h → qua 21h | −0,0804 | −1,61 |
| 271ª | 2025-06-18 | quinta feriado | ter 20h → qua 20h | −0,0078 | −0,14 |

A janela do Yahoo não depende do feriado brasileiro. Só na 175ª e na 191ª, com anúncio depois das 20h,
a cotação posterior é a da noite de quinta.

## 6. As 7 reuniões de fim de mês e a média mensal do Yahoo

O `cambio_usd` do painel é a média, no mês de calendário, das linhas do Yahoo pela data
(`R/data_download/exchange.R`). A surpresa dessas 7 reuniões vai ao mês seguinte (m+1).

| reunião | horário europeu | 1ª cotação posterior | linha | entra na média de |
|---|---|---|---|---|
| 2016-08-31 | verão | qua 20h | 2016-08-31 | **m** |
| 2016-11-30 | inverno | qua 22h | 2016-12-01 | m+1 |
| 2017-05-31 | verão | qua 20h | 2017-05-31 | **m** |
| 2018-10-31 | inverno | qua 21h | 2018-11-01 | m+1 |
| 2019-07-31 | verão | qua 20h | 2019-07-31 | **m** |
| 2024-01-31 | inverno | qua 21h | 2024-02-01 | m+1 |
| 2024-07-31 | verão | qua 20h | 2024-07-31 | **m** |

- Nas 4 de verão, a primeira cotação posterior ao anúncio entra na média do mês da reunião, e a
  surpresa entra no mês seguinte.
- Nas 3 de inverno, ela entra no mês da surpresa.
- A nota de 10-13 (seção 7) dizia que, nas 3 de inverno, a linha do dia 1º trazia a sessão de quarta,
  anterior ao anúncio. Estava errado pelo mesmo motivo da seção 2.
- Com 20 a 23 pregões no mês, uma cotação pesa cerca de 1/21 da média. O resto da comparação entre fim
  de mês e média fica para a ponte (b).

## 7. Anexo B: a linha diária com o Yahoo realinhado

### A janela

- DI e CDS continuam de quarta a quinta, e saíram iguais nas semanas comuns.
- O câmbio passou a ser o Yahoo pela hora da cotação:
  - **semanas com reunião:** a janela da convenção, as linhas `yahoo_pre` e `yahoo_post` de
    `meetings.csv`;
  - **semanas sem reunião:** da noite de terça à de quarta, a janela que um anúncio às 18h de quarta
    teria. Os dois regimes diferem só pelo anúncio. A regra é embutida no plano aprovado pelo autor.
- O painel tem 658 semanas (eram 656), com 104 de reunião. Entraram 2013-01-16, que antes faltava por
  não ter a linha de quarta no Yahoo, e a semana de 2025-04-16, sem reunião.
- O teste perde a primeira semana pela defasagem formal (`p = 1`, inerte), que é a da 165ª reunião.
  Ficam `n_C` = 103 e `n_NC` = 554 (eram 102 e 553).
- O conjunto de reuniões do Anexo B não é o das 102 do instrumento:
  - inclui as duas de Thanksgiving, que o filtro de S&P 500, VIX e Brent tira do instrumento;
  - perde a 165ª.
- A variação nova do câmbio tem correlação 0,32 com a antiga nas semanas comuns.

### `output/het/het_conditions.csv` e `het_variance_ratios.csv`, linha diária

| vértice | razão de variância do câmbio | λ₁ | λ₂ | `Qr` p | Holm |
|---|---|---|---|---|---|
| 3 meses | 1,04 → **0,69** | 7,55 → 7,03 | 1,36 → 1,15 | 0,0033 → **0,0019** | 0,010 → 0,006 |
| 6 meses | 1,04 → **0,70** | 4,06 → 3,66 | 1,36 → 1,13 | 0,084 → **0,064** | 0,169 → 0,127 |
| 12 meses | 1,04 → **0,70** | 3,63 → 3,45 | 1,40 → 1,14 | 0,147 → **0,081** | 0,169 → 0,127 |

- **A condição continua valendo no diário com o DI de 3 meses, agora com mais folga.**
  - A sensibilidade ao vértice diminui, mas continua: o p vai de 0,002 a 0,064 e 0,081. A 10%, os três
    vértices rejeitam sem ajuste, e só o de 3 meses rejeita com Holm.
  - A correção de curtose continua decidindo: o fator vai a 4,97 no vértice de 3 meses, e sem ela os
    três vértices rejeitam com p abaixo de 1e-5.
  - O determinante normalizado do vértice de 3 meses vai de 40,8 a 33,8.
- ⚠ **A razão de variância do câmbio cai abaixo de 1.** Nas semanas de reunião, a variação do câmbio
  da noite de terça à de quarta tem 0,69 a 0,70 da variância das demais semanas. Com a janela antiga,
  pelas datas, ela era 1,04. A frase da §3.3 de que, no diário, só a variância do DI sobe continua
  verdadeira, mas o número de `tab:het_frequency` muda.
- As razões do DI (5,54 → 5,47 no vértice de 3 meses) e do CDS (0,80 → 0,81) só se mexem pelas duas
  semanas a mais.

### As linhas mensais

- **VAR mensal (por MQO e sob a escala).** Saiu byte-idêntico, assim como `het_var_theta.csv`: o VAR
  usa `yield_*`, `cds_5y` e `cambio_usd`, que a branch não mudou.
- **Linha fatorial: mudou pela base da branch, não pelo câmbio.** As inovações são as do passo 0, com as
  Focus a horizonte fixo e a `msci` como índice de emergentes.

  | teste | antes | agora |
  |---|---|---|
  | λ₁ | 4,03 | 3,05 |
  | `λ₁ = λ₂` | 0,076 (sem correção 0,035) | **0,312** (sem correção 0,228) |
  | `λ₁ = … = λ₄` | 0,021 | **0,240** |
  | `λ₁ = … = λ₅` | 0,013 | **0,145** |

  ⚠ As três rejeições que a nota de `tab:het_frequency` imprime como inconvenientes (0,035, 0,021 e
  0,013) **deixam de existir na base da branch**: nenhum teste da linha fatorial rejeita a 10%. Isso
  entra no Anexo B quando o artigo migrar para a base reconstruída (item 6 do Tema A).

`script/validation/validate_het_cv.R` passa.

## 8. O que pode e o que não pode ser dito

- Pode: no dia do Copom, com o Yahoo da última cotação antes do anúncio à primeira depois, uma surpresa
  bruta de +50 p.b. vem com o real apreciando R$ 0,037 (0,80%), significante a 95%. Com a surpresa
  ortogonalizada, R$ 0,029 (0,66%), significante a 90% e não a 95%.
- Pode: a cotação do Yahoo é a da noite do pregão, das 20h às 22h em Brasília. Na quarta ela vem
  depois do anúncio em 96 das 102 reuniões, e isso é inferido do carimbo e da resposta no verão
  europeu, não declarado pelo Yahoo.
- Não pode: repetir o R$ 0,048 ou o "significante a 95% com as duas surpresas" como resultado
  corrente. Esses números eram da PTAX.
- Não pode: dizer que a janela de quarta a quinta pelas datas das linhas do Yahoo cumpre a convenção.
  Ela perde o anúncio nas 51 reuniões de verão com anúncio antes das 20h.
- Não pode: ler a resposta fraca no inverno europeu como evidência de horário ou de ausência de
  resposta.
- Pode, na branch: com o câmbio realinhado, a condição de posto vale no diário com o DI de 3 meses
  (`Qr` p 0,002, Holm 0,006), e a variância do câmbio nas semanas de reunião é 0,69 a 0,70 da das
  demais.
- Não pode: tratar como correntes a razão diária do câmbio de 1,04 e os p 0,003, 0,084 e 0,147 de
  `tab:het_frequency`. Nem as rejeições da linha fatorial (0,035, 0,021 e 0,013), que não se repetem na
  base da branch. O `.tex` segue com eles até o item do Tema A.
- Não pode: atribuir a troca de sinal entre o evento diário e o DFM mensal ao câmbio usado.

## 9. O que mudou

- `R/instrument/di_surprise.R`: nova `load_yahoo_brl()`, usada por três scripts. Nada mais muda no
  módulo, e o smoke test sai bit-idêntico.
- `script/copom_timing.R`: janela cambial do Yahoo, meses das cotações e `d_cds_used` calculado ali.
  Muda só `meetings.csv`.
- `script/daily_event.R`: câmbio do Yahoo pela janela de `meetings.csv`, e `fx_event_windows.csv` novo.
  `fx_alignment.csv` perdeu as três colunas do bloco de eventos, que comparavam o Yahoo pelas datas com
  a PTAX.
- `script/het_conditions.R`: câmbio do Yahoo pela hora da cotação.
- `script/run_all.R` (descrição do estágio `ptax`), `script/README.md`, `.claude/rules/data.md`,
  `CLAUDE.md`, `registro/pendencias.md` e `notas/_indice.md`.
