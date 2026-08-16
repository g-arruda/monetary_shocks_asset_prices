# Blocos ausentes do painel: o que vale acrescentar, com código e cobertura

> **PROPOSTA, 2026-08-13.** Catálogo operacional das classes de séries que
> faltam no painel de 106. **Nenhuma série foi acrescentada, nenhum resultado de
> produção foi alterado, nenhuma estimação com painel aumentado foi rodada, e
> nenhum `.tex` foi tocado.** A produção segue `(r,q,p) = (7,6,6)`,
> `z_jk_bs_purif`, `yield_6m`, ξ_mp 7,65 full / 11,53 pré-COVID.
>
> **O que foi verificado aqui, e o que não foi.** Todo código SGS abaixo foi
> consultado na API do BCB em 2026-08-13: existência, frequência mensal,
> primeira e última observação. Nenhum foi verificado quanto a **efeito** sobre
> ξ_mp, fatores ou IRFs — isso é o protocolo da nota de proposta e ainda não
> rodou. E os **nomes** das séries não vêm de consulta autoritativa: a página de
> metadados do SGS é renderizada por JavaScript e não respondeu a `curl`. Onde a
> identificação está fechada por aritmética eu digo; onde é inferência por
> magnitude eu digo também. **Confirmar no site do SGS antes de usar.**

## As três notas de 2026-08-13 e o que cada uma faz

| nota | papel |
|---|---|
| [`proposta_composicao_painel`](2026-08-13_proposta_composicao_painel.md) | **protocolo** — como testar cada classe sem contaminar a produção |
| [`composicao_do_painel`](2026-08-13_composicao_do_painel.md) | **medição** — o que o painel de 106 já é (dominância, redundância, fragilidade) |
| esta | **catálogo** — quais séries, com que código, cobertura e tratamento |

Esta nota não repete o diagnóstico nem o protocolo. Ela pressupõe os dois.

## A restrição de desenho que governa toda adição

Da nota de medição: a padronização BLL divide cada série pelo desvio padrão da
sua primeira diferença, de modo que **toda série entra com variância 1**. A
consequência é aritmética e vale a pena escrever antes de qualquer lista:

> **A participação de um bloco na decomposição espectral é a contagem de
> colunas, não a informação que ele traz.**

É por isso que 8 índices de ações com **1,74 dimensões efetivas** ficam com 39%
do fator 4, e por isso que o painel tem sobrepeso de 2,17× em ações e 1,72× na
curva. Duas implicações diretas para o que segue:

1. **Blocos novos devem ser pequenos e internamente pouco correlacionados.** Um
   bloco de crédito bancário com 12 séries pesaria mais que a curva inteira e
   apenas trocaria uma concentração por outra — a nota de proposta já fixa isso
   na classe 5, e a medição diz por quê. **Três a quatro séries por bloco é o
   alvo defensável;** acima disso é preciso justificar a dimensão efetiva, não a
   contagem.
2. **Nunca incluir as três pernas de uma identidade contábil.** Vários blocos
   abaixo vêm em triplas `saldo = crédito − débito` que fecham **exatamente**
   (verifiquei a aritmética, ver §2). Incluir as três insere uma dependência
   linear exata no painel. Escolher **duas das três** — ou o saldo, ou as duas
   pernas.

## Cobertura: nenhuma das adições custa observações

A amostra é 2013-01 a 2025-09, e `drop_na()` em `model_alessi.R` corta linhas
com qualquer `NA`. Uma série que comece em 2015 truncaria o painel em silêncio.
**Nenhuma candidata faz isso:**

| código | 1ª obs | última | freq |
|---|---|---|---|
| 13762, 4513, 4649, 3546, 21340, 227xx, 23079 | 2010-01 | 2025-09 | mensal |
| 21082, 20714 | 2011-03 | 2025-09 | mensal |

Todas cobrem 2013-01 com folga. As séries FRED e Focus são diárias e agregam.

---

## 1. Fiscal — a lacuna mais cara, e não é ambígua

