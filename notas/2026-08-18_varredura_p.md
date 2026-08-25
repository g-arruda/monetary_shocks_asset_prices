# `p`: o impacto não se move; a reversão de médio prazo se move, como a §4 já dizia

> **CURRENT.** Rodada de 2026-08-18 sobre a produção de 111 séries
> `drop_setor_externo__eua__credito__imoveis`, `(r,q) = (5,5)`,
> `z_jk_bs_purif` × `yield_6m`, amostra completa 2013-01 a 2025-09, wild
> bootstrap de 800 réplicas, semente 123, bandas 68/90, `h = 0..48`.
> Grade pré-registrada `p ∈ {2,3,4,6}`, quatro células com bootstrap completo.
> Script: `script/p_selection.R`, novo.
> Saídas: `output/factors/p_selection.{csv,md}`, `p_selection_paths.{csv,pdf}`,
> `p_selection_containment.csv`, `p_selection_lag_criteria.csv`.
> **Produção não muda.** A rodada entrega a varredura que faltava; ela não
> decide `p`.

## 1. A pergunta e o veredito

`p = 6` está fixo em **todo** sweep vivo — `irf_spec_sweep.R:26` e
`irf_spec_stage2.R:34` gravam `SPEC$p` como constante nas 400 células — e não é
o argmin de critério de informação nenhum. A única variação que existia,
`P_GRID <- c(1L, 4L, 6L)` em `script/factor_stationarity.R`, roda sem bootstrap
e reporta só o **extremo de médio prazo**, nunca o impacto. Como as quatro
manchetes do paper são impactos, a pendência nomeava o risco certo: não é a
reversão que preocupa, é o impacto se mover.

**Veredito, em quatro partes:**

1. **O impacto não se move.** Pela regra fixada **antes** de olhar as
   trajetórias, **26 de 30** pares (variável × `p`) saem *imateriais*, **4**
   saem *parciais* e **nenhum** sai *material*. `share_in90 = 1` nos **30**
   pares: nenhuma célula alternativa sai da banda de 90% da produção em
   horizonte nenhum de `h = 0..36`, nem na janela curta `h ≤ 12`.
2. **A significância no impacto é invariante.** Os seis vértices da curva, o
   câmbio, o EMBI+ e o CDS de 5 anos excluem zero a 90% em `h = 0` nas **quatro**
   células; `asset_ibov` **não** exclui em nenhuma das quatro. A magnitude fica
   entre `−6,5%` e `+11,7%` da produção no bloco-manchete e entre `−3,8%` e
   `+3,2%` na curva.
3. **A reversão de médio prazo se move, e é isso que a §4 já afirma.** O
   horizonte em que a trajetória cruza de volta o sinal do impacto anda até
   sete meses: `yield_6m` vai de `h = 22` em `p = 6` para `h = 15` em `p = 2`,
   `yield_5y` de 17 para 13, `cambio_usd` de 12 para 9, EMBI+ de 15 para 13 e
   CDS de 15 para 13. **O item fecha corroborando a §4**, que desde 2026-08-18
   descreve a reversão como dinâmica conjunta sensível a `p` e não como
   confirmação independente de canal.
4. **`asset_ibov` é a exceção, e ela corta para os dois lados.** O impacto
   desaba de `−1,7227` para `−0,3360` — entre `−43,8%` e `−80,5%` da produção,
   e `resto_coluna_h0` desce a `0,225`, ou seja **a coluna estimada muda de
   verdade**, não é denominador. **Mas ela não sai da banda:** `share_in90 = 1`
   nas três alternativas, porque a banda do bloco acionário é larga demais para
   o teste de contenção discriminar ali. É o mesmo achado da rodada de `q`, e é
   informação sobre o bloco acionário, não sobre `p`.

## 2. A regra de leitura, pré-registrada

