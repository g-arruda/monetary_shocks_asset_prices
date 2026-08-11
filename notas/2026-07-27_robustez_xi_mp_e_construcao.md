# Robustez do ξ_mp e da construção do instrumento

> **Veredito: CURRENT.** Escrita sob a especificação de produção corrente —
> `z_jk_bs_purif` × `yield_6m`, (r, q) = (7, 6), p = 6, vintage de 106 séries
> de 2026-07-24. Nenhuma decisão de produção mudou: o exercício **confirmou** a
> construção herdada em vez de substituí-la.
>
> Artefatos: `output/instrument/xi_mp_robustness.{csv,md}`,
> `output/instrument/instrument_construction_sweep.{csv,md}`,
> `output/instrument/vertex_irf_overlay.pdf`.
> Código: `script/xi_mp_robustness.R`, `script/instrument_construction_sweep.R`,
> `script/validate_hac_kernel.R`, `R/instrument/build_variants.R`.

Fecha os dois itens de robustez abertos em `pendencias.md` em 2026-07-27: o
ξ_mp nunca tinha sido estressado, e o vértice do DI e o esquema de agregação
nunca tinham sido varridos no vintage corrente sob a régua corrente.

---

## 0. O achado que reorganizou os dois itens

Os dois exercícios pareciam independentes e **não são**. O esquema de agregação
de Gertler-Karadi parte cada surpresa entre `t` e `t+1`, o que induz **MA(1)**
no instrumento mensal por construção — e a justificativa corrente de
`NWlags = 0` depende explicitamente de a soma ser não-sobreposta. Sem a opção
HAC do primeiro item, a célula GK do segundo sairia mal especificada. Por isso
o HAC veio primeiro.

E há um fato do painel que decide a questão da agregação antes de qualquer
regressão. A nota 11 do GK enuncia a **própria motivação de forma condicional**:

> "as we use **monthly average rates (not end of the month rates)** for our
> monetary policy indicators, a surprise that happens at the end of a month can
> be expected to have a smaller influence on the monthly average rate than a
> surprise coming at the beginning of the month"

A ponderação existe **porque** o indicador de política do GK é média mensal. O
indicador deste projeto, `yield_6m`, é observação de **fim de mês** —
`script/download.R:49-53` faz `slice_tail(n = 1)`. Para um indicador de fim de
mês, uma surpresa em qualquer dia de `t` já está integralmente refletida no
valor de `t`, que é exatamente o que a soma assume. A previsão "GK deve piorar
neste painel" foi **registrada no plano antes de rodar**.

Corolário que cai de graça: os 7 encontros em que a quarta é o último dia do mês
e a quinta é o dia 1 do seguinte, hoje contabilizados em `t+1` pela convenção de
quinta-feira, estão **certos** — o anúncio sai após o fechamento e não entra no
yield de fim de mês de `t`.

---

## 1. Opção HAC no bloco Wald

`compute_factor_space_wald` ganhou `nw_lags` (default 0). O kernel é a
transcrição literal de `codigo_olea/functions/RForm/NW_hac_STATA.m` — Bartlett
`1 − n/(L+1)`, divisor `T`, sem correção de graus de liberdade.

**Validação em dois níveis** (`script/validate_hac_kernel.R`):

| nível | resultado |
|---|---|
| Kernel × transcrição literal do MATLAB, lags 0-8 | diferença **0** (exata) |
| Pesos × `sandwich::kweights(., "Bartlett")` | idênticos |
| `nw_lags = 0` × números publicados de Kilian | `validate_olea_kilian.R` segue passando (ξ₁ = 4,399 vs 4,4; F HC1 = 9,438 vs 9,4) |
| **Ponta a ponta × aplicação oficial de impostos** (`TaxSVARIV.m`, n = 9, p = 2, **NWlags = 8**) | bloco Γ de `WHat` reproduzido com diferença relativa **2,6e-10 — e só em lag 8** (lag 0 erra 88%, lag 4 erra 12%, lag 12 erra 3,9%) |

O quarto teste mede algo que os outros não alcançam. O projeto aplica a correção
Shat **residualizando `z` nos regressores do VAR** em vez de montar o bloco
oficial `−kron(Q₂Q₁⁻¹, I)`. As duas coisas são iguais porque Shat é matriz
constante e a forma NW é bilinear, logo `Shat·NW(M)·Shat' = NW(M·Shat')` — mas
isso era **argumento**, e agora é medição, válida em qualquer defasagem.

O fixture (`output/validation/olea_tax_*.csv`, 52 KB) foi extraído de
`codigo_olea/Data/Tax/Tax_RForm.mat`, que é gitignored; sem ele o script pula o
teste B com aviso, em vez de falhar.

---

## 2. Leave-one-month-out