**Por que.** É a única classe cuja ausência contradiz o próprio texto: a leitura
dos resultados é de **dominância fiscal** (CDS↑, câmbio↑, curva coerente) e o
painel não mede nada fiscal. EMBI+ e CDS são o **preço** do risco soberano, não
o fundamento que o antecede. Um referee pode perguntar por que o mecanismo
invocado na interpretação não está no espaço de fatores, e hoje não há resposta.

| série | código | escala | verificação |
|---|---|---|---|
| DBGG, % do PIB | **13762** | 74,48 → 77,38 em 2024 | magnitude bate com o publicado ✓ |
| DLSP, % do PIB | **4513** | ~60 em 2024 | magnitude plausível ✓ |
| Resultado primário consolidado | **4649** | R$ milhões, **muda de sinal** | magnitude plausível ✓ |

**Tratamento.** As duas primeiras são razões e entram em **nível**. A terceira
muda de sinal e **não pode ser logada** — `script/clean.R` só aplica log a
`base_*`, `credit*`, `fin_inst_reserve_req` e `pib`, então basta **não**
acrescentá-la a essa lista. A sazonalidade é resolvida sozinha:
`check_seasonality()` detecta e o X-13 roda sem passo manual.

⚠ **Vintage.** Resultado primário e dívida são revisados. A regra da nota de
proposta — respeitar a data de divulgação disponível em cada mês — vale aqui com
mais força que nas demais classes, porque o dado fiscal de dezembro só existe em
fim de janeiro. Usar a série corrente insere informação posterior no mês de
referência.

## 2. Setor externo real — cinco taxas de câmbio e nenhuma quantidade

**Por que.** O painel tem 5 câmbios (com **1,59 dimensões efetivas**, sobrepeso
1,48×) e nenhuma quantidade do balanço de pagamentos. O preço da moeda está
representado até a redundância; o fluxo que o sustenta, não.

**A estrutura está fechada por aritmética.** Testei as identidades em jan/2024:

- **22701 = 22702 − 22703** (−3501,5 = 35911,8 − 39413,3) ✓
  → 22701 é o **saldo em transações correntes**, 22702 e 22703 suas duas pernas.
- **22707 = 22708 − 22709** (5562,8 = 26961,9 − 21399,1) ✓
  → tripla de **bens**: exportações ≈ US$ 27,0 bi e importações ≈ US$ 21,4 bi em
  jan/2024, magnitudes compatíveis com o comércio de bens do Brasil.
- **22710 = 22711 − 22712** (5268,6 = 26667,5 − 21398,9) ✓
  → tripla **quase gêmea** da anterior (26667 contra 26962).

⚠ **É aqui que eu paro.** Há **duas** triplas de bens com magnitudes vizinhas e
eu não consigo dizer qual é a série de manchete sem o nome autoritativo —
provavelmente diferem por conceito (BPM6 contra base MDIC, ou inclusão de bens
sob *merchanting*). **Confirmar no SGS qual das duas usar.** A identidade que
está segura é a de transações correntes.

| série | código | observação |
|---|---|---|
| Saldo em transações correntes | **22701** | identidade fechada ✓ |
| Transações correntes, 12m, % PIB | **23079** | −0,97 a −1,47 em 2024; razão, entra em nível |
| Exportações / importações de bens | **22708 / 22709** | ⚠ ou a tripla 22711/22712 — confirmar |
| Reservas internacionais | **3546** | US$ ~355 bi em 2024 ✓; volume, candidata a log |

**Escolher duas das três pernas em cada tripla.** A sugestão mínima e não
redundante: `22701` (ou `23079`) + `22708` + `22709`, ou então saldo comercial +
reservas. Termos de troca (FUNCEX) e atividade chinesa, que a nota de proposta
cita, **não estão no SGS** e exigem fonte externa — ficam fora deste catálogo
até terem produtor no repo.

## 3. Expectativas Focus — o insumo já está no repositório

**Por que.** Duas razões, e a segunda é específica deste projeto.

A primeira: expectativa é a informação *forward-looking* que a literatura de
suficiência informacional (Forni–Gambetti 2010) aponta como remédio para *price
puzzle*, e o *price puzzle* de amostra cheia é item aberto em `pendencias.md`.
**Não estou afirmando que resolve** — é hipótese testável, e barata.

