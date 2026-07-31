# Os fatores são I(1)? São cointegrados? E o vale de médio prazo é economia?

> **CURRENT.** Escrita em 2026-07-31 sob a produção corrente: `z_jk_bs_purif` ×
> `yield_6m`, r=7, q=6, p=6, painel de 106 séries (vintage 07-24), 153 meses
> (2013-01 a 2025-09). Corpo gerado e números em
> `output/factors/factor_stationarity.md` + seis CSVs, produzidos por
> `script/factor_stationarity.R`. **Esta nota é escrita à mão e nenhum script a
> toca.**

## A acusação

Item do council review de 2026-07-31 (`relatorio/council_2026-07-31.md:74`),
levantado por dois críticos por ângulos independentes:

- **harsh-referee:** a reversão de médio prazo — curva, Selic, CDS, EMBI e os
  sete recortes de crédito, todos revertendo em h≈20-35 — é exatamente o que um
  **par de autovalores complexos dominante** produziria mecanicamente na
  companion do VAR(6), sem nenhum conteúdo econômico. A padronização BLL resolve
  a escala do PCA, não a estacionariedade do VAR dos fatores.
- **metodologista:** não há diagnóstico de raiz unitária nem de cointegração em
  lugar nenhum do paper. Pediu ADF/KPSS/PP.

## O que já existia, e o que faltava

**Metade da resposta já estava no repo e ninguém tinha juntado com a outra.** A
Tarefa 5 da rodada de auditoria de 07-28
(`diagnostics/05_persistencia_fatores.R` → `t5_1_autovalores.csv`,
`diagnostico_dfm.md:439-459`) já reportava os cinco maiores módulos da companion
42×42 e já concluía, em prosa, *"a corcova é mecânica"*. O que faltava:

1. raiz unitária **nos fatores** — o `t5_4` testa as 106 séries do painel, que é
   outro objeto;
2. **Phillips-Perron** — o repo só tinha ADF e KPSS;
3. **cointegração** — `ca.jo`/`vars` não apareciam em lugar nenhum;
4. o espectro **completo**, com argumento e período implícito, persistido em CSV.
   Os 117,9 meses do par dominante estavam escritos no markdown e calculados em
   lugar nenhum.

Quatro auto-testes garantem que a máquina é a de produção: os cinco maiores
módulos batem `t5_1_autovalores.csv` a 1,1e-16 (OLS e Kilian); o módulo máximo
bate `dfm$diagnostics$max_eigenvalue` e o `dfm_max_eig` do
`irf_coherence_cell.rds` (0,976794); o ADF recalculado concorda com o `t5_4` em
20 de 20 séries sorteadas; e — o mais forte — a IRF reconstruída por soma de
autovalores reproduz a IRF de produção com **máx |dif| = 5,2e-13**.

## 1. Os fatores são I(1), e nenhum é I(2)

ADF, PP e KPSS a 5%, especificação com deriva, em nível e em primeira diferença:

| | nível | primeira diferença |
|---|---|---|
| I(1), ADF e KPSS concordam | **4 de 7** (F2, F4, F5, F6) | 0 |
| I(0), ADF e KPSS concordam | 2 (F1, F7) | 4 |
| ambíguo | 1 (F3) | 3 (F4, F5, F6) |

**Os três "ambíguos" em diferença não são preocupação.** Em primeira diferença
ADF **e** PP rejeitam a raiz unitária nos **sete** fatores; o rótulo ambíguo vem
só do KPSS rejeitar estacionariedade ao mesmo tempo, que é o comportamento
conhecido do KPSS com `lags = "short"` em amostra de 150. **Nenhum fator é
I(2)**, que seria o problema de verdade.

**PP concorda com ADF em 14 de 14 combinações fator × transformação.** No painel
de 106 séries o PP rejeita a raiz unitária em 38; ele concorda com o veredito
ADF+KPSS nas 20 séries I(0) e nas 56 I(1), e só reparte as 30 ambíguas (18/12).
Os três testes concordam em I(1) em **56 séries**.

Painel misto — 4 fatores I(1), 2 I(0), 1 ambíguo — **é o desenho, não um
defeito**: Alessi-Kerssenfischer §2.1 admite *"the factors are I(1) and the
idiosyncratic components are either I(0) or I(1)"*.

## 2. Cointegração: sim, e o posto é sensível à defasagem

Johansen, `ecdet = "const"`, `spec = "transitory"`, n = 7:

| K | traço | máx-autovalor | traço c/ Reinsel-Ahn |
|---|---|---|---|
| 2 | 4 | 4 | 4 |
| 4 | 1 | 1 | 0 |
| **6 (produção)** | **2** | 1 | 0 |

Na defasagem de produção o posto é **2** — 2 relações de cointegração, **5
tendências comuns**. Duas ressalvas obrigatórias:

- **O posto é lag-sensível**, como se esperava: 4 em K=2, 1-2 em K=4 e K=6. Não
  se pode reportar "o posto é 2" sem a coluna do K.
