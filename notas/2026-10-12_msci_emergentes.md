# A `msci` vira o índice MSCI de emergentes: os passos 0 a 4 de novo

> **CURRENT — 2026-10-12.** Rerodada dos passos 0/5 a 4/5 do plano do orientador de 03-10
> (`email/email_professor_03-10_11h31.md`), no desenho do e-mail de 08-10 para os passos 3 e 4
> (`email/email_professor_08-10_15h15.md`). Branch `feature/focus-horizonte-fixo`, **não mergeada**.
> - A série `msci` do painel era a ação da MSCI Inc. (nota `2026-10-09_placebos_holm`, seção 4) e
>   passa a ser o índice MSCI Emerging Markets. Tudo o mais é a base do passo 0: 115 séries na mesma
>   ordem, Focus a horizonte fixo, 2012-03 a 2025-12, `(r,q,p) = (5,5,4)`, `z_bs_purif`, escala COVID
>   de Lenza-Primiceri com θ reestimado no painel novo, +50 p.b. em `yield_6m`, conjuntos
>   Anderson-Rubin com NW(0).
> - Linha de base: a base do passo 0 com a ação, em `2348852`, lida pelo git em
>   `script/msci_emerging_index.R`.
> - Decisões do autor em 10-12, tomadas antes de rodar:
>   - a troca vale só nesta branch, e `main` fica com a ação até a promoção;
>   - a base fica congelada: nada além da coluna `msci` é baixado de novo;
>   - uma nota só para a rerodada, e as cinco notas dos passos ganham banner de números superados;
>   - o índice é o de preço em dólares, da própria MSCI.
> - O desenho de cada passo segue o das notas `2026-10-03_focus_horizonte_fixo`,
>   `2026-10-05_precisao_ar`, `2026-10-05_evento_diario`, `2026-10-08_influencia_reunioes` e
>   `2026-10-09_placebos_holm`. Esta nota só traz os números novos ao lado dos antigos.
> - Nada no `.tex` nem em `paper/img/`.

## 1. A série

O índice vem do serviço de níveis da própria MSCI: código 891800, índice de preço em dólares,
variante padrão, nível do último dia útil de cada mês. O estágio de rede é `msci`
(`script/download_msci.R`), separado para não baixar de novo o painel. Ele escreve
`data/raw/msci_em.csv`, de 2010-01 a 2025-12. O fechamento de dez/2023 é 1023,74 e o de dez/2024
1075,48, os valores publicados pela MSCI.

`clean.R` põe o índice na coluna `msci`, na mesma posição (85ª do painel de produção). O
`raw_data.csv` em disco é anterior à troca e ainda traz a ação nessa coluna; o índice a sobrescreve.
`download.R` deixou de ler `data/raw/investing/msci.csv` e passa a 112 séries. O arquivo fica em
disco porque `main` ainda o lê.

Conferido contra a cópia do painel do passo 0 feita antes de rodar `clean.R`:
- as outras 114 séries do painel de produção, e as outras 105 da base de 106, saem bit-idênticas e na
  mesma ordem;
- não há NA;
- o manifesto só muda na linha da `msci`.

A ação e o índice são séries diferentes (`output/msci_emerging_index/series.csv`, `series.pdf`):

| | ação da MSCI Inc. | índice MSCI emergentes |
|---|---|---|
| unidade | dólares por ação | pontos |
| amplitude, 2012-03 a 2025-12 | 26,94 a 664,88 | 740,33 a 1404,37 |
| tratamento sazonal (`clean.R`) | X-13, especificação completa | nenhum, a série não é sazonal |

Nos 166 meses, a correlação entre os níveis é 0,53, e entre as variações mensais é 0,30.

## 2. Passo 0: a base

**θ e o modelo** (`output/msci_emerging_index/model.csv`):

