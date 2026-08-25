# `q`: a checagem da Figura A3 de Alessi-Kerssenfischer não replica na escala normalizada

> **CURRENT.** Rodada de 2026-08-18 sobre a produção de 111 séries
> `drop_setor_externo__eua__credito__imoveis`, `(r,p) = (5,6)`,
> `z_jk_bs_purif` × `yield_6m`, amostra completa 2013-01 a 2025-09, wild
> bootstrap de 800 réplicas, semente 123, bandas 68/90.
> Script: `script/q_selection.R`, estendido (antes só entregava `h = 0` em três
> células; agora entrega trajetórias, contenção e figura em quatro).
> Saídas: `output/factors/q_selection.{csv,md}`, `q_selection_paths.{csv,pdf}`,
> `q_selection_containment.csv`.
> **Produção não muda.** O item de `q` continua **aberto** — esta nota entrega
> a checagem que faltava, não a decisão.

## 1. A pergunta e o veredito

A nota de 2026-08-17 fechou a fidelidade da tradução de `amengual_watson()` e
mediu a discordância do critério, mas deixou de fora justamente o teste com que
**Alessi-Kerssenfischer justificam a própria escolha de `q`**. A nota 4 do
artigo deles:

> *"In principle, the DFM framework allows static factors $F_t$ to have reduced
> rank — that is, to be spanned by $q \le r$ 'dynamic' factors... Given our
> external instrument identification scheme, however, results are virtually
> identical whether or not $q < r$; thus we assume $q = r$ for simplicity."*

E a **Figura A3** do apêndice é o que sustenta a afirmação: o benchmark
`(p=6, r=8, q=8)` carrega ponto **e** bandas, e `q = 5, 6, 7` entram sobrepostos
como linhas de **ponto apenas**. A leitura é de contenção — as alternativas
ficam dentro das bandas do benchmark, logo `q` é imaterial. Esta rodada constrói
a mesma figura para `r = 5`.

**Veredito, em três partes:**

1. **Na escala normalizada, a afirmação de AK não replica.** Pela regra de
   leitura fixada antes de olhar as trajetórias, **0 de 18** pares
   (variável × `q`) saem *imateriais* e **13** saem *materiais*.
2. **Mas quase todo o gap é o denominador de normalização, não a coluna
   estimada.** Mantida a normalização fixa no denominador da produção, o resto
   do gap no impacto fica entre **0,59 e 1,17** — isto é, da ordem de 1, "a
   coluna não mudou" — em `yield_2y`, `yield_5y`, `cambio_usd` e `cds_5y`.
   `cambio_usd` e `cds_5y` voltam para **dentro** da banda de 90% da produção em
   **todos** os 37 horizontes, nas três alternativas.
3. **`asset_ibov` é a exceção, e ela corta para os dois lados.** Descontado o
   denominador, a coluna estimada do Ibovespa ainda é **3,8× e 4,0×** a da
   produção em `q = 3` e `q = 2` — é a única variável do bloco onde a
   divergência não é escala. **Mas mesmo assim ela não sai da banda:** −22,43
   reescalado dá −6,577 contra um piso de 90% em **−6,910**. A banda de impacto
   do bloco acionário é larga demais para o teste de contenção discriminar ali,
   e isso é informação sobre o bloco, não sobre `q`.

## 2. A regra de leitura, pré-registrada

Fixada no plano de 2026-08-18, **antes** de qualquer trajetória ser olhada, e
aplicada mecanicamente pelo `case_when` do script:

- **`share_in90`** — fração dos horizontes `h = 0..36` em que o ponto da célula
  alternativa cai dentro da banda de 90% **da produção**. É o que o olho lê na
  Figura A3, e a assimetria (só a produção tem banda) é o desenho de AK.
- **`cor_path`** — correlação da trajetória alternativa com a de produção em
  `h = 0..36`. Mede **forma**, imune à escala.
- *imaterial* ⇔ `share_in90 = 1` **e** `cor_path > 0,95`; *material* ⇔
  `share_in90 < 1` ou inversão de sinal no impacto; o resto é *parcial*.

## 3. Força: a coincidência que organiza o resultado

Amostra completa, de `output/instrument/mosw_strength_grid.csv`, reproduzido
pelo auto-teste 2 a desvio 4,441e-16:

| q | ξ_mp | F_rob,mp | AR limitado | bandas válidas | `impacto_mp_pre` | `denom_ratio` |
|---|---|---|---|---|---|---|
| **5** (produção) | **6,271** | 10,12 | sim | não | 8,426e-05 | 1 |
| 4 | 4,807 | 6,61 | sim | não | 5,443e-05 | 0,646 |
| 3 | 3,149 | 3,66 | **não** | não | 2,471e-05 | 0,293 |
| 2 (critério BLL) | 3,809 | 4,824 | **não** | não | 2,690e-05 | 0,319 |

