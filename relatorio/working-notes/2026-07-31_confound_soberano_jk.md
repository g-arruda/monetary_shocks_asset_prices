# O filtro JK seleciona risco soberano? — teste diário

> ⚠ **Os testes B e D foram removidos em 2026-08-10** de
> `script/jk_sovereign_confound.R`, e as seções correspondentes desta nota saíram
> junto. Nada do que eles produziram é reproduzível ou citável; quem precisar do
> registro recorre ao histórico do git. Os testes A e C seguem CURRENT e
> reproduzem com `max |dif| = 0`, `p_boot` inclusive, e o C ganhou na mesma data
> um terceiro degrau, a máscara re-derivada nos resíduos ortogonalizados das duas
> pernas. Razão do corte em
> [`historico_decisoes.md` §2.4](../../_instrucoes/historico_decisoes.md).
>
> **CURRENT quanto ao desenho e ao veredito; a lacuna de dado declarada abaixo
> foi fechada.** Escrita em 2026-07-31 sob a produção corrente: `z_jk_bs_purif` ×
> `yield_6m`, r=7, q=6, p=6, painel de 106 séries (vintage 07-24), ξ_mp 10,43
> full / 12,22 pré-COVID. Corpo gerado e números em
> `output/instrument/jk_sovereign_confound.{csv,md}` e
> `jk_sovereign_irf_overlay.pdf`, produzidos por
> `script/jk_sovereign_confound.R`. **Esta nota é escrita à mão e nenhum script a
> toca.**
>
> **Duas coisas mudaram em 2026-08-09** — ver
> [`2026-08-09_confound_soberano_cds`](2026-08-09_confound_soberano_cds.md).
> (i) O CDS 5a diário **existe** (`data/CDS 5y.xlsx`, Bloomberg), então a
> "lacuna declarada" da seção homônima abaixo está morta e o teste roda nas duas
> proxies; o veredito não mudou. (ii) O wild bootstrap passou a ser semeado por
> célula, então os **`p_boot`** citados aqui diferem dos correntes por ruído de
> Monte Carlo (~0,007 de erro-padrão). Coeficientes, `t`, R² e todas as IRFs
> desta nota seguem **exatos** — inclusive `z_jk_bs_norisk`, congelado de
> propósito para servir de auto-teste.

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

`script/jk_sovereign_confound.R`. **Nada de produção foi modificado**: as
variantes deste teste são construídas em memória, e `build_variants.R` /
`instrument.R` estão intocados.

Três auto-testes passam exatos e garantem que a máquina é a de produção: o
painel diário reconstruído bate `copom_event_diagnostics.csv` (máx |dif| =
1,4e-14, máscaras idênticas); ξ_mp da referência reproduz 10,43 / 12,22; e a IRF
de referência reproduz o smoke test do `CLAUDE.md` em h=0 (`yield_6m` 0,005,
`yield_2y` 0,009164, `yield_5y` 0,009274, `asset_ibov` −1,673, `cambio_usd`
0,1498).

**Lacuna declarada — ⚠ FECHADA EM 2026-08-09**, ver
[`2026-08-09_confound_soberano_cds`](2026-08-09_confound_soberano_cds.md). O
parágrafo abaixo fica só por procedência: `data/CDS 5y.xlsx` existe, o script o
lê como entrada **obrigatória** (não há mais detecção automática de
`data/investing/cds5y_daily.csv`, que nunca chegou a existir), e o veredito é o
mesmo nas duas proxies.

> **[texto original]** não existe CDS 5a **diário** neste repositório nem fonte
> programática gratuita com histórico 2013-2025 — o Ipeadata encerrou o EMBI+ em
> 07/2024 e nunca teve CDS, WorldGovernmentBonds não tem CSV/API, MacroMicro
> publica semanal, cbonds é pago. A única fonte diária é a página histórica da
> Investing.com, a mesma de onde saiu o arquivo **mensal** do repo, e exige export
> por navegador (tentado, extensão não conectada). O **EMBI+ Brasil diário** é a
> proxy principal: 94 dos 95 pares Qua→Qui (o buraco é 2024-06-19, feriado
> americano). O script detecta `data/investing/cds5y_daily.csv` automaticamente se
> o arquivo aparecer.

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

