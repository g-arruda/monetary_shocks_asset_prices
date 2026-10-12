# Focus a horizonte fixo: câmbio e CDS no caso base reestimado

> **NÚMEROS DA BASE SUPERADOS em 2026-10-12** por
> [`2026-10-12_msci_emergentes`](2026-10-12_msci_emergentes.md). A série `msci` do painel era a ação
> da MSCI Inc. e passou a ser o índice MSCI de emergentes, e a base foi reestimada. A construção das
> Focus e as decisões desta nota seguem valendo. A comparação com `main` também continua como
> registro do efeito das Focus, porque as duas bases tinham a ação. θ̂, ξ_mp, as raízes e as respostas
> correntes estão na nota nova.

> **CURRENT — 2026-10-03.** Passo 0/5 do plano do orientador de 03-10
> (`email/email_professor_03-10_11h31.md`). Branch `feature/focus-horizonte-fixo`, **não mergeada**.
> - A branch muda o painel de produção: as seis séries Focus anuais passam de "ano seguinte" à
>   aproximação de horizonte fixo de 12 meses de Dovern, Fritsche e Slacalek (2012). Tudo o mais fica:
>   115 séries na mesma ordem, 2012-03 a 2025-12, `(r,q,p) = (5,5,4)`, `z_bs_purif`, escala COVID de
>   Lenza-Primiceri com θ reestimado no painel novo, conjuntos Anderson--Rubin de 80% e 90% com NW(0).
> - Linha de base: `main` em `d9ac7f0`, lida pelo git em `script/focus_fixed_horizon.R`.
> - Decisões do autor em 03-10: a fórmula do e-mail, as seis séries, a meta Selic nos três novembros
>   em que a Focus já não pergunta o ano corrente, e as colunas renomeadas de `_ny` para `_12m`.
> - Nada no `.tex` nem em `paper/img/`. Promover a `main` é decisão do autor depois que o orientador
>   vir esta nota.

## 1. Câmbio e CDS

O impacto e os seis primeiros meses de câmbio e CDS não mudam. O que muda é a ponta longa, onde a
reversão deixa de excluir zero a 90%.

| série | h | antes, ponto | antes, 90% | agora, ponto | agora, 90% | agora, 80% |
|---|---|---|---|---|---|---|
| BRL/USD (R$/US$) | 0 | 0,141 | [0,069; 0,275] | 0,146 | [0,071; 0,278] | [0,089; 0,230] |
| | 1 | 0,178 | [0,066; 0,354] | 0,180 | [0,064; 0,356] | [0,094; 0,294] |
| | 3 | 0,173 | [0,055; 0,319] | 0,172 | [0,058; 0,311] | [0,090; 0,266] |
| | 6 | 0,108 | [−0,024; 0,215] | 0,120 | [−0,003; 0,226] | [0,037; 0,195] |
| | 12 | 0,000 | [−0,148; 0,094] | 0,027 | [−0,111; 0,129] | [−0,064; 0,101] |
| | 24 | −0,090 | [−0,287; 0,017] | −0,077 | [−0,238; 0,044] | [−0,184; 0,011] |
| | 36 | −0,115 | [−0,327; −0,001] | −0,113 | [−0,280; 0,006] | [−0,223; −0,026] |
| CDS 5 anos (p.b.) | 0 | 34,0 | [15,7; 67,6] | 33,9 | [15,7; 66,0] | [20,1; 54,4] |
| | 1 | 36,7 | [16,5; 67,8] | 37,1 | [16,4; 68,8] | [21,8; 57,8] |
| | 3 | 34,9 | [15,0; 58,2] | 34,0 | [13,6; 57,0] | [19,6; 49,7] |
| | 6 | 24,0 | [0,3; 41,5] | 26,1 | [2,4; 44,0] | [10,3; 39,0] |
| | 12 | 3,5 | [−24,7; 21,0] | 9,0 | [−19,3; 27,4] | [−9,4; 22,7] |
| | 24 | −18,7 | [−57,1; 2,6] | −15,0 | [−47,9; 8,9] | [−36,8; 2,4] |
| | 36 | −25,9 | [−70,3; −2,0] | −24,4 | [−59,2; 0,3] | [−47,3; −6,3] |