| | antes (ação) | agora (índice) |
|---|---|---|
| θ̂ = (s̄0, s̄1, s̄2, ρ) | (7,4640; 15,0121; 1,4370; 0,9656) | (7,5070; 14,8750; 1,4177; 0,9671) |
| log-verossimilhança | −1549,96 | −1554,88 |
| ξ_mp, janela completa | 6,80 | 6,66 |
| ξ_mp, pré-COVID | 5,50 | 5,60 |
| F_rob, completa / pré-COVID | 8,28 / 5,34 | 8,07 / 5,16 |
| maior raiz, completa / pré-COVID | 0,9855 / 0,9945 | 0,9887 / 0,9910 |
| Bai-Ng IC1, IC2, IC3 | 5, 5, 18 | 5, 5, 18 |
| `p` por AIC / BIC (T = 154) | 4 / 2 | 4 / 2 |
| ξ_mp de `z_bruto` / `z_jk_bs_purif` | 6,31 / 4,83 | 6,22 / 4,77 |

- θ̂ passou nas três guardas de `verify_covid_theta()`: condições de primeira ordem, perfil em ρ e
  multi-start de 750 inícios.
- Os dois companheiros são estáveis.
- ξ_mp cai 2% na janela completa e sobe 2% na pré-COVID, e segue abaixo de 10 nas duas.
- Todo conjunto de 80% e de 90% é intervalo, mais o `singleton` da normalização.
- Os sete validadores passam com os pinos novos, e o smoke test reproduz o cache.

**Câmbio e CDS.** Nada muda além da terceira casa:

| série | h | antes, ponto | antes, 90% | agora, ponto | agora, 90% | agora, 80% |
|---|---|---|---|---|---|---|
| BRL/USD (R$/US$) | 0 | 0,146 | [0,071; 0,278] | 0,145 | [0,068; 0,281] | [0,087; 0,231] |
| | 1 | 0,180 | [0,064; 0,356] | 0,179 | [0,062; 0,360] | [0,092; 0,296] |
| | 3 | 0,172 | [0,058; 0,311] | 0,168 | [0,055; 0,307] | [0,087; 0,261] |
| | 6 | 0,120 | [−0,002; 0,226] | 0,117 | [−0,004; 0,222] | [0,035; 0,191] |
| | 12 | 0,027 | [−0,111; 0,129] | 0,026 | [−0,115; 0,129] | [−0,067; 0,101] |
| | 24 | −0,077 | [−0,238; 0,044] | −0,077 | [−0,242; 0,045] | [−0,186; 0,011] |
| | 36 | −0,113 | [−0,280; 0,006] | −0,115 | [−0,284; 0,005] | [−0,226; −0,027] |
| CDS 5 anos (p.b.) | 0 | 33,9 | [15,7; 66,0] | 33,5 | [15,0; 66,4] | [19,5; 54,3] |
| | 1 | 37,1 | [16,4; 68,8] | 36,9 | [16,1; 69,3] | [21,5; 57,8] |
| | 3 | 34,0 | [13,6; 57,0] | 33,3 | [13,1; 56,3] | [19,0; 48,9] |
| | 6 | 26,1 | [2,4; 44,0] | 25,6 | [2,1; 43,3] | [10,0; 38,4] |
| | 12 | 9,0 | [−19,3; 27,4] | 8,9 | [−19,8; 27,3] | [−9,6; 22,5] |
| | 24 | −15,0 | [−47,9; 8,9] | −15,1 | [−48,5; 9,1] | [−37,0; 2,5] |
| | 36 | −24,4 | [−59,2; 0,3] | −24,7 | [−59,7; 0,2] | [−47,7; −6,6] |

O câmbio segue significante a 90% de h0 a h5, e o CDS de h0 a h6. A reversão de h36 segue
significante a 80% e não a 90%, nas duas séries.

**O painel** (115 séries, h0 a h36, 4255 pares; `irf_outside.csv`, `irf_significance_by_h.csv`):
- **Pontos fora do conjunto de 90% antigo.** Fora da `msci`, nenhum ponto novo sai. Na `msci` saem 33
  dos 37, mas ali a comparação é entre duas séries diferentes e não conta nada.
