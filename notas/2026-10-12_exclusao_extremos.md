# Exclusão das reuniões com movimento extremo de VIX, S&P 500 ou Brent

> **CURRENT — 2026-10-12.** Passo 3/5, parte 2, do plano do orientador de 03-10
> (`email/email_professor_03-10_11h31.md`), no desenho do item 3 do e-mail de 08-10
> (`email/email_professor_08-10_15h15.md`). Branch `feature/focus-horizonte-fixo`, **não mergeada**,
> sobre a base reestimada em 10-12 (Focus a horizonte fixo e `msci` o índice de emergentes, nota
> `2026-10-12_msci_emergentes`).
> - A regra e a leitura foram fixadas pelo autor e commitadas antes de rodar (`2cad8bd`, em
>   `registro/pendencias.md`). Até esse commit a lista das reuniões marcadas não foi cruzada com o
>   ranking de influência.
> - Produção da branch: `z_bs_purif`, `(r,q,p) = (5,5,4)`, escala COVID de Lenza-Primiceri, +50 p.b. em
>   `yield_6m`, NW(0). Ponto e conjuntos saem `identical()` ao cache `output/irf/irf_coherence_cell.rds`.
> - Script: `script/meeting_influence.R`, que ganhou a célula `sem_extremos`. Saídas em
>   `output/meeting_influence/`. Nada no `.tex` nem em `paper/img/`.

## 1. A regra

Fixada antes de rodar, na versão mais simples fiel aos e-mails (Caminho A):
- **Janela:** do fechamento de quarta ao de quinta, a mesma da surpresa. O Copom anuncia depois do
  fechamento de B3 e de NY.
- **Variáveis:** retorno log do S&P 500, variação log do VIX e retorno log do Brent (`BZ=F`), em %,
  sobre `data/raw/investing/external_factors_daily.csv`, o arquivo que o instrumento já usa. A
  variação é a de linhas consecutivas, como em `build_variants.R`; só o VIX troca a diferença em
  pontos pela variação log.
- **Referência:** as variações de todos os pregões de 2012-03-01 a 2025-12-31 em que existem.
- **Extremo:** |variação| acima do percentil 95 da |variação| da própria série na referência
  (`quantile()` padrão). A reunião sai se ao menos uma das três for extrema na quinta. A regra é
  bilateral porque o viés de um choque global sobre câmbio e CDS não depende do sinal do choque.
- **Exclusão:** a de `meeting_influence.R` (nota `2026-10-08_influencia_reunioes`, seção 1). O resíduo
  BS da reunião sai da soma do seu mês. Fatores, cargas, VAR, θ̂, inovações e os resíduos BS das outras
  reuniões ficam os da amostra completa, e T = 162, o calendário e NW(0) ficam os da produção.

Ao rodar apareceu um detalhe da referência: o arquivo tem níveis ausentes, o Brent em 20 pregões de
2012–2014 e 2016 e o S&P 500 e o VIX em três dias de bolsa de NY fechada (2023-11-23, 2025-01-09,
2025-07-04). Com a variação de linhas consecutivas, um nível ausente apaga a variação do dia e a do
seguinte, e a referência fica com as variações que existem, como a regra diz. Nas 102 reuniões as três
variações existem, porque `build_variants.R` descarta a quinta sem alguma delas.

O script ganhou uma guarda, além das da nota de 10-08: as 102 reuniões têm as três variações. Fora
do script, conferiu-se que as células de produção, sem as 5 e sem as 10 saem byte-idênticas às do
commit anterior, e `ranking.csv` também, e que um cálculo independente em R base dá os mesmos três
limiares.

## 2. As reuniões marcadas

| série | pregões na referência | percentil 95 da \|variação\| | reuniões marcadas |
|---|---|---|---|
| S&P 500 | 3476 | 2,02% | 5 |
| VIX | 3476 | 15,38% | 5 |
| Brent | 3446 | 4,43% | 5 |

As 15 marcas caem em **11 reuniões**, todas dentro da janela das inovações: o S&P 500 e o VIX marcam
juntos quatro, e nenhuma marcada pelo Brent é marcada por outra série. Com três séries independentes
seriam 14,5 reuniões, e cada série marca 5, contra 5,1 esperadas.

