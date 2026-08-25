# O bloco de preços através da escada de instrumentos

> **CURRENT.** Rodada de 2026-08-18 sob a produção de 111 séries
> `drop_setor_externo__eua__credito__imoveis`, `(r,q,p) = (5,5,6)`,
> `yield_6m` +50bp, amostra cheia (2013-01 a 2025-09) e pré-COVID
> (2013-01 a 2019-12). Script novo: `script/price_cross_instrument.R`.
> Saídas: `output/irf/price_cross_instrument.{csv,md}`,
> `price_cross_instrument_pre_covid_bands.csv`,
> `price_cross_instrument_pre_covid_cell.rds`,
> `price_cross_instrument_paths.pdf`. Fecha o item D de
> `registro/pendencias.md` e substitui, no que diz respeito ao desenho e aos
> números, a nota de 2026-07-12.

## 1. A pergunta e o desenho

A pendência pedia a comparação cross-instrumento do IPCA na dimensão de
produção. O argumento que ela tinha de decidir vem de
[`2026-07-12_price_puzzle_ipca`](2026-07-12_price_puzzle_ipca.md): a alta de
curto prazo dos preços ao consumidor na amostra cheia seria uma propriedade da
**amostra** e não da construção do instrumento, porque (i) aparecia em todos os
instrumentos e (ii) sumia na janela pré-COVID. Aquela nota está superada em
duas frentes: foi escrita sob `z_jk_purif × (6,5)`, e metade da sua evidência
eram os quatro instrumentos identificados por heterocedasticidade, abandonados
em 2026-08-17 e não citáveis.

**O desenho executado não é a varredura das oito variantes.** Por decisão do
autor, são **três construções aninhadas**, cada uma acrescentando exatamente
uma camada, a terceira sendo a produção:

| degrau | coluna | valores | máscara |
|---|---|---|---|
| 1. surpresa bruta | `z_bruto` | `delta_di` | nenhuma |
| 2. + residualizada por informação predeterminada | `z_bs_purif` | `e_di_bs` (Bauer-Swanson eq. 7) | nenhuma |
| 3. + filtro de sinal | `z_jk_bs_purif` | `e_di_bs` | `jk_monetary_bs` |

O aninhamento é o que dá poder de leitura: o passo 1→2 isola a camada de
**valores** e o passo 2→3 isola a camada de **seleção**, que é a distinção que
a rodada do instrumento já havia medido (`.claude/rules/instrument.md`:
*strength lives in the mask, not the purified values*). `z_bruto_purif` e
`z_jk_purif` ficam de fora de propósito: usam `e_di`, a purificação
**contemporânea**, cujo lado direito pode absorver o próprio choque.

**O que este desenho não pode dizer.** Os três degraus partem da mesma surpresa
de DI em dia de Copom — por construção, já que são aninhados. A concordância
entre eles diz que o padrão não é **produzido** pela purificação nem pelo filtro
de sinal. Ela **não** diz que o padrão é comum entre *esquemas* de
identificação; a perna que dizia isso morreu com a rota de heterocedasticidade.

O bloco avaliado é o de preços inteiro, herdado de `coherence_var_table()`: seis
medidas pontuadas (`price_ipca`, difusão, EX0, EX1, médias aparadas, INPC) e
duas ambíguas (IGP-M, IPP). A janela de leitura é **h2–h8**, onde a corcova
vive, e não a janela h12–h48 que a régua de coerência pontua.

## 2. Força: a janela forte é a que não produz a corcova

| janela | degrau 1 | degrau 2 | degrau 3 (produção) |
|---|---|---|---|
| cheia | 5,271 | 4,368 | **6,271** |
| pré-COVID | 14,862 | 13,982 | **10,993** |

Na amostra cheia **nenhum dos três degraus alcança 10**, e os três passam de
3,84: o conjunto AR de 95% é limitado, mas as bandas convencionais não valem, de
modo que a comparação sustenta **sinal e direção, nunca intervalo**. No
pré-COVID os três passam de 10.