A raiz máxima da companion é **0,964858** nas quatro — estabilidade não
desempata, exatamente como em 2026-08-17.

**A coincidência:** as duas células que saem *materiais* em **todas** as seis
variáveis são `q = 3` e `q = 2`, que são precisamente as duas com ξ_mp abaixo de
3,84. E `denom_ratio` cai monotonicamente com a força. Não é acaso: `ξ_mp` e
`impacto_mp_pre` medem a mesma relevância do instrumento no espaço fatorial por
dois caminhos, e é o segundo que divide cada IRF da célula.

## 4. O que a figura mostra, célula por célula

`output/factors/q_selection_paths.pdf`, três páginas. A página 1 traz as cinco
variáveis pedidas (`yield_6m`, `yield_2y`, `yield_5y`, `cambio_usd`, `cds_5y`),
a página 2 o `asset_ibov` sozinho e a página 3 a decomposição pós-hoc.

**`q = 4` é o quase-acerto.** Em **5 das 6** variáveis a trajetória fica dentro
da banda de 90% da produção em **todos** os 37 horizontes — `share_in90 = 1` em
`yield_6m`, `yield_2y`, `yield_5y`, `cds_5y` e `asset_ibov`. Ela falha a regra
por dois motivos, e os dois merecem ser ditos:

- **`cambio_usd` sai da banda, e sai em `h = 0`.** O impacto vai de **0,15793**
  (produção) para **0,28481**, contra uma banda de 90% de
  **[0,09207 ; 0,24927]**. `share_in90` = 0,946; em `h ≤ 12` cai para 0,846.
  ⚠ Essa é a variável-manchete da §4. A divergência é para **mais** depreciação,
  não para menos.
- **`cor_path` fica abaixo de 0,95 em quatro das seis** — 0,605 em `yield_6m`,
  0,844 em `yield_2y`, 0,903 em `yield_5y`, 0,655 em `asset_ibov`. A
  descorrelação vive no médio prazo, onde as bandas da produção são largas o
  bastante para conter caminhos de formato diferente. **Isso não é evidência
  independente:** o comportamento de médio prazo aqui e a persistência quase
  unitária do VAR de fatores são o mesmo objeto, e o projeto proíbe citá-los
  separadamente.

**`q = 3` e `q = 2` saem materialmente**, e onde mais saem é em `h ≤ 12`:
`cambio_usd` tem `share_in90` de 0,486 e 0,568 no total e **0,000** em `h ≤ 12`;
`cds_5y`, 0,730 e 0,703 no total contra 0,231 e 0,154 em `h ≤ 12`.

## 5. A decomposição pós-hoc: denominador ou coluna estimada?

⚠ **Achado depois de olhar, e deliberadamente fora da regra de veredito** —
nenhuma coluna desta seção entra no `case_when`, justamente para que olhar para
ela não pudesse virar um veredito fixado antes.

`resto_coluna_h0` é o quociente de impacto alternativa/produção **multiplicado
por** `denom_ratio`: o que sobra do gap depois de remover o denominador de
normalização. **1 significa que a coluna estimada não mudou e todo o gap era
escala.**

| variável | q=4 | q=3 | q=2 |
|---|---|---|---|
| `yield_2y` | 0,820 | 0,591 | 0,608 |
| `yield_5y` | 0,889 | 0,775 | 0,785 |
| `cambio_usd` | 1,165 | 0,929 | 0,751 |
| `cds_5y` | 0,977 | 1,019 | 0,983 |
| **`asset_ibov`** | 1,106 | **3,818** | **4,035** |

A linha de `yield_6m` está de fora porque é tautológica: o impacto bruto da
variável de política **é** o denominador, então `ratio_h0` vale 1 por construção
e `resto_coluna_h0` reproduz `denom_ratio`. Não é achado, é a identidade que
fixa a normalização.

A página 3 da figura desenha isso. Reescaladas pelo denominador da produção,
`cambio_usd` e `cds_5y` colapsam para dentro da banda: `share_in90_resc` =
**1,000** nas seis células, contra 0,486 e 0,568 (`cambio_usd` em `q=3` e `q=2`)
e 0,730 e 0,703 (`cds_5y`) na escala normalizada. É o colapso mais nítido da
rodada.

⚠ **Duas leituras que a tabela reescalada não autoriza, e que é preciso dizer
antes que alguém as faça:**

- **`asset_ibov` reescalado também fica dentro da banda** — `share_in90_resc`
  1,000 em `q = 4` e `q = 3`, e 0,973 em `q = 2`, onde o único horizonte fora é
  `h = 0` por **0,04**. Isso **não** desmente o fator de ~4 da linha anterior: a
  banda de 90% da produção em `h = 0` é [−6,9096 ; 0,7747], cerca de **quatro
  vezes** o ponto de −1,7227. Contenção é teste fraco onde a banda é larga, e no
  bloco acionário ela é. As duas medidas medem coisas diferentes e as duas
  valem.
