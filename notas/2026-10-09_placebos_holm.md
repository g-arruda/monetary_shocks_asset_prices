# Placebos com avaliação conjunta por Holm

> **CURRENT — 2026-10-09.** Passo 4/5 do plano do orientador de 03-10
> (`email/email_professor_03-10_11h31.md`), no desenho do item 4 do e-mail de 08-10
> (`email/email_professor_08-10_15h15.md`). Branch `feature/focus-horizonte-fixo`, **não mergeada**,
> sobre a base do passo 0 (nota `2026-10-03_focus_horizonte_fixo`).
> - Produção da branch: `z_bs_purif`, `(r,q,p) = (5,5,4)`, escala COVID de Lenza-Primiceri com θ̂ do
>   painel a horizonte fixo, +50 p.b. em `yield_6m`, NW(0). Nada é reestimado. Os p-valores são os da
>   tabela do passo 1, e o ponto e os conjuntos de 90% dela conferem com o cache
>   `output/irf/irf_coherence_cell.rds`.
> - ⚠ A série `msci` do painel é a ação da MSCI Inc. (NYSE: MSCI), não o índice MSCI de mercados
>   emergentes que o paper e o e-mail nomeiam (seção 4). Seis dos 18 testes são dela.
> - Script: `script/placebo_holm.R`. Saídas em `output/placebo_holm/`. Nada no `.tex` nem em
>   `paper/img/`.

## 1. O teste e a família

O e-mail pede os p-valores da rotina AR e, se o código só devolvesse conjuntos, uma descrição do teste
antes de criar outra rotina. O código devolve o p-valor desde 10-05 (`ar_statistic()`, em
`R/identification/weak_iv_ar.R`), e nenhuma rotina nova foi escrita. Esta seção resume o cálculo.

- **Estatística.** Para a série j no horizonte h, AR(λ0) = T (num − λ0 · den)² / (Dd Ŵ Dd′), com
  Dd = [Da, Dg − λ0 d0]. Aqui num é a resposta da célula antes da normalização, den = d0′Γ é o momento
  de normalização e Ŵ é a covariância conjunta de vec(A) e Γ (`mosw_rform_cov()`). Sob H0, a
  estatística é χ²(1). O conjunto AR de nível κ é {λ0 : AR(λ0) ≤ χ²_κ(1)}, de modo que p < 1 − κ
  equivale a o conjunto de nível κ não conter zero. A tabela usa λ0 = 0.
- **Origem dos números.** `output/ar_precision/table.csv`, célula de produção, escrita pelo passo 1 em
  10-05 com `ar_statistic(..., lambda0 = 0)` e NW(0). As três séries têm código 1, então o zero testado
  está na unidade publicada. Os horizontes h = 0, 1, 3, 6, 12 e 24 foram fixados no passo 1, antes de
  olhar os resultados.
- **Família e correção.** São três séries e seis horizontes, 18 testes. Holm (`p.adjust(method =
  "holm")`) controla a probabilidade de ao menos uma rejeição falsa na família, ao nível de 10%. Pelo
  e-mail, não há Wald empilhado nem bandas simultâneas nesta rodada.

Guardas do script:
- as 18 linhas existem, e todos os conjuntos de 90 e 95% são intervalos;
- ponto e limites de 90% são iguais aos do cache (diferença abaixo de 1e-12), o que prova que a tabela
  do passo 1 é a da base corrente;
- p < 0,10 equivale à significância a 90% lida da topologia do conjunto, e p < 0,05 à de 95%;
- nenhum p ajustado fica abaixo do original;
- os preditores da regressão BS do DI incluem `pre_vix` e `pre_sp500`, e nenhum é de MSCI ou de EPU.

## 2. A tabela

Conjuntos AR pontuais, nas unidades de cada série: VIX em pontos, MSCI Inc. em dólares por ação, EPU em
pontos do índice. "Holm (18)" é a correção na família pedida. "Holm (12)" é a mesma correção sem as seis
linhas da MSCI Inc.

