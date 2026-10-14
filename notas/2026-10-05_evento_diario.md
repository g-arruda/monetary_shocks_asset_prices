# Evento diário: câmbio e CDS na surpresa bruta e na ortogonalizada

> **CÂMBIO SUPERADO em 2026-10-13** por
> [`2026-10-13_cambio_yahoo_convencao`](2026-10-13_cambio_yahoo_convencao.md). Por decisão do autor,
> o câmbio diário passou da PTAX ao Yahoo `BRL=X`, da última cotação antes do anúncio à primeira
> depois. Com a surpresa bruta, o efeito vai de −R$ 0,048 (p 0,019) a −R$ 0,037 (p 0,012). Com a
> ortogonalizada, vai de −R$ 0,048 (p 0,021) a −R$ 0,029 (p 0,088), e deixa de ser significante a
> 95%. CDS e DFM não mudam.
> ⚠ **A seção 1 erra o horário do Yahoo.** A linha datada d traz a cotação da noite do pregão
> (20h–22h em Brasília), posterior ao anúncio em 96 das 102 reuniões. A janela de quarta a quinta pelas
> datas perde o anúncio nas 51 reuniões de verão europeu, e não "acompanha o pregão de quarta" nas 45
> de inverno.

> **NÚMEROS DO DFM SUPERADOS em 2026-10-12** por
> [`2026-10-12_msci_emergentes`](2026-10-12_msci_emergentes.md), seção 4. A série `msci` do painel
> passou da ação da MSCI Inc. ao índice MSCI de emergentes. As regressões diárias não usam o painel e
> saíram byte-idênticas. Só as linhas do DFM mensal mudam: câmbio 0,146 → 0,145 e CDS 33,9 → 33,5 com
> a surpresa ortogonalizada. A leitura desta nota segue valendo.

> **CURRENT — 2026-10-05.** Passo 2/5 do plano do orientador de 03-10
> (`email/email_professor_03-10_11h31.md`). Branch `feature/focus-horizonte-fixo`, **não mergeada**,
> sobre a base do passo 0 (nota `2026-10-03_focus_horizonte_fixo`).
> - O instrumento diário é o de `main`, porque o passo 0 não mexeu nele: 102 reuniões, surpresa bruta
>   `delta_di` e resíduo Bauer-Swanson `e_di_bs`, lidos de `data/processed/copom_event_diagnostics.csv`.
>   Os DFMs são os da branch: `(5,5,4)`, escala de Lenza-Primiceri, +50 p.b. em `yield_6m`, um com
>   `z_bs_purif` (produção) e outro com `z_bruto`.
> - Decisões do autor em 10-05, tomadas antes de rodar:
>   - o câmbio diário é a PTAX, num estágio de rede próprio;
>   - a amostra é só a comum, as 102 reuniões;
>   - não há subamostra pré-COVID.
> - Scripts: `script/download_ptax.R` (estágio `ptax`) e `script/daily_event.R`. Saídas em
>   `output/daily_event/`. Nada no `.tex` nem em `paper/img/`.

## 1. Dados e janelas

O Copom anuncia depois do fechamento de quarta. As três variações vão de quarta a quinta, pelas
datas exatas e sem carregar cotação adiante:

| série | fonte | janela | unidade |
|---|---|---|---|
| surpresa | contrato DI mais próximo de 126 d.u. (`build_thursday_surprises()`) | fechamento → fechamento | p.b. |
| câmbio | PTAX de venda, SGS 1 | 13h → 13h | R$/US$ e % (`100·Δlog`) |
| CDS 5 anos | Bloomberg `BRAZIL CDS USD SR 5Y D14 Corp` | fechamento → fechamento | p.b. |

A PTAX de um dia é a média das quatro janelas de consulta entre 10h e 13h. A de quarta antecede o
anúncio e a de quinta o sucede. O Olinda carimba o boletim de fechamento entre 13h07 e 13h16 nos dias
consultados (14 a 23/01/2015). A janela do câmbio, portanto, não é a do DI: termina no começo da tarde
de quinta.

⚠ O horário do fechamento do CDS na Bloomberg não está no arquivo. Se em algum ano ele cair depois do
anúncio, a variação de quarta a quinta perde parte da reação.

