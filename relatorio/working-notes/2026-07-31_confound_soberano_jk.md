# O filtro JK seleciona risco soberano? — teste diário

> **CURRENT.** Escrita em 2026-07-31 sob a produção corrente: `z_jk_bs_purif` ×
> `yield_6m`, r=7, q=6, p=6, painel de 106 séries (vintage 07-24), ξ_mp 10,43
> full / 12,22 pré-COVID. Corpo gerado e números em
> `output/instrument/jk_sovereign_confound.{csv,md}`, `jk_sovereign_days.csv` e
> `jk_sovereign_irf_overlay.pdf`, produzidos por
> `script/jk_sovereign_confound.R`. **Esta nota é escrita à mão e nenhum script a
> toca.**

## A acusação

Item mais grave do council review de 2026-07-31
(`relatorio/council_2026-07-31.md`). Os três críticos convergiram por ângulos
independentes; o argumento lógico decisivo é do macro-theorist:

- O filtro Jarociński-Karadi descarta o confound **benigno** — efeito-informação
  do BC, em que juros sobem e ações sobem junto.
- Mas uma surpresa fiscal/soberana doméstica tem juros ↑, ações ↓, câmbio ↑ —
  **exatamente o padrão que o filtro retém como "política"**.
- Os placebos do paper não descartam isso: um choque fiscal doméstico também não
  deveria mover o S&P 500.

A constelação medida no §4 — repasse de 1,85× na ponta longa, depreciação de
3,64%, CDS +29,1 pb, EMBI +20,0 pb, núcleo positivo — é compatível com as duas
leituras. O projeto nunca havia tentado separá-las.

## O que foi feito

`script/jk_sovereign_confound.R`. Quatro testes, três deles antes de qualquer
DFM. **Nada de produção foi modificado**: as variantes de três vias são
construídas em memória, e `build_variants.R` / `instrument.R` estão intocados.

Três auto-testes passam exatos e garantem que a máquina é a de produção: o
painel diário reconstruído bate `copom_event_diagnostics.csv` (máx |dif| =
1,4e-14, máscaras idênticas); ξ_mp da referência reproduz 10,43 / 12,22; e a IRF
de referência reproduz o smoke test do `CLAUDE.md` em h=0 (`yield_6m` 0,005,
`yield_2y` 0,009164, `yield_5y` 0,009274, `asset_ibov` −1,673, `cambio_usd`
0,1498).

**Lacuna declarada:** não existe CDS 5a **diário** neste repositório nem fonte
programática gratuita com histórico 2013-2025 — o Ipeadata encerrou o EMBI+ em
07/2024 e nunca teve CDS, WorldGovernmentBonds não tem CSV/API, MacroMicro
publica semanal, cbonds é pago. A única fonte diária é a página histórica da
Investing.com, a mesma de onde saiu o arquivo **mensal** do repo, e exige export
por navegador (tentado, extensão não conectada). O **EMBI+ Brasil diário** é a
proxy principal: 94 dos 95 pares Qua→Qui (o buraco é 2024-06-19, feriado
americano). O script detecta `data/investing/cds5y_daily.csv` automaticamente se
o arquivo aparecer.

## Pré-requisito que quase virou armadilha: o alinhamento do EMBI

O arquivo é um painel JP Morgan republicado pelo BC dominicano, então
alinhamento no fechamento do mesmo dia **não é garantido a priori** — e toda a
leitura do teste A depende disso. Diagnóstico: correlacionar a variação diária
do EMBI com o movimento de mercado em `t`, `t−1` e `t+1`.

| série | t | t−1 | t+1 |
|---|---|---|---|
| BRL/USD | +0,225 | +0,082 | +0,210 |
| S&P 500 | **−0,498** | −0,045 | +0,060 |
| VIX | **+0,413** | −0,007 | −0,109 |
| Ibovespa | **−0,508** | −0,088 | +0,016 |

Contemporâneo domina por uma ordem de grandeza. **O arquivo é do mesmo dia.**
Consequência: a janela Qua→Qui é a medida correta, e a janela Qui→Sex **não é**
uma correção de alinhamento — é uma janela do **dia seguinte**, ou seja a
resposta *defasada* do risco à surpresa, não notícia de risco dentro da janela
do evento. Sem esse diagnóstico eu teria lido o resultado de Qui→Sex (adiante)
como contaminação.

## A — a regressão diária

Regra de leitura fixada **antes** de os números existirem (mesma disciplina do
sweep de vértice, que fixou seu limiar de 2,00 *ex ante*): contaminação exige
que o dia retido carregue **mais** notícia de risco por unidade de surpresa que
um dia comum — isto é, interação positiva e significativa, não o nível do
coeficiente.