Os horizontes são os que o passo 1 fixa antes de olhar os resultados, mais h36, onde a §4 para. O
câmbio sobe 3% no impacto (R$ 0,141 para 0,146 por dólar) e o CDS fica em 34 p.b. Nenhum ponto das
duas séries sai do conjunto de 90% antigo, de h0 a h36.

O conjunto de 90% do câmbio excluía zero em h0–h4 e h32–h36, e agora exclui em h0–h5. O do CDS
excluía em h0–h6 e h28–h36, e agora exclui em h0–h6. A reversão de longo prazo das duas séries
continua excluindo zero a 80% em h36, de modo que pela regra de dois níveis ela passa de
"significativa" a "direção e magnitude". Os conjuntos de 90% ficam 4% (câmbio) e 1% (CDS) mais
estreitos, em mediana, e o ponto de h36 quase não anda. A significância antiga da ponta longa
dependia de um limite superior encostado em zero (−0,001 no câmbio, −2,0 p.b. no CDS).

## 2. A construção

Na última pesquisa Focus do mês `m` do ano `y`, a série é

    (12 − m)/12 · F(y) + m/12 · F(y+1),

com `F` a mediana para o ano indicado, de modo que dezembro é a mediana do ano seguinte pura e
janeiro dá 11/12 ao ano que em dezembro era o seguinte. A virada de ano não produz salto.

A eq. (1) de Dovern, Fritsche e Slacalek (2012) dá peso `k/12` ao ano corrente, com `k` contando os
meses até o fim do ano **incluindo o da pesquisa**: em novembro, 2/12. A Consensus Economics responde
na primeira quinzena do mês, e o mês corrente ainda está por vir. A fórmula do e-mail dá 1/12 em
novembro, porque a última pesquisa Focus do mês fecha o mês, e restam `12 − m` meses do ano `y`. É a
mesma equação com o timing da Focus. Para Selic, câmbio e DLSP, que são valores de fim de ano, ela
coincide com a interpolação linear do valor em `t + 12` entre os dois fins de ano. DFS aplicam a regra
a PIB e inflação, e não aos juros, que a Consensus já pergunta a horizonte fixo.

**Lacunas.** A Focus deixa de perguntar o ano corrente quando o valor está decidido. O câmbio do ano
corrente falta nos 14 dezembros, e a Selic nos 14 dezembros e em nov/2012, nov/2013 e nov/2015,
quando a última reunião do ano (28/11/2012, 27/11/2013 e 25/11/2015) caiu antes da última pesquisa do
mês. Dezembro tem peso 0 no ano corrente e não precisa do valor. Nos três novembros entra a meta Selic
decidida naquela reunião (7,25, 10 e 14,25), que já é o valor de fim de ano, com peso 1/12. O autor
escolheu a SGS 432, e a meta veio de `data/raw/copom_historico.csv`, que traz o mesmo número por
reunião, porque `api.bcb.gov.br` não resolvia em 03-10 (NXDOMAIN inclusive no 8.8.8.8). Qualquer outra
lacuna para `clean.R`.

**Insumos.** `script/download_focus_current_year.R`, estágio de rede próprio, baixa a mediana do ano
corrente na data da última pesquisa do mês das séries "ano seguinte", sem re-baixar o painel de
`download.R`. O "ano seguinte" segue vindo de `raw_data.csv` e `focus_fiscal_expectations.csv`, que
não mudaram. A Olinda devolveu as mesmas medianas "ano seguinte" das de 2026-09-02 nas seis séries
(diferença máxima 0), e `download_focus_data()`, depois de extraída a busca anual para
`fetch_focus_annual()`, devolve os três arquivos brutos idênticos.