- **A estatística assintótica super-rejeita nesta amostra.** Com n=7, K=6 e T=147
  efetivos são ~300 parâmetros. Aplicando o fator de Reinsel-Ahn
  `(T − nK)/T = 0,714`, **nenhuma** hipótese nula é rejeitada e o posto vai a 0.
  É a mesma distorção que a Tarefa 7 já documentou nesta amostra por outro
  caminho (o χ²(9) assintótico super-rejeita 2,3× a 5,3×,
  `diagnostico_dfm.md` §7.4).

**Nenhum dos dois extremos ameaça o desenho.** Com 0 < posto < 7 vale
Sims-Stock-Watson (1990): o VAR irrestrito em nível estima consistentemente os
parâmetros de um VAR cointegrado. Com posto 0 (Reinsel-Ahn), são 7 raízes
unitárias independentes e o VAR em nível segue consistente, só com inferência de
longo prazo não-padrão. É literalmente a defesa que Alessi-Kerssenfischer
escrevem na §2.2 — *"as Sims, Stock, and Watson (1990) show, the parameters of a
cointegrated VAR are consistently estimated using an unrestricted VAR in levels"*
— acrescida de BLL (2016b), que mostram o VAR em nível **superando** o VECM em
IRF de **curto prazo**, por convergência mais rápida do estimador. As duas chaves
(`barigozzi2016non`, `alessi`) já estão no `references.bib`: **nenhuma referência
nova**.

**Mas a defesa de BLL é sobre o curto prazo, e é aí que ela custa.** O médio
prazo, h≈20-48, é exatamente onde o argumento não alcança — e é o que a seção 3
desta nota mede.

## 3. O espectro, e o par que o referee suspeitou

Companion 42×42 (r·p), OLS, produção:

| ordem | \|λ\| | complexo | período | quarto de ciclo | meia-volta | meia-vida |
|---|---|---|---|---|---|---|
| 1-2 | **0,976794** | **sim** | **117,9 m** | **29,47** | 58,95 | 29,52 |
| 3-4 | 0,960987 | sim | 56,36 | 14,09 | 28,18 | 17,42 |
| 5-6 | 0,910031 | sim | 37,66 | 9,42 | 18,83 | 7,35 |
| 7-8 | 0,875 | sim | 10,89 | 2,72 | 5,44 | 5,19 |

Duas raízes acima de 0,97, seis acima de 0,90, **nenhuma explosiva**. 40 das 42
são complexas.

**A quase-raiz-unitária não é da escolha de `p`.** Em p=1 o módulo máximo é
**0,982** (Kilian: 0,99979), *maior* que em p=6; em p=4 é 0,966. O que muda com
`p` é a natureza da raiz dominante: em p=1 ela é **real**, em p=4 e p=6 é um par
complexo. E o período do par se move: 94,4 meses em p=4, 117,9 em p=6.

## 4. O vale de médio prazo — três testes, e a ordem em que foram feitos importa

**Só o teste 1 foi pré-registrado.** Os testes 2 e 3 foram escritos *depois* de
ver o resultado do primeiro, para transformar coincidência em teste. Declarado
aqui e no cabeçalho do script.

### Teste 1 (pré-registrado): coincidência de períodos — 10 de 14

Regra R1, fixada antes dos números: se o horizonte de reversão observado cair
dentro de ±25% do marco mecânico, a reversão não é evidência independente.

- **Inversão de sinal:** 0 de 14 perto da meia-volta (58,9 meses). As inversões
  acontecem em h≈2-12, muito antes. A *primeira troca de sinal* **não** é o
  marco mecânico.
- **Extremo de médio prazo (h ≥ 13):** **10 de 14** dentro de ±25% do quarto de
  ciclo (29,5 meses). O vale que o §4 conta — curva h=31-32, Selic h=34, crédito
  h=25-32 — cai em cima do marco.

Ficam de fora `yield_10y` (h=22), `cds_5y` (h=20), `embi_perc` (h=22) e
`cambio_usd` (h=17) — e vale notar que a meia-volta do **segundo** par é 28,2 e
a do terceiro 18,8, de modo que praticamente todo extremo de médio prazo do
painel cai sobre algum marco dos três primeiros pares. Isso é sugestivo, e nada
além disso.

### Teste 2 (posterior): reestimar em p ∈ {1, 4, 6} — o vale **não** segue o par

| p | dominante complexa? | quarto de ciclo | mediana de h do vale |
|---|---|---|---|
| 1 | **não** (real) | — | **30,5** |
| 4 | sim | 23,60 | 29,5 |
| 6 | sim | 29,47 | 26,0 |

O quarto de ciclo vai de indefinido → 23,6 → 29,5; a mediana do vale vai
30,5 → 29,5 → 26,0. **Movem em direções opostas**, e o vale existe até em p=1,
onde a raiz dominante é real e não pode oscilar. Lido sozinho, este teste
**absolveria** a especificação: o vale não é artefato de ter escolhido p=6.

### Teste 3 (posterior, e é o decisivo): apagar o par dominante de `B`

