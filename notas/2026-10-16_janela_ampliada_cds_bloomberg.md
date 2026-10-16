# Janela ampliada do CDS nas duas leituras e as datas para a Bloomberg

> **CURRENT — 2026-10-16.** Passo 2 de `registro/pendencias.md`: o e-mail que manda ao orientador a
> conferência 1/4, pergunta a janela ampliada do CDS e dá as datas para a cotação intradiária da
> Bloomberg (`email/email_meu_16-10_12h53.md`, enviado). Branch `feature/focus-horizonte-fixo`,
> **não mergeada**.
> - Nada foi reestimado e nenhuma regressão lê as janelas novas. Instrumento, painel e produção
>   ficaram intocados; nada em `R/`.
> - Decisões do autor em 16-10: as 8 datas e o critério (seção 2), mandar só as datas e os horários
>   do anúncio, como o orientador pediu, um e-mail só, e deixar prontas no código as duas leituras da janela ampliada do CDS,
>   enquanto o orientador não responde. Os horários do Yahoo e do CDS seguem como hipóteses.
> - Script: `script/copom_timing.R`. Saídas que mudaram: `output/copom_timing/meetings.csv` e
>   `excluded_meetings.csv`, só com colunas e linhas novas.

## 1. A janela ampliada do CDS

O e-mail de 14-10 pede "a janela ampliada, com as duas mudanças adjacentes" e não tem o item 2, que
diria qual. As duas leituras estão calculadas para as 111 reuniões, com o fechamento às 17h de Nova York
(decisão do autor de 14-10):

| leitura | janela | colunas em `meetings.csv` | `window` em `excluded_meetings.csv` |
|---|---|---|---|
| larga | da cotação anterior à quarta à primeira depois dela, pelas datas | `cds_wide_pre`, `cds_wide_post`, `d_cds_wide` | `larga` |
| estreita mais um | a janela das 17h de NY com uma cotação a mais de cada lado | `cds_wide3_pre`, `cds_wide3_post`, `d_cds_wide3` | `estreita_mais_um` |

- **A larga** segue a larga do Yahoo (decisão de 15-10): pelas datas, sem usar o horário do fechamento,
  e por isso contém o anúncio qualquer que seja ele. Toda quarta tem cotação de CDS, e a janela cobre
  sempre duas variações, de terça a quinta. É a leitura que o registro já trazia: nas 27 das 102 em que o
  fechamento de quarta às 17h de NY vem depois do anúncio, ela soma à estreita a variação seguinte; nas
  outras 75, a anterior.
- **A estreita mais um** cobre três variações. Vai de terça a sexta em 82 das 111 reuniões e de segunda a
  quinta nas 28 em que a estreita é de terça a quarta. Na 179ª vai de terça à segunda seguinte.
- Guardas do script: duas variações na larga em toda reunião, e a larga contém a janela estreita sob as
  duas hipóteses de fechamento (17h e 18h de NY).
- Nas 9 fora das 102, a larga vai sempre de terça a quinta. A estreita mais um vai de terça a sexta em 7.
  Na 195ª, cuja estreita é de terça a quarta, vai de segunda a quinta. Na 179ª vai de terça à segunda
  seguinte (2013-12-02), porque o arquivo não tem CDS na sexta depois do Thanksgiving.

## 2. As datas para a Bloomberg

O orientador pode pedir a um conhecido a cotação intradiária do dólar, só para identificar o horário do
Yahoo. Critério do autor: a maior |ΔDI| em cada regime de horário do anúncio (nota
`2026-10-13_ponte_horarios_copom`, seção 2) e em cada horário europeu, com peso no inverno europeu, onde
o evento não fixa a hora (nota `2026-10-13_cambio_yahoo_convencao`, seção 3).

