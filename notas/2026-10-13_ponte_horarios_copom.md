# Ponte, conferência: horários do dia do Copom e janelas de DI, câmbio e CDS

> **CURRENT — 2026-10-13.** Primeiro item da ponte do e-mail do orientador de 12-10
> (`email/email_professor_12-10_19h40.md`, item 2, último parágrafo). Branch
> `feature/focus-horizonte-fixo`, **não mergeada**.
> - Nada foi reestimado, e o instrumento, o painel e `R/` ficaram intocados. O smoke test sai
>   bit-idêntico ao da branch (câmbio `0.1448646415797471`).
> - Decisões do autor em 10-13, antes de rodar:
>   - o horário do anúncio é documentado reunião a reunião;
>   - o horário do fechamento do CDS é inferido dos dados e escrito como inferido: os dados são do
>     orientador, e o autor não tem o horário;
>   - as 9 reuniões fora das 102 são documentadas e medidas, sem mexer no instrumento.
> - A regra de leitura dos três testes do CDS foi commitada antes de rodar (`5048a09`).
> - Scripts: `script/download_copom_minutes.R` (estágio de rede `copom_atas`, grava
>   `data/raw/copom_atas.csv`) e `script/copom_timing.R`. Saídas em `output/copom_timing/`. Nada no
>   `.tex` nem em `paper/img/`.

## 1. A convenção

O orientador fixa a convenção: a cotação anterior tem de vir de uma sessão encerrada antes da
divulgação, e a primeira cotação posterior é a do pregão seguinte de cada mercado. Para cada uma das
111 reuniões de 2012-03 a 2025-12 (165ª a 275ª, todas ordinárias, todas em quarta), o script:
- data o anúncio;
- acha, no DI, na PTAX e no CDS, a última cotação antes dele e a primeira depois;
- compara essas datas com as que o instrumento (`R/instrument/build_variants.R`) e
  `script/daily_event.R` usam.

## 2. O horário do anúncio

A fonte é a ata de cada reunião, que registra o início e o término de cada sessão. O comunicado sai
depois da última sessão da quarta. A API do BCB (`atas_detalhes`) devolve a ata em HTML, menos nas
reuniões 200 a 231, que só existem em PDF e foram convertidas com `pdftotext`. O anúncio é o término
dessa sessão, ou o horário mínimo que o BCB anunciou para o período, o que vier depois.

| período | reuniões (nas 102) | horário mínimo | anúncio | fonte do mínimo |
|---|---|---|---|---|
| 2012-03 a 2016-06 | 35 (31) | nenhum; o segundo dia começava por volta das 16h30 | 19h19 a 20h55 | Jornal do Comércio, 12/07/2016 |
| 2016-07 a 2020-10 | 35 (33) | 18h; 18h20 de out a fev até 2020, pelas atas | 18h00 a 18h20 | notas do BCB de 11/07/2016, 21/02/2017, 10/04/2017 e 12/03/2020 |
| 2020-12 a 2025-12 | 41 (38) | 18h30 | 18h30 a 19h12 | nota do BCB de 17/11/2020; Resolução BCB 61, de 13/01/2021 |

- Nas atas, as reuniões de out/2016 a fev/2017, out/2017 a fev/2018, dez/2018 a fev/2019 e dez/2019
  a fev/2020 terminam às 18h20 (2019-12-11 às 18h11), e as demais desse período entre 18h00 e 18h19.
  O mínimo de 18h20 só está documentado para fev/2017, pela nota de 21/02/2017 e pela de 10/04/2017,
  que o encerra. Os retornos a 18h de
  mar/2019 e mar/2020 implicam um mínimo mais tarde nos invernos de 2017-18, 2018-19 e 2019-20, mas
  o valor não foi achado, e para essas reuniões vale o término da ata.
- O BCB declara em todas essas notas que o horário segue o fechamento dos mercados domésticos.
- O menor anúncio da amostra é 18h00.
- Antes de 2016-07 o anúncio é o término da ata, e o comunicado sai em seguida, a um intervalo que
  não se sabe.

## 3. DI