- **Largura.** A largura mediana dos conjuntos de 90% fica a 0,4% da antiga.
- **Pares significantes.** A 80%, são 2362 contra 2366. A 90%, sobem de 1051 para 1132: 103 ganhos
  e 22 perdidos.
  - Dos 103 ganhos, 82 estão em h25–h36, e 93 dos 103 têm sinal negativo.
  - Os índices de preços são o maior bloco dos ganhos de h25–h36: 33 dos 82. O IPCA passa a ser
    significante a 90% em h28–h36, antes h30–h33. Os núcleos IPC-Fipe e IPCA-DP passam a ser
    significantes em h31–h36, e o IGP-M em h31–h35, todos com sinal negativo.
  - Das 22 perdas, 7 são da própria `msci` e 10 são de índices de ações: Ibovespa, IFIX e IMAT, duas
    cada; IDIV, IFNC, IMOB e SMLL, uma cada.
- ⚠ **O IPCA segue positivo em h1 e h3–h7**, com máximo de +0,038 p.p. (+0,039 antes). Em nenhum
  desses horizontes é significante a 90%.

## 3. Passo 1: precisão

**Câmbio e CDS a 90 e 95%, na produção** (`step1_fx_cds.csv`):

| série | h | ponto | 95% | p-valor antes | p-valor agora |
|---|---|---|---|---|---|
| câmbio | 0 | 0,145 | [0,048; 0,361] | 0,013 | 0,015 |
| | 1 | 0,179 | [0,028; 0,458] | 0,030 | 0,031 |
| | 3 | 0,168 | [0,014; 0,372] | 0,039 | 0,041 |
| | 6 | 0,117 | [−0,060; 0,260] | 0,104 | 0,107 |
| | 12 | 0,026 | [−0,186; 0,162] | 0,642 | 0,657 |
| | 24 | −0,077 | [−0,324; 0,085] | 0,253 | 0,254 |
| CDS | 0 | 33,5 | [10,2; 85,5] | 0,015 | 0,017 |
| | 1 | 36,9 | [10,1; 86,9] | 0,021 | 0,021 |
| | 3 | 33,3 | [5,5; 66,6] | 0,033 | 0,035 |
| | 6 | 25,6 | [−9,6; 49,1] | 0,084 | 0,086 |
| | 12 | 8,9 | [−35,3; 32,7] | 0,457 | 0,464 |
| | 24 | −15,1 | [−65,4; 16,9] | 0,260 | 0,262 |

- **Impacto.** Câmbio e CDS seguem significantes a 95% no impacto.
- **Câmbio a 95%.** Significante de h0 a h3, como antes.
- ⚠ **CDS a 95%.** Significante em h0, h1, h3 e h4. Antes era de h0 a h4: o p-valor em h2 passa a
  0,051.
- **Painel.** Nos seis horizontes da tabela, há 185 pares significantes a 95% (186 antes). De h0 a
  h36 são 469, contra 458.

**Janela pré-COVID** (`step1_precovid_cells.csv`; `step1_fx_cds.csv`, célula `pre_covid_p2`):
- `p = 4` segue barrado pelas duas condições (`hac_dim` 135 e `par_dim` 120 contra T = 90).
- Em `(5,5,2)`, ξ_mp vai de 5,64 a 5,87, com maior raiz 0,9885.
- Câmbio e CDS seguem significantes a 95% em h0, h1, h3 e h6: câmbio 0,117 no impacto,
  95% [0,016; 0,252]; CDS 40,9 p.b., 95% [4,6; 76,4].
- Em h12, o câmbio não é significante a 95% ([−0,004; 0,302]), e o CDS passa a ser ([0,1; 76,2],
  antes [−0,1; 80,2]).
- ⚠ **O ponto pré-COVID de `p = 4` em relação ao conjunto de 90% de `p = 2`.** Ele sai do conjunto
  em 725 pares de 76 séries, contra 659 de 65. No câmbio, CDS, curva e EMBI, sai em h8–h20, antes
  h9–h22.
