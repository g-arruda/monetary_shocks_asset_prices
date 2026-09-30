# Anexo D: a regressão pré-anúncio de Bauer-Swanson e as respostas por camada do instrumento

> **Nota de leitura (2026-09-30):** a `fig:instrumento_camadas`, hoje no Anexo C, passou a
> desenhar outras oito séries (DI 6 meses e 2 anos, BRL/USD, CDS, Focus PIB, IPCA 12 meses e
> Selic, DBGG), por decisão do autor. Ver `2026-09-30_robustez_pandemia`, seção 6.

> **CURRENT — 2026-09-25.** Rodada de apêndice em `paper/paper_anpec.tex`, **sem
> reestimação da produção** e sem nenhuma frase nova no corpo (decisão do autor:
> "apenas coloque os anexos").
> - Produção de 115 séries, 2012-03 a 2025-12, `(r,q,p) = (5,5,4)`, escala de
>   volatilidade COVID de Lenza-Primiceri e conjuntos Anderson--Rubin de 68% e 90%
>   com NW(0).
> - Fecha o item do Tema B de `registro/pendencias.md` aberto em 2026-09-25 (figura
>   das IRFs por camada) e acrescenta a tabela dos coeficientes da ortogonalização,
>   pedida pelo autor no mesmo dia.
> - `R/instrument/build_variants.R` passou a devolver os dois ajustes (`bs_fits`),
>   sem mudar o cálculo: os três CSVs de `data/processed/` saíram idênticos em bytes.
> - Os números das respostas são os do θ̂ reestimado no mesmo dia com o passo de
>   diferença finita mais fino (`2026-09-25_p_sensibilidade_anexo`, §1), que move a
>   produção em no máximo 8e-5 da escala de cada série. A tabela de Bauer-Swanson
>   não depende de θ̂.

## 1. A tabela é a Tabela 3 de Bauer-Swanson

Conferido no texto salvo em `artigos/`: a Tabela 3 de Bauer e Swanson (2023),
"Economic news predicts high-frequency monetary policy surprises", reporta a
regressão da equação (7), `mps_t = α + β'news_t + ε_t`, uma coluna por medida de
surpresa (fator *target*, fator *path*, surpresa NS), com erro padrão entre
parênteses, sem estrelas, preditores agrupados em notícias macroeconômicas e
financeiras, e `R²` ao pé. A constante não aparece. A `tab:bs_ortogonalizacao`
segue esse desenho, com uma coluna por regressão que a construção roda:

- (1) a surpresa do DI de 6 meses (quarta→quinta, p.b.), cujo resíduo, somado nas
  semanas de reunião de cada mês, é `z_bs_purif`;
- (2) o retorno do Ibovespa no mesmo dia (%), cujo resíduo entra no filtro de sinal.

Diferenças em relação a BS, todas declaradas na legenda:
- a amostra são as **638 quintas-feiras válidas** (102 após reunião do Copom), não
  só as semanas de anúncio, porque é assim que `build_variants.R` estima;
- não há notícias macroeconômicas, que não têm contrapartida diária no Brasil (a
  §3.3 já dizia isso ao comparar o `R²` 0,022 com os 0,12--0,20 deles);
- tendência linear incluída e não reportada, como a nota da Tabela 2 deles faz com
  constante e tendência;
- EP **HC1**, não bootstrap: BS reamostram porque seus fatores GSS são regressores
  gerados, e aqui a surpresa é uma variação observada. HC1 é o mesmo estimador do
  `F_rob` da `tab:first_stage`;
- uma linha a mais, a Wald conjunta HC1 dos oito preditores.

Números (`output/instrument/bs_orthogonalization.csv`):

| | DI (1) | Ibovespa (2) |
|---|---|---|
| `R²` | 0,0216 | 0,0148 |
| Wald conjunta, F / p | 1,569 / 0,131 | 1,153 / 0,326 |
| \|t\| > 1,96 | Brent 0,050 (0,023); Focus Selic 1,209 (0,605) | Ibovespa −0,016 (0,007) |
| 1,64 < \|t\| < 1,96 | inclinação do DI −0,920 (0,498) | — |

⚠ **A previsibilidade não é significativa em conjunto** (p 0,131 no DI, 0,326 no
Ibovespa). A ortogonalização remove um componente que a Wald não distingue de zero,
o que casa com o efeito pequeno que ela tem na força (ξ_mp 6,68 → 6,16). O paper
imprime o p na tabela e não comenta.