> ⚠ **A ressalva (i) endureceu em 2026-08-09.** No CDS 5a, que mede sem o
> arredondamento do EMBI, o coeficiente dos 62 dias é **0,140 com p_boot 0,003**
> — não marginal, **significativo**. A razão contra o controle é a mesma (~3×,
> 0,140 contra 0,436), mas "menos risco que um dia comum, **não** zero risco"
> passa de cautela a fato medido. Ver
> [`2026-08-09_confound_soberano_cds`](2026-08-09_confound_soberano_cds.md).

O resultado de Qui→Sex (+0,248, p = 0,025) é, dado o alinhamento estabelecido, a
**resposta defasada** do prêmio de risco à surpresa de política — e é
exatamente o que a IRF mensal do §4 já reporta (EMBI +0,20, sig90). É resultado,
não contaminação.

*(Seção removida em 2026-08-10 junto com o teste que a produzia. Os números
não são mais reproduzíveis e não devem ser citados; o registro fica no
histórico do git e a razão do corte em `_instrucoes/historico_decisoes.md`
§2.4.)*

## C — instrumento ortogonalizado ao risco diário

`e_di_bs` residualizado em ΔEMBI e Δlog BRL contemporâneos (R² = 0,127),
máscara BS-JK reaplicada. **ξ_mp = 10,72 full**, acima dos 10,43 da produção;
pré-COVID cai de 12,22 para 8,18. Todas as manchetes seguem sig90, com
atenuação de 15-20% no bloco de risco (EMBI 0,200 → 0,162; CDS 29,1 → 25,6) e
praticamente nenhuma no câmbio (0,150 → 0,145).

Isto é um **limite inferior**: política legitimamente move spread soberano, então
ortogonalizar contra o risco *contemporâneo* super-remove. Sobreviver é descarte
forte; não sobreviver seria ambíguo. Sobreviveu.

*(Seção removida em 2026-08-10 junto com o teste que a produzia. Os números
não são mais reproduzíveis e não devem ser citados; o registro fica no
histórico do git e a razão do corte em `_instrucoes/historico_decisoes.md`
§2.4.)*

## Veredito

**A acusação específica do council não se sustenta.** O filtro empobrece o
conteúdo diário de risco em vez de enriquecê-lo, e o instrumento ortogonalizado
ao risco preserva ξ_mp e todas as manchetes. **Não há motivo para reenquadrar o
paper**, e nada muda na produção.

O que **não** foi mostrado, e não deve ser afirmado: que o instrumento é livre de
risco soberano. Ele não é, porque o coeficiente nos 62 dias é positivo e
marginal. A afirmação defensável é mais estreita e é a que responde ao parecer:
**o filtro JK não seleciona risco soberano para dentro; ele seleciona menos risco
do que um dia comum.**

## Para o paper

Cabe uma subseção curta no §5 Robustez, com a tabela de interação (5 linhas), a
comparação h=0 das variantes e as ressalvas declaradas. O overlay
`jk_sovereign_irf_overlay.pdf` já serve de figura. O parágrafo tem de dizer as
duas coisas na ordem: o controle não-Copom e a interação negativa.

*(2026-08-09: escrita como §5.2 de `texto_anpec/paper_anpec.tex`, `sec:confound`,
seguindo essa ordem e sem figura, em prosa com os números como o resto do paper.
Os números publicados são os da rodada de duas proxies — ver
[`2026-08-09_confound_soberano_cds`](2026-08-09_confound_soberano_cds.md).
Reescrita em 2026-08-10 sobre os testes A e C.)*

## Aberto

- **CDS 5a diário** — se o export da Investing.com for feito, o script incorpora
  sozinho e o teste ganha a proxy que o parecerista nomeou.
- **Nada disso vai à produção nesta rodada.** As variantes deste teste são
  construídas em memória e promover qualquer uma é decisão separada.