| reunião | quarta | anúncio | horário europeu | Yahoo de quarta, hora inferida | ΔDI (p.b.) |
|---|---|---|---|---|---|
| 174ª | 2013-04-17 | 19h56, limite inferior | verão | 20h | −35,0 |
| 186ª | 2014-10-29 | 20h12, limite inferior | inverno | 22h | +41,0 |
| 196ª | 2016-01-20 | 20h16, limite inferior | inverno | 22h | −28,0 |
| 204ª | 2017-01-11 | 18h20 | inverno | 22h | −28,5 |
| 213ª | 2018-03-21 | 18h00 | inverno | 21h | −14,5 |
| 237ª | 2021-03-17 | 18h45 | inverno | 21h | +38,5 |
| 242ª | 2021-10-27 | 18h35 | verão | 20h | +41,0 |
| 267ª | 2024-12-11 | 18h33 | inverno | 21h | +28,5 |

- As de verão são controle: nelas o evento já situa a cotação às 20h.
- Nas três primeiras o BCB não publica a hora do comunicado (a API `comunicados_detalhes` só dá a data).
  A primeira matéria do G1 com a decisão dá o teto: 20h06 em 17/04/2013, 20h19 em 29/10/2014 e 20h25 em
  20/01/2016, hora oficial de Brasília da época (metadado sem fuso). O comunicado saiu, portanto, entre o
  término da ata e esses horários, 7 a 10 minutos. O e-mail diz isso. ⚠ Na 174ª a faixa (19h56–20h06)
  cai sobre as 20h inferidas do Yahoo, e a data separa mal o antes do depois. ⚠ A Exame de 20/01/2016
  marca 19h34, antes da ata, provavelmente sem o horário de verão; não entrou como teto.
- O e-mail manda só as datas e os horários do anúncio, como o orientador pediu (decisão do autor de
  16-10, que retirou uma grade de horários extra do rascunho). ⚠ A cotação no horário do anúncio, sozinha,
  não diz a que hora corresponde a linha do Yahoo; casá-la com uma hora candidata (20h, 21h ou 22h) exige
  as cotações nessas horas.
- Não há leitor desses dados no código. Quando chegarem, a hora entra em `load_yahoo_brl()`
  (`R/instrument/di_surprise.R`), e as janelas saem de novo por `copom_timing.R`.

## 3. O que mudou e o que ficou igual

- `script/copom_timing.R`: o bloco das duas leituras logo depois de `cds_windows`; o teste (C) do CDS
  passou a ler a cotação anterior à quarta de `cds_wide_pre`, o mesmo cálculo que fazia; a tabela das 9
  ganhou as duas janelas, e os horários e o status do CDS são postos uma vez para as três janelas dele.
- `output/copom_timing/excluded_meetings_advisor.csv`, novo: a tabela das 9 que vai em anexo no e-mail,
  só com o que o e-mail de 14-10 pede: o motivo de cada exclusão (ponto 3) e o que a entrega 1 lista.
  Uma linha por reunião e mercado (DI, PTAX, Yahoo de terça a quinta, CDS às 17h de NY), com o horário
  do anúncio e se é documentado ou limite inferior, o feriado, o motivo, as datas pré e pós, o horário da cotação e a duração em dias. O horário
  da cotação leva o status só no DI (desconhecido) e na PTAX (documentado); no Yahoo e no CDS vai só a
  hora usada, sem "inferido" nem "hipótese", e o e-mail diz apenas que o fechamento do DI é desconhecido
  (decisão do autor de 16-10). Em português, com
  ponto e vírgula. Sai de `excluded_meetings.csv` pelo mesmo script, e uma mudança de horário a refaz.
- As colunas antigas de `meetings.csv` e as 45 linhas antigas de `excluded_meetings.csv` saem iguais
  valor a valor. As demais saídas de `output/copom_timing/` saem byte-idênticas.
- `script/daily_event.R`, `script/event_trajectory.R` e `script/monthly_reduced_form.R` rodaram de novo e
  saíram byte-idênticos.

## 4. O que pode e o que não pode ser dito

- Pode: as duas leituras da janela ampliada do CDS estão prontas e esperam a resposta do orientador.
- Não pode: ler `d_cds_wide` ou `d_cds_wide3` como resposta à surpresa. Nenhuma regressão rodou.
- Não pode: dizer que o CDS fecha às 17h de Nova York, nem que o Yahoo cota à meia-noite de Londres.
  São hipóteses até os dados da Bloomberg. O anexo de 16-10 traz as duas horas sem esse qualificador,
  por decisão do autor; isso não as torna documentadas.