**Janela:** `CloseRate`, o último negócio, do fechamento de quarta ao de quinta, no contrato mais
próximo de 126 d.u. cotado nos dois dias.

- Fontes de mercado sem data dão ao DI1 negociação das 9h às 16h, com extensão até 18h; a Exame dá
  18h15 para o segmento BM&F em out/2012, sem distinguir o contrato; a grade atual da B3 vai das 9h
  às 18h. A grade data a data não foi reconstruída. Todo anúncio vem às 18h00 ou depois, o BCB o põe
  depois do fechamento doméstico, e até jun/2016 ele vem depois das 19h19.
- O que os dados dizem (`di_close_settlement.csv`):
  - nas 102 reuniões, a surpresa de fechamento a fechamento e a de ajuste a ajuste têm correlação
    0,959;
  - a diferença entre fechamento e ajuste da quarta, que mede o que andou depois da janela do ajuste
    (por volta das 16h), não acompanha a variação de ajuste a ajuste: coeficiente 0,026, EP 0,044,
    p 0,55. Se negócios posteriores ao anúncio entrassem no fechamento de quarta, essa diferença
    andaria com a notícia;
  - a mediana dessa diferença em módulo é 1,0 p.b. nas quartas de Copom, contra 0,5 nas outras 556
    quartas;
  - a maior diferença é de −37 p.b., em 2020-03-18, dia de circuit breakers na B3. A reunião
    terminou às 18h06.
- **A janela do DI cumpre a convenção nas 102 reuniões.**

## 4. Câmbio: a convenção cambial

**Janela:** PTAX de venda (SGS 1), em R$/US$. A PTAX de um dia é a média de quatro consultas, às 10h,
11h, 12h e 13h (Circular 3.506). Nos dias consultados em jan/2015, o boletim de fechamento saiu entre
13h07 e 13h16 (nota `2026-10-05_evento_diario`).

- A de quarta vem antes do anúncio, e a de quinta é a primeira depois dele. **Cumpre a convenção nas
  102.**
- A janela termina às 13h de quinta. Não pega a tarde de quinta e não coincide com a do DI, que vai
  até o fim da sessão.
- O câmbio diário do Yahoo (`BRL=X`) não serve para a janela, porque carimba as barras à meia-noite de
  Londres e, no inverno europeu, a linha datada d acompanha a sessão d−1 (nota
  `2026-10-05_evento_diario`, seção 1; item do Tema D). A ponte não o usa.

## 5. CDS

**Janela usada em `daily_event.R`:** fechamento de quarta ao de quinta, `PX_LAST` da Bloomberg
(`BRAZIL CDS USD SR 5Y D14 Corp`). A fonte de preço e o horário do fechamento não estão no arquivo. Os
dados são do orientador, e o autor não tem a informação.

O que a documentação pública diz:
- a fonte CBGN da Bloomberg é um retrato da CBIN, a composição intradiária, no fechamento de Nova York
  (guia de usuário da Bloomberg da Universidade de Washington, 2010);
- as cotações de fim de dia da CMA na Bloomberg são tiradas às 17h de Nova York e às 17h de Londres
  (Risk.net e WatersTechnology).

A rodada carrega duas hipóteses de Nova York, 17h e 18h, e testa nos dados contra Londres.

### 5.1 Quantas reuniões violam a convenção em cada hipótese

O fechamento de quarta vem depois do anúncio quando o horário de NY, levado a Brasília com o horário
de verão de cada país, passa do anúncio. Nesses casos, a janela que cumpre a convenção vai da cotação
anterior à quarta até a de quarta.

| período | reuniões | depois do anúncio, NY 17h | depois do anúncio, NY 18h |
|---|---|---|---|
| 2012-03 a 2016-06 | 31 | 3 | 8 |
| 2016-07 a 2020-10 | 33 | 11 | 33 |
| 2020-12 a 2025-12 | 38 | 13 | 36 |
| total | 102 | **27** | **77** |

- Com fechamento em Londres (16h30, 12h30 a 14h30 em Brasília), a quarta vem antes do anúncio em
  todas.
- Com NY às 17h, há empate em 10 reuniões do período de 18h: o fechamento é às 18h00 de Brasília e a
  reunião termina às 18h00. Elas contam como "antes".