| reunião (quinta) | S&P 500 | VIX | Brent | marcada por | surpresa (p.b.) | ordem de influência |
|---|---|---|---|---|---|---|
| 2013-10-10 | +2,16 | −17,34 | +2,48 | S&P, VIX | 7,3 | 80 |
| 2014-07-17 | −1,19 | +27,90 | +0,10 | VIX | −2,8 | 72 |
| 2016-01-21 | +0,52 | −3,32 | +4,80 | Brent | −25,6 | 4 |
| 2018-02-08 | −3,83 | +18,78 | −1,07 | S&P, VIX | −3,3 | 76 |
| 2018-03-22 | −2,55 | +26,76 | −0,81 | S&P, VIX | −10,0 | 34 |
| 2019-08-01 | −0,90 | +10,31 | −7,44 | Brent | −4,1 | 69 |
| 2020-03-19 | +0,47 | −6,00 | +13,48 | Brent | 23,4 | 16 |
| 2021-03-18 | −1,49 | +11,53 | −7,19 | Brent | 29,0 | 7 |
| 2022-02-03 | −2,47 | +9,74 | +1,82 | S&P | −21,7 | 11 |
| 2022-03-17 | +1,23 | −3,82 | +8,43 | Brent | −20,5 | 3 |
| 2022-05-05 | −3,63 | +20,49 | +0,69 | S&P, VIX | 1,0 | 84 |

Variações em %. A surpresa é o resíduo BS da reunião; a ordem é a de `ranking.csv` (10-12).
- **Cruzamento com a influência, feito depois do commit da regra.** Três das 11 estão entre as dez
  mais influentes (3ª, 4ª e 7ª), duas delas entre as cinco, e mais duas entre a 11ª e a 16ª. As cinco
  marcadas pelo Brent incluem quatro dessas cinco.
- **2020-03-19**, o dia de pânico da COVID, entra pelo Brent (+13,5%), não pelo VIX (−6,0%) nem pelo
  S&P 500 (+0,5%).
- ⚠ **Brent:** o `BZ=F` é o primeiro vencimento, sem ajuste da troca, e a lista não separa um salto de
  troca de uma variação de preço. Nenhuma das cinco datas é o último dia útil do mês. A regra não muda.

## 3. Resultados

**Força.** d0'Γ e Σz² relativos à produção.

| célula | reuniões fora | ξ_mp | F_rob | d0'Γ | Σz² | conjunto de 90% limitado | de 95% |
|---|---|---|---|---|---|---|---|
| produção | 0 | 6,66 | 8,07 | 1 | 1 | sim | sim |
| sem extremos | 11 | 5,67 | 7,66 | 0,87 | 0,78 | sim | sim |

Para comparação, sem as 5 mais influentes ξ_mp é 3,54 e sem as 10 é 1,82 (nota de 10-12, seção 5).
Todo conjunto da célula nova é um intervalo, a 90 e a 95%.

**Câmbio BRL/USD (R$/US$) e CDS 5 anos (p.b.): ponto e p-valor AR da resposta zero**

| h | câmbio produção | p | câmbio sem extremos | p | CDS produção | p | CDS sem extremos | p |
|---|---|---|---|---|---|---|---|---|
| 0 | 0,145 | 0,015 | 0,107 | 0,075 | 33,5 | 0,017 | 32,0 | 0,035 |
| 1 | 0,179 | 0,032 | 0,152 | 0,072 | 36,9 | 0,022 | 35,4 | 0,042 |
| 3 | 0,168 | 0,041 | 0,163 | 0,065 | 33,3 | 0,035 | 35,0 | 0,042 |
| 6 | 0,117 | 0,107 | 0,108 | 0,150 | 25,6 | 0,086 | 25,9 | 0,094 |
| 12 | 0,026 | 0,657 | 0,008 | 0,891 | 8,9 | 0,464 | 6,7 | 0,579 |
| 24 | −0,077 | 0,254 | −0,094 | 0,191 | −15,1 | 0,262 | −18,2 | 0,193 |

**Conjuntos sem extremos.** Os de produção estão na nota do passo 1 (`2026-10-05_precisao_ar`, números
correntes na de 10-12).

| série | h | 90% | 95% |
|---|---|---|---|
| câmbio | 0 | [0,017; 0,187] | [−0,034; 0,225] |
| câmbio | 1 | [0,026; 0,284] | [−0,038; 0,354] |
| câmbio | 3 | [0,036; 0,286] | [−0,030; 0,349] |
| câmbio | 6 | [−0,034; 0,199] | [−0,132; 0,232] |
| câmbio | 12 | [−0,166; 0,110] | [−0,294; 0,143] |
| câmbio | 24 | [−0,283; 0,035] | [−0,410; 0,083] |
| CDS | 0 | [12,3; 61,9] | [5,1; 82,4] |
| CDS | 1 | [12,9; 64,8] | [3,5; 83,2] |
| CDS | 3 | [13,9; 58,1] | [3,8; 70,9] |
| CDS | 6 | [1,1; 42,0] | [−16,2; 47,7] |
| CDS | 12 | [−27,4; 24,7] | [−53,8; 30,0] |
| CDS | 24 | [−56,6; 6,6] | [−83,2; 15,5] |

No impacto o conjunto de 90% do câmbio fica mais estreito que o de produção ([0,068; 0,281]) e desce:
o ponto cai mais do que a incerteza cresce.