**Nível, ΔEMBI (bp) sobre a surpresa:**

| conjunto | n | coef | t | p_boot | R² |
|---|---|---|---|---|---|
| **jk_bs (produção)** | 61 | **0,099** | 1,74 | 0,097 | 0,039 |
| Copom (todos) | 94 | 0,066 | 1,32 | 0,200 | 0,017 |
| Copom rejeitados pela máscara | 33 | 0,019 | 0,18 | 0,908 | 0,001 |
| **não-Copom (controle)** | 498 | **0,326** | 3,97 | 0,005 | 0,130 |

**Nível, Δlog BRL:** controle 0,051 (t = 4,64, p = 0,005); retidos 0,004
(t = 0,40, p = 0,72).

**Interação `x:1(jk_bs)` sobre todas as quintas — a estatística que decide:**

| proxy | coef | t | p_boot |
|---|---|---|---|
| EMBI (Qua→Qui) | **−0,182** | −1,94 | 0,108 |
| BRL (Qua→Qui) | **−0,036** | −2,17 | **0,066** |
| slope DI 504−63bd | −0,228 | −0,75 | 0,520 |
| DI ~10a | −0,616 | −1,88 | 0,113 |
| EMBI (Qui→Sex, dia seguinte) | +0,248 | +2,61 | 0,025 |

**Veredito: a acusação específica não se sustenta, e o dado aponta na direção
oposta.** Num dia comum, uma variação de DI vem carregada de notícia de risco —
o coeficiente do controle é 0,326 com R² de 0,13. Nos 62 dias retidos ele cai
para 0,099 com R² de 0,04, e no câmbio some (0,004, t = 0,40). As interações são
**negativas** nas quatro proxies da janela do evento, e no câmbio é significativa
a 10% com sinal de apreciação relativa — a assinatura de UIP, não de risco. A
camada BS + máscara JK **empobrece** o conteúdo de risco em vez de enriquecê-lo,
que é o oposto do mecanismo de seleção alegado.

Duas ressalvas honestas: (i) o coeficiente nos 62 dias é positivo e marginal
(p = 0,097), então **não** é "zero conteúdo de risco" — é "menos que num dia
comum"; (ii) a interação do EMBI a 0,108 não cruza 10%, então o que se afirma é
ausência de enriquecimento, não sua refutação formal.

O resultado de Qui→Sex (+0,248, p = 0,025) é, dado o alinhamento estabelecido, a
**resposta defasada** do prêmio de risco à surpresa de política — e é
exatamente o que a IRF mensal do §4 já reporta (EMBI +0,20, sig90). É resultado,
não contaminação.

## B — classificação de três vias

Terceira via pelo câmbio, com a mesma forma do JK: aperto **aprecia** o BRL
(UIP) → sinais de `e_di_bs` e `e_brl_bs` diferem = política; surpresa fiscal
**deprecia** → sinais iguais = soberano. As pernas de FX e EMBI são purificadas
na **mesma** RHS pré-evento do Bauer-Swanson, para a máscara continuar
predeterminada.

Os 62 dias se partem quase ao meio: **31 política / 30 soberano / 1 não
classificado** (regra FX); 24/37/1 pela regra do EMBI. ξ_mp cai a 3,52 e 3,50 nas
duas metades, contra 10,43 do total — queda esperada e essencialmente mecânica,
já que os meses não-nulos caem de 62 para 31 e 30.

| h=0 | produção | política (31) | soberano (30) | orto. risco |
|---|---|---|---|---|
| `cambio_usd` | 0,150 ✓ | **0,129** | 0,165 ✓ | 0,145 ✓ |
| `embi_perc` | 0,200 ✓ | 0,103 | 0,270 ✓ | 0,162 ✓ |
| `cds_5y` | 29,1 ✓ | 18,9 | 36,5 ✓ | 25,6 ✓ |
| `yield_2y` | 0,00916 ✓ | 0,00852 ✓ | 0,00963 ✓ | 0,00891 ✓ |
| `price_ipp` | 0,586 ✓ | 0,382 | 0,735 ✓ | 0,544 ✓ |

(✓ = banda de 90% exclui zero.)

**Nenhum sinal inverte.** A metade soberana tem respostas sistematicamente
maiores de risco e câmbio, a metade política menores — o que é a leitura
esperada e mostra que a classificação separa algo real. Mas a metade política
perde a significância a 90% em EMBI e CDS com n pela metade e ξ_mp de 3,5, então
a perda de banda é indistinguível de perda de potência.

