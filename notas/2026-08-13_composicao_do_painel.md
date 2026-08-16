# Composição do painel: quem domina os fatores e do que ξ_mp realmente depende

> **CURRENT.** Escrita em 2026-08-13 sob a produção corrente: `z_jk_bs_purif` ×
> `yield_6m`, r=7, q=6, p=6, painel de 106 séries, ξ_mp **7,65** full / **11,53**
> pré-COVID (vintage pós-correção de fechamento mensal de 2026-08-12). Corpo
> gerado por `script/panel_composition.R` em
> `output/panel/panel_composition.{md,csv}` (cinco CSVs). O baseline do script
> reproduz 7,65/11,53 exatamente, o que ancora todo o resto da nota.
>
> **Nada em produção foi modificado.** O script só lê o painel, re-estima o DFM
> em subconjuntos de colunas e chama
> `diagnose_instrument_in_factor_space()`; não escreve em `data/`, não toca
> `script/model_alessi.R` e não produz IRF. **Nenhum `.tex` foi tocado.**

Motivação: a percepção de que a força do instrumento é sensível ao painel. A
rodada testa as três perguntas separadamente — **redundância** (há muito de uma
coisa só?), **dominância** (algum bloco captura os fatores?) e **fragilidade**
(ξ_mp depende de quais séries?) — porque as respostas são diferentes.

> **Relação com [`2026-08-13_proposta_composicao_painel`](2026-08-13_proposta_composicao_painel.md).**
> As duas notas são da mesma data e do mesmo tema, escritas em paralelo e por
> caminhos de código independentes. A proposta define **o protocolo de teste das
> cinco classes a acrescentar**; esta aqui **mede o painel que já existe**. Elas
> não se substituem, e os números onde se sobrepõem foram reconciliados
> explicitamente:
>
> | corte | proposta | esta nota |
> |---|---|---|
> | sem os 7 itens de juros ≠ `yield_6m` (N=99) | ξ_mp 1,24 / F 0,95 | **1,24 / 0,95** |
> | sem os 5 vértices `yield_*` ≠ `yield_6m` (N=101) | — | 1,09 / 0,81 |
> | sem as 2 quase-duplicatas (N=104) | ξ_mp 7,94 | **7,94** / 8,02 |
>
> Os dois cortes de curva diferem só por incluir ou não `juros_selic` e
> `juros_cdi`, e dão a mesma leitura. **Corroboração independente, não repetição:
> mesmos números por implementações separadas.**

## Veredito curto

1. **ξ_mp não é frágil a séries individuais.** Nas 105 remoções uma-a-uma, ξ_mp
   fica em **[5,21; 8,33]** na amostra cheia e **[8,80; 14,76]** na pré-COVID.
   **Nenhuma** remoção individual cruza 3,84 — o conjunto AR permanece limitado
   nos 210 painéis. A percepção de fragilidade não se sustenta nesse nível.
2. **ξ_mp depende de um bloco, e é o bloco da curva.** Removendo os cinco
   vértices que não são `yield_6m`, ξ_mp cai de 7,65 para **1,09** (AR
   **ilimitado**) e de 11,53 para 6,41 no pré-COVID. É a única remoção de bloco
   que destrói a identificação, e nenhuma série da curva sozinha faz isso.
3. **Há dominância, e ela é medida, não impressão.** O bloco acionário tem 8
   séries e **1,74 dimensões efetivas** — 8 cópias do Ibovespa ocupando 7,55% da
   variância do painel para carregar informação de ~1,7 série. Câmbio (5 → 1,59)
   e curva (6 → 1,64) têm o mesmo problema. É superponderação no sentido de
   Boivin–Ng (2006), e o efeito aparece nos fatores.
4. **Faltam blocos, e um deles é aquele em que o paper apoia a interpretação:**
   não há **nenhuma série fiscal** no painel, embora a leitura dos resultados
   seja de dominância fiscal. Também faltam expectativas (Focus), setor externo
   e um bloco de política monetária dos EUA — os três com insumo **já no repo**.

## 1. Redundância: quatro pares são a mesma série duas vezes

Correlação das primeiras diferenças padronizadas, |ρ| > 0,95:

| ρ | par |
|---|---|
| **0,9997** | `juros_selic` × `juros_cdi` |
| **0,9963** | `asset_ibov` × `asset_mlcx` |
| 0,9578 | `ind_bens_consumo` × `ind_transformacao` |
| 0,9576 | `yield_5y` × `yield_10y` |

`juros_selic` × `juros_cdi` é **1,0000 em nível** e dá ao bloco `politica`
dimensão efetiva **exatamente 1,00**: duas colunas, uma informação. O CDI é a
Selic por construção institucional. `asset_ibov` × `asset_mlcx` é quase o mesmo
caso — MLCX é large+mid cap, isto é, o Ibovespa com outro nome.

Isto é agravante, não fatal: a padronização BLL dá variância 1 a cada série, de
modo que **a participação de um bloco na decomposição espectral é a contagem de
colunas, não a informação que ele traz**. Duplicar uma série dobra seu peso no
autovalor sem acrescentar nada.