A segunda: `data/processed/focus_daily.csv` **já é baixado** por
`R/data_download/focus_fred.R` e usado **só** na purificação pré-evento do
instrumento. As expectativas participam da construção de `z` e não do espaço de
fatores. Essa assimetria é uma escolha que nunca foi registrada como decisão.

**Custo de implementação: quase zero.** O helper `fetch_olinda()` já existe e é
genérico. Verifiquei que o endpoint anual responde e devolve medianas por
`DataReferencia`:

- `ExpectativasMercadoInflacao12Meses` — IPCA 12m, já usado no repo
- `ExpectativasMercadoAnuais` — `Indicador eq 'Selic'`, `'PIB Total'`,
  `'Câmbio'`, filtrando `DataReferencia` para o horizonte fixo

⚠ **A armadilha é a mediana revisada.** Usar a mediana Focus corrente para um mês
passado insere informação posterior. A agregação mensal tem de ser a **última
mediana publicada dentro do mês**, o mesmo critério de fim de mês que a curva já
usa — e cuja correção em 2026-08-12 moveu ξ_mp de 10,43 para 7,65. Errar isso
aqui custa o mesmo tipo de erro.

## 4. Condições financeiras externas e política monetária dos EUA

**Por que.** O conteúdo estrangeiro do painel hoje são 7 índices EPU + MSCI +
VIX. **Não há nenhuma taxa americana, nenhum índice do dólar, e — já é pendência
aberta do §5.1 — nenhum nível do S&P 500**, apesar de o texto do paper afirmar
que há. A rodada de coincidência FOMC testou o *confound* americano **fora** do
painel; um bloco americano dentro do painel deixa o fator global ser estimado em
vez de suposto.

`data/raw/fred_dgs2.csv` (DGS2) também já está no repo e também é usado só na
purificação — mesma assimetria da classe 3.

**Todas verificadas** no mesmo endpoint sem chave que `focus_fred.R` já usa
(`fredgraph.csv?id=...`):

| série | id FRED | cobertura | jan/2024 |
|---|---|---|---|
| Treasury 2 anos | `DGS2` | já no repo | — |
| Treasury 10 anos | `DGS10` | desde 2012-01-03 ✓ | 3,95 |
| Fed funds efetiva | `FEDFUNDS` | desde 2012-01 ✓ | 5,33 |
| Índice do dólar (broad) | `DTWEXBGS` | desde 2012-01-03 ✓ | 119,27 |
| Inclinação 10a−2a | `T10Y2Y` | desde 2012-01-03 ✓ | −0,38 |

⚠ **`SP500` do FRED está descartada, e o motivo importa.** A série tem janela
móvel de ~10 anos: consultada em 2026-08-13, a primeira observação é
**2016-08-15**. Entrar com ela truncaria o painel de 2013-01 para 2016-08 —
**43 meses a menos** — e o `drop_na()` de `model_alessi.R` faria isso **em
silêncio**.

**E não é preciso.** O nível do S&P 500 **já está no repositório com cobertura
integral**: `data/raw/investing/external_factors_daily.csv` vai de **2012-01-03
a 2026-01-30**, produzido por `R/data_download/external_factors.R` a partir do
Yahoo `^GSPC`. Ou seja, a pendência do §5.1 — o paper descreve um placebo de
S&P 500 que o painel não contém — **não depende de baixar nada**, só de agregar
para mensal uma série que o pipeline já busca.

⚠ **Não incluir `DGS2`, `DGS10` e `T10Y2Y` juntos:** a inclinação é a diferença
exata das outras duas, mesma armadilha de identidade da §2.

## 5. Condições de crédito bancário

**Por que.** O §4.4 discute o canal de crédito sustentado em banda de 68%, e o
painel tem **volumes** (9 séries) e **dois spreads ICC**, mas nenhuma taxa em
nível e nenhuma medida de risco de balanço. Quantidade de crédito, preço do
empréstimo e inadimplência são três coisas distintas, e hoje só a primeira está
representada.

