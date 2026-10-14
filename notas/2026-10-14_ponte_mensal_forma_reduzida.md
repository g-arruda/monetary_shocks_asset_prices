# Ponte (b): forma reduzida mensal de câmbio e CDS na surpresa agregada, sem fatores

> **CURRENT — 2026-10-14.** Ponte (b) do e-mail do orientador de 12-10
> (`email/email_professor_12-10_19h40.md`, item 2b). Branch `feature/focus-horizonte-fixo`, **não
> mergeada**.
> - **Regra commitada antes de rodar** (`e19a754`), no cabeçalho de `script/monthly_reduced_form.R`:
>   janela, surpresas, séries, agregações, amostras, horizontes, normalização, inferência e leitura.
> - **Rodada em `f4b916e`**, sem mudança de código depois do commit da regra. Antes dele, só a parte de
>   dados do script (séries mensais, marcas de reunião e as guardas delas, sem regressão) rodou no
>   scratchpad. Ela pegou um erro de código: `summarise(.by =)` não aceita renomear. Nenhuma regressão
>   foi vista antes do commit.
> - **Decisões do autor em 14-10, antes de rodar:**
>   - séries do painel e a outra agregação, construída dos diários;
>   - fim de mês alinhado à `yield_6m`;
>   - três amostras para os meses com z = 0;
>   - surpresas ortogonalizada e bruta;
>   - h = 0 e 1;
>   - forma reduzida e IV pela `yield_6m`.
> - A regressão IV escalar do passo 2 passou a `R/identification/weak_iv_ar.R` como
>   `fit_reduced_form_iv()` (`fbf9c35`), com Newey-West entre meses vizinhos no calendário.
>   - `output/daily_event/` saiu byte-idêntico.
>   - O smoke test saiu bit-idêntico aos valores da branch, e os sete validadores passam.
> - Nada reestimado: o instrumento, o painel e o DFM de produção ficaram intocados.

## 1. O desenho

- **Janela.** As 162 inovações fatoriais do DFM, de 2012-07 a 2025-12. A surpresa do mês t é a do
  instrumento: a soma das surpresas das reuniões cujo primeiro pregão de DI depois do anúncio cai em t
  (`R/instrument/build_variants.R`). Nenhum mês tem duas reuniões.
- **Surpresas.**
  - `z_bs_purif`, a ortogonalizada: a da produção e a mesma da ponte (a), somada no mês.
  - `z_bruto`, a bruta.
- **Respostas.** Câmbio em R$ por US$ e em % (100·Δlog); CDS de 5 anos em p.b.
- **Agregação**, duas por série:
  - *painel*: as séries do DFM, isto é, o câmbio como média mensal e o CDS como fim de mês
    (seção 2);
  - *alternativa*, construída dos arquivos diários:
    - o câmbio de fim de mês alinhado à `yield_6m`;
    - o CDS como média mensal do Bloomberg.
- **Amostras** (seção 3): (i) z = 0 em todo mês sem surpresa, como no DFM, 162 meses; (ii) sem os 9
  meses de reunião fora das 102, 153; (iii) só os 99 meses com reunião das 102.
- **Horizontes.** h = 0 é x_t − x_{t−1}; h = 1 é x_{t+1} − x_{t−1}. Em h = 1 sai 2025-12, que não tem
  t + 1.
- **Normalização.**
  - Primeiro a forma reduzida, por +50 p.b. de surpresa, com intervalos de Wald a 90 e 95%.
  - Depois o efeito por +50 p.b. de variação da `yield_6m` de fim de mês em t, a normalização do DFM.
    É um IV exatamente identificado, com primeiro estágio (π, F) e conjunto Anderson-Rubin a 90 e 95%.
  - Na forma reduzida e no IV, a significância é a mesma, porque o conjunto exclui o zero se e só se
    a forma reduzida rejeita (guarda da função).
- **Inferência.** HC1 em h = 0. Em h = 1, cujas janelas se sobrepõem em um mês, Newey-West com uma
  defasagem de Bartlett, que só pareia meses vizinhos no calendário; isso importa na amostra (iii), que
  tem buracos.