- O impacto do câmbio em `p = 4` é 0,129, contra 0,121.

**Autocorrelação dos momentos** (`moment_ljung_box.csv`). O retrato é o de antes:
- O momento de ξ_mp não tem autocorrelação: Ljung-Box p 0,99, 0,80 e 0,95 em 3, 6 e 12
  defasagens.
- Em câmbio e CDS, ψ_t(0) de h0 a h12 não rejeita a 5%. O menor p é 0,237, no CDS em h6 com 3
  defasagens.
- Em h24, o câmbio rejeita com 3 defasagens (p 0,038).
- No ponto, o câmbio em h0 rejeita com 12 defasagens (p 0,0001).
- No bloco de coeficientes da função de influência, 15%, 14% e 19% das colunas rejeitam, contra 15%,
  14% e 21% antes.

**Newey-West** (`step1_nw_strength.csv`, `output/ar_precision/nw_panel.csv`):

| L | ξ_mp antes | ξ_mp agora | F_rob agora | pares a 80% | a 90% | a 95% | perdidos a 90% | largura mediana a 90% |
|---|---|---|---|---|---|---|---|---|
| 0 | 6,80 | 6,66 | 8,07 | 2362 | 1132 | 469 | 0 | 1,000 |
| 1 | 6,94 | 6,78 | 7,84 | 2386 | 1386 | 665 | 7 | 1,006 |
| 2 | 7,04 | 6,89 | 7,62 | 2470 | 1637 | 829 | 4 | 0,995 |
| 3 | 7,16 | 7,00 | 7,60 | 2548 | 1765 | 954 | 7 | 0,983 |
| 4 | 7,41 | 7,26 | 7,86 | 2632 | 1927 | 1213 | 8 | 0,952 |
| 8 | 9,18 | 9,00 | 10,05 | 2897 | 2336 | 1755 | 7 | 0,805 |
| 12 | 10,01 | 9,79 | 11,64 | 2958 | 2443 | 1897 | 6 | 0,749 |

- **De 1 a 3 defasagens**, o impacto de câmbio e CDS segue significante a 95%, e os dois são
  significantes a 95% até h4.
- **Ponta longa a 90%.** Volta em parte. O câmbio é significante em h36 com L = 2 e em h33–h36 com
  L = 3. O CDS, em h34–h36 com L = 2 e em h32–h36 com L = 3.
- ⚠ **ξ_mp com 12 defasagens.** Fica em 9,79, abaixo de 10, onde antes chegava a 10,01. Nenhuma
  truncagem da grade leva ξ_mp a 10.

## 4. Passo 2: evento diário

As regressões diárias não usam o painel. `events.csv`, `regressions.csv` e `fx_alignment.csv` saem
byte-idênticos. Na reunião, um aperto de +50 p.b. vem com o real se **apreciando** R$ 0,048, e isso é
significante a 95%. O CDS não é significante a 90%. Mudam só as linhas do DFM mensal
(`step2_daily_dfm.csv`):

| surpresa | câmbio antes | câmbio agora | CDS antes | CDS agora | ξ_mp antes | ξ_mp agora |
|---|---|---|---|---|---|---|
| bruta | 0,099 | 0,096 | 23,3 | 22,2 | 6,31 | 6,22 |
| ortogonalizada | 0,146 | 0,145 | 33,9 | 33,5 | 6,80 | 6,66 |

- Com a surpresa ortogonalizada, câmbio e CDS do DFM seguem significantes a 95%.
- Com a bruta, nenhum dos dois é significante a 95%. O câmbio também não é significante a 90%
  ([−0,006; 0,184]), nem o CDS ([−1,2; 44,9]).
- A tabela 2×2 da nota do passo 2 e a leitura não mudam: o câmbio só troca de sinal na passagem do
  diário ao DFM, e essa passagem não é decomposta.