## 2. Dominância: superponderação por bloco

`n_effective` é a razão de participação dos autovalores da correlação interna do
bloco (n se ortogonal, 1 se uma série repetida); `sobrepeso` é a razão entre a
participação em variância (contagem) e a participação em informação.

| bloco | n | n_efetivo | % do painel | % da informação | **sobrepeso** |
|---|---|---|---|---|---|
| acoes | 8 | 1,74 | 7,55 | 3,48 | **2,17** |
| industria | 12 | 3,21 | 11,32 | 6,44 | **1,76** |
| curva | 6 | 1,64 | 5,66 | 3,29 | **1,72** |
| cambio | 5 | 1,59 | 4,72 | 3,18 | **1,48** |
| trabalho | 14 | 5,00 | 13,21 | 10,02 | 1,32 |
| epu | 8 | 5,62 | 7,55 | 11,26 | 0,67 |
| commodities | 3 | 2,47 | 2,83 | 4,96 | 0,57 |
| confianca | 2 | 1,91 | 1,89 | 3,84 | 0,49 |

O efeito é visível na atribuição fator a fator (participação de cada bloco na
soma dos loadings ao quadrado):

- **F4 é 39,0% ações.** Oito séries com 1,74 dimensões efetivas capturam quase
  40% de um fator estático.
- **F1 é 31,8% indústria + 25,7% trabalho** — o fator de atividade real, o mais
  bem representado do painel.
- **F5 é 59,9% preços**, F3 é 31,2% agregados monetários + 21,5% trabalho, F6 é
  23,0% crédito.
- **F7 é 51,3% EPU** — o sétimo fator, aquele que a produção adiciona sobre o
  IC automático, é majoritariamente um fator de incerteza estrangeira, com a
  **menor comunalidade média do painel** (0,281).

⚠ **A leitura tentadora de que r=7 "é pago pelo EPU" não se sustenta e não deve
ser escrita.** Testado diretamente: sem o bloco EPU o IC2 continua 5 (IC1 vai de
5 para 6, q_hat de 3 para 5), e ξ_mp em (7,6) cai apenas de 7,65 para 7,24. Em
(5,4), 4,77 com EPU e 5,15 sem. O EPU constrói F7 mas não é o que faz r=7
funcionar.

## 3. Fragilidade: leave-one-out em dois níveis

**Por série (105 painéis × 2 amostras).** Amostra cheia: mín 5,21, mediana 7,64,
máx 8,33; **105 de 105 abaixo de 10** — mas isso já é verdade no baseline (7,65),
não é efeito da remoção. Pré-COVID: mín 8,80, mediana 11,40, máx 14,76, 6 de 105
abaixo de 10. **Zero painéis abaixo de 3,84 nas duas amostras.**

As remoções individuais mais custosas na amostra cheia:

| série removida | ξ_mp | Δ |
|---|---|---|
| `yield_1y` | 5,21 | −2,44 |
| `epu_brazil` | 5,45 | −2,20 |
| `yield_2y` | 5,54 | −2,10 |
| `epu_germany` | 6,12 | −1,53 |
| `yield_3m` | 6,32 | −1,33 |
| `epu_us` | 6,35 | −1,30 |

**Por bloco.** Ordenado pelo dano na amostra cheia:

| bloco removido | n | ξ_mp full | Δ full | ξ_mp pré-COVID | Δ pré |
|---|---|---|---|---|---|
| **curva** (menos `yield_6m`) | 5 | **1,09** | **−6,56** | 6,41 | −5,13 |
| domínio financeiro_domestico | 20 | 2,35 | −5,30 | 5,36 | −6,18 |
| risco_externo | 4 | 7,04 | −0,61 | 13,9 | +2,33 |
| epu | 8 | 7,24 | −0,41 | 10,1 | −1,44 |
| cambio | 5 | 7,38 | −0,27 | 9,77 | −1,76 |
| **trabalho** | 14 | 7,43 | −0,22 | 13,6 | +2,10 |
| precos | 11 | 7,44 | −0,21 | 7,47 | −4,06 |
| acoes | 8 | 7,85 | +0,21 | 8,75 | −2,78 |
| **domínio atividade_real** | 28 | **8,08** | **+0,43** | 4,19 | −7,35 |
| industria | 12 | 8,24 | +0,59 | 9,59 | −1,94 |
| credito | 10 | 8,85 | +1,20 | 23,5 | +11,9 |

O contraste é o resultado da rodada: **jogar fora 28 séries de atividade real
(26% do painel) melhora ξ_mp na amostra cheia; jogar fora 5 vértices de juros a
destrói.** O tamanho do bloco não prevê sua importância para a relevância do
instrumento — o que prevê é se o bloco mede a coisa que o instrumento move.

Isso é o esperado e não é circularidade: o instrumento é surpresa de DI, a
normalização é `yield_6m`, e ξ_mp é calculado na direção da inovação
fator-implícita de `yield_6m`. Sem os outros vértices, o espaço de fatores não
tem como reconstruir o movimento da curva, e a inovação de `yield_6m` implicada
pelos fatores fica mal medida. **É uma exigência de medição, e vale registrá-la:
a curva não é uma variável do painel entre 106, é o instrumento de medida da
identificação.**