**Painel.** As outras 109 séries ficam bit-idênticas, e o painel-base de 106 também. A Focus PIB a
horizonte fixo deixa de ser classificada como sazonal pelo teste de `clean.R` (a "ano seguinte" passava
pelo X-13), e as seis entram sem ajuste.

## 3. As séries

Participação de janeiro na soma de quadrados das variações mensais (1/12 = 0,083 sem concentração):

| série | completa, antes | completa, agora | pré-COVID, antes | pré-COVID, agora | correlação dos níveis | correlação das variações |
|---|---|---|---|---|---|---|
| PIB | 0,735 | 0,011 | 0,759 | 0,039 | 0,684 | 0,197 |
| Selic | 0,578 | 0,085 | 0,539 | 0,171 | 0,962 | 0,663 |
| resultado primário | 0,441 | 0,010 | 0,506 | 0,050 | 0,939 | 0,564 |
| resultado nominal | 0,461 | 0,057 | 0,471 | 0,031 | 0,947 | 0,430 |
| DLSP | 0,394 | 0,057 | 0,603 | 0,021 | 0,997 | 0,661 |
| câmbio | 0,039 | 0,019 | 0,075 | 0,038 | 0,999 | 0,957 |

As participações de "antes" são das séries brutas, sem o X-13 que a Focus PIB recebia no painel, e
por isso diferem um pouco das da nota `2026-10-01_precovid_dbgg_focus_pib`. A Focus PIB é a série que
mais muda: o nível novo correlaciona 0,68 com o antigo, e as variações, 0,20. Em 2020 a PIB "ano
seguinte" subiu de 2,5% para 3,5%, porque mirava 2021, enquanto a de horizonte fixo caiu a −2,19% em
maio, com 7/12 do peso na previsão para 2020. O resultado primário a horizonte fixo chegou a −6,52% do
PIB em julho, contra −2,84% da "ano seguinte". A Selic
pré-COVID ainda tem o dobro da participação uniforme em janeiro (0,171), o que é notícia de janeiro e
não troca de ano-alvo.

## 4. O modelo

| | antes | agora |
|---|---|---|
| θ̂ (s̄0, s̄1, s̄2, ρ) | 6,611; 12,468; 1,760; 0,944 | 7,464; 15,012; 1,437; 0,966 |
| raiz máxima, completa / pré-COVID | 0,98368 / 0,99336 | 0,98550 / 0,99447 |
| ξ_mp, completa / pré-COVID | 7,019 / 6,837 | 6,802 / 5,504 |
| F_rob, completa / pré-COVID | 8,616 / 8,307 | 8,283 / 5,336 |
| ξ_mp completa, `z_bruto` / `z_jk_bs_purif` | 6,678 / 5,013 | 6,312 / 4,833 |
| Bai-Ng BLL IC1, IC2, IC3 | 5, 5, 20 | 5, 5, 18 |
| AIC / BIC em `T = 154` | `p = 4` / `p = 2` | `p = 4` / `p = 2` |

θ̂ passou pela trava de 750 inícios e pelas condições de primeira ordem em `p = 2..6`. `r = 5` e
`p = 4` seguem selecionados por IC1, IC2 e AIC. Todo conjunto de 80% e 90% da produção é `interval`,
2841 por nível, mais o `singleton` da normalização em h0.

⚠ **A força pré-COVID cai.** ξ_mp vai de 6,84 a 5,50 e F_rob de 8,31 a 5,34, contra 7,02 → 6,80 e
8,62 → 8,28 na amostra completa. Na grade, quatro células pré-COVID mudam de lado do 3,84: com
`z_jk_bs_purif`, `(4,3)` e `(4,4)` deixam de ser limitadas, e com `z_bruto`, `(7,2)` e `(8,2)` passam
a ser. O passo 1 pede intervalos pré-COVID, e a célula fica mais fraca antes de enfrentar o bloqueio de
`hac_dim`.