**O câmbio diário que o repositório já tinha não serve para a janela do evento.** O
`data/raw/brl_usd_daily.csv` vem do Yahoo `BRL=X`, que carimba as barras à meia-noite de Londres.
Entre o último domingo de março e o último domingo de outubro, as linhas vão de domingo a quinta.
`fx_alignment.csv` compara a variação diária desse arquivo com a da PTAX e com a do Ibovespa, de
2012-03 a 2025-12:

| horário europeu | dias | PTAX t−1 | PTAX t | PTAX t+1 | Ibov t−1 | Ibov t | Ibov t+1 |
|---|---|---|---|---|---|---|---|
| inverno | 1364 | 0,45 | 0,48 | −0,04 | −0,43 | 0,02 | 0,00 |
| verão | 1653 | 0,04 | 0,55 | 0,42 | −0,03 | −0,47 | 0,00 |

No inverno, a linha datada d acompanha o pregão d−1. A PTAX das 13h fica no meio do pregão, por isso
a variação de um fechamento ao seguinte se reparte entre duas variações dela. Das 102 reuniões, 45
caem no inverno europeu. Nelas, a variação de quarta a quinta lida pelas datas do Yahoo acompanha o
pregão de quarta, que fecha antes do anúncio, e não o de quinta. Nas reuniões, a correlação dessa
variação com a da PTAX é 0,38 no inverno (44 reuniões, porque o Yahoo não tem 2013-01-16) e 0,58 no
verão.

⚠ A mesma coluna alimenta o câmbio diário de `script/het_conditions.R`
(`output/het/daily_changes.csv`) e, por ele, a razão de variância do câmbio na linha diária de
`tab:het_frequency`, no Anexo B. Esta rodada só registra e não corrige (item novo em
`registro/pendencias.md`, Tema D).

## 2. A amostra

São as 102 reuniões da regressão Bauer-Swanson, de 2012-03 a 2025-12. As duas surpresas e as três
variações existem em todas, então a amostra comum é essa, sem perda. O script confere que as somas
mensais de `delta_di` e `e_di_bs` reproduzem `z_bruto` e `z_bs_purif` de
`instrumentos_mensais.csv`, a 1e-10.

| série | média | desvio-padrão | mínimo | máximo |
|---|---|---|---|---|
| surpresa bruta (p.b.) | 0,66 | 13,2 | −35,0 | 41,0 |
| surpresa ortogonalizada (p.b.) | 0,00 | 12,4 | −33,3 | 38,6 |
| câmbio (R$/US$) | 0,0005 | 0,042 | −0,111 | 0,169 |
| câmbio (%) | 0,06 | 0,92 | −1,97 | 2,94 |
| CDS (p.b.) | −0,25 | 6,95 | −47,4 | 20,3 |

A correlação entre as duas surpresas é 0,936, e a das variações de câmbio (%) e de CDS nas reuniões
é 0,22.

## 3. Forma reduzida

Cada variação contra uma surpresa, com constante: `Δy = a + b·s + u`. O EP é HC1, e o p-valor é o da
χ²(1), o mesmo do teste Anderson-Rubin em zero da seção 4. Coeficientes por +50 p.b. de surpresa, N
= 102.

| surpresa | resposta | coef. | EP | p-valor | R² |
|---|---|---|---|---|---|
| bruta | câmbio (R$/US$) | −0,048 | 0,021 | 0,019 | 0,090 |
| bruta | câmbio (%) | −1,04 | 0,41 | 0,013 | 0,089 |
| bruta | CDS (p.b.) | 0,94 | 2,69 | 0,726 | 0,001 |
| ortogonalizada | câmbio (R$/US$) | −0,048 | 0,021 | 0,021 | 0,079 |
| ortogonalizada | câmbio (%) | −1,04 | 0,43 | 0,016 | 0,078 |
| ortogonalizada | CDS (p.b.) | −0,49 | 4,07 | 0,903 | 0,000 |

No dia do Copom, uma surpresa de +50 p.b. vem com o real **apreciando** R$ 0,048 por dólar, ou 1,04%.
A associação é significante a 95% com as duas surpresas, e a ortogonalização quase não a move:
−0,0483 → −0,0482 R$/US$. O CDS não é significante a 90% com nenhuma das duas.