Fixada no plano de 2026-08-18, antes de qualquer trajetória ser olhada, e
aplicada mecanicamente por `containment_vs_production()` — a **mesma** função
que a rodada de `q` usa, extraída para `R/identification/spec_sweep.R` nesta
rodada justamente para que as duas não possam divergir na regra:

- *imaterial* ⟺ `share_in90 = 1` em todo `h ≤ 36` **e** `cor_path > 0,95`
- *material* ⟺ `share_in90 < 1` fora de `h = 0`, ou inversão de sinal no impacto
- o resto é *parcial*

Os quatro *parciais* são todos por `cor_path`, nunca por contenção:
`cambio_usd` em `p = 3` (0,9210) e `p = 2` (0,9470), `asset_ibov` em `p = 3`
(0,8592) e `p = 2` (0,8234). Forma diferente, contenção intacta.

## 3. A correção de um número que estava no próprio item

A pendência dizia, citando `diagnostics/output/t5_3_ordem_defasagens.csv`, que
"BIC e HQ selecionam `p = 1`, AIC seleciona `p = 4`". **BIC e HQ selecionam
`p = 2`**, não `p = 1`: naquela mesma tabela BIC vale `9,41027` em `p = 1`
contra `9,01574` em `p = 2`, e HQ vale `9,11496` contra `8,42252`. O comentário
de `script/factor_stationarity.R:100` repetia o erro e foi corrigido junto.
AIC seleciona `p = 4`, como o item dizia.

Há ainda um defeito de comparabilidade no artefato citado: `estimate_var_ols()`
estima em `T − p` observações, de modo que os critérios de `t5_3` são
comparados em **amostras diferentes** (152 a 141 observações). A rodada
recomputa as duas variantes — a de amostra variável, que reproduz `t5_3` a
`1,8e-15`, e a de amostra comum fixada nas últimas `T − 12` observações, que é
o que `vars::VARselect` faz. **Os argmins são os mesmos nas duas:** AIC `p = 4`,
BIC `p = 2`, HQ `p = 2`. O defeito existe e não muda o veredito.

`p = 6` continua não sendo o argmin de nenhum dos três.

## 4. Força, estabilidade e as duas assimetrias contra a varredura de `q`

| `p` | dim. companion | `n_obs` 1º estágio | ξ_mp | F^rob_mp | raiz máxima | `denom_ratio` |
|---|---|---|---|---|---|---|
| 6 (produção) | 30 | 147 | 6,27085 | 10,1205 | 0,964858 | 1 |
| 4 | 20 | 149 | 5,24016 | 10,0609 | 0,968126 | 1,20243 |
| 3 | 15 | 150 | 5,76705 | 8,75077 | 0,975933 | 1,17096 |
| 2 | 10 | 151 | 5,15898 | 8,19735 | 0,969667 | 1,15415 |

**Duas assimetrias que não existem na varredura de `q` e precisam ser lidas nas
colunas, não assumidas.** Primeiro, `p` muda o tamanho do primeiro estágio:
`sel_ext_inst_sample()` descarta os primeiros `p` meses, então `n_obs = 153 − p`
e ξ_mp de duas células **não está na mesma amostra**. Segundo, `p` muda a
dimensão da companion (`r·p`, de 10 a 30), então a raiz máxima de duas células é
o máximo de matrizes de tamanhos diferentes.

⚠ **O número desconfortável: `p = 6` é a célula mais forte da grade.** ξ_mp
6,27 contra 5,16-5,77 nas três alternativas, e F^rob 10,12 contra 8,20-10,06.
Isso é **fato reportado, não justificativa** — a §3.5 declara que nenhuma
dimensão foi escolhida pela célula de maior força, e essa regra não pode ser
contornada por trás com `p`. Também não há mecanismo monótono: `p = 3` (5,77) é
mais forte que `p = 4` (5,24). **Nenhuma das quatro células alcança 10 em ξ_mp**,
e as quatro passam de 3,84, então o conjunto AR é limitado em todas e em
nenhuma as bandas convencionais são aproximadamente válidas.

