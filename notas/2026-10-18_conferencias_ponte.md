# Conferências do e-mail de 18-10 e a ponte nas convenções corrigidas

> **CURRENT — 2026-10-18.** Resposta ao e-mail do orientador de 18-10
> (`email/email_professor_18-10_16h14.md`). Branch `feature/auditoria-janelas-copom`, **não mergeada**.
> - Nada em `R/` mudou, e a produção também não. O smoke test sai bit-idêntico ao pino da branch
>   (câmbio `0.12500959582800081`), os sete validadores passam, e `instrument.csv`,
>   `instrumentos_mensais.csv`, `copom_event_diagnostics.csv` e `instrument_no_holiday_windows.csv` saem
>   byte-idênticos. As saídas antigas de `output/copom_timing/` também saem iguais.
> - Decisões do autor em 18-10:
>   - item 4: só confirmar e explicar; na sensibilidade de 104, os 7 meses seguem com z = 0, sem reestimar;
>   - a ponte roda nas bases de 111 (produção) e de 104 (sensibilidade);
>   - item 1: só explicar; a janela larga do Yahoo fica pelas datas das linhas, e o `cambio_usd` do DFM não
>     muda;
>   - item 1: baixar os carimbos da API do Yahoo, para documentá-los à parte da data da linha.
> - Scripts: `script/download_yahoo_stamps.R` (novo; estágio de rede `yahoo_stamps`), `script/copom_timing.R`,
>   `script/instrument.R`, `script/daily_event.R`, `script/event_trajectory.R` e
>   `script/monthly_reduced_form.R`.
> - ⚠ Influência, placebos, `ar_precision`, a grade de força, o VAR e os anexos seguem na base de 102.
>   O e-mail diz que não é preciso refazer influência e placebos agora.

## 1. O que o e-mail pede e o que foi feito

| item | feito |
|---|---|
| 1. Yahoo: a diferença entre as linhas "de terça a quinta" vem do índice de datas ou da seleção? | Do índice de datas (seção 2). A seleção é a mesma em todas as reuniões. |
| 1. Data da linha, carimbo e horário à parte; quais câmbios entram no evento e no DFM; a regra nas 111 | Seção 2 e `output/copom_timing/yahoo_rows.csv`. Nenhuma estimativa usa a janela que muda com a estação. |
| 2. CDS de 26/11 a 02/12/2013, por que a ampliada termina em 02/12, o valor redondo, estreita contra ampliada, janelas longas | Seção 3. |
| 3. Conferir as 5 ambíguas, a margem de 30 min, desconhecido contra conhecido e próximo | Seção 4. |
| 4. Como entram os meses com z = 0 na sensibilidade; a definição de ξ_mp e a referência | Seção 5. Nada reestimado. |
| 5. As fontes dos horários do DI1 | Seção 6. Nenhuma busca nova. |
| A ponte nas convenções, com magnitudes e intervalos; sem teste entre bases, sem influência e placebos | Seção 7. |

## 2. Yahoo: data da linha, carimbo e horário

**O carimbo.** `script/download_yahoo_stamps.R` baixa as barras diárias de `BRL=X` do endpoint de gráfico
que o quantmod usa. Vêm com o carimbo de cada uma (segundos UNIX) e o fuso declarado, `Europe/London`.
- Os 4174 carimbos, de 2010-01-04 a 2026-01-01, caem todos às 00:00 de Londres.
- Onze barras vêm sem fechamento, e o quantmod as descarta (a de 2013-01-16 é a terça que falta à 172ª).
- As outras 4163 batem com `brl_usd_daily.csv`, linha a linha e com o mesmo fechamento.

**A data da linha.** `quantmod::getSymbols()` lê o carimbo no fuso da bolsa e o converte com `as.Date()`, que
no R 4.3.3 usa UTC.
- No horário de verão britânico, a meia-noite de Londres cai às 23h UTC da véspera, e a linha leva a
  data da véspera.
- Por isso o arquivo tem linhas de domingo a quinta no verão europeu e de segunda a sexta fora dele.
- `copom_timing.R` confere que a data de cada linha é a data UTC do carimbo.

**O horário da cotação.** O Yahoo não o documenta. A hipótese de `load_yahoo_brl()` é o instante do carimbo:
20h em Brasília no verão europeu e 21h fora dele, uma hora a mais com o Brasil no horário de verão.
- No verão europeu a cotação cai às 21h em 3 reuniões, as de outubro de 2015, 2016 e 2017, em que o
  horário de verão brasileiro já tinha começado (`yahoo_rows.csv`). As notas de 13-10 e 17-10 dizem só
  "20h no verão europeu". O código converte cada carimbo na própria data, e nenhuma janela muda.