Isso é o próprio argumento contra erro de identificação: a janela em que o
instrumento é **mais forte** é justamente a que **não** produz a corcova. Se
`H = (Z'η)/(Z'Z)` estivesse projetando o choque errado, o defeito deveria
aparecer onde a identificação é melhor, e ocorre o oposto.

## 3. Amostra cheia: a corcova é comum aos três degraus

`price_ipca`, pontos percentuais da taxa mensal:

| degrau | h2 | h3 | h4 | h5 | h6 | h7 | h8 |
|---|---|---|---|---|---|---|---|
| 1. bruta | −0,0620 | −0,0248 | +0,0496 | **+0,1425** | +0,1061 | +0,1395 | +0,1383 |
| 2. residual | −0,0551 | −0,0121 | +0,0744 | **+0,1739** | +0,1350 | +0,1722 | +0,1711 |
| 3. produção | −0,0242 | +0,0093 | +0,0496 | +0,1092 | +0,0886 | +0,1144 | **+0,1145** |

Os três degraus dão o mesmo formato — negativo no impacto e em h2, positivo de
h4 em diante, máximo em h5 nos dois primeiros e em h8 na produção. Nas **oito**
séries do bloco o máximo em módulo dentro de h2–h8 é positivo nos **três**
degraus (8 de 8 séries, 3 de 3 degraus). A corcova não é produzida pela
purificação nem pelo filtro de sinal.

## 4. A decomposição por camada, que é o que o aninhamento entrega

Sobre o máximo em módulo em h2–h8:

- **Camada de valores (1→2), a residualização Bauer-Swanson: amplifica.**
  `delta_valores` aumenta o módulo da resposta em **16 de 16** células (oito
  séries × duas janelas). No IPCA cheio, +0,1425 → +0,1739.
- **Camada de seleção (2→3), o filtro de sinal: encolhe.** `delta_selecao`
  reduz o módulo em **8 de 8** séries na amostra cheia e em **6 de 8** no
  pré-COVID. No IPCA cheio, +0,1739 → +0,1145, uma queda de 34%.

**Isto contradiz a nota de 07-12 no seu ponto 2.** Aquela nota afirmava que "o
filtro JK não reduz a corcova", comparando `z_bruto` (h6 +0,10) com
`z_jk_purif` (h6 +0,17) e concluindo que a hipótese de contaminação por
*information shocks* ficava descartada. A comparação misturava as duas camadas
e usava a purificação contemporânea. Separadas, elas têm sinais opostos e a de
seleção tem o sinal que Jarociński-Karadi preveem. O filtro **atenua** a
corcova; o que ele não faz é eliminá-la.

⚠ **Ressalva de magnitude, obrigatória.** `impact_mp_pre` — o denominador pelo
qual toda a IRF da célula é dividida — é 4,325e-05 no degrau 2 e 8,426e-05 no
degrau 3. Só a aritmética da normalização preveria uma razão de 0,513 entre os
dois; a observada é 0,659. A atenuação medida é, portanto, **menor** do que o
denominador sozinho produziria, de modo que não é artefato de escala — mas
também não é estimativa limpa de magnitude, porque as duas coisas se movem
juntas. Abaixo de ξ_mp 10 o que a comparação sustenta é o **sinal** de
`delta_selecao`, não o seu tamanho.

## 5. Pré-COVID: a corcova se inverte, e há bandas pela primeira vez

A célula pré-COVID `(5,5)` nunca havia sido bootstrapada — a etapa 2 só rodou
pré-COVID em `(7,6)` e `(6,5)`. Ela foi rodada aqui com 800 réplicas, semente
123.