**A quase-raiz-unitária não vem de `p`**, o que já estava em
`notas/2026-07-31_estacionariedade_fatores.md` e agora está preso à IRF: as
raízes ficam entre 0,9649 e 0,9759 na grade, e a **menor** delas é a da
produção. Nenhum dos quatro bootstraps emitiu aviso — a correção de Kilian
convergiu nas quatro células.

## 5. O denominador, e o que sobra dele

`denom_ratio` é o impacto pré-normalização de `yield_6m` da célula sobre o da
produção. Ele é **maior que 1** nas três alternativas (1,15 a 1,20), isto é, a
produção divide pelo **menor** denominador da grade e por isso imprime as
respostas maiores por aritmética. Mantida a normalização fixa no denominador da
produção, `resto_coluna_h0` fica entre **1,12 e 1,31** no bloco-manchete — a
coluna estimada sobe o que o denominador tinha descido, e os dois efeitos se
cancelam quase exatamente. A contenção sobrevive à reescala em 21 dos 30
pares; os 9 restantes (`yield_3m`, `yield_6m` e `yield_1y` nas três
alternativas) saem da banda em **um único horizonte, `h = 0`, e por motivo
mecânico**: a banda de 90% da produção em `h = 0` para a variável de
normalização é o ponto degenerado `[0,005 ; 0,005]`, de modo que multiplicar
por um `denom_ratio ≠ 1` sai dela por construção, e o trecho curto da curva
herda a mesma estreiteza no impacto. Fora de `h = 0` a contenção reescalada é
integral em toda a grade.

A exceção é de novo `asset_ibov`, onde `resto_coluna_h0` cai a 0,676 / 0,503 /
0,225: ali o denominador não explica nada e a coluna estimada é que muda.

## 6. Números inconvenientes, listados

- **A contagem de horizontes significativos na janela curta se move**, ainda que
  o impacto não. Em `h ≤ 12`, `cambio_usd` tem 7 horizontes sig90 em `p = 6`
  contra 4 em `p = 3`; o CDS tem 8 contra 6; o EMBI+ 8 contra 5; `yield_6m` 12
  contra 9. O que é invariante é a significância **no impacto**, não a extensão
  da janela significativa.
- **`p = 6` é a célula mais forte da grade** (item 4 acima).
- **`asset_ibov` perde 80% do impacto em `p = 2`** e continua dentro da banda —
  o teste de contenção é fraco no bloco acionário e isso limita o que esta
  rodada pode dizer sobre ele.
- **Nenhuma célula da grade alcança ξ_mp ≥ 10**, inclusive a produção.

## 7. O que fica em aberto

A §3.4 do paper (linha 225) justifica `p = 6` dizendo que é "suficiente para
acomodar a persistência das séries mensais brasileiras sem sobreparametrizar a
dinâmica". Essa frase não tem lastro: `p = 6` não é o argmin de AIC, BIC nem HQ,
e o paper não diz isso em lugar nenhum. Esta rodada dá o lastro para a frase
**correta** — `p = 6` é fidelidade a Alessi-Kerssenfischer, e o impacto é
robusto à escolha — mas a reescrita do `.tex` ficou fora desta rodada por
decisão do autor e virou item próprio do Tema A em `registro/pendencias.md`.

⚠ Uma terceira formulação foi levantada e **recusada na mesma data**: defender
`p = 6` como *padrão da literatura brasileira*. Não há nada no repositório que
a sustente — das 45 entradas de `paper/references.bib` a única brasileira é
`goncalves2025`, evidência **diária** sem VAR de fatores mensal —, o
levantamento da prática brasileira não foi feito, e a frase custaria duas ou
três chaves contra o orçamento de 25. A defesa verificável é a de cima:
fidelidade ao desenho replicado, mais a varredura desta nota.