## 5. O painel inteiro

De h0 a h36, 37 dos 4255 pontos novos saem do conjunto de 90% antigo, em quatro séries: a Focus
resultado primário (27 horizontes, h0 e h11–h36), o salário mínimo (h1–h6), a Focus PIB (h0, h1 e h3)
e a Focus resultado nominal (h0). Três das quatro são as séries reconstruídas, que agora são outro
objeto, e o conjunto antigo é o de outra série.

Os pares série-horizonte com conjunto de 90% excluindo zero caem de 1588 para 1051, e os de 80%, de
2490 para 2366. Os conjuntos de 90% ficam 2% mais estreitos em mediana.

| horizontes | perdem a 90% | ganham a 90% |
|---|---|---|
| h0–h24 | 180 | 118 |
| h25–h36 | 488 | 13 |

Em h30–h36 as séries com conjunto de 90% excluindo zero vão de cerca de 50 para 1 a 7, e as de 80%
ficam em cerca de 78 nas duas células. A largura cai 6% a 9% nesses horizontes e o ponto, 3% a 8% em
valor absoluto. A ponta longa da produção antiga excluía zero a 90% por pouco em dezenas de séries ao
mesmo tempo, porque todas herdam a mesma dinâmica dos fatores, e uma mudança pequena nessa dinâmica
basta para tirar o zero de dentro ou pô-lo de volta em bloco. Por série, em `irf_outside.csv`: IPCA de
20 para 4 horizontes, núcleo IPC, núcleo IPCA-DW e spread PJ de 16 a 17 para 0, DLSP de 17 para 8,
EMBI de 15 para 7, DI de 2 a 10 anos de 16 para 6 ou 7, IBC-Br de 24 para 25.

## 6. O que muda na leitura da §4

Pontos tirados de `output/irf/irf_coherence_h.csv` nas duas células.

- **IPCA.** ⚠ A frase "o IPCA nunca fica positivo" deixa de valer: o ponto fica positivo em h1 e
  h3–h7, com máximo de +0,039 p.p. em h4, sem excluir zero. O conjunto de 90% exclui zero só em
  h30–h33, contra h17–h36 antes.
- **IBC-Br.** Negativo nos 36 meses, como antes, com conjunto de 90% excluindo zero em h0 e h3–h26
  (antes h0 e h3–h25).
- **Ibovespa.** O impacto vai de −2,47% a −1,65%. O conjunto de 90% exclui zero em h2 e h5–h11, só
  na fase positiva (máximo +3,03% em h2), nunca no impacto. Antes excluía em h5–h9 e h34–h36.
- **NFSP primária.** Positiva com conjunto de 90% excluindo zero em h22–h32, contra h16–h33 antes. O
  h1, negativo, deixa de excluir zero.
- **Focus PIB.** O impacto vai de −0,189 a −0,306 p.p. A nota de 01-10 previa metade da resposta com a
  carga sem janeiros (−0,091). A série a horizonte fixo é outra, e a previsão valia para a "ano
  seguinte" limpa do salto, não para esta. A fase positiva de h36 (+0,193) deixa de excluir zero a 90%.
- **Focus Selic.** O impacto vai de 0,471 a 0,433 p.p., e h6 e h36 deixam de excluir zero a 90%.
- **DBGG.** O impacto fica em −0,134 (era −0,136). O conjunto de 90% exclui zero em h3, e não mais em
  h6 nem em h36.
- **Focus IPCA 12 meses.** Passa a excluir zero a 90% em h3 (0,203) e deixa de excluir em h24 e h36.

Nove variáveis mudam de veredito na tabela de coerência (`irf_coherence_summary.csv`): quatro de
`coerente_forte` a `parcial` (IFIX e crédito ao comércio, transporte e indústria), três de
`incoerente` a `parcial` (PIB, desemprego e ocupação), e duas de `parcial` a `incoerente` (SMLL e
IMOB).