De h0 a h36 (`joint_fx_cds.csv`):
- **câmbio:** significante a 90% em h0–h4 (produção h0–h5) e a 95% em horizonte nenhum (produção
  h0–h3);
- **CDS:** significante a 90% em h0–h6, como na produção, e também em h35–h36 (p 0,099 e 0,098; na
  produção 0,105 e 0,102); a 95% em h0, h1 e h3 (produção h0, h1, h3 e h4).

**Painel**, nos seis horizontes da tabela (689 pares testados):
- nenhum ponto sai do conjunto de 90% de produção;
- os pares significantes a 90% vão de 298 a 238 (79 perdidos, 19 ganhos) e a 95% de 184 a 114;
- 31 pontos trocam de sinal, nenhum num par significante a 90% na produção.

**Exclusões individuais das 11** (`ranking.csv`, valor sem a reunião). O câmbio no impacto cai mais sem
2022-03-17 (0,124), 2021-03-18 (0,126), 2020-03-19 (0,132) e 2022-02-03 (0,135), e sobe sem
2016-01-21 (0,170). As outras seis o deixam entre 0,145 e 0,148. As cinco marcadas pelo Brent somam
−0,024 no impacto, e as seis marcadas só por S&P 500 ou VIX somam −0,005. As mudanças individuais não
se somam à conjunta: somam −0,029, e a conjunta é −0,038.

## 4. Leitura

Contra a leitura registrada antes de rodar:
- **Risco global (S&P 500, VIX).** Se o viés de contaminação explicasse o resultado, câmbio e CDS
  cairiam sem as reuniões marcadas. O CDS não cai: −4% no impacto e em h1, +5% em h3, com a mesma
  significância a 90% e a 95% até h3. O câmbio cai 26% no impacto (0,145 → 0,107), 15% em h1 e 3% em
  h3, e perde os 95% em todo horizonte; a 90% continua significante até h4. Uma a uma, as seis
  reuniões marcadas só por S&P 500 ou VIX movem pouco o câmbio, e a maior mudança (2022-02-03, −0,010)
  é a de uma surpresa grande, a 11ª reunião mais influente.
- **Brent.** A leitura espera o viés com sinal oposto: petróleo em alta sobe o DI e aprecia o real, e
  tirar as reuniões contaminadas subiria o câmbio. Uma a uma, três das cinco marcadas pelo Brent o
  baixam (2022-03-17, 2021-03-18, 2020-03-19) e uma o sobe (2016-01-21). A queda do câmbio não segue o
  sinal que a leitura atribui a esse canal.
- **Força e concentração.** ξ_mp cai 15% (6,66 → 5,67), menos que sem as 5 mais influentes (3,54), e
  os conjuntos seguem limitados a 95%. Três das reuniões marcadas estão entre as dez mais influentes,
  e elas, com a 11ª e a 16ª, são as que mais movem o câmbio uma a uma. Com o CDS estável, o câmbio
  estável em h1–h3 e a força menor, o padrão se aproxima do que a leitura registrada chama de
  concentração. A exceção é o impacto do câmbio.
- **Critério de 03-10.** Não há inversão de sinal em câmbio nem em CDS, nem no painel em pares
  significantes. O que muda é a significância do câmbio a 95%.
- ⚠ **A condição da verificação de terça a quarta.** A regra manda rodá-la só se câmbio ou CDS
  caírem. Pela letra, a condição se cumpre no câmbio: o impacto cai 26% e perde os 95%. O CDS não cai.
  Rodar ou não é decisão do autor (`pendencias.md`, Tema B).

## 5. O que fica de fora

- **A janela de terça a quarta**, inteira antes do anúncio. Condicional pela regra, fora deste
  exercício; virou item aberto.
- **Células por série.** A regra fixa uma célula com as 11 reuniões. Excluir só as do Brent, ou só as
  de S&P 500 e VIX, não foi rodado; a decomposição da seção 3 vem das exclusões individuais já em
  `ranking.csv`.
- **Reestimação.** Como na nota de 10-08, nem os fatores nem a ortogonalização BS são reestimados.
- **Seleção por câmbio, CDS, índice de emergentes, DXY ou EMBI.** Proibida pela regra.

## 6. Arquivos

- `output/meeting_influence/extreme_thresholds.csv`: por série, os pregões da referência, o percentil
  95 da |variação| e quantas reuniões ele marca.
- `output/meeting_influence/extreme_meetings.csv`: as 102 reuniões, com ordem de influência, mês,
  `in_window`, as três variações, as três marcas e `excluded`.
- `output/meeting_influence/joint_table.csv`, `joint_fx_cds.csv` e `joint_strength.csv`: ganharam a
  célula `sem_extremos`; as linhas das outras três células não mudaram.