- **DFM ao lado.** A célula de produção com `z_bs_purif` e com `z_bruto`, em h = 0 e 1, com conjuntos
  AR de 90 e 95% e ξ_mp. Ela confere com o passo 1 (`output/ar_precision/table.csv`, h0 e h1) e com o
  passo 2 (`output/daily_event/comparison.csv`, h0) a 1e-10.

## 2. Fim de mês contra média

O que o orientador pede documentar.

- **`yield_6m`: fim de mês.** É o fechamento do DI no último pregão do mês. Nas 7 reuniões no último
  pregão do mês, ela é a cotação de quarta, anterior ao anúncio (guarda de `copom_timing.R`), e a
  surpresa vai ao mês seguinte. A `yield_6m` de t, portanto, não contém essas 7 reuniões, e a de t+1
  contém.
- **`cambio_usd` do DFM: média mensal.** É a média das linhas do Yahoo `BRL=X` agrupadas pela **data do
  arquivo** no mês civil (`R/data_download/exchange.R`). O script confere a média contra o painel a
  1e-12, nos 166 meses.
  - Cada linha traz a cotação da noite: 20h–22h de Brasília da própria data no verão europeu, e da
    véspera fora dele (`load_yahoo_brl()`; nota `2026-10-13_cambio_yahoo_convencao`).
  - A média do mês mistura os dias antes e depois da reunião do mês, e a parte posterior à reunião é
    tanto menor quanto mais tarde no mês ela cai.
  - Nas 7 reuniões de fim de mês, a primeira cotação posterior ao anúncio entra na média de t em 4
    (verão europeu: 2016-08-31, 2017-05-31, 2019-07-31, 2024-07-31) e na de t+1 em 3 (2016-11-30,
    2018-10-31, 2024-01-31). A surpresa vai a t+1 nas 7 (`meetings.csv`, `yahoo_post_month`).
- **`cds_5y` do DFM: fim de mês.** É o fechamento do Investing (`data/raw/investing/cds5y.csv`), com
  correlação 0,9994 com o fechamento de fim de mês do Bloomberg (`.claude/rules/data.md`).
  - ⚠ O horário do fechamento do Investing não é conhecido.
  - Se for o do Bloomberg às 17h de Nova York, em 2 das 7 reuniões de fim de mês (2016-11-30 e
    2024-01-31) o fechamento de quarta vem depois do anúncio. Ele então entra no mês t, com a surpresa
    em t+1 (`wednesday_close_after_ny17`).
  - A série do painel não é corrigida.
- **Câmbio de fim de mês (alternativa).** É a última cotação do Yahoo do mês civil pela hora de Brasília.
  - Nos 7 meses cujo último pregão tem reunião, a cotação civil vem depois do anúncio, e o script a
    troca pela última anterior (`yahoo_pre`), a da noite de terça. Assim a reunião fica no mês da sua
    surpresa, como na `yield_6m`.
  - Os 7 meses e a cotação tomada: 2016-08 (30/08, 20h), 2016-11 (29/11, 22h), 2017-05 (30/05, 20h),
    2018-10 (30/10, 21h), 2019-07 (30/07, 20h), 2024-01 (30/01, 21h) e 2024-07 (30/07, 20h).
  - Nos outros meses ela é a cotação da noite do último dia do mês.
- **CDS médio (alternativa).** É a média dos fechamentos diários do Bloomberg no mês, com 20 a 23
  cotações por mês. ⚠ A fonte é outra que a do painel (Bloomberg, não Investing).

## 3. Meses sem reunião

- No instrumento, e portanto no DFM, a surpresa é zero em todo mês sem surpresa
  (`build_variants.R`), e o DFM usa os 162 meses.
- Dos 162 meses da janela:
  - 99 têm reunião entre as 102;
  - 9 têm reunião fora das 102 e entram com zero (2013-05, 2013-11, 2015-06, 2015-11, 2017-09, 2019-06,
    2022-06, 2023-11, 2025-06; 7 quintas de feriado no Brasil e 2 de Thanksgiving);
  - 54 não têm reunião.