**O achado mais forte está no câmbio.** Os 31 dias "política" foram selecionados
por terem, **no dia do evento, apreciação do BRL** consistente com UIP. Ainda
assim a IRF mensal desses mesmos dias dá **depreciação** (+0,129, mesmo sinal e
86% da magnitude da produção). A depreciação mensal do §4 **não é herdada da
janela do evento** — ela é produzida pela propagação mensal, não pela seleção de
quais dias entram. É a evidência mais direta contra a leitura de artefato de
seleção, e vale porque o desenho do teste a tornava falsificável: se a
depreciação viesse dos dias, esta célula teria invertido.

## C — instrumento ortogonalizado ao risco diário

`e_di_bs` residualizado em ΔEMBI e Δlog BRL contemporâneos (R² = 0,127),
máscara BS-JK reaplicada. **ξ_mp = 10,72 full**, acima dos 10,43 da produção;
pré-COVID cai de 12,22 para 8,18. Todas as manchetes seguem sig90, com
atenuação de 15-20% no bloco de risco (EMBI 0,200 → 0,162; CDS 29,1 → 25,6) e
praticamente nenhuma no câmbio (0,150 → 0,145).

Isto é um **limite inferior**: política legitimamente move spread soberano, então
ortogonalizar contra o risco *contemporâneo* super-remove. Sobreviver é descarte
forte; não sobreviver seria ambíguo. Sobreviveu.

## D — auditoria narrativa, e a ressalva que sobra

A concentração é alta: os 5 dias de maior alavancagem valem **28,6%** de Σ|z|.

| # | reunião | `e_di_bs` | ΔEMBI | Δlog BRL | classe | peso |
|---|---|---|---|---|---|---|
| 1 | 2021-10-27 | +37,0 | +1 | +1,97 | soberano | **6,6%** |
| 2 | 2013-04-17 | −35,5 | +4 | −0,77 | soberano | 6,3% |
| 3 | 2021-03-17 | +34,9 | −5 | −0,72 | política | 6,2% |
| 4 | 2017-01-11 | −28,0 | −6 | +0,06 | soberano | 5,0% |
| 5 | 2024-12-11 | +25,2 | −3 | −1,54 | política | 4,5% |

**O dia de maior alavancagem do instrumento inteiro é 2021-10-27** — a semana da
PEC dos Precatórios, com o BRL depreciando 1,97% no dia *apesar* de uma alta de
150 pb, e classificado "soberano" pela regra de FX. Ou seja: o teste agregado
não detecta enriquecimento sistemático de risco, mas **o dia individualmente
mais influente é exatamente o tipo de dia que o parecerista temia**. Os outros
quatro do topo são reuniões cuja leitura de política é direta (2021-03-17: alta
de 75 pb acima do esperado, BRL aprecia; 2024-12-11: alta de 100 pb com
*guidance*, BRL aprecia 1,54%).

Anotei só o que consigo afirmar com confiança; `jk_sovereign_days.csv` traz os 95
dias com a coluna `nota_evento` vazia para o autor completar.

## Veredito

**A acusação específica do council não se sustenta.** O filtro empobrece o
conteúdo diário de risco em vez de enriquecê-lo; a classificação de três vias
não inverte nenhum sinal; o instrumento ortogonalizado ao risco preserva ξ_mp e
todas as manchetes; e a depreciação mensal sobrevive nos dias selecionados por
apreciação diária. **Não há motivo para reenquadrar o paper**, e nada muda na
produção.

O que **não** foi mostrado, e não deve ser afirmado: que o instrumento é livre de
risco soberano. Ele não é — o coeficiente nos 62 dias é positivo e marginal, a
metade "soberana" tem respostas de risco sistematicamente maiores, e o dia de
maior peso é fiscal. A afirmação defensável é mais estreita e é a que responde ao
parecer: **o filtro JK não seleciona risco soberano para dentro; ele seleciona
menos risco do que um dia comum.**

## Para o paper

Cabe uma subseção curta no §5 Robustez, com a tabela de interação (5 linhas), a
comparação h=0 das quatro variantes, e as duas ressalvas declaradas. O overlay
`jk_sovereign_irf_overlay.pdf` já serve de figura. O parágrafo tem de dizer as
três coisas na ordem: o controle não-Copom, a interação negativa, e a
concentração em 2021-10-27.

## Aberto

- **CDS 5a diário** — se o export da Investing.com for feito, o script incorpora
  sozinho e o teste ganha a proxy que o parecerista nomeou.
- **Regra do EMBI vs regra do FX** discordam bastante (concordância na tabela 2×2
  do corpo gerado); a do EMBI concentra a força na metade soberana (ξ_mp 7,77
  contra 0,89 da metade política), o que merece um olhar antes de qualquer
  promoção a produção.
- **Nada disso vai à produção nesta rodada.** Promover a classificação de três
  vias é decisão separada, e os números acima não a recomendam: ela custa metade
  da amostra e não muda sinal nenhum.