- Antes de 2016-07 o anúncio é um limite inferior, porque o comunicado sai depois do término da ata.
  Com NY às 17h, 2 das 3 reuniões "depois" ficam a menos de 30 minutos e podem passar a "antes"; com
  NY às 18h, 1 das 8.

### 5.2 Os três testes, pela regra fixada antes de rodar

**(A) Calendário: inconclusivo.** O CDS cota em todos os 72 feriados só dos EUA, em todos os 37 só do
Reino Unido e em todos os 21 dias em que os dois mercados fecham.
- Descritivo, fora da regra: nenhum desses dias tem variação zero, o que descarta que a cotação deles
  seja só a do dia anterior repetida.
- A mediana de |ΔCDS| é menor nos feriados: 0,41 p.b. com os dois mercados fechados, 0,90 nos só dos
  EUA e 1,19 nos só do Reino Unido, contra 2,35 em todos os dias.

**(B) Alinhamento diário: inconclusivo.** Correlações de ΔCDS com as variações do Ibovespa, da PTAX e
do S&P 500 (`cds_alignment.csv`):

| horário de verão dos EUA | dias | Ibov d−1 | Ibov d | Ibov d+1 | PTAX d | PTAX d+1 | S&P d−1 | S&P d |
|---|---|---|---|---|---|---|---|---|
| não | 1087 | −0,146 | −0,505 | −0,053 | 0,426 | 0,235 | −0,084 | −0,460 |
| sim | 2254 | −0,069 | −0,604 | 0,053 | 0,457 | 0,187 | −0,018 | −0,557 |

- A condição de Nova York vale no verão americano e falha no inverno, onde |cor(Ibov d−1)| é 0,146,
  acima do limite de 0,1.
- A condição de Londres falha nos dois regimes: a correlação com o Ibovespa do próprio dia domina, e a
  com a PTAX de d+1 fica acima de 0,1.
- O teste não separa 17h de 18h.

**(C) Janelas do evento, descritivo** (`cds_event.csv`). Coeficiente por +50 p.b., EP HC1.

| janela | surpresa | 102 reuniões | quarta depois do anúncio com NY 17h (27) |
|---|---|---|---|
| anterior → quarta | bruta | 0,93 (3,62; p 0,80) | 0,77 (2,73; p 0,78) |
| anterior → quarta | ortogonalizada | 3,70 (5,94; p 0,53) | 1,16 (2,69; p 0,67) |
| quarta → quinta | bruta | 0,94 (2,69; p 0,73) | 5,38 (3,50; p 0,12) |
| quarta → quinta | ortogonalizada | −0,49 (4,07; p 0,90) | 4,00 (3,37; p 0,24) |
| anterior → quinta | bruta | 1,88 (2,79; p 0,50) | 6,15 (3,47; p 0,077) |
| anterior → quinta | ortogonalizada | 3,21 (3,51; p 0,36) | 5,16 (3,40; p 0,13) |

- A linha de quarta a quinta nas 102 é a de `daily_event.R`.
- A janela que vai da cotação anterior à quarta até a de quinta contém o anúncio em qualquer das três
  hipóteses de horário, ao custo de incluir a tarde da véspera.
- Nas 102, o CDS não é significante a 90% em nenhuma janela.
- Pela regra, o teste não decide o horário.

### 5.3 Leitura

- O horário do fechamento do CDS não fica fixado: nem o arquivo nem os dados o determinam.
- A documentação pública aponta Nova York. Nos dados, a condição de Londres falha nos dois regimes, e
  a de Nova York só vale no verão americano.
- **A janela de quarta a quinta do CDS cumpre a convenção só com fechamento em Londres.** Com Nova
  York, falha em 27 (17h) a 77 (18h) das 102 reuniões.
- A escolha da janela do CDS na ponte (a) fica para o autor, antes de rodá-la.

## 6. As 9 reuniões fora das 102