- Um zero do instrumento não separa "sem reunião" de "reunião fora da amostra". A amostra (ii) tira os 9,
  e a (iii) fica só com os 99.
- **Resultado.** Em nenhuma das 24 combinações de resposta, agregação, surpresa e h a amostra muda o
  sinal ou a significância a 90 ou 95%.
  - O ponto se move na terceira casa: câmbio de referência em h0, R$ 0,145, 0,144 e 0,144 nas amostras
    (i), (ii) e (iii).
  - O primeiro estágio também quase não se move: π de 1,85 a 1,86 e F de 9,27 a 9,32 na ortogonalizada.
- Daqui em diante, os números são os da amostra (i).

## 4. Forma reduzida, por +50 p.b. de surpresa

`output/monthly_reduced_form/regressions.csv`, amostra (i). O R² vai de 0,0006 a 0,068.

**Câmbio, R$ por US$**

| surpresa | agregação | h | efeito | 90% | 95% | p | significância |
|---|---|---|---|---|---|---|---|
| ortogonalizada | painel (média) | 0 | **+0,145** | [+0,030; +0,259] | [+0,009; +0,281] | **0,037** | **95%** |
| ortogonalizada | painel (média) | 1 | **+0,293** | [+0,116; +0,470] | [+0,082; +0,503] | **0,006** | **95%** |
| ortogonalizada | fim de mês | 0 | +0,115 | [−0,018; +0,248] | [−0,043; +0,273] | 0,154 | não a 90% |
| ortogonalizada | fim de mês | 1 | +0,158 | [−0,041; +0,357] | [−0,079; +0,395] | 0,193 | não a 90% |
| bruta | painel (média) | 0 | +0,107 | [+0,003; +0,211] | [−0,017; +0,231] | 0,092 | 90% |
| bruta | painel (média) | 1 | +0,212 | [+0,082; +0,341] | [+0,057; +0,366] | 0,007 | 95% |
| bruta | fim de mês | 0 | +0,031 | [−0,072; +0,133] | [−0,091; +0,153] | 0,622 | não a 90% |
| bruta | fim de mês | 1 | +0,069 | [−0,084; +0,222] | [−0,114; +0,251] | 0,459 | não a 90% |

**Câmbio, %**

| surpresa | agregação | h | efeito | 90% | 95% | p | significância |
|---|---|---|---|---|---|---|---|
| ortogonalizada | painel (média) | 0 | +3,39 | [+0,94; +5,83] | [+0,47; +6,30] | 0,023 | 95% |
| ortogonalizada | painel (média) | 1 | +6,79 | [+2,87; +10,71] | [+2,12; +11,46] | 0,004 | 95% |
| ortogonalizada | fim de mês | 0 | +2,70 | [−0,27; +5,66] | [−0,84; +6,23] | 0,135 | não a 90% |
| ortogonalizada | fim de mês | 1 | +3,57 | [−0,79; +7,93] | [−1,63; +8,76] | 0,178 | não a 90% |
| bruta | painel (média) | 0 | +2,27 | [−0,002; +4,54] | [−0,44; +4,98] | 0,100 | não a 90% |
| bruta | painel (média) | 1 | +4,62 | [+1,55; +7,70] | [+0,96; +8,28] | 0,013 | 95% |
| bruta | fim de mês | 0 | +0,52 | [−1,86; +2,90] | [−2,31; +3,36] | 0,718 | não a 90% |
| bruta | fim de mês | 1 | +1,39 | [−2,05; +4,84] | [−2,71; +5,50] | 0,507 | não a 90% |

**CDS de 5 anos, p.b.**

