# Coincidência FOMC: o filtro JK seleciona spillover do Fed?

> ⚠ **O teste 4 (a divisão em metades com e sem FOMC) foi removido em
> 2026-08-10**, e com ele saiu a terceira perna da regra de veredito, que era a
> única que o consumia. A perna **havia passado** e a cláusula de poder não foi
> acionada, de modo que retirá-la torna a regra estritamente mais permissiva e o
> veredito segue **CONFOUND FOMC NÃO DETECTADO**, verificado rodando o script
> antes e depois com `max |dif| = 0` em toda linha sobrevivente. A seção
> correspondente desta nota saiu junto, nada do que o teste produziu é
> reproduzível ou citável, e quem precisar do registro recorre ao histórico do
> git. Os testes 0 a 3 seguem CURRENT. Razão do corte em
> [`historico_decisoes.md` §2.4](../../_instrucoes/historico_decisoes.md) e no
> cabeçalho de `script/fomc_coincidence.R`.
>
> **CURRENT no resto.** Escrita em 2026-08-10 sob a produção corrente: `z_jk_bs_purif` ×
> `yield_6m`, r=7, q=6, p=6, painel de 106 séries (vintage 07-24), ξ_mp 10,43
> full / 12,22 pré-COVID. Corpo gerado em
> `output/instrument/fomc_coincidence.{csv,md}` + `fomc_coincidence_days.csv` +
> `fomc_coincidence_irf_overlay.pdf`. Código: `R/data_download/fomc_dates.R`,
> `R/instrument/event_tests.R`, `script/fomc_coincidence.R`. **Nada em produção
> foi modificado** — `DEFAULT_VARIANT`, vértice e esquema de agregação seguem
> intactos, as variantes deste teste são construídas em memória, e as oito
> colunas `z_*` de `instrumentos_mensais.csv` saíram **bit-idênticas** depois de
> repopular a flag. **Nenhum `.tex` foi tocado.**
>
> Fecha o item 10 (Fase 2) de
> [`2026-08-10_roadmap_pos_council`](2026-08-10_roadmap_pos_council.md) e a
> Objeção 1 do `relatorio/council_2026-08-10.md`. Irmã da rodada soberana:
> [`2026-08-09_confound_soberano_cds`](2026-08-09_confound_soberano_cds.md).

## 0. Veredito em cinco linhas

**Confound FOMC não detectado**, pela regra fixada antes de os números
existirem. O bloco americano contemporâneo não explica a surpresa nos 62 dias
retidos (F_rob 0,94, p_boot 0,458, R² 0,033) e a interação com a coincidência
FOMC é nula (F_rob 0,85, p_boot 0,466). Nos **35 dias em que Copom e FOMC caem
no mesmo dia** o bloco americano explica **0,5% da variância da surpresa**
(F_rob 0,09, p_boot 0,921) — menos que em qualquer outro conjunto de dias da
amostra. A ameaça era real e grande em exposição (24 dos 62 dias retidos,
**35,5% de Σ|z|**), e o teste não a encontra.

---

## 1. Por que este item existiu, e o que ele diz sobre o repositório

O achado do skeptic não veio de nenhum artefato: veio de notar que
`R/instrument/build_variants.R:244` computa uma flag `fomc_coincide` cujo
arquivo de entrada, `data/fomc_dates.csv`, **nunca existiu**.
`script/instrument.R` tinha um `if (file.exists(...)) ... else
as.Date(character(0))`, então a flag era **identicamente FALSE desde o dia em
que foi escrita**, e `_instrucoes/Instrumento.md` (Etapa 1.4) já especificava
essa coleta desde a concepção do projeto.

A lição é sobre o `else`, não sobre o FOMC. Um fallback silencioso transformou
"a coleta não foi feita" em "a coleta deu vazio", que são indistinguíveis rio
abaixo. `load_fomc_dates()` (`R/instrument/di_surprise.R`) agora **aborta** com
ponteiro para o downloader, e `script/run_all.R` declara `data/fomc_dates.csv`
como requisito duro do estágio `instrument`, de modo que o preflight quebra em
vez de rodar mudo.