## 2. As respostas por camada

`script/instrument_layers_irf.R` roda `run_stage2_cell()` três vezes na produção,
trocando só o instrumento. Cada camada tem os seus conjuntos AR de 68% e 90%
(ξ_mp 6,85 / 6,16 / 6,68 > 3,84), e **todos são `interval`**, exceto o `singleton` da
normalização, em 115 séries × h 0--36: 4254 + 1 por camada e nível
(`output/irf/instrument_layers_irf.csv`). A figura `fig:instrumento_camadas` segue o
desenho da `fig:q_sensibilidade`: a produção com os conjuntos, as outras duas
camadas em ponto. A linha de produção confere com `irf_coherence_h.csv` a 1e-10.

**Contenção.** Nenhum ponto de `z_bruto` ou de `z_bs_purif` sai do conjunto de 90%
da produção, em nenhuma das 115 séries e em nenhum horizonte até 36 (0 de 4255 em
cada camada). Do conjunto de 68% saem 4 pontos de `z_bs_purif` e nenhum de
`z_bruto`.

**Impactos, nas unidades da §4** (h = 0):

| série | produção | + ortogonalização | bruta |
|---|---|---|---|
| DI 2 anos (p.b.) | 70,1 | 62,9 | 62,6 |
| DI 5 anos (p.b.) | 72,9 | 62,3 | 61,4 |
| Câmbio BRL/USD (%) | 3,23 | 2,38 | 2,39 |
| CDS 5 anos (p.b.) | 30,5 | 24,8 | 24,0 |
| IBC-Br (%) | −0,66 | −0,76 | −0,68 |
| IPCA (p.p. ao mês) | −0,045 | −0,038 | −0,049 |
| Ibovespa (%) | **−1,50** | **+0,19** | **+0,27** |
| DLSP (p.p. do PIB) | −0,67 | −0,59 | −0,58 |

Leitura:
- **As duas camadas sem filtro são quase a mesma curva.** A ortogonalização move pouco
  o ponto, como move pouco a força.
- **O filtro de sinal amplia os impactos de juros longos, câmbio e CDS** em 12% a
  36% (DI de 2 anos 70,1 contra 62,9; câmbio 3,23 contra 2,38), e é a camada que dá
  à produção o seu nível.
- ⚠ **O impacto do Ibovespa troca de sinal com o filtro**, de +0,2/+0,3% para −1,5%.
  É mecânico: a regra JK retém os dias em que DI e Ibovespa andam em direções
  opostas, e então o instrumento filtrado correlaciona negativamente com a inovação
  das ações por construção. Nenhuma das três camadas exclui zero em h0 no Ibovespa
  (produção: 90% [−8,33; 3,50]). Esta é a linha que um parecerista usaria, e por isso
  fica registrada aqui.
- Em h = 12 as camadas sem filtro já estão abaixo de zero na curva (2 anos −7,8 e
  −5,8 p.b.) e no câmbio (−0,63 e −0,69%), enquanto a produção ainda está positiva
  (13,5 p.b., 0,13%). A reversão chega uns meses antes sem o filtro.

**A hipótese deixada pela nota superada `2026-07-15_sweep_instrumentos_irf`** — as
formas se sobrepõem e a inclinação da curva não acompanha ξ_mp — **se confirma na
vintage de produção**: as três camadas desenham a mesma forma, e a camada com maior
ξ_mp é a que tem os maiores impactos na curva, mas a ordem entre bruta (6,68) e
ortogonalizada (6,16) não se reflete nas respostas, que são quase iguais.

## 3. Código

- `R/reporting/sensitivity.R`, novo: `stack_cell_paths()`, `stop_unless_interval_sets()`,
  `stop_unless_matches_cache()` e `rescale_to_paper_units()`, extraídos de
  `q_sensitivity.R` quando o mesmo passo passou a se repetir em três scripts
  (`q_sensitivity.R`, `p_sensitivity.R`, `instrument_layers_irf.R`).
  `q_sensitivity.R` foi refatorado sobre eles, e a tabela de caminhos saiu igual nas
  duas janelas (ver `2026-09-25_p_sensibilidade_anexo`).
- `script/instrument.R` escreve `output/instrument/bs_orthogonalization.csv`, e
  `run_all.R` o declara entre as saídas do estágio `instrument`.