## 5. Passo 3: influência das reuniões

- **A ordem.** É a mesma nas dez primeiras posições, salvo a troca entre a 2ª e a 3ª: 2021-10-28 sobe
  a 2ª e 2022-03-17 desce a 3ª (`step3_ranking.csv`). As cinco e as dez mais influentes são as mesmas
  reuniões.
- **Uma a uma.** Nada muda muito. Nas 99 reuniões que entram em Γ:
  - câmbio em h0 de 0,124 a 0,175, antes 0,126–0,175;
  - CDS de 28,4 a 41,7 p.b., antes 28,9–42,0;
  - ξ_mp de 5,38 a 7,49, antes 5,52–7,61.

**Exclusão conjunta** (`step3_strength.csv`, `step3_fx_cds.csv`):

| | ξ_mp antes | ξ_mp agora | F_rob agora | câmbio h0 agora | CDS h0 agora |
|---|---|---|---|---|---|
| produção | 6,80 | 6,66 | 8,07 | 0,145 | 33,5 |
| sem as 5 | 3,59 | 3,54 | 3,69 | 0,192 | 43,0 |
| sem as 10 | 2,01 | 1,82 | 1,65 | 0,077 | 40,1 |

- **Sem as 5:**
  - ⚠ o câmbio é significante a 90% de h0 a h4, antes h0–h5;
  - o CDS é significante a 90% de h0 a h4, como antes;
  - a 95%, nenhum dos dois é significante. Os conjuntos de 95% do câmbio são a reta toda, e os do
    CDS são a reta toda ou dois raios.
- **Sem as 10:** todo conjunto de câmbio e CDS é a reta toda, a 90% e a 95%.

A leitura da nota do passo 3 fica como estava: a significância depende de poucas reuniões, e a
direção e a magnitude não. ⚠ Sem as 10, ξ_mp é mais baixo que antes (1,82 contra 2,01).

## 6. Passo 4: placebos com Holm

A família é a do e-mail de 08-10: VIX, MSCI emergentes e EPU dos EUA, em h = 0, 1, 3, 6, 12 e 24, com
18 testes, ajuste de Holm e nível de 10%. A família de 12 da nota do passo 4 saiu de
`placebo_holm.R`, porque só existia por a série ser a ação. Os conjuntos são pontuais. As unidades
são pontos do VIX, pontos do índice MSCI e pontos do EPU (`step4_placebos.csv`):

| série | h | ponto | 90% | 95% | p | p antes | Holm (18) |
|---|---|---|---|---|---|---|---|
| VIX | 0 | 0,45 | [−1,59; 3,42] | [−2,21; 4,98] | 0,692 | 0,662 | 1,000 |
| VIX | 1 | 0,09 | [−0,96; 1,75] | [−1,26; 2,66] | 0,876 | 0,866 | 1,000 |
| VIX | 3 | −0,97 | [−1,98; 0,13] | [−2,37; 0,60] | 0,126 | 0,123 | 1,000 |
| VIX | 6 | −1,10 | [−1,93; −0,02] | [−2,20; 0,52] | 0,098 | 0,088 | 1,000 |
| VIX | 12 | −0,67 | [−1,62; 0,90] | [−1,88; 1,77] | 0,334 | 0,311 | 1,000 |
| VIX | 24 | 0,79 | [−0,78; 3,14] | [−1,25; 4,39] | 0,370 | 0,371 | 1,000 |
| MSCI emergentes | 0 | −27,5 | [−65,0; −5,7] | [−86,5; 0,1] | 0,051 | 0,505 | 0,859 |
| MSCI emergentes | 1 | −27,3 | [−56,7; −9,1] | [−73,0; −4,0] | 0,032 | 0,172 | 0,575 |
| MSCI emergentes | 3 | −21,0 | [−38,9; −5,6] | [−47,0; 0,1] | 0,051 | 0,055 | 0,859 |
| MSCI emergentes | 6 | −15,6 | [−27,7; 0,2] | [−31,9; 7,8] | 0,102 | 0,055 | 1,000 |
| MSCI emergentes | 12 | −5,8 | [−16,2; 9,8] | [−19,3; 18,1] | 0,397 | 0,135 | 1,000 |
| MSCI emergentes | 24 | 6,5 | [−5,1; 21,5] | [−9,0; 28,8] | 0,303 | 0,756 | 1,000 |
| EPU dos EUA | 0 | 9,01 | [−2,45; 30,36] | [−5,32; 43,03] | 0,186 | 0,179 | 1,000 |
| EPU dos EUA | 1 | 9,45 | [−3,39; 31,98] | [−6,77; 44,99] | 0,210 | 0,196 | 1,000 |
| EPU dos EUA | 3 | 8,19 | [−0,83; 24,42] | [−3,16; 33,90] | 0,130 | 0,113 | 1,000 |
| EPU dos EUA | 6 | 3,88 | [−2,14; 14,79] | [−3,69; 21,17] | 0,273 | 0,218 | 1,000 |
| EPU dos EUA | 12 | 1,76 | [−3,98; 12,16] | [−5,45; 18,24] | 0,608 | 0,586 | 1,000 |
| EPU dos EUA | 24 | 5,20 | [−1,74; 15,18] | [−3,90; 20,36] | 0,191 | 0,212 | 1,000 |