DFM fixo, só o momento Γ recomputado — `c_mp` também vem do DFM e fica fixo, de
modo que o exercício isola a influência que passa pelo **momento**, não pela
estimação de fatores.

**Instrumento de produção, amostra completa** (147 meses):

| | valor |
|---|---|
| ξ_mp cheio | **10,43** |
| mínimo / mediana / máximo sob LOO | 8,43 / 10,43 / 12,21 |
| descartes que derrubam abaixo de **10** | **24 de 147** |
| descartes que derrubam abaixo de **3,84** | **0 de 147** |

A leitura tem duas partes e elas apontam para lados diferentes:

1. **A afirmação forte é frágil.** "ξ_mp ≥ 10, logo bandas convencionais valem"
   não sobrevive à remoção de qualquer mês: 24 meses individuais derrubam a
   estatística abaixo do limiar. O parecerista que perguntar "isso raspa o
   limiar" está certo.
2. **A afirmação que sustenta a inferência é robusta.** O conjunto AR é limitado
   se e somente se ξ_mp > 3,84, e **nenhum** dos 147 descartes chega perto de
   violar isso (mínimo 8,43). Sob qualquer amostra a menos de um mês, o conjunto
   AR continua sendo um intervalo limitado.

Nenhum mês domina, e **nenhum dos dez mais influentes é da COVID** — o mais
influente é 2024-12 (−2,00), seguido de 2023-05 (−1,90) e 2022-05 (−1,60). A
força não é artefato de 2020.

Pré-COVID é mais folgado: 12,22 cheio, mínimo 8,40, só 4 de 78 descartes abaixo
de 10.

O contraste entre variantes reproduz o achado da máscara: `z_jk_purif`
(máscara contemporânea) tem **147 de 147** descartes abaixo de 10 e um abaixo
de 3,84.

---

## 3. HAC — ξ_mp por defasagem

| amostra | NW(0) | NW(1) | NW(2) | NW(3) | NW(4) | NW(5) | NW(6) |
|---|---|---|---|---|---|---|---|
| full | 10,43 | 10,13 | 10,61 | 11,73 | 12,97 | 14,54 | 15,64 |
| pré-COVID | 12,22 | 12,98 | 13,92 | 14,07 | 14,19 | 14,45 | 13,14 |

O instrumento de produção cruza 10 em **todas** as defasagens, nas duas janelas.
E ξ_mp é **crescente** em NW na amostra completa, então NW(0) é a escolha
**conservadora** — não uma conveniência. Isso encerra a objeção antes de ela ser
feita: reportar NW(0) não infla a força, subestima-a.

---

## 4. Vértice do DI

**Correção de registro.** `pendencias.md` dizia "não há artefato nenhum". O
artefato existe, **arquivado**: `arquivo/output/instrument_grid.{csv,md}`,
gerado em 2026-04-12 por `arquivo/script/instrument_grid.R`, é a procedência do
comentário `# best F in grid search` (`TARGET_BD` entra no repo em `ef56277`,
2026-04-26, logo depois). Ele elegeu DI 6m — mas com F = 4,30, ou seja "menos
ruim", sob a régua legada, no vintage pré-refresh, e cobrindo só as 4 variantes
legadas. `z_jk_bs_purif` não existia. Re-rodar era necessário; o enquadramento é
que estava errado.

**ξ_mp por vértice, soma JK, `z_jk_bs_purif`:**

| du | 21 | 42 | 63 | 84 | 105 | **126** | 147 | 168 | 189 | 210 | 252 | 378 | 504 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| full | 6,61 | 8,34 | 5,01 | **10,63** | 6,51 | **10,43** | 10,54 | 7,21 | 6,98 | 6,58 | 7,96 | 8,03 | 8,51 |
| pré-COVID | 13,46 | **18,44** | 15,15 | 14,24 | 10,73 | 12,22 | 11,41 | 7,85 | 5,24 | 11,23 | 2,75 | 1,94 | 0,50 |

**126 du não é o argmax em nenhuma das duas janelas.** Na completa, 84 (10,63) e
147 (10,54) o superam; na pré-COVID, 42 (18,44) domina. E a resposta ao vértice
é **não-monotônica e instável** — 63 du dá 5,01 na completa e 15,15 na
pré-COVID.

### A regra de decisão e por que ela não dispara

A regra foi fixada no plano **antes** de qualquer número existir: troca-se a
produção só se uma célula (i) bater o incumbente nas duas janelas, (ii) cruzar
10 nas duas, e (iii) vencer por margem **maior que a dispersão LOO do próprio
ξ_mp do incumbente**. O critério (iii) é lido programaticamente de
`xi_mp_robustness.csv` pelo script de varredura, não asseverado à mão.

- Limiar (iii): **2,00** pontos.
- Quatro células passam em (i) e (ii): (84, `z_jk_raw`) 11,59/13,01;
  (84, `z_jk_raw_purif`) 11,42/13,68; (147, `z_bruto`) 10,74/17,41;
  (84, `z_jk_bs_purif`) 10,63/14,24.