| reunião | quarta | motivo | 1ª sessão de DI e PTAX depois | ΔDI bruta (p.b.) | ΔPTAX (R$/US$) | ΔPTAX (%) | ΔCDS NY 17h | ΔCDS NY 18h |
|---|---|---|---|---|---|---|---|---|
| 175ª | 2013-05-29 | quinta, Corpus Christi | sexta, 05-31 | +37,0 | +0,0425 | +2,01 | −0,19 | −0,19 |
| 179ª | 2013-11-27 | quinta, Thanksgiving | quinta, 11-28 | −19,0 | +0,0150 | +0,65 | −0,17 | +2,50 |
| 191ª | 2015-06-03 | quinta, Corpus Christi | sexta, 06-05 | +9,0 | +0,0500 | +1,59 | +4,32 | +4,32 |
| 195ª | 2015-11-25 | quinta, Thanksgiving | quinta, 11-26 | +8,5 | −0,0082 | −0,22 | +23,86 | +23,86 |
| 209ª | 2017-09-06 | quinta, 7 de setembro | sexta, 09-08 | −2,5 | −0,0225 | −0,73 | −3,61 | −2,75 |
| 223ª | 2019-06-19 | quinta, Corpus Christi | sexta, 06-21 | −10,0 | −0,0468 | −1,22 | −3,80 | −5,62 |
| 247ª | 2022-06-15 | quinta, Corpus Christi | sexta, 06-17 | −1,0 | +0,0194 | +0,38 | +12,89 | −10,00 |
| 258ª | 2023-11-01 | quinta, Finados | sexta, 11-03 | −4,5 | −0,1284 | −2,59 | −9,14 | −5,58 |
| 271ª | 2025-06-18 | quinta, Corpus Christi (e Juneteenth) | sexta, 06-20 | +8,5 | +0,0078 | +0,14 | +1,05 | +2,27 |

**Por que ficam fora:**
- Em 7 delas a quinta é feriado no Brasil. `build_thursday_surprises()` exige uma cotação de DI na
  quinta de calendário, e pela convenção a primeira cotação posterior de DI e de PTAX é a de sexta.
- Nas 2 de Thanksgiving, DI e PTAX existem na quinta, e as janelas da convenção são as do instrumento.
  As duas caem só pelo filtro da variação de S&P 500, VIX e Brent na quinta, que não entra em regressão
  alguma e serve apenas para fixar a amostra.

**Leitura:**
- A variação do DI é a surpresa bruta, medida com o contrato fixo e calculada pela mesma função do
  instrumento, com a primeira sessão posterior no papel da quinta. A ortogonalizada exigiria refazer a
  regressão Bauer-Swanson.
- Nos 7 feriados a janela é de dois dias e inclui o feriado, em que os mercados de fora operam.
- ⚠ A 175ª reunião, de 2013-05-29, tem surpresa bruta de +37 p.b. Isso é 2,8 desvios-padrão das 102,
  cujo máximo é +41.
- **Os meses dessas 9 reuniões entram no instrumento com surpresa zero**, embora tenha havido decisão
  (`months.csv`): 2013-05, 2013-11, 2015-06, 2015-11, 2017-09, 2019-06, 2022-06, 2023-11 e 2025-06.
  Nenhum deles tem outra reunião. Incluí-las ou não é decisão do autor.

## 7. A correspondência entre reuniões e meses

- O mês do instrumento é o da quinta. O da convenção é o do primeiro pregão de DI depois do anúncio.
  Nas 102 os dois coincidem, e as somas mensais de `delta_di` e `e_di_bs` reproduzem `z_bruto` e
  `z_bs_purif` a 1e-10.
- Sete reuniões caem no último pregão do mês, e a surpresa delas vai ao mês seguinte: 2016-08-31,
  2016-11-30, 2017-05-31, 2018-10-31, 2019-07-31, 2024-01-31 e 2024-07-31.