A coluna "p antes" das linhas da MSCI é da ação da MSCI Inc., outra série.

- **Com Holm, nenhum dos 18 testes rejeita a 10%.** O menor p ajustado é 0,575 (antes 0,983).
  **Não rejeitamos a hipótese de resposta zero após o ajuste por múltiplos testes.** Isso não
  comprova a exogeneidade, porque também pode refletir pouca precisão.
- **Sem ajuste, quatro testes rejeitam a 10%**, antes três:
  - MSCI emergentes em h0, h1 e h3 (p 0,051, 0,032 e 0,051);
  - o VIX em h6 (p 0,098).
  
  ⚠ **A MSCI em h1 rejeita a 5%** (p 0,032), e nenhum teste rejeitava a 5% antes.
- **Nos outros horizontes até h24** (`output/irf/irf_coherence_h.csv`), que não entram na família:
  - o índice MSCI é significante a 90% em h0, h1, h3 e h4, sempre negativo, e a 80% de h0 a h9;
  - o VIX segue significante a 90% em h2, h5 e h6;
  - o EPU não é significante a 90% em nenhum horizonte, e a 80% é em h0, h2–h4 e h24.
  
  A contagem desses pontos não é evidência estatística conjunta.
- **A ortogonalização.** Não muda: só o VIX entra, como `pre_vix` (coeficiente −0,025, p 0,92). Nem a
  MSCI nem o EPU entram (`output/placebo_holm/orthogonalization.csv`).
- **O p = 0,54** é o mesmo da nota do passo 4, seção 5: a regressão é diária e não usa o painel.

**A rejeição pontual da MSCI.** Pelo e-mail de 08-10, ela é reportada e discutida, sem presumir
contaminação.
- **Magnitude.** No impacto, um aperto de 50 p.b. vem com o índice de emergentes 27,5 pontos mais
  baixo. São 0,59 desvio-padrão da variação mensal do índice (46,9 pontos), que na amostra ficou entre
  740 e 1404 pontos.
- **O que a rodada não separa.**
  - O Brasil é um dos países do índice, e a queda das ações brasileiras em dólares entra nele
    mecanicamente, pelo peso do Brasil. A rodada não mede esse peso.
  - Uma piora de risco comum aos emergentes que coincida com as surpresas do Copom mostraria o mesmo
    sinal.
  - A rejeição está no impacto e em h1, não nos horizontes posteriores, onde o e-mail sugere pensar em
    transmissão.