| série | h | ponto | 90% | 95% | p | Holm (18) | Holm (12) |
|---|---|---|---|---|---|---|---|
| VIX | 0 | 0,48 | [−1,50; 3,34] | [−2,10; 4,79] | 0,662 | 1,000 | 1,000 |
| VIX | 1 | 0,10 | [−0,93; 1,68] | [−1,22; 2,51] | 0,866 | 1,000 | 1,000 |
| VIX | 3 | −0,93 | [−1,88; 0,10] | [−2,23; 0,55] | 0,123 | 1,000 | 1,000 |
| VIX | 6 | −1,09 | [−1,85; −0,07] | [−2,10; 0,42] | 0,088 | 1,000 | 1,000 |
| VIX | 12 | −0,71 | [−1,63; 0,84] | [−1,87; 1,70] | 0,311 | 1,000 | 1,000 |
| VIX | 24 | 0,79 | [−0,77; 3,14] | [−1,23; 4,37] | 0,371 | 1,000 | 1,000 |
| MSCI Inc. | 0 | 1,01 | [−2,17; 3,95] | [−3,52; 5,07] | 0,505 | 1,000 | |
| MSCI Inc. | 1 | 1,48 | [−0,45; 3,66] | [−1,16; 4,62] | 0,172 | 1,000 | |
| MSCI Inc. | 3 | 2,82 | [0,55; 6,36] | [−0,10; 8,23] | 0,055 | 0,983 | |
| MSCI Inc. | 6 | 2,78 | [0,59; 5,82] | [−0,10; 7,33] | 0,055 | 0,983 | |
| MSCI Inc. | 12 | 2,02 | [−0,35; 4,15] | [−1,36; 4,95] | 0,135 | 1,000 | |
| MSCI Inc. | 24 | −0,44 | [−4,20; 2,10] | [−6,13; 2,86] | 0,756 | 1,000 | |
| EPU dos EUA | 0 | 8,80 | [−2,23; 28,69] | [−5,00; 40,02] | 0,179 | 1,000 | 1,000 |
| EPU dos EUA | 1 | 9,45 | [−3,01; 30,64] | [−6,31; 42,36] | 0,196 | 1,000 | 1,000 |
| EPU dos EUA | 3 | 8,77 | [−0,40; 24,72] | [−2,79; 33,63] | 0,113 | 1,000 | 1,000 |
| EPU dos EUA | 6 | 4,34 | [−1,65; 14,84] | [−3,20; 20,75] | 0,218 | 1,000 | 1,000 |
| EPU dos EUA | 12 | 1,78 | [−3,71; 11,51] | [−5,12; 17,00] | 0,586 | 1,000 | 1,000 |
| EPU dos EUA | 24 | 4,60 | [−1,87; 13,79] | [−3,87; 18,40] | 0,212 | 1,000 | 1,000 |

Sem ajuste, três dos 18 testes rejeitam a 10%: MSCI Inc. em h3 e h6 (p 0,055 nos dois) e VIX em h6
(p 0,088). Nenhum rejeita a 5%. Com Holm, o menor p ajustado é 0,983 na família de 18 e 1 na de 12, e
nenhum teste rejeita a 10%.

Nos outros horizontes até h24 (`output/irf/irf_coherence_h.csv`), o VIX é significante a 90% em h2, h5
e h6, a MSCI Inc. em h2–h10 e o EPU em nenhum. A 80%, o EPU é significante em h0–h4. Esses horizontes
não entram na família, e a contagem deles não é evidência estatística conjunta.

## 3. As séries na ortogonalização

O instrumento é o resíduo da regressão da surpresa do DI, nas 102 reuniões, em constante e nove
preditores pré-evento (`output/instrument/bs_orthogonalization.csv`). Das três séries, só o VIX entra.

- **VIX.** Entra como `pre_vix`, a variação de 65 pregões até o fechamento de quarta, o último antes do
  anúncio (`R/instrument/build_variants.R`). O coeficiente no DI é −0,025 (EP HC1 0,240, p 0,919), de
  modo que a ortogonalização retira da surpresa quase nada na direção do VIX. A variação do VIX na
  própria sessão (`d_vix`) não entra em regressão nenhuma e só serve para fixar quais quintas têm dados.
- **A restrição não é contemporânea.** O resíduo é ortogonal, nas 102 reuniões, à tendência do VIX
  antes do anúncio. Nada restringe a variação do VIX de quarta a quinta nem a dos meses seguintes, e os
  testes de h ≥ 1 não carregam restrição mecânica.
- ⚠ **Em h0 a independência é parcial.** O VIX do painel é o fechamento do mês, e a inovação de h0 cobre
  o mês da quinta da reunião. Em média, 45% dos dias desse mês (mediana 50%) caem antes do fechamento
  de quarta, dentro da janela de 65 pregões. Nas sete reuniões cuja quinta cai no dia 1º, a sobreposição
  é zero. O teste do VIX em h0 não é, por isso, uma checagem de todo independente da ortogonalização.
  Como o coeficiente de `pre_vix` está perto de zero, a restrição pesa pouco na prática, e o teste não
  rejeita (p 0,662).
- **S&P 500.** `pre_sp500`, a tendência de 65 pregões do S&P 500, também entra. O VIX se move com ele,
  e a restrição que ele impõe também é pré-evento.
- **MSCI Inc. e EPU dos EUA** não entram na regressão desta branch. O EPU só entra na branch
  `feature/placebo-epu`, não mergeada (seção 5).

## 4. ⚠ A série `msci` não é o índice de mercados emergentes

`data/raw/investing/msci.csv`, que `script/download.R` lê como `msci`, traz a cotação mensal da ação da
MSCI Inc. (NYSE: MSCI), a empresa que calcula os índices, e não o índice MSCI de mercados emergentes.
- Os fechamentos de julho a novembro de 2023 no arquivo, 548,08, 543,62, 513,08, 471,55 e 520,85, são
  os da ação nas mesmas datas (histórico de preços da MSCI Inc., consultado em 10-09).