No ponto, `price_ipca` é negativo em h6 e h7 nos três degraus (−0,141/−0,149/
−0,092 em h6). O máximo em módulo de h2–h8 é negativo nos três (−0,168/−0,177/
−0,096). Nas outras séries a inversão **não é uniforme**: IGP-M, INPC e o
headline invertem nos três degraus; EX0, difusão e IPP permanecem positivos nos
três; EX1 e médias aparadas invertem nos degraus 1 e 2 mas não na produção.

## 6. Os números inconvenientes

1. **Pré-COVID troca a corcova de curto prazo por uma falha de médio prazo.**
   Em h24 o headline vira **positivo** nos três degraus (+0,089/+0,096/+0,112),
   e a régua de coerência aplicada à célula pré-COVID bootstrapada declara as
   **seis** medidas pontuadas `incoerente`, com `share_correct` entre 0,162 e
   0,486 na janela h12–h48. O "negativo em todos os horizontes" da nota de
   07-12 **não sobrevive**.
2. **A perna pré-COVID não tem significância.** Na célula bootstrapada, varrendo
   h = 0..48, as únicas células sig90 do bloco inteiro são `price_ipp` em h1 e
   h2. Nenhuma medida de preço ao consumidor exclui zero a 90% em horizonte
   nenhum. A desinflação pré-COVID é uma afirmação de **sinal do ponto**, com
   bandas que contêm zero em toda parte.
3. **A correção de Kilian não convergiu no DGP do bootstrap pré-COVID.** A raiz
   máxima da companion é 1,000202, já acima de 1, então o encolhimento esgota as
   iterações. O ponto é OLS puro e não é afetado; as **bandas** desta célula são
   o objeto afetado, o que reforça o item 2 em vez de contradizê-lo.
4. **Os números do "contexto novo" da própria pendência estavam vencidos.** Ela
   citava `price_ipca` sig90 em h5, EX0 em h2 e h4–h8, médias aparadas em
   h4/h5/h7, e o veredito `incoerente` de EX0 — tudo do vintage `(7,6)` de 106
   séries. Na produção corrente, varrendo h = 0..48, as únicas células sig90 do
   bloco são **EX0 em h5, h7 e h8** e **IPP em h0–h3**; o IPCA cheio **nunca** é
   sig90; e EX0 é `parcial`, com cinco das seis medidas em `coerente`.

## 7. O que a §4.5 pode e não pode afirmar

**Pode:**

- que a alta de curto prazo dos preços ao consumidor aparece nas três
  construções do instrumento, de modo que não é produzida pela residualização
  sobre informação predeterminada nem pelo filtro de sinal;
- que o filtro de sinal a **atenua** sem eliminá-la, e que a residualização a
  amplifica, com a ressalva de que abaixo de ξ_mp 10 o que se lê é sinal;
- que na janela pré-COVID, onde o instrumento é mais forte nos três degraus, o
  headline responde negativamente em h6–h7;
- que a alta não é significativa a 90% em horizonte nenhum na produção corrente,
  e que a desinflação pré-COVID também não é.

**Não pode:**

- chamar o padrão de *price puzzle* (decisão editorial de 2026-08-18);
- dizer que o padrão é comum entre **esquemas** de identificação, ou citar
  heterocedasticidade e GMR como corroboração;
- afirmar que o pré-COVID "resolve" o problema, porque ele o troca por um médio
  prazo que a régua declara incoerente nas seis medidas;
- ler magnitudes entre degraus sem o denominador de normalização ao lado.

## Arquivos-fonte

- `output/irf/price_cross_instrument.csv` — 2.352 linhas, 2 janelas × 3 degraus
  × 8 séries × h = 0..48.
- `output/irf/price_cross_instrument.md` — relatório gerado, com força,
  h2–h8, deltas por camada e a célula pré-COVID com bandas.
- `output/irf/price_cross_instrument_pre_covid_bands.csv` e
  `price_cross_instrument_pre_covid_cell.rds`.
- `output/irf/irf_coherence_h.csv` — produção cheia, para os itens 4 do §6.