## 4. Painéis balanceados: o painel grande não está comprando relevância

Teto de k séries por bloco, mantendo as k mais representativas (maior |loading|
no PC1 do próprio bloco) e sempre `yield_6m`:

| teto | N | ξ_mp full | ξ_mp pré-COVID |
|---|---|---|---|
| 2 | 35 | 7,87 | **16,8** |
| 3 | 47 | 4,05 | 14,4 |
| 4 | 59 | 6,56 | 11,8 |
| 6 | 78 | 6,47 | 14,9 |
| 8 | 91 | 5,31 | 13,2 |
| — (produção) | 106 | 7,65 | 11,53 |

Nenhum painel balanceado fica abaixo de 3,84, e **todos superam a produção no
pré-COVID**. A variação em N não é monótona (4,05 em N=47, 7,87 em N=35), o que
é o próprio ruído de re-rotação dos fatores e deve ser lido como ruído.

**É aqui que a sensibilidade percebida realmente vive:** ξ_mp se move de ~4 a ~8
quando os *pesos de bloco* mudam por atacado, e quase nada quando séries
individuais saem. A sensibilidade é ao **desenho do painel**, não à sua
realização.

## 5. O que falta

Comunalidade mediana 0,533; **16 séries abaixo de 0,20** (`trab_min_wage` 0,013,
`epu_india` 0,043, `price_incc` 0,056, `ind_min_extr` 0,067, `msci` 0,101, `icc`
0,112). Séries assim consomem peso de variância e devolvem quase só
idiossincrasia.

Blocos ausentes, em ordem de custo argumentativo:

1. **Fiscal — ausente por completo.** A leitura dos resultados (CDS↑, câmbio↑,
   curva coerente) é de dominância fiscal, e o painel não mede nada fiscal.
   Verificados no SGS e mensais em toda a amostra: **13762** (DBGG % PIB, 74,48
   → 77,38 em 2024), **4513** (DLSP % PIB, ~60), **4649** (resultado primário
   consolidado, R$ milhões — muda de sinal, então entra em nível, sem log). É a
   lacuna mais defensável: um referee pode perguntar por que o mecanismo
   invocado não está no painel.
2. **Expectativas (Focus) — o insumo já está no repo.**
   `data/processed/focus_daily.csv` é baixado por `R/data_download/focus_fred.R`
   e usado só na purificação do instrumento. Medianas mensais de IPCA 12m,
   Selic fim de período, PIB e câmbio são informação forward-looking, que é
   exatamente o que a literatura de suficiência informacional (Forni–Gambetti
   2010) aponta como remédio para *price puzzle* — e o *price puzzle* de amostra
   cheia é item aberto em `pendencias.md`. **Não estou afirmando que resolve; é
   uma hipótese testável barata.**
3. **Política monetária e mercado dos EUA.** `data/raw/fred_dgs2.csv` (DGS2) já
   existe, também só usado na purificação. O conteúdo estrangeiro do painel hoje
   são 7 EPU + MSCI + VIX, e não há nenhuma taxa americana nem índice do dólar.
   Casa com a rodada de coincidência FOMC, que testou o confound fora do painel.
   Inclui o **nível do S&P 500**, cuja ausência já é item aberto do §5.1.
4. **Setor externo.** Cinco taxas de câmbio e nenhuma quantidade externa:
   reservas internacionais (**SGS 3546**, verificado), balança comercial e
   termos de troca. ⚠ Os códigos das pernas de exportação/importação e de
   transações correntes **não foram confirmados** — 22708 retorna ~US$ 28 bi/mês
   e 22885 ~US$ 6 bi/mês, ambos plausíveis para mais de uma série; confirmar
   antes de usar.
5. **Qualidade de crédito e imóveis.** Verificados: **21082** (inadimplência
   total, ~3,3%), **20714** (taxa média de juros do crédito, ~28% a.a.),
   **21340** (IVG-R, preços residenciais). O §4.4 discute o canal de crédito com
   banda de 68% e o painel tem volumes e spreads, mas nenhuma taxa de nível nem
   inadimplência.

`script/clean.R` só aplica log a volumes (`base_`, `credit`,
`fin_inst_reserve_req`, `pib`); taxas e índices entram em nível. Séries fiscais
que mudam de sinal, portanto, **não** esbarram na transformação — basta não
incluí-las na lista de log.

## O que esta rodada não fez

- **Não roda IRF e não produz inferência.** Todos os números são ξ_mp, F_rob,mp
  e impacto pré-normalização; nenhum bootstrap foi executado.
- **Não propõe mudar o painel de produção.** As 106 séries seguem canônicas; a
  nota mede o painel, não o substitui.
- **Não testa o painel aumentado.** Os blocos da §5 são recomendações
  verificadas quanto a existência e frequência, não quanto a efeito — se entram,
  ξ_mp e o IC precisam ser re-rodados, e o resultado pode ser adverso.
- **Não reabre a escolha (r,q).** A checagem de EPU foi feita para refutar uma
  hipótese própria, não para propor dimensão nova.