**As datas.** `R/data_download/fomc_dates.R` raspa as páginas de calendário do
próprio Fed. O índice `fomc_historical_year.htm` **enumera** as páginas de
arquivo por ano (o Fed publica com defasagem de cinco anos, hoje até 2020) e
`fomccalendars.htm` cobre os anos correntes — o intervalo de anos é lido do
índice, nunca hard-coded, então a coleta acompanha o calendário sozinha. A data
extraída é a da URL do comunicado (`monetaryYYYYMMDDa.htm`), que **é** a data da
decisão; as datas renderizadas na página são intervalos ("28-29") com o mês num
elemento irmão. Quatro `stopifnot` derrubam a coleta se o HTML mudar: 8 reuniões
agendadas por ano de 2013 a 2025 **exceto 2020, que tem 7** (a reunião de 17-18
de março foi cancelada e substituída pela não-agendada de 15 de março), as sete
não-agendadas em janela conferidas contra lista literal, ausência de duplicatas,
e o total de **110 datas em 2013-2025**.

**Cross-check da Wikipédia, e por que ela não serve de fonte.** O autor apontou
a tabela `History_of_Federal_Open_Market_Committee_actions`. Ela lista só as
reuniões que **mudaram a meta** — 66 das 124 datas raspadas, todas as 66 dentro
do conjunto do Fed. Serve de conferência pontual, não de calendário, e por isso
não virou dependência de runtime.

---

## 2. A exposição é maior do que o council estimou

| conjunto | coincidem com FOMC | de | % de Σ\|z\| |
|---|---|---|---|
| dias Copom | 35 | 95 | — |
| dias retidos pelo filtro JK | **24** | 62 | **35,5%** |
| top-20 por alavancagem | **8** | 20 | 22,9% |

O council disse "7 dos top-20, ≈19% de Σ|z|" e "~1/3" dos dias retidos. São **8**
dos top-20, **22,9%** de Σ|z| entre eles, e **38,7%** dos retidos (24 de 62),
carregando 35,5% de Σ|z|. A ameaça é maior do que a crítica que a levantou — o
que torna o nulo subsequente mais informativo, não menos. Por ano, a
concentração é recente e severa: 5 de 7 em 2019, 5 de 8 em 2023 e 2024, e
**7 de 8 em 2025**.

---

## 3. Onde no calendário a notícia do Fed cai — e a perna que não coopera

Antes de qualquer regressão há um argumento de horário. O comunicado do FOMC
sai às **14:00 ET**, antes do fechamento do DI na B3 (18:00 BRT) e antes do
fixing das 15:30 ET a que o DGS2 é cotado. Logo a decisão do Fed deveria estar
**no fechamento de quarta** — isto é, dentro do conjunto de informação contra o
qual a surpresa do Copom é medida, e portanto benigna por construção. O que
pode vazar para dentro da janela é a cauda da coletiva e o overnight.

Mediana de |Δ|, sobre os 95 dias Copom:

| | n | UST 2a Ter→Qua | UST 2a Qua→Qui | S&P Ter→Qua | S&P Qua→Qui |
|---|---|---|---|---|---|
| Copom no dia do FOMC | 35 | **5,00 bp** | 3,00 bp | 0,54% | **0,74%** |
| Copom sem FOMC | 60 | 2,00 bp | 2,00 bp | 0,41% | 0,49% |

**As duas pernas não concordam, e isso é o resultado, não um rodapé.** A perna
de *taxa* — por onde uma surpresa de política monetária americana viaja —
confirma o horário: a variação do UST 2a é quase o dobro antes da janela. A
perna de *ações* não: o S&P se move **mais** de Qua→Qui, ou seja a reação
acionária à decisão continua no dia seguinte e **está** dentro da janela do
instrumento. O argumento de horário cobre parte da ameaça, não toda ela, e é
por isso que os testes seguintes existem em vez de a nota parar aqui.

---

## 4. A regressão decisiva, e o número que inverte o sinal da suspeita

`e_di_bs` regredido no bloco americano contemporâneo (`d_ust2`, `r_sp500`),
HC1, `p_boot` por wild bootstrap sob a nula restrita, cada célula semeada pela
própria identidade:

| conjunto | n | F_rob | p_boot | R² |
|---|---|---|---|---|
| retidos (jk_bs) | 62 | 0,94 | 0,458 | 0,033 |
| Copom (todos) | 95 | 0,67 | 0,541 | 0,007 |
| **Copom com FOMC** | **35** | **0,09** | **0,921** | **0,005** |
| Copom sem FOMC | 60 | 1,54 | 0,273 | 0,030 |
| **Copom rejeitados** | **33** | **2,31** | **0,166** | **0,108** |
| não-Copom (controle) | 503 | 0,49 | 0,711 | 0,003 |

Interações, que são a estatística que decide (contaminação exige que o dia
*selecionado* carregue **mais** notícia americana por unidade de surpresa que o
dia de comparação): bloco US × 1(fomc_coincide) sobre os 95 dias Copom dá
F_rob 0,85, p_boot 0,466; bloco US × 1(jk_bs) sobre as 598 quintas válidas dá
F_rob 0,82, p_boot 0,511. Ambas nulas.