- O que a sustenta, além do carimbo, é o dia. As correlações diárias de `fx_alignment.csv`, iguais às de
  antes, põem a linha d junto ao pregão do Ibovespa de d no verão europeu e de d−1 fora dele.
- E o evento, no verão (`fx_event_windows.csv`, 111 reuniões, surpresa bruta). Nas 55 reuniões de verão
  em que a linha de quarta (20h ou 21h) vem depois do anúncio:
  - a variação das linhas de terça a quarta responde: −1,03% por +50 p.b., p 0,024;
  - a de quarta a quinta não responde: +0,13%, p 0,85.
- Nas 8 reuniões de verão com anúncio depois da cotação de quarta, as linhas de terça e de quarta são ambas
  anteriores ao anúncio. Com elas, as 63 de verão dão −0,54% (p 0,31) nas linhas de terça a quarta.
- No inverno europeu (48 reuniões) o evento não fixa a hora.

**A diferença na tabela das 9.** A janela larga é "da linha de terça à de quinta", pelas datas das linhas
(decisão do autor de 15-10).
- Pela hora inferida, ela cobre a noite de terça à de quinta nas 63 reuniões do verão europeu e a de
  segunda à de quarta nas 48 do inverno, entre elas a 179ª, a 195ª e a 258ª.
- A seleção é a mesma em todas: a diferença vem da data UTC do carimbo, não de um deslocamento.
- Nenhuma regressão lê a janela larga.
- A janela da convenção, que entra no evento diário, na ponte (a) e no Anexo B, é escolhida pela hora e
  não pela data. Nas 111 ela vai da última cotação antes do anúncio à primeira depois: terça → quarta à
  noite em 102, quarta → quinta em 8 e segunda → quarta na 172ª. A cotação de quarta à noite vem depois do
  anúncio em 103 das 111.

**As séries cambiais.**
- Evento diário e ponte (a): Yahoo `BRL=X` pela janela da convenção.
- DFM: `cambio_usd`, a média no mês civil das mesmas linhas do Yahoo, pela data da linha
  (`R/data_download/exchange.R`). Pela hora inferida, no inverno europeu a média do mês m vai da noite do
  último dia de m−1 à do penúltimo de m. Não muda (decisão do autor).
- A PTAX só aparece como janela diagnóstica na tabela das 9 e como relógio das 13h.

## 3. CDS

**De 26/11 a 02/12/2013**, no arquivo da Bloomberg:

| data | CDS |
|---|---|
| ter 26/11 | 202,668 |
| qua 27/11 | 205,168 |
| qui 28/11 (Thanksgiving) | 205,000 |
| sex 29/11 | sem cotação |
| seg 02/12 | 214,000 |

- **Por que a ampliada termina em 02/12.** A estreita da 179ª vai de quarta a quinta. A ampliada soma uma
  variação de cada lado no calendário da própria série, e o arquivo não tem a sexta 29/11, a única sexta
  depois do Thanksgiving que falta em 2012–2025. Por isso ela vai de terça 26/11 a segunda 02/12, seis
  dias de calendário.
- **O valor redondo.**
  - 39 das 3609 cotações de 2012-03 a 2025-12 são inteiras, 30 delas em 2013–2014
    (`output/copom_timing/cds_round_quotes.csv`); a de 02/12 é uma delas.
  - O valor de 28/11 difere do de 27/11, então não repete a cotação anterior.
  - O repositório não tem segunda fonte diária de CDS (o Investing é mensal), e nada permite confirmá-lo
    nem invalidá-lo.
  - A observação fica nas duas janelas, com essa limitação, e nada é zerado.
  - A surpresa de DI da 179ª (−19 p.b.) entra no instrumento do DFM de qualquer forma.
- **Janelas longas.**
  - A estreita tem 1 dia de calendário nas 111.
  - A ampliada tem 3 em 110 e 6 na 179ª.
  - No DI, as 7 de feriado vão de quarta a sexta (`long_window`).

**Estreita contra ampliada** (`output/daily_event/regressions.csv`, efeito por +50 p.b. no DI de 6 meses,
conjunto AR de 90%, surpresa ortogonalizada; a bruta entre parênteses):