| surpresa | agregação | h | efeito | 90% | 95% | p | significância |
|---|---|---|---|---|---|---|---|
| ortogonalizada | painel (fim de mês) | 0 | **+41,3** | [+18,7; +63,9] | [+14,4; +68,2] | **0,003** | **95%** |
| ortogonalizada | painel (fim de mês) | 1 | **+43,0** | [+10,1; +75,9] | [+3,8; +82,3] | **0,032** | **95%** |
| ortogonalizada | média (Bloomberg) | 0 | +27,4 | [+6,3; +48,5] | [+2,3; +52,6] | 0,032 | 95% |
| ortogonalizada | média (Bloomberg) | 1 | +54,5 | [+21,3; +87,5] | [+15,0; +93,9] | 0,007 | 95% |
| bruta | painel (fim de mês) | 0 | +26,4 | [+7,8; +45,1] | [+4,2; +48,6] | 0,020 | 95% |
| bruta | painel (fim de mês) | 1 | +30,1 | [+3,8; +56,4] | [−1,2; +61,5] | 0,060 | 90% |
| bruta | média (Bloomberg) | 0 | +19,9 | [+4,3; +35,6] | [+1,3; +38,6] | 0,036 | 95% |
| bruta | média (Bloomberg) | 1 | +41,9 | [+17,2; +66,5] | [+12,5; +71,2] | 0,005 | 95% |

- Em %, o câmbio da bruta no painel em h0 tem p 0,1002 e não é significante a 90%, enquanto em R$ é
  significante a 90% (p 0,092).

## 5. Por +50 p.b. de `yield_6m`, ao lado do DFM

**Primeiro estágio** (Δ`yield_6m` em p.b. na surpresa em p.b., amostra (i), h0):
- ortogonalizada: π = 1,855 (EP 0,608), F 9,30;
- bruta: π = 2,065 (EP 0,531), F 15,13.

⚠ Na ortogonalizada o F fica abaixo de 10. Valem os conjuntos AR, não o Wald.

`output/monthly_reduced_form/comparison.csv`. Ponto, conjunto de 90% e significância. O DFM tem ξ_mp
6,661 (ortogonalizada) e 6,224 (bruta).

| resposta | surpresa | h | mensal, painel | mensal, alternativa | DFM |
|---|---|---|---|---|---|
| câmbio | ortogonalizada | 0 | 0,078 [0,016; 0,201], 95% | 0,062 [−0,009; 0,194], não a 90% | 0,145 [0,068; 0,281], 95% |
| câmbio | ortogonalizada | 1 | 0,158 [0,052; 0,428], 95% | 0,085 [−0,019; 0,316], não a 90% | 0,179 [0,062; 0,360], 95% |
| câmbio | bruta | 0 | 0,052 [0,001; 0,112], 90% | 0,015 [−0,041; 0,067], não a 90% | 0,096 [−0,006; 0,184], não a 90% |
| câmbio | bruta | 1 | 0,103 [0,038; 0,209], 95% | 0,033 [−0,042; 0,128], não a 90% | 0,112 [−0,049; 0,244], não a 90% |
| CDS | ortogonalizada | 0 | 22,3 [9,2; 53,1], 95% | 14,8 [3,1; 40,5], 95% | 33,5 [15,0; 66,4], 95% |
| CDS | ortogonalizada | 1 | 23,2 [5,3; 59,4], 95% | 29,4 [10,4; 74,0], 95% | 36,9 [16,1; 69,3], 95% |
| CDS | bruta | 0 | 12,8 [4,0; 24,7], 95% | 9,7 [2,1; 20,5], 95% | 22,2 [−1,2; 44,9], não a 90% |
| CDS | bruta | 1 | 14,6 [2,1; 29,6], 90% | 20,3 [8,5; 38,5], 95% | 26,1 [−0,6; 50,6], não a 90% |

- Na ortogonalizada, com as séries do painel, cada ponto mensal cai dentro do conjunto de 90% do DFM,
  e cada ponto do DFM dentro do conjunto mensal. Isso não é teste de igualdade.
- O ponto mensal é menor que o do DFM nas quatro células: câmbio 0,078 contra 0,145 em h0 e 0,158
  contra 0,179 em h1; CDS 22,3 contra 33,5 e 23,2 contra 36,9.