- Nessas sete, o que acontece com cada medida mensal da reunião ao mês:
  - **`yield_6m`:** é a última cotação do mês da curva do orientador. Nas sete, ela é a da própria
    quarta, anterior ao anúncio, e a correspondência é coerente.
  - **Câmbio do painel:** é a média dos dias do Yahoo no mês de calendário
    (`R/data_download/exchange.R:103`). O mês m não tem sessão posterior ao anúncio. No inverno europeu
    (2016-11-30, 2018-10-31, 2024-01-31), a linha do Yahoo datada no dia 1º do mês seguinte acompanha a
    sessão de quarta, anterior ao anúncio, e entra na média do mês da surpresa.
  - **CDS do painel:** é a última cotação do mês do Investing, de horário também desconhecido. Se ela
    fechar como o CDS da Bloomberg em Nova York, a cotação de quarta já vem depois do anúncio em 2 das
    sete com NY às 17h (2016-11-30 e 2024-01-31) e nas sete com NY às 18h. A reação ficaria então no
    mês m, e a surpresa no mês m+1.
- A comparação entre fim de mês e média, e o tratamento dos meses sem reunião, ficam para a ponte (b).

## 8. O que pode e o que não pode ser dito

- Pode: pelas atas, o anúncio de cada reunião vem às 18h00 ou depois. Até jun/2016 ele vem entre 19h19
  e 20h55, de 2016-07 a 2020-10 entre 18h00 e 18h20, e desde 2020-12 entre 18h30 e 19h12.
- Pode: as janelas do DI (fechamento de quarta ao de quinta) e da PTAX (13h de quarta às 13h de quinta)
  cumprem a convenção nas 102 reuniões.
- Pode: 9 das 111 reuniões ficam fora, e os meses delas entram com surpresa zero.
- Pode: a surpresa vai ao mês do primeiro pregão depois do anúncio. Nas sete reuniões de fim de mês,
  a `yield_6m` do mês da reunião é a cotação de quarta, anterior ao anúncio.
- Não pode: dizer que a janela do CDS de quarta a quinta cumpre a convenção. Ela depende de um horário
  de fechamento que o arquivo não traz e os dados não fixam.
- Não pode: dizer que o CDS fecha em Nova York ou em Londres. O horário é inferido, não declarado, e o
  teste da regra deu inconclusivo.
- Não pode: ler o teste (C) como evidência do horário, nem a falta de significância do CDS como
  ausência de resposta.
- Não pode: atribuir a troca de sinal do câmbio entre o evento diário e o DFM mensal a qualquer item
  desta conferência.

## 9. O que mudou

- `script/download_copom_minutes.R`, novo estágio de rede `copom_atas` em `script/run_all.R`, grava
  `data/raw/copom_atas.csv` com as 111 atas, 79 em HTML e 32 convertidas de PDF.
- `script/copom_timing.R` escreve `output/copom_timing/`. O horário extraído foi conferido à mão contra
  quatro atas de formatos diferentes: 165ª 20h50, 206ª 18h01, 245ª 19h03 e 270ª 18h36.
- Nada em `R/`, `data/processed/` ou no resto de `output/` mudou, e o smoke test sai bit-idêntico.

## Fontes do horário

- Atas do Copom: `https://www.bcb.gov.br/api/servico/sitebcb/copom/atas_detalhes?nro_reuniao=N`.
- 11/07/2016, a partir das 18h: Jornal do Comércio, "BC muda horário de reuniões do Copom e data de
  divulgação da ata", 12/07/2016.
- 21/02/2017, segue a partir das 18h20: Estado de Minas, 21/02/2017.
- 10/04/2017, volta às 18h a partir da reunião de 12/04: InfoMoney, 10/04/2017.
- 12/03/2020, volta às 18h a partir da reunião de 17 e 18/03: IstoÉ Dinheiro e Meon, 12/03/2020.
- 17/11/2020, a partir das 18h30: Seu Dinheiro, 17/11/2020.
- 13/01/2021, sempre a partir das 18h30: Resolução BCB 61; Seu Dinheiro, 13/01/2021.
- A nota de 12/03/2019 (volta às 18h na reunião de 19 e 20/03) só foi vista por resumo de busca. A ata
  da 221ª confirma o término às 18h04.
- DI1: página de horários de taxas de juros da B3 (grade atual); Exame, out/2012.
- CDS: guia de usuário da Bloomberg da Universidade de Washington (2010) e Risk.net/WatersTechnology
  sobre a CMA.