- Maior margem: **1,16**. Abaixo de 2,00.

**A regra não dispara. A produção fica em 126 du + soma.**

A conclusão correta não é "126 du é ótimo". É que **o vértice não é identificado
com precisão suficiente para escolher entre os candidatos**: as diferenças entre
os melhores vértices são menores do que o que a remoção de um único mês move a
estatística. A escolha herdada está dentro do conjunto indistinguível do melhor,
e isso é tudo o que se pode afirmar — o que, aliás, é uma afirmação mais
defensável do que a que o comentário de código fazia.

O protocolo anti-screening do MOSW (nota 6) é respeitado: a grade inteira de 260
células está publicada e nada é filtrado pela estatística.

### O overlay (análogo da Figura A4 de Alessi-Kerssenfischer)

`output/instrument/vertex_irf_overlay.pdf`. O apêndice de robustez do A&K roda
A1 (`p`), A2 (`r`), A3 (`q`) e **A4 (instrumento)**; este projeto tinha os três
primeiros e não tinha o quarto.

**Todos os 13 vértices produzem essencialmente a mesma IRF** — mesmo sinal,
mesma forma, dentro da banda de 68% em quase todo horizonte, para `yield_6m`,
`yield_2y`, `yield_5y`, `asset_ibov` e `cambio_usd`. Ou seja: o vértice move
ξ_mp em vários pontos e **não move as IRFs**. É o resultado mais forte da nota,
e é o que efetivamente responde "a escolha do vértice contamina os resultados?".

As bandas são reaproveitadas do bootstrap de produção já em disco, sem rodar
bootstrap novo; o vértice de produção reproduz a trajetória pontual do benchmark
com erro máximo de **1,07e-14** em 100 pontos, o que valida o pipeline do
overlay inteiro contra o artefato de produção.

---

## 5. Esquema de agregação

**ξ_mp sob GK, lido em NW(1)** (o MA(1) que o próprio esquema induz):

| du | 21 | 42 | 63 | 84 | 105 | **126** | 147 | 252 | 504 |
|---|---|---|---|---|---|---|---|---|---|
| full | 2,45 | 1,94 | 0,29 | 0,31 | 0,06 | **0,30** | 0,07 | 0,46 | 0,52 |
| pré-COVID | 8,29 | 12,83 | 6,77 | 4,04 | 3,79 | **3,44** | 3,30 | 0,01 | 0,28 |

O colapso é total: **0,30 contra 10,43** no vértice de produção, e em nenhum
vértice a agregação GK cruza sequer 3,84 na amostra completa.

A implementação foi verificada contra um caso calculável à mão — surpresa de
10 bps no dia 15 de um mês de 31 dias devolve 5,4839 em `t` e 4,5161 em `t+1`,
exatamente `10·17/31` e `10·14/31`, somando 10. O colapso é resultado, não bug.

Duas consequências a registrar junto do número: sob GK os meses sem reunião
**deixam de ser zero** (a propriedade que JK e BS ambos assumem se perde), e o
MA(1) induzido invalida `NWlags = 0` para essas células.

Isto converte o "desvio documentado" do `CLAUDE.md` — a agregação é de JK, não
de GK — em uma **escolha justificada com número**: a soma dentro do mês não é
apenas a convenção de JK e de BS, é o esquema correto dado que o indicador de
política deste painel é de fim de mês.

---

## 6. O que isto muda no paper

- **§3.4** ganha justificativa própria para as duas escolhas, no lugar de
  convenção herdada: o vértice está dentro do conjunto indistinguível do melhor
  e não move as IRFs (overlay A4); a soma é o esquema correto para um indicador
  de fim de mês, com o contrafactual GK medido.
- **§3.5/§3.6** ganham a defesa do ξ_mp: o conjunto AR é limitado sob qualquer
  amostra a menos de um mês, e NW(0) é conservador. Mas a afirmação
  "bandas convencionais valem" **continua marginal** — 24 de 147 meses a
  derrubam abaixo de 10, o que **reforça** o item de bandas Anderson-Rubin, que
  segue aberto e agora tem uma razão empírica, não só de limiar.
- **Apêndice B** recebe a grade de 260 células e o overlay.

## 7. O que não foi feito, e por quê

- **F efetivo de Montiel Olea-Pflueger** — morto em `pendencias.md:240-247`,
  citação a MOSW l. 335 conferida ("*when there are multiple instruments*").
- **Winsorizar `z`** — encolheria exatamente os dias grandes, que são a variação
  identificadora; o LOO é a resposta certa no lugar dele.
- **Bandas AR** — item próprio, ainda aberto, e este trabalho aumenta a
  prioridade dele.