- Na bruta, o mensal é significante e o DFM não, nas quatro células do painel.

## 6. Leitura pela regra

Regra do cabeçalho, fixada antes de rodar. A linha de referência é painel, amostra (i), surpresa
ortogonalizada.
- **Câmbio: caso (i).** Positivo em h0 e h1 e significante a 95% nos dois. A depreciação aparece na
  forma reduzida mensal sem os fatores.
- **CDS: caso (i).** Positivo em h0 e h1 e significante a 95% nos dois.
- **As outras linhas, uma a uma:**
  - Câmbio de fim de mês: caso (ii) nas duas surpresas. É positivo em h0 e h1 e não é significante a
    90% em nenhum.
  - Câmbio do painel com a surpresa bruta: caso (i) (h0 a 90%, h1 a 95%).
  - CDS: caso (i) nas quatro combinações de agregação e surpresa.
  - Amostras: nenhuma muda a leitura (seção 3).
- **Contraste com a referência, descrito e não testado:**
  - Da média ao fim de mês, o câmbio enfraquece (0,145 → 0,115 em h0, 0,293 → 0,158 em h1) e perde os
    90%.
  - Do fim de mês à média, o CDS cai em h0 (41,3 → 27,4), sobe em h1 (43,0 → 54,5) e fica a 95%.
- Sem teste conjunto. As duas janelas se aninham, então os dois horizontes não são independentes.

## 7. Pontes (a) e (b) na mesma unidade

A forma reduzida das duas pontes é por +50 p.b. da mesma surpresa: `e_di_bs` por reunião, que é a
`z_bs_purif` do mês da reunião. As magnitudes se comparam; as janelas, não.

| | janela | câmbio, R$ | CDS, p.b. |
|---|---|---|---|
| (a) k = 1 | da última cotação antes do anúncio à primeira depois | −0,029 (90%) | −1,2 (não a 90%) |
| (a) k = 10 | até a 10ª cotação, 13–14 dias | +0,048 (não a 90%) | +16,5 (95%) |
| (a) k = 20 | até a 20ª cotação, 27–28 dias | +0,122 (95%) | +19,9 (não a 90%) |
| (b) h = 0, fim de mês | fim de t−1 a fim de t | +0,115 (não a 90%) | +41,3 (95%) |
| (b) h = 1, fim de mês | fim de t−1 a fim de t+1 | +0,158 (não a 90%) | +43,0 (95%) |
| (b) h = 0, média | média de t−1 a média de t | +0,145 (95%) | +27,4 (95%) |
| (b) h = 1, média | média de t−1 a média de t+1 | +0,293 (95%) | +54,5 (95%) |

- No CDS, o fim de mês é o do painel (Investing) e a média é a do Bloomberg. No câmbio, a média é a do
  painel e o fim de mês é o alinhado.
- A janela mensal começa no fim (ou na média) do mês anterior, e por isso contém os dias de t antes da
  reunião, que a ponte (a) não contém.

## 8. O que pode e o que não pode ser dito

- **Pode** (a significância segue as seções 4 e 5):
  - Na forma reduzida mensal sem os fatores, com as séries do DFM, a surpresa ortogonalizada e os meses
    sem reunião com zero, +50 p.b. de surpresa vêm com:
    - o real depreciando R$ 0,145 no mês, significante a 95%, e R$ 0,293 até o mês seguinte, também
      a 95%;
    - o CDS alargando 41,3 p.b. no mês e 43,0 até o seguinte, os dois significantes a 95%.
  - Pela regra, a depreciação aparece ao passar à frequência mensal sem os fatores e não surge só no DFM.
    Com a ponte (a), ela já aparece na trajetória diária.
  - Com o câmbio de fim de mês alinhado, o ponto segue positivo e não é significante a 90%: +0,115 no
    mês e +0,158 até o seguinte.
  - Como os meses sem reunião entram não muda sinal nem significância de nada.
  - Por +50 p.b. de `yield_6m`, com as séries do painel e a surpresa ortogonalizada:
    - o câmbio mensal deprecia 0,078 em h0 e 0,158 em h1, os dois significantes a 95%, contra 0,145
      e 0,179 do DFM;
    - o CDS alarga 22,3 e 23,2 p.b., contra 33,5 e 36,9 do DFM.

    O primeiro estágio tem F 9,30.