- A série vai de 29,56 em janeiro de 2010 a 599 em janeiro de 2024, cerca de vinte vezes, a trajetória
  da ação.
- O arquivo traz volume negociado em todos os meses (de 5,6 a 46,2 milhões), coluna que o arquivo do
  VIX, um índice, deixa vazia.

Consequências:
- o paper a chama de "MSCI de mercados emergentes" na §3.2, no Anexo A (`tab:lista_variaveis`), no
  parágrafo de placebos da §3.3 e em `fig:placebos` (rótulo em `script/fig_section5.R`);
- ela é uma das 115 séries do painel de produção, em `main` e nesta branch, e entra nos fatores e na
  estimação de θ̂. Trocá-la pelo índice muda a base do passo 0 e obriga a refazer os passos 0 a 4;
- nesta rodada, seis dos 18 testes são sobre uma ação americana. Sem eles, Holm na família de 12 também
  não rejeita nada.

A troca é decisão do autor e está aberta em `pendencias.md`, Tema D.

## 5. O p = 0,54

O e-mail de 03-10 pede que se explicite a hipótese do p = 0,54.
- **Hipótese.** H0: β_EPU = 0 na regressão da surpresa do DI de 6 meses de quarta a quinta, nas 102
  reuniões, em constante, nos nove preditores pré-evento da produção e em `pre_epu`. `pre_epu` é a
  tendência de 13 semanas do EPU diário dos EUA até a quarta, 100 × (log da média nos 91 dias corridos
  até a quarta − log da média nos 91 anteriores). O teste é t com EP HC1: coeficiente −0,028
  (EP 0,046), t −0,61, p 0,543.
- **Leitura.** Naquela especificação não há evidência de que a tendência do EPU antes da reunião tenha
  poder preditivo sobre a surpresa. Isso não valida a exogeneidade do instrumento, porque o teste olha
  uma variável, numa janela, pela média condicional.
- **Onde está.** Só na branch `feature/placebo-epu` (nota `2026-09-29_placebo_epu` e
  `output/instrument/bs_orthogonalization.csv` daquela branch). A regressão é diária e não usa o painel,
  e a regressão BS sem o EPU é idêntica em `main` e nesta branch. O p não depende da base do passo 0.

## 6. Leitura

- **Nos 18 testes, não rejeitamos a hipótese de resposta zero após o ajuste por múltiplos testes**, a
  10%, e tampouco na família de 12, sem a MSCI Inc. Isso não comprova a exogeneidade do instrumento,
  porque também pode refletir pouca precisão. Os conjuntos de 90% têm de 1,8 a 4,8 pontos de largura no
  VIX, de 0,3 a 0,9 desvio-padrão da variação mensal do VIX (5,2 pontos), e de 15 a 34 pontos no EPU,
  de 0,25 a 0,56 desvio-padrão da variação mensal do EPU (60 pontos).
- **Rejeições pontuais.** Sem ajuste e a 10%, a MSCI Inc. sobe 2,8 dólares em h3 e em h6 e o VIX cai
  1,1 ponto em h6. Nenhuma sobrevive ao ajuste. São respostas dos meses seguintes, não do impacto, e a
  rodada não separa transmissão de contaminação.
- **A série que viola mudou com a base.** Na base de `main`, nos dois primeiros anos, o EPU era
  significante a 90% em h1–h3, e o VIX e a MSCI Inc. não. Na base do passo 0, o EPU deixa de ser, e o
  VIX e a MSCI Inc. passam a ser (nota `2026-10-03_focus_horizonte_fixo`, seção 7). Pontos
  significantes que trocam de série quando as Focus mudam reforçam o que o e-mail diz da contagem.
- **A figura.** `fig:placebos` pode ficar como descrição das respostas, com os conjuntos identificados
  como pontuais na legenda. A legenda, o parágrafo da §3.3 e o nome da série esperam a promoção da base
  (`pendencias.md`, Tema A).

## 7. O que fica de fora

- Wald empilhado e bandas simultâneas, que o e-mail dispensa.
- Outras truncagens de Newey-West. Só NW(0), a de produção, entrou. A autocorrelação dos momentos dos
  testes dos placebos não foi examinada (a do passo 1 cobre ξ_mp, câmbio e CDS).
- A surpresa bruta. Com o coeficiente de `pre_vix` perto de zero, a comparação com `z_bruto` não foi
  feita.
- O índice MSCI de emergentes, que não está no painel (seção 4).
- O `.tex` e `paper/img/`.

## 8. Arquivos

- `output/placebo_holm/table.csv`: os 18 testes, com série, rótulo, h, ponto, conjuntos de 90 e 95%,
  p-valor AR em zero, p de Holm nas famílias de 18 e de 12, e as decisões a 10% sem ajuste e com Holm.
- `output/placebo_holm/orthogonalization.csv`: o preditor de cada placebo na regressão BS do DI, com
  estimativa, EP HC1, t e p, vazio para as séries que não entram.