- ⚠ **Em h0 o mês do índice se sobrepõe à reunião.** O nível é o do fim do mês, e parte dos dias
  desse mês antecede a quarta da reunião. É a mesma ressalva que a nota do passo 4 faz para o VIX.
  Diferente do VIX, a MSCI não entra na ortogonalização, então o teste em h0 não tem restrição
  mecânica. Mas a ortogonalização usa as tendências de 65 pregões do S&P 500 e do VIX, que andam com
  o índice de emergentes.

## 7. O que pode e o que não pode ser dito

- **Pode:** a troca da `msci` não muda câmbio e CDS. No impacto, R$ 0,145 por dólar e 33,5 p.b.,
  ambos significantes a 95% (p 0,015 e 0,017). O câmbio é significante a 95% até h3. O CDS é
  significante a 95% em h0, h1, h3 e h4.
- **Pode:** nenhum ponto de outra série sai do conjunto de 90% da base antiga.
- **Pode:** com Holm nos 18 testes, não rejeitamos a resposta zero dos placebos a 10%.
- **Não pode:** que o placebo da MSCI "passa". Sem ajuste, o índice de emergentes cai no impacto e em
  h1, h1 rejeitando a 5%, e a rodada não separa o peso do Brasil, uma piora comum aos emergentes e uma
  contaminação.
- **Não pode:** que o instrumento seja forte em alguma truncagem de Newey-West. Com 12 defasagens,
  ξ_mp é 9,79.
- **Não pode:** usar os 81 pares a mais significantes a 90% como sinal de precisão maior. Os ganhos
  estão sobretudo em h25–h36, e a contagem não é evidência conjunta.

## 8. O que fica de fora

- **`main`.** Segue com a ação da MSCI Inc. no painel de produção, nos anexos, em `paper/img/` e nos
  números do `.tex`. A troca entra em `main` com a promoção da branch.
- **O paper.** Já chama a série de "MSCI de mercados emergentes" (§3.2, §3.3, Anexo A,
  `fig:placebos`), e passa a estar certo depois da promoção. A fonte em `tab:lista_variaveis` ainda é
  "Investing.com".
- **Os anexos desta branch.** `q`, `p`, pandemia e camadas, mais `het_conditions.R` (a linha fatorial
  do Anexo B) e `fig_section5.R`, não rodaram de novo, como no passo 0.
- **O passo 3, parte 2** (exclusão por VIX, S&P 500 e Brent), espera a regra do autor. **O passo 5**
  não foi pedido.
- **O peso do Brasil no índice de emergentes**, que separaria a parte mecânica do placebo.

## 9. Arquivos

- `script/download_msci.R` (estágio `msci`) escreve `data/raw/msci_em.csv`.
- `script/clean.R` põe o índice na coluna `msci`.
- `script/msci_emerging_index.R` escreve `output/msci_emerging_index/`:
  - a série: `series.csv`, `series_summary.csv` e `series.pdf`;
  - o modelo: `model.csv`;
  - as respostas: `irf_table.csv`, `irf_outside.csv`, `irf_significance_by_h.csv` e `irf.pdf`;
  - os passos 1 a 4 antes e depois: `step1_fx_cds.csv`, `step1_significance_counts.csv`,
    `step1_precovid_cells.csv`, `step1_nw_strength.csv`, `step2_daily_dfm.csv`, `step3_strength.csv`,
    `step3_fx_cds.csv`, `step3_ranking.csv` e `step4_placebos.csv`.
- `compare_model()` e `compare_cells()` saíram de `script/focus_fixed_horizon.R` para
  `R/reporting/sensitivity.R`. Os CSVs do passo 0 saíram byte-idênticos.
- Os outputs dos passos foram reescritos: `output/ar_precision/`, `output/daily_event/comparison.csv`,
  `output/meeting_influence/` e `output/placebo_holm/`. O mesmo vale para o cache
  `output/irf/irf_coherence_cell.rds` e para θ̂ em `output/factors/`.
- Os pinos de `validate_production_spec.R` e `validate_covid_volatility.R` foram atualizados, com os
  antigos em comentário.