| base | estreita, 17h de NY | ampliada |
|---|---|---|
| 111 | −0,8 [−6,7; 4,9] (bruta +0,8 [−3,3; 4,8]) | **+7,7 [0,7; 15,0]**, p 0,071 (bruta +6,5 [0,2; 12,7], p 0,089) |
| 104 | −0,9 [−7,6; 5,6] | +6,9 [−1,0; 15,1], p 0,150 |

- Na produção, a ampliada é significante a 90% e não a 95%. A estreita não é significante.
- A ampliada inclui a variação da véspera e a do dia seguinte e incorpora outras notícias.

## 4. A classificação

- **A contagem.** Na tabela das 9, o CDS estreito é ambíguo em 5: 179ª, 195ª, 209ª, 223ª e 258ª.
  - O e-mail de 17-10 falou só das quatro do orientador.
  - Na 258ª (01/11/2023), o fechamento às 17h de NY cai às 18h em Brasília, exatos 30 minutos antes do
    anúncio das 18h30. É ambígua pela margem.
- **A margem de 30 minutos** é convenção da auditoria (decisão do autor de 17-10, commitada em `8edc3a2`),
  não regra de mercado. Nenhum corte alternativo rodou.
- **Hora da cotação desconhecida.** Todas as ambiguidades do CDS e do Yahoo dependem de hipóteses: 17h de NY
  e meia-noite de Londres, sem documentação dos provedores.
  - Na 179ª e na 195ª também o anúncio é só um limite inferior (o término da ata), e a ordem não se
    estabelece.
  - No DI, a 209ª (06/09/2017) tem o anúncio documentado às 18h00, mas o fim do pregão só tem o limite de
    18h15, de fonte secundária.
- **Horários conhecidos, mas próximos.** Só o DI da 223ª (19/06/2019) e o da 258ª.
  - O último negócio sai no máximo às 18h00, pela grade da B3.
  - O anúncio documentado sai às 18h05 e às 18h30.
  - Nas três reuniões de 2017 em diante, o CDS às 18h fica a 0, 5 e 30 minutos de anúncios documentados.

## 5. A sensibilidade sem as sete e ξ_mp

**Os meses com z = 0.** Na base de 104, os 7 meses das reuniões excluídas entram com z = 0 nos momentos
de identificação. É o preenchimento por zero de MOSW (`SVARIV.m:128`).
- Eles contam em T = 162 e somam zero a Σ z_t η_t.
- Entram na variância dos momentos como meses de surpresa nula.
- O VAR dos fatores roda nos 162 meses, nas duas bases.
- `ar_dfm_moments()` aborta quando o instrumento não cobre todos os meses: excluí-los dos momentos não
  está implementado.

**Exclusão contra zero.**
- Sob a escala COVID nada é centrado, e um mês com z = 0 não entra em Γ̂ = Σ z_t η_t / T nem em Σ z_t².
  Excluí-lo multiplica Γ̂ por um escalar.
- O ponto normalizado seria o mesmo. Mudariam T e a variância dos momentos, e com eles ξ_mp e os
  conjuntos.
- Nenhum dos 162 meses tem duas reuniões, então nenhum zero é uma soma incompleta.

**ξ_mp.** É a Wald de Montiel Olea, Stock e Watson (2021) na direção que normaliza o choque,
`ξ_mp = T (d₀'Γ̂)² / (d₀' Ŵ₂ d₀)` (`mosw_ar_bounds()`).
- d₀ é a linha de cargas do DI de 6 meses no impacto e Γ̂ a covariância entre o instrumento e as
  inovações dos fatores.
- Ŵ₂ é a variância assintótica de Γ̂, com a correção de MOSW pelo VAR estimado e Newey-West de ordem zero.
- A leitura é a de MOSW: o conjunto AR de nível 1−α é limitado se e só se ξ_mp passa do quantil 1−α da
  χ²₁ (1,64 a 80%, 2,71 a 90%, 3,84 a 95%).
- O 10 é a regra de bolso de Staiger e Stock (1997) para o F de primeiro estágio homocedástico, referência
  convencional, não resultado de MOSW.
  - MOSW a citam para o F robusto ("some rule of thumb, such as F > 10", seção 4.2).
  - Na aplicação da seção 5, comparam com ela também ξ: 4,4 e 9,4 ficam "below the Staiger-Stock value of 10".
  - Lembram que ξ tende a ser menor que o F em amostra finita.
  - No artigo, o 10 é referência convencional, não limiar que classifica o instrumento (§3.4).
- Valores: 7,28 na produção e 6,55 na de 104, sob a surpresa ortogonalizada. Os conjuntos são limitados a
  80, 90 e 95%, e os valores ficam abaixo de 10.