## 7. ⚠ Placebos

A violação do EPU dos EUA, em h1–h3 na produção antiga, some. Duas séries externas que eram
`placebo_ok` passam a `placebo_viola`: o VIX exclui zero a 90% em h2, h5 e h6 (antes só em h29–h43,
fora da janela), e o MSCI de emergentes em h2–h10 (antes em h36–h41). O parágrafo de placebos da §3.3
e a `fig:placebos` falam do EPU, e na base nova a limitação muda de série. O passo 4/5 trata disso
sobre esta base.

## 8. O que pode e o que não pode ser dito

- Pode: com as Focus a horizonte fixo, o impacto de um aperto de 50 p.b. sobre câmbio e CDS fica onde
  estava (R$ 0,146 por dólar e 34 p.b.), com conjunto de 90% excluindo zero de h0 a h5 e h6.
- Pode: a reversão de longo prazo de câmbio, CDS, curva e EMBI fica em direção e magnitude, a 80%, e
  não mais significativa a 90%.
- Não pode: que a significância de longo prazo da produção antiga sobreviva à reconstrução. Na base
  nova ela some em h25–h36 na maior parte do painel.
- Não pode: comparar as respostas das seis Focus reconstruídas com as antigas como se fossem a mesma
  série. São previsões de horizonte diferente.
- Não pode: ler a queda da significância como efeito das Focus sobre a identificação. O instrumento e a
  especificação são os mesmos, e o que muda são os fatores e θ̂, que o painel determina.

## 9. O que fica velho na branch

Nada abaixo foi rodado de novo, e tudo continua na base antiga:

- `paper/img/fig_*.pdf` e os números do `.tex`, inclusive `tab:first_stage` (ξ_mp 7,02 e 6,84).
- Os anexos: `q_sensitivity.R`, `p_sensitivity.R`, `pandemic_sensitivity.R` e
  `instrument_layers_irf.R` e suas saídas. `output/factors/theta_by_p/` já foi reestimado por
  `covid_volatility_theta.R`, e `p_sensitivity.csv` não.
- A linha das inovações fatoriais de `het_conditions.R` (Anexo B) e `precovid_divergence.R`.
- `output/irf/irf_section.md`.

O benchmark VAR não muda, porque as suas cinco séries (IBC-Br, IPCA, DI 6 meses, câmbio e CDS) são as
mesmas.

⚠ `data/processed/` não é versionado e é o mesmo para todas as branches. Com esta branch em disco, o
painel é o de horizonte fixo. Ao voltar a `main`, rodar `Rscript script/run_all.R --only=clean` e
conferir o smoke test bit a bit antes de qualquer estimação.

## 10. O que mudou

- `R/data_download/focus.R`: `fetch_focus_annual()` extraída das duas cópias da busca anual.
- `script/download_focus_current_year.R` e o estágio `focus_current_year` de `run_all.R`, que escreve
  `data/raw/focus_current_year.csv`.
- `script/clean.R` constrói as seis séries, e `build_production_extensions()` recebe as três fiscais
  prontas (`focus_data` sem default).
- Os nomes `_ny` viram `_12m` no painel e nos scripts vivos. O bruto mantém `_ny`.
- Reestimados: θ̂, superfície Bai-Ng, cache e conjuntos AR (`irf_coherence_*`), grade de força,
  diagnósticos do instrumento. `validate_production_spec.R` e `validate_covid_volatility.R` pinam os
  valores novos e guardam os antigos em comentário. Os demais validadores passam sem mudança.
- `script/focus_fixed_horizon.R` escreve `output/focus_fixed_horizon/`, de onde vêm os números desta
  nota.

Smoke test da branch, em h0: `yield_6m` 0,005, `yield_2y` 0,0071747739108540751, `yield_5y`
0,0077302048927632531, `asset_ibov` −1,6546048858122004, `cambio_usd` 0,14584857519843694.