- **Não pode:**
  - Comparar a forma reduzida com o DFM em magnitude: o DFM é por +50 p.b. de `yield_6m`, a forma
    reduzida por +50 p.b. de surpresa. O R$ 0,145 das duas é coincidência de números.
  - Dizer que o primeiro estágio mensal é forte. F 9,30 na ortogonalizada.
  - Atribuir o enfraquecimento do câmbio de fim de mês ao alinhamento temporal da média, ou ao ruído de
    uma cotação só. As duas coisas mudam juntas e não foram separadas.
  - Atribuir a passagem da apreciação no evento à depreciação no mês a um mecanismo. A janela mensal
    acumula o mês inteiro, inclusive os dias antes da reunião, e a forma reduzida só diz quanto a
    variação se correlaciona com a surpresa.
  - Ler como resposta zero o que não é significante: o câmbio de fim de mês, e o câmbio da bruta em %
    no h0.
  - Tratar o CDS do painel como alinhado nas 2 reuniões de fim de mês de 2016-11 e 2024-01: o horário do
    Investing não é conhecido.
  - Tratar a hora da cotação do Yahoo como declarada. Ela é inferida (nota
    `2026-10-13_cambio_yahoo_convencao`).
  - Estender a leitura a outras séries ou horizontes: só câmbio e CDS, em h = 0 e 1.

## 9. O que muda com as respostas do orientador (e-mail de 14-10)

- **Câmbio (pergunta 1).** Se a janela do Yahoo mudar, só o câmbio de fim de mês depende dela, nos 7
  meses que tomam a `yahoo_pre`. Basta rodar de novo `copom_timing.R` e este script. Se a fonte mudar
  (outro câmbio que não o Yahoo), muda o `cambio_usd` do painel, e com ele `download.R`, `clean.R` e a
  base inteira.
- **CDS (pergunta 2).** Nada aqui usa o fechamento às 17h de NY: o CDS do painel é o do Investing e a
  alternativa é a média do Bloomberg. Não muda.
- **As 9 reuniões (pergunta 3).** Se entrarem, mudam o instrumento e a base: `instrument.R`,
  `copom_timing.R`, `ar_precision.R`, `daily_event.R` e este script.
  - As guardas de contagem do bloco de constantes (`N_EVENTS` 102, `N_MEETING_MONTHS` 99, `N_OUTSIDE`
    9) param o script até serem atualizadas.
  - A amostra (ii) passa a ser igual à (i).

## 10. O que mudou

- `R/identification/weak_iv_ar.R`: `fit_reduced_form_iv()` (`fbf9c35`), a antiga
  `fit_event_regression()` de `script/daily_event.R`. Ganhou `nw_lags` e `period`, sem default.
  - Com `nw_lags = 0` a conta é a de antes.
  - Acima disso, soma termos de Bartlett só entre observações vizinhas no calendário. Sem buracos,
    confere com `sandwich::NeweyWest(prewhite = FALSE, adjust = TRUE)`; com buracos, com a conta
    manual.
- `script/daily_event.R` chama a função com `nw_lags = 0`, e as saídas saíram byte-idênticas.
- `script/monthly_reduced_form.R`, novo, escreve `output/monthly_reduced_form/`:
  - `months.csv`, por mês;
  - `changes.csv`, por mês, resposta, agregação e h;
  - `regressions.csv`, 72 linhas;
  - `comparison.csv`, IV mensal e DFM.
- A linha de referência foi refeita à mão com `lm()` e `sandwich`: HC1 em h0, NW(1) em h1 e o IV.
- Smoke test bit-idêntico; os sete validadores passam.