- **`yield_6m` reescalado piora** (1,000 → 0,919 em `q=4`; 0,811 → 0,703 em
  `q=3`) e isso não significa nada: a trajetória normalizada da variável de
  política está presa a 0,005 em `h = 0` por construção, então multiplicá-la por
  `denom_ratio` desfaz a própria normalização. A linha existe na tabela por
  simetria, não para ser lida.

**A leitura:** a afirmação de AK — de que sob identificação por instrumento
externo a escolha de `q` é imaterial — sobrevive **para a coluna estimada** de
tudo menos o bloco acionário. O que não sobrevive é a escala, e a escala aqui
não é detalhe: ela é o denominador de normalização, que é uma medida de força do
instrumento. Em AK o denominador não se move porque `q` não mexe na força do
instrumento deles; neste painel mexe, e muito.

## 6. O número inconveniente, dito por inteiro

Impacto em `h = 0`, quatro células:

| variável | q=5 | q=4 | q=3 | q=2 |
|---|---|---|---|---|
| `yield_6m` | 0,005 | 0,005 | 0,005 | 0,005 |
| `yield_2y` | 0,00743006 | 0,00942631 | 0,01497210 | 0,01414646 |
| `yield_5y` | 0,00776115 | 0,01067718 | 0,02050525 | 0,01908602 |
| `cambio_usd` | 0,15792807 | 0,28480588 | 0,50029182 | 0,37155046 |
| `cds_5y` | 32,541729 | 49,225406 | 113,06289 | 100,16374 |
| `asset_ibov` | −1,7226767 | −2,9497503 | **−22,425902** | **−21,771082** |

Exclui zero a 90% no impacto: em `q = 5` e `q = 4`, cinco das seis — `asset_ibov`
**não**. Em `q = 3` e `q = 2`, **as seis**.

A banda de 90% da produção para `asset_ibov` em `h = 0` é
**[−6,9096 ; 0,7747]**: os −22,4 de `q = 3` estão muito fora dela na escala
normalizada. Ler isso como argumento a favor de migrar seria o erro que a nota
de 2026-08-17 já nomeou — magnitude maior com instrumento mais fraco é a
assinatura clássica de viés de instrumento fraco. Mas o número não pode ser
omitido, e agora ele está medido com a normalização controlada, não apenas
conjecturado: **mesmo descontando o denominador, sobra um fator de ~4 na coluna
acionária**, e é a única variável do bloco de que isso se pode dizer.

⚠ **E o contra-número, na mesma respiração:** esse fator de ~4 reescalado ainda
cabe dentro da banda de impacto da produção (§5). Quem quiser usar a §6 para
dizer "o bloco acionário é instável em `q`" tem de carregar junto que a banda
que o declara nulo é larga o bastante para acomodar quatro vezes o ponto.

## 7. O que isto fecha e o que continua aberto

**Fecha:** a checagem de robustez de `q` no desenho do próprio AK, que não
existia. `q = 5` deixa de ser um default sem contraditório e passa a ser uma
escolha com a checagem feita e o resultado registrado — inclusive o desfavorável.

**Não fecha, e continua sendo decisão do autor:**

- **A saída "manter `q = 5` e declarar"** ganhou fundamento novo, mas de tipo
  diferente do de AK: aqui não se pode escrever "os resultados são virtualmente
  idênticos", porque não são na escala normalizada. O que se pode escrever é que
  as células alternativas divergem **por força de instrumento**, e que as duas
  que mais divergem não passam na régua de AR. A §3.5 hoje diz que `q = 5` é
  escolha operacional e que a fundamentação segue aberta — o que continua
  **exato**, e esta rodada não autoriza sozinha trocar essa frase por uma
  invocação de AK.
- **`q = 4` não foi pedido por critério nenhum** e tem ξ_mp menor que a produção
  (4,807 contra 6,271). Ele entra aqui como degrau da escada, não como candidato.
- **A ressalva da padronização do 2º estágio** de `amengual_watson()`
  (`notas/2026-08-17_selecao_q_e_fidelidade_amengual_watson.md` §6) segue
  intocada.

**Auto-testes que a rodada passou** (todos `stopifnot`): a célula `q = 5`
reproduz `output/irf/irf_coherence_h.csv` em ponto **e** bandas 68/90 a
**3,553e-15** nos 294 pontos do bloco; ξ_mp e F_rob batem com
`mosw_strength_grid.csv` a **4,441e-16** nas quatro células; `yield_6m` em
`h = 0` é exatamente 0,005 em todas; e os impactos de `q ∈ {5,3,2}` reproduzem a
tabela anterior a **1,421e-14**.