## 4. Primeiro estágio e efeito normalizado

O efeito por +50 p.b. no DI de 6 meses é o IV exatamente identificado da resposta na variação do
contrato (`delta_di`), instrumentada pela surpresa. O conjunto Anderson-Rubin a κ é
`{β0 : (b − β0π)² ≤ χ²₁(κ)·Var(b − β0π)}`. Nele, b e π são as inclinações da resposta e de `delta_di`
na surpresa, e a variância vem da covariância HC1 conjunta das duas. O script confere, em cada limite
finito, que o Wald HC1 de `Δy − β0·delta_di` contra a surpresa é igual ao valor crítico, a 1e-8.

- **Surpresa bruta:** ela é a própria variação do contrato. O primeiro estágio é a identidade, π = 1
  sem erro, e o conjunto AR é o intervalo de Wald da forma reduzida.
- **Surpresa ortogonalizada:** π = 1 por construção, porque o resíduo de uma regressão com constante é
  ortogonal aos valores ajustados. O EP HC1 é 0,039 e o F_rob 656. O conjunto AR quase não se afasta
  do de Wald.

Assim, o efeito normalizado tem o mesmo ponto da forma reduzida. Os conjuntos, por +50 p.b. no DI de
6 meses:

| surpresa | resposta | ponto | 90% | 95% |
|---|---|---|---|---|
| bruta | câmbio (R$/US$) | −0,048 | [−0,082; −0,014] | [−0,089; −0,008] |
| bruta | câmbio (%) | −1,04 | [−1,72; −0,35] | [−1,85; −0,22] |
| bruta | CDS (p.b.) | 0,94 | [−3,5; 5,4] | [−4,3; 6,2] |
| ortogonalizada | câmbio (R$/US$) | −0,048 | [−0,081; −0,014] | [−0,088; −0,007] |
| ortogonalizada | câmbio (%) | −1,04 | [−1,73; −0,33] | [−1,86; −0,19] |
| ortogonalizada | CDS (p.b.) | −0,49 | [−7,4; 6,1] | [−8,7; 7,3] |

Todos os conjuntos são `interval`. A normalização usa o contrato e não a `yield_6m` do DFM, porque a
curva diária do orientador (`data/raw/yields/yields_dia.csv`) tem três casas decimais: resolução de
10 p.b., grossa demais para uma variação diária.

## 5. A tabela 2×2 e a etapa

Impacto por +50 p.b. no evento diário e no DFM mensal da mesma base, com as duas surpresas
(`comparison.csv`). No DFM, o câmbio vem em R$/US$ e o CDS em p.b., as unidades do evento diário.

| etapa | surpresa | câmbio | 90% | 95% | CDS | 90% | 95% | força |
|---|---|---|---|---|---|---|---|---|
| evento diário | bruta | −0,048 | [−0,082; −0,014] | [−0,089; −0,008] | 0,9 | [−3,5; 5,4] | [−4,3; 6,2] | identidade |
| evento diário | ortogonalizada | −0,048 | [−0,081; −0,014] | [−0,088; −0,007] | −0,5 | [−7,4; 6,1] | [−8,7; 7,3] | F 656 |
| DFM mensal | bruta | 0,099 | [0,002; 0,186] | [−0,044; 0,221] | 23,3 | [0,9; 46,0] | [−8,9; 56,1] | ξ_mp 6,31 |
| DFM mensal | ortogonalizada | 0,146 | [0,071; 0,278] | [0,052; 0,352] | 33,9 | [15,7; 66,0] | [11,0; 84,0] | ξ_mp 6,80 |

A linha de produção (DFM, ortogonalizada) é a do passo 1, e o script a confere contra
`output/ar_precision/table.csv` a 1e-10. No DFM com a surpresa bruta, câmbio e CDS são significantes a
90% e não a 95%.

**Regra de leitura, fixada antes de rodar.** Cada célula se descreve pelo sinal do ponto e pela
significância a 90 e 95%. A divergência "surge" na primeira etapa da cadeia em que o sinal do ponto se
opõe ao do evento diário com a surpresa bruta. A cadeia é: bruta diária → ortogonalizada diária → DFM.
O DFM com a bruta serve de conferência cruzada. Nenhuma comparação entre etapas é teste de igualdade.