**Duas leituras que a tabela permite e a hipótese de contaminação não.**

1. Os 35 dias em que Copom e FOMC caem no mesmo dia são **exatamente aqueles em
   que a surpresa menos se relaciona com o bloco americano** (R² 0,005, o menor
   da tabela, contra 0,003 do controle de dias comuns e 0,030 dos dias Copom sem
   FOMC). Se a coincidência estivesse injetando notícia do Fed na surpresa, esse
   seria o conjunto com o maior R², não o menor.
2. O maior R² da tabela está nos **33 dias que o filtro JK rejeita** (0,108,
   contra 0,033 dos retidos), e o **único coeficiente da tabela inteira que
   chega perto de significância está lá**: `r_sp500` com 3,491, t 2,05,
   p_boot **0,065** — nos dias descartados, não nos retidos. Isto é, o filtro
   descarta preferencialmente o dia carregado de notícia americana. É o mesmo
   padrão que a rodada soberana encontrou no CDS — retidos +0,140, rejeitados
   −0,285 — e reforça a leitura de que o filtro separa dois regimes de sinal
   oposto, agora com o regime nomeado: dia de Fed dovish/risk-on contra
   hawkish/risk-off.

---

## 5. Valores contra máscara: a distinção que o item 5 do roadmap exigia

O Teste C da rodada soberana ortogonaliza os **valores** da surpresa e deixa a
**seleção** dos dias intacta — contra a própria auditoria de fidelidade do
projeto ("a força vive na máscara"). Aqui as duas coisas são construídas
separadas, e o resultado é quantitativo:

| variante | o que muda | dias | ξ_mp full | ξ_mp pré-COVID |
|---|---|---|---|---|
| `z_jk_bs_purif` | produção | 62 | 10,43 | 12,22 |
| `z_jk_bs_noglob` | só os **valores** | 62 | 10,22 | 12,62 |
| `z_jk_bs_glob` | valores **e máscara** | 61 | 7,72 | 14,17 |
| `z_jk_us` | purificação contemporânea cheia | 63 | 5,44 | 13,60 |

Ortogonalizar os valores custa **0,21 de ξ_mp** (10,43 → 10,22); acrescentar a
re-derivação da máscara custa outros **2,50** (10,22 → 7,72), doze vezes mais.
O bloco global explica só **0,76%** da variância de `e_di_bs` — daí o
canal de valores ser inócuo — mas **24,7%** da de `e_ibov_bs`, e é por aí que a
máscara se move: 54 dos 62 dias sobrevivem, 7 entram. A distinção máscara-vs-
valores não é semântica; nesta amostra ela é a diferença entre um efeito
desprezível e um efeito de um quarto da força do instrumento.

Nenhuma das variantes inverte manchete alguma, e todas mantêm o ponto de
produção dentro do CI90.

---

*(Seção removida em 2026-08-10 junto com o teste que a produzia. Os números
não são mais reproduzíveis e não devem ser citados; o registro fica no
histórico do git e a razão do corte em `_instrucoes/historico_decisoes.md`
§2.4.)*

## 7. O que vai para o paper, e o que não vai

**Vai.** Uma subseção de §5 dizendo que 24 dos 62 dias retidos coincidem com
decisão do FOMC e carregam 35,5% de Σ|z|, que o bloco americano contemporâneo
não explica a surpresa nesses dias (R² 0,005), e que re-derivar a máscara sobre
os resíduos duplos preserva os sinais das manchetes. A ressalva de horário é
obrigatória, porque o argumento vale para a perna de taxa e não para a de ações.

**Não vai.** (i) Qualquer promoção de variante, porque o precedente de
`historico_decisoes.md` é não promover recortes do conjunto de dias. (ii) A
frase de `:519` do `paper_anpec.tex` como está — o
council mostrou que "o confundidor sobrevivente é doméstico" era afirmação sem
teste; agora tem teste, e a frase deve citá-lo em vez de assumi-lo.

**Continua aberto.** O item 6 do roadmap (a descrição errada do placebo
`sp500_vix`, que é só o VIX) é onde esta ameaça mordia no texto, e não foi
tocado aqui — é redação, não estimação. E este teste mede o canal americano
pelo que `d_ust2` e `r_sp500` capturam na janela Qua→Qui; um spillover que
chegasse por canal não medido por esses dois continua fora do alcance, como
sempre esteve.