## 6. As fontes dos horários do DI1

| período | fim do pregão | status | fonte |
|---|---|---|---|
| 2012-03 a 2018-12 | 18h15 | limite superior, fim do segmento BM&F, de fonte secundária; a grade do DI1 não foi achada | Exame, 19/10/2012 (https://exame.com/invest/mercados/horario-verao-muda-pregao-bm-fbovespa-506260/); Jornal do Comércio, 14/10/2016 (https://www.jornaldocomercio.com/_conteudo/2016/10/economia/526266-com-horario-de-verao-bm-fbovespa-altera-funcionamento-a-partir-do-dia-17.html) |
| 2019-01 a 2022-12-09 | 18h00, sessão estendida de 16h50 a 18h00 | documentado | grade de juros da B3 no Wayback Machine, capturas de 2019-01-07 (20190107143157) a 2022-01-24 (20220124102052) (https://www.b3.com.br/pt_br/solucoes/plataformas/puma-trading-system/para-participantes-e-traders/horario-de-negociacao/derivativos/taxas-de-juros/); Ofício Circular 094/2020-PRE, que deixa o DI1 inalterado no horário de verão dos EUA (https://www.b3.com.br/data/files/71/43/8B/34/340A37109CFAD937AC094EA8/OC%20094-2020%20PRE%20Novos%20Hor%C3%A1rios%20de%20Negocia%C3%A7%C3%A3o%202020_01112020_R.pdf) |
| desde 2022-12-12 | 18h00, negociação contínua das 9h às 18h | documentado | grade atual da B3 (mesmo endereço); InfoMoney, 23/11/2022 (https://www.infomoney.com.br/mercados/b3-altera-modelo-de-definicao-de-ajuste-do-di-que-tera-sessao-continua-ate-18h/) |

As URLs foram recuperadas das transcrições das sessões de 17-10, onde as fontes foram achadas. Não houve
busca nova.

## 7. A ponte nas convenções corrigidas

**Convenções aplicadas.**
- As 111 reuniões, com as 7 janelas de DI de quarta a sexta.
- A regressão Bauer-Swanson de cada base refeita na própria amostra. `instrument.R` grava agora também as
  surpresas por reunião e as três variantes mensais da base de 104.
- O câmbio pela janela da convenção do Yahoo.
- O CDS pelo fechamento às 17h de NY, estreito e ampliado. Isso tira o passo 2 da janela de quarta a
  quinta.
- Cada série no próprio calendário.
- Na forma reduzida mensal da base de 104, os 7 meses com z = 0 (amostra i, como no DFM) e fora da
  amostra (ii, 155 meses). Na de 111, a amostra (ii) coincide com a (i) e não roda.

**Produção (111), surpresa ortogonalizada.** Câmbio em R$/US$ e CDS em p.b., intervalos de 90%. Evento,
trajetória e forma reduzida mensal são por +50 p.b. de surpresa; o DFM é por +50 p.b. no DI de 6 meses.

| etapa | câmbio | CDS |
|---|---|---|
| evento diário, 1ª cotação (110) | −0,024 [−0,048; 0,000], p 0,107 | −0,8 [−6,6; 5,0] |
| 5ª cotação | −0,022 [−0,073; 0,030] | +0,6 [−18,1; 19,4] |
| 10ª cotação | +0,036 [−0,033; 0,105] | **+18,8 [6,9; 30,8]**, p 0,009 |
| 20ª cotação | **+0,104 [0,022; 0,187]**, p 0,037 | **+24,0 [3,5; 44,5]**, p 0,054 |
| forma reduzida mensal, h0 | **+0,118 [0,015; 0,221]**, p 0,060 | **+35,0 [14,6; 55,4]**, p 0,005 |
| forma reduzida mensal, h1 | **+0,244 [0,087; 0,401]**, p 0,010 | **+42,7 [14,3; 71,1]**, p 0,013 |
| DFM, h0 (ξ_mp 7,28) | **+0,125 [0,048; 0,228]** | **+30,6 [12,9; 56,8]** |
| DFM, h1 | **+0,161 [0,046; 0,309]** | **+34,6 [14,8; 61,6]** |

Em negrito, significante a 90%.
- **Câmbio.** O sinal se inverte entre a 5ª e a 10ª cotação, e na 20ª a depreciação é significante a 95%.
  - Pela regra da ponte (a), a depreciação aparece na trajetória diária em até 20 cotações.
  - Na 5ª e na 10ª nada é significante, e a inversão não fica datada.
  - ⚠ Na 1ª cotação, a apreciação **deixa de ser significante a 90%** na produção (p 0,107; na base de
    102 era −0,029, p 0,086).
  - No passo 2, por +50 p.b. no DI de 6 meses, ela é −0,024 [−0,047; +0,001].
  - Em log, a apreciação é −0,61% e é significante a 90% (p 0,055). Com a surpresa bruta é −0,031,
    significante a 95% (p 0,021).
- **Forma reduzida mensal.** É positiva e significante nas duas séries.
  - ⚠ O câmbio em h0 perde os 95% (p 0,060; 0,037 na base de 102).
  - Pelo IV por +50 p.b. de `yield_6m` (F do primeiro estágio 9,3): câmbio 0,070 e 0,145 em h0 e h1, CDS
    20,7 e 25,3.
  - O câmbio de fim de mês dá +0,072 e +0,127, não significantes a 90%.
- **CDS.** Não responde na 1ª e na 5ª cotação. Sobe a partir da 10ª: +18,8, significante a 95%.
- **DFM bruto (111).** Câmbio +0,101 [0,015; 0,179] e CDS +24,9 [6,0; 45,1] em h0, significantes a 90% e
  não a 95%; ξ_mp 7,69.

**Sensibilidade (104), surpresa ortogonalizada.** Amostra comum de 103 na trajetória.
- Câmbio:
  - evento diário −0,030 [−0,057; −0,003], significante a 90% (p 0,073);
  - 20ª cotação +0,123, p 0,028;
  - forma reduzida mensal +0,134 (p 0,050) e +0,277 (p 0,009);
  - DFM +0,136 [0,056; 0,269].
- CDS:
  - evento diário −0,8;
  - 10ª cotação +18,9, p 0,018; 20ª +22,4, p 0,090;
  - forma reduzida mensal +37,9 e +41,4;
  - DFM +32,4 [13,7; 65,2].
- ξ_mp 6,55. Na forma reduzida mensal, tirar os 7 meses (amostra ii, 155 meses) em vez de pô-los a zero
  muda, com a surpresa ortogonalizada, o câmbio em menos de 0,001 e o CDS em menos de 0,1 p.b.

## 8. O que pode e o que não pode ser dito

- Pode: a data da linha do Yahoo é a data UTC de um carimbo sempre às 00:00 de Londres, e por isso a linha
  "de terça" é a noite de terça no verão europeu e a de segunda fora dele.
- Pode: nenhuma estimativa usa a janela pelas datas das linhas. A da convenção é escolhida pela hora.
- Não pode: dizer que o Yahoo cota à meia-noite de Londres ou o CDS às 17h de NY. São hipóteses.
- Não pode: dizer que o valor de 28/11/2013 é inválido, nem que foi confirmado.
- Pode: na produção, o câmbio deprecia de forma significante na 20ª cotação depois do anúncio, na forma
  reduzida mensal e no DFM. O CDS sobe a partir da 10ª cotação.
- Não pode: datar a inversão. A 5ª e a 10ª cotação do câmbio não são significantes.
- Não pode: chamar de significante a 90% a apreciação na 1ª cotação, em R$, na produção com a surpresa
  ortogonalizada.
- Não pode: ler a sensibilidade de 104 como exclusão das reuniões dos momentos. Os meses entram como
  surpresa nula.

## 9. O que mudou

- `script/download_yahoo_stamps.R`, novo, e o estágio `yahoo_stamps` em `script/run_all.R`.
- `script/copom_timing.R`:
  - lê os carimbos e confere data, hora e fechamento;
  - escreve `yahoo_rows.csv` (as linhas das janelas das 111 com data, carimbo em UTC e em Londres e hora
    inferida) e `cds_round_quotes.csv`;
  - as saídas antigas saem iguais.
- `script/instrument.R`: grava `instrumentos_mensais_no_holiday_windows.csv` e
  `copom_event_diagnostics_no_holiday_windows.csv`.
- `script/daily_event.R`:
  - bases de 111 e 104;
  - CDS às 17h de NY e ampliado;
  - DFMs conferidos contra o cache e contra `copom_windows/comparison.csv`;
  - grupo `verao_quarta_apos_anuncio` em `fx_event_windows.csv`;
  - não lê mais `ar_precision`.
- `script/event_trajectory.R`: bases de 111 e 104; em k = 1 reproduz o passo 2 também no CDS.
- `script/monthly_reduced_form.R`: bases de 111 e 104; o DFM é conferido contra o passo 2 (h0) e o cache
  (h1); não lê mais `ar_precision`.