- **Câmbio.** O sinal só se opõe no DFM, e com as duas surpresas. A ortogonalização não cria a
  divergência: no dia ela não move o ponto, e no DFM o ponto de produção tem o mesmo sinal do da
  bruta. **A divergência com a evidência diária surge na passagem do evento diário ao DFM mensal.**
- **CDS.** Pela regra, o sinal do ponto troca já na ortogonalização (+0,9 → −0,5 p.b.). Nenhum dos dois
  é significante a 90%, e os dois conjuntos de 90% têm 9 a 13 p.b. de largura: é inversão pontual com
  grande incerteza, que o critério de 03-10 não trata como invalidação. A diferença de magnitude, de
  perto de zero no dia para +23 e +34 p.b. no DFM, surge na mesma passagem que a do câmbio.

**O que a passagem muda, sem que nada aqui separe:**
- a frequência;
- a janela: o evento contra o mês;
- a variável de normalização: o contrato DI contra a `yield_6m` de fim de mês da curva do orientador;
- a medida: PTAX das 13h contra a média mensal do Yahoo no câmbio, e o fechamento diário Bloomberg
  contra o fechamento do mês do Investing no CDS;
- o modelo: a resposta do DFM é a do componente comum.

A proibição de 2026-09-22 veda decompor frequência e janela, e o orientador deixa a agregação temporal
completa para depois.

## 6. O que pode e o que não pode ser dito

- Pode: no dia do Copom, uma surpresa de +50 p.b. vem com o real apreciando R$ 0,048 por dólar
  (1,04%), associação significante a 95% com a surpresa bruta (p 0,019) e com a ortogonalizada (p
  0,021).
- Pode: no dia, a ortogonalização de Bauer-Swanson não muda a associação do câmbio (−0,0483 contra
  −0,0482 R$/US$).
- Pode: no dia, a associação do CDS não é significante a 90% com nenhuma das duas surpresas.
- Pode: normalizado pela variação do DI de 6 meses, o efeito tem o mesmo ponto da forma reduzida. O
  primeiro estágio é a identidade na bruta e tem F 656 na ortogonalizada, e os conjuntos AR ficam
  iguais ou quase iguais aos de Wald.
- Pode: o câmbio troca de sinal na passagem do evento diário ao DFM mensal, com as duas surpresas, e
  a ortogonalização não é a etapa da troca.
- Não pode: atribuir a troca à frequência, à janela, à agregação, à normalização, à medida ou ao
  modelo. A passagem muda os cinco juntos, e nada nesta rodada os separa.
- Não pode: ler a associação diária como efeito causal do choque monetário. É forma reduzida no dia do
  Copom, como o e-mail pede, e só vira efeito sob a hipótese de que a surpresa da janela é só política.
- Não pode: "o CDS não responde no dia". Não é significante a 90%: isso é ausência de evidência, com
  conjuntos de ±4 a ±9 p.b. a 95%.
- Não pode: citar `het_rigobon/` como corroboração do sinal diário do câmbio. `goncalves2025` entra
  só como a evidência diária publicada por eles, em outro desenho de identificação.
- Não pode: usar o câmbio diário de `brl_usd_daily.csv` numa janela de evento sem o realinhamento da
  seção 1.

## 7. O que mudou

- `script/download_ptax.R`, estágio de rede `ptax` em `script/run_all.R`: grava
  `data/raw/ptax_daily.csv` (SGS 1 por `download_bcb_data()`, 3517 dias de 2012-01 a 2025-12; a PTAX
  de 2015-01-14 é 2,6222, igual à do Olinda).
- `script/daily_event.R` escreve `output/daily_event/`.
- `.claude/rules/data.md` ganhou a PTAX e o aviso sobre o Yahoo, e corrigiu duas frases velhas: o
  xlsx do CDS é lido por `het_conditions.R`, e `instrument.R` não lê câmbio.
- Nada em `R/` mudou. O smoke test sai bit-idêntico ao da branch (câmbio 0,14584857519843694), e
  nenhum arquivo de `output/` fora de `output/daily_event/` mudou.
- O passo 3 (influência das reuniões) pode partir de `events.csv`, que traz, por reunião, as duas
  surpresas e as três variações.