| série | código | escala | verificação |
|---|---|---|---|
| Inadimplência total | **21082** | ~3,3% em 2024 | magnitude plausível ✓ |
| Taxa média de juros do crédito | **20714** | ~28% a.a. em 2024 | magnitude plausível ✓ |

⚠ **Esta é a classe com maior risco de sobrepeso.** O bloco de crédito já tem 10
séries e dimensão efetiva 5,24. Acrescentar taxas por modalidade e custo de
captação — que a nota de proposta lista — levaria o bloco a ~15 colunas, mais
que a curva e o câmbio somados, e trocaria a concentração da curva por
concentração de modalidades, exatamente o que a proposta adverte. **Duas séries
agregadas, não uma família por modalidade.**

## 6. Imóveis — a classe mais fraca da lista, e por isso vem por último

O painel tem `credito_construcao`, `price_incc`, `asset_imob` e `asset_ifix`,
mas nenhum preço de imóvel. O **IVG-R** (**21340**, índice ~667→705 em 2024,
mensal desde antes de 2013) fecha a lacuna com uma série.

⚠ **Não faço caso forte por ela.** `price_incc` tem comunalidade **0,056** — é
quase puro idiossincrático neste painel — o que é indício de que o bloco
imobiliário brasileiro comove pouco com o resto em frequência mensal. O IVG-R é
suavizado por construção (mediana móvel de operações de financiamento) e pode
herdar o mesmo problema. Entra como candidata única, e sai sem luto.

---

## Prioridade

1. **Fiscal** (13762, 4513, 4649) — é a única que fecha uma lacuna entre o que o
   paper *afirma* e o que o painel *mede*.
2. **Expectativas Focus** — custo de implementação quase nulo, insumo no repo, e
   é a única com hipótese mecanicista associada a um item aberto (*price
   puzzle*).
3. **Bloco americano** (FRED) — insumo parcialmente no repo, e fecha a pendência
   do S&P 500 no §5.1 de quebra.
4. **Setor externo real** (227xx, 3546) — contrapeso econômico aos 5 câmbios.
5. **Crédito bancário** (21082, 20714) — duas séries, não mais.
6. **Imóveis** (21340) — opcional.

## Armadilhas, reunidas

- **Identidades contábeis exatas:** `saldo = crédito − débito` nas triplas do
  BP; `T10Y2Y = DGS10 − DGS2`. Duas das três, nunca as três.
- **Sobrepeso por contagem:** cada série entra com variância 1, então o tamanho
  do bloco *é* seu peso. Blocos novos pequenos.
- **Log em série que muda de sinal:** resultado primário e saldos não entram na
  lista de log de `clean.R`.
- **Revisão e vintage:** fiscal e Focus exigem a observação disponível **no**
  mês, não a corrente. O erro de fim de mês da curva, corrigido em 2026-08-12,
  é o precedente de quanto isso custa.
- **Truncamento silencioso:** `drop_na()` corta linhas, e o `SP500` do FRED é o
  caso concreto — começa em 2016-08 e custaria 43 meses sem avisar. Cobertura
  conferida para todas as candidatas SGS e FRED desta nota.
- **Seleção pelo maior ξ_mp:** proibida pela regra da nota de proposta. A
  pergunta é se a força **sobrevive** a uma representação menos concentrada, não
  qual adição produz o número maior.

## O que esta nota não faz

- **Não roda nada.** Nenhum painel aumentado foi estimado; não há ξ_mp, fator,
  comunalidade ou IRF de nenhuma das classes acima.
- **Não confirma nomes de série.** Existência, frequência e cobertura sim, por
  consulta à API; nomes não, e as duas triplas de bens da §2 estão explicitamente
  em aberto.
- **Não propõe substituir o painel de produção.** As 106 séries seguem
  canônicas até que o protocolo da nota de proposta rode e o autor decida.
- **Não promete efeito.** Nada aqui autoriza dizer que qualquer adição elevará a
  força do instrumento; o resultado pode ser adverso, e a nota de medição mostra
  que ξ_mp se move com a reponderação de blocos em qualquer direção.