Este não reestima nada. Escrevendo `A = V Λ V⁻¹`, tem-se
`Aʰ = Σₖ λₖʰ vₖ wₖ'`, e como a IRF é `Λ·Bₕ·K·M·H` com `Bₕ = (Aʰ)[1:r,1:r]`, ela é
**linear em Bₕ**. Dá para deletar o par dominante de `Bₕ` exatamente e empurrar o
contrafactual pelo mesmo `ident_ext_instr` e pela mesma transformação de `tcode`
que a produção usa. (A reconstrução completa bate a produção a 5,2e-13 — é o
auto-teste que licencia o exercício.)

**Sem o par dominante, o vale de médio prazo não some: ele inverte de sinal em
12 das 14 séries**, e o horizonte do extremo colapsa de h≈22-34 para h=13, o
próprio limite inferior da janela — ou seja, não sobra extremo interior nenhum.

| série | vale completo | sem o par 1 | razão |
|---|---|---|---|
| `yield_3m` | −0,00788 em h=32 | **+0,01241** em h=13 | −1,57 |
| `yield_6m` | −0,00779 em h=31 | **+0,01181** em h=13 | −1,52 |
| `juros_selic` | −0,778 em h=34 | **+1,235** em h=13 | −1,59 |
| `credito_construcao` | −2,443 em h=29 | **+2,845** em h=13 | −1,16 |
| `credit_outstanding` | −1,227 em h=29 | **+1,442** em h=13 | −1,18 |
| `embi_perc` | −0,172 em h=22 | **+0,153** em h=13 | −0,89 |

Sobrevivem duas: `cds_5y` (razão 1,04) e `cambio_usd` (3,21, com o vale
*aumentando*). **O controle fecha o argumento:** apagar o **segundo** par em vez
do primeiro deixa a magnitude praticamente intacta — razão mediana **0,977**
contra **1,170** (e sinal invertido) do primeiro. Não é "qualquer par"; é aquele.

## Veredito

**O referee está certo no que importa, e a régua pré-registrada é para ser
honrada.** No modelo de produção, a reversão de médio prazo em curva, Selic e
crédito **é** a oscilação amortecida do par complexo dominante: retire o par e o
vale inverte. Pela regra R1, ela **não é evidência independente** de nada, e o
§4 tem de dizer isso onde conta o vale setorial e a reversão da curva.

**Mas a acusação não se sustenta na versão forte.** O par não é artefato de ter
escolhido p=6 — a quase-raiz-unitária é *maior* em p=1, e o vale aparece em p=1,
p=4 e p=6, na mesma janela h≈25-34. A afirmação defensável é mais estreita e
mais desconfortável:

> A reversão de médio prazo e a persistência quase-unitária do VAR de fatores
> são **o mesmo objeto**, não dois fatos que se confirmam. O paper pode reportar
> a reversão como o que o modelo estimado implica; não pode citá-la como
> evidência separada da dinâmica que a produz.

**Consequência prática para o `tex`:** o tier de 68% do §4 — vale setorial em
h=11-12, contração do crédito em h=24-32, reversão da curva e da Selic em
h=25-44 — continua sendo o que o modelo diz, mas ganha uma ressalva de uma
frase, e ela pertence ao corpo, não a nota de rodapé. E o item de Limitações que
hoje cita a razão |ponto|/meia-banda ganha um companheiro: o médio prazo não é só
impreciso, é **dinamicamente redundante** em relação ao curto prazo.

## O que NÃO foi mostrado

- Que os fatores sejam I(1) com certeza: F3 é ambíguo e F1/F7 dão I(0). O painel
  é misto, o que é admitido por construção mas impede a frase "os sete fatores
  são I(1)".
- Que o posto de cointegração seja 2. Ele é 2 na especificação de produção, 4 em
  K=2 e 0 sob correção de pequena amostra. A frase defensável é *"há
  cointegração, o posto não é identificado com precisão, e o VAR em nível é
  consistente sob qualquer um dos valores encontrados"*.
- Que a reversão seja economicamente vazia. Ela é dinamicamente inseparável da
  persistência do VAR — o que é diferente de ser ruído. Um VECM não resolveria
  isso: BLL (2016b) mostram que ele é *pior* no curto prazo, e o problema aqui
  não é viés, é redundância de informação.

## Aberto daqui

- **Redigir a ressalva no §4** e o parágrafo em Limitações. Bloqueado pelo item
  "§5 Robustez está inteira comentada".
- **Bandas de banda simultânea** (Montiel Olea-Plagborg-Møller 2021), pedida pelo
  metodologista no mesmo review: com a reversão dominada por um único modo, as
  bandas pontuais horizonte a horizonte são especialmente enganosas ao longo do
  caminho. Item novo, não estava registrado.
- **Não** estimar VECM. Decisão do autor em 2026-07-31, e a evidência aqui
  reforça: o posto não é identificado com precisão suficiente para escolher a
  restrição, e BLL mostram que a restrição piora o curto prazo.
