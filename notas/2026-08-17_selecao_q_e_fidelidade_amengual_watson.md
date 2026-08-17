# Seleção de `q`: a fidelidade da tradução está fechada, a discordância do critério não

> **CURRENT.** Rodada de 2026-08-17 sob a produção de 111 séries
> `drop_setor_externo__eua__credito__imoveis`, `(r,p) = (5,6)`,
> `z_jk_bs_purif` × `yield_6m`, amostra completa 2013-01 a 2025-09.
> Scripts: `script/validate_amengual_watson.R` (novo) e `script/q_selection.R`
> (novo), mais o alargamento de `script/mosw_strength_grid.R` para `q = 2:r`.
> Saídas: `output/validation/amengual_watson_validation.md`,
> `output/factors/q_selection.{csv,md}`, `output/instrument/mosw_strength_grid.csv`.
> **Produção não muda.** O item de `q` continua **aberto** — esta nota entrega
> os números, não a decisão.

## 1. A pergunta e o veredito

O Tema E de `registro/pendencias.md` mantinha dois itens acoplados: a função
`amengual_watson()` era tradução sem `validate_*.R`, e o critério que ela
implementa escolhe `q = 2` ou `3` contra o `q = 5` de produção. O item de
fidelidade estava escrito na premissa de que a fidelidade **decidiria** o outro:
se a tradução estivesse errada, a discordância seria espúria.

**Veredito, em três partes:**

1. **A tradução é fiel.** Casada a convenção de padronização, ela reproduz o
   `amengual_watson.m` de Stock-Watson a precisão de máquina.
2. **A discordância não é artefato de tradução, e o motivo é o oposto do que a
   primeira leitura sugere.** O `apply_bll = TRUE` não é uma variante caseira: é
   o espaço fatorial da própria produção, diferenciado — que é justamente o
   objeto estacionário que Amengual-Watson exige. O `q = 2` vem do caminho
   admissível; o `q = 5` que coincide com a produção vem de rodar o critério no
   painel de níveis, onde Bai-Ng não vale.
3. **Mas a célula que o critério indica não identifica.** Em `(5,2)` e `(5,3)`,
   ξ_mp fica **abaixo de 3,84** na amostra completa, de modo que o conjunto de
   Anderson-Rubin a 95% é ilimitado. Pela régua de força do próprio projeto, a
   IRF dessas células é um número sem identificação atrás.

O item de `q` portanto **não fecha**: ele deixou de ser uma dúvida sobre código
e virou um conflito entre dois critérios do projeto — o de dimensão e o de
força — que só o autor resolve.

## 2. Fidelidade: o isolamento é exato

`script/validate_amengual_watson.R` transcreve literalmente `amengual_watson.m`,
`factor_estimation_ls.m` (caso balanceado, sem fatores observados e sem
`lambda_constraints`) e `bai_ng.m`, com os parâmetros do próprio SW
(`nt_min = 20`, `tol = 1e-8`, `favar_kilian.m:57-59`), e roda contra a fixture
commitada `output/validation/amengual_watson_fixture.csv` — o painel de produção.
Não há MATLAB nem Octave nesta máquina, então a transcrição *é* o instrumento,
como no Check A de `validate_hac_kernel.R`.

| checagem | resultado |
|---|---|
| `q_hat`, MATLAB contra projeto | **5 contra 5**, acordo exato |
| gap em `aw` com a mesma padronização | **0,0068259651** em todas as 5 entradas, dispersão **4,163e-16** |
| a constante esperada | `log(147/146)` = **0,0068259651** |
| gap com a flag como está no projeto | média **1,636893**, dispersão **1,849e-02** |

A constante é exatamente a diferença entre o desvio padrão **populacional** que o
`nanstd .* mult` do MATLAB produz e o **amostral** do `sd()` do R. Ou seja: o que
separa as duas implementações é uma escolha de denominador, não um desvio de
algoritmo.

**A única diferença de substância** é que `factor_estimation_ls.m` padroniza a
matriz de resíduos coluna a coluna antes do PCA e do `ssr`, e a versão do projeto
chama `bai_ng_criteria(resid_mat, standardize = FALSE)`. Como é reescala **por
coluna**, e não por constante comum, ela **pode** mover o `argmin` em outro
painel. Neste não move — é o acordo da primeira linha da tabela. Fica registrado
como ressalva, não como defeito.

Duas diferenças mapeadas antes e descartadas: o `trend` da linha 20 de
`amengual_watson.m` é índice de linha (`ii = tmp(:,1)`), não regressor, e o
projeto está certo em não incluí-lo; `packr` e `nt_min` só agem em painel
desbalanceado.

## 3. O que `apply_bll = TRUE` de fato é

Medido nesta rodada, contra `estimate_static_factors()`:

- os autovetores de `cov(yy)` **são** o `lambda` da produção — desvio máximo em
  valor absoluto **2,165e-15**;
- `cor(PC_k(yy), diff(F_prod)_k)` = **1,000000** nos cinco fatores.

A produção padroniza os níveis pelo desvio padrão das diferenças e tira as
loadings da covariância das diferenças (`estimate_static_factors:242-289`); o
painel nunca é diferenciado. O `apply_bll` das funções de critério troca o painel
por `yy`. São operações diferentes, mas geram **o mesmo espaço fatorial**, um em
nível e o outro em diferença. Como o critério exige estacionariedade, é a versão
diferenciada que ele pode ler.

Consequência para a leitura, e é o ponto que inverte o item como estava escrito:
**o `q = 5` do caminho de níveis não é endosso da produção.** É o comparável de
fidelidade, na ferramenta que `.claude/rules/identification.md` exclui neste
painel.

## 4. As três células lado a lado

Amostra completa, `nboot = 800`, seed 123, bandas 68/90.
Fonte: `output/factors/q_selection.{csv,md}` e
`output/instrument/mosw_strength_grid.csv`.

| q | ξ_mp | F_rob,mp | AR limitado | bandas válidas | impacto_mp_pre | raiz máxima |
|---|---|---|---|---|---|---|
| **5** (produção) | **6,271** | 10,12 | sim | não | 8,426e-05 | 0,964858 |
| 3 | 3,149 | 3,66 | **não** | não | 2,471e-05 | 0,964858 |
| 2 (critério BLL) | 3,809 | 4,824 | **não** | não | 2,690e-05 | 0,964858 |

Impacto em h = 0 nas cinco obrigatórias:

| variável | q=5 | q=3 | q=2 |
|---|---|---|---|
| `yield_6m` | 0,005 | 0,005 | 0,005 |
| `yield_2y` | 0,00743006 | 0,01497210 | 0,01414646 |
| `yield_5y` | 0,00776115 | 0,02050525 | 0,01908602 |
| `asset_ibov` | −1,7226767 | −22,425902 | −21,771082 |
| `cambio_usd` | 0,15792807 | 0,50029182 | 0,37155046 |

Exclui zero a 90% no impacto: em `q = 5`, quatro das cinco — `asset_ibov` **não**.
Em `q = 3` e `q = 2`, **as cinco**.

## 5. O número inconveniente, dito por inteiro

**As células que o critério indica produzem resultados maiores e mais
significativos do que a produção**, inclusive recuperando o bloco acionário no
impacto, que é justamente o resultado nulo que o paper hoje precisa qualificar.
Ler isso como argumento a favor de migrar seria o erro. Duas medidas explicam por
quê:

- **A normalização.** `impacto_mp_pre` cai de 8,426e-05 em `q = 5` para 2,471e-05
  em `q = 3` — denominador **3,4 vezes menor**, e toda IRF da célula é dividida
  por ele. Isso responde por cerca de 3,4× dos 13× de aumento em `asset_ibov`; o
  resto vem da própria coluna estimada, que também cresce.
- **A força.** As duas células estão **abaixo de 3,84**, o limiar em que o
  conjunto de Anderson-Rubin deixa de ser limitado. Magnitude maior com
  instrumento mais fraco é a assinatura clássica de viés de instrumento fraco,
  não de um resultado melhor.

Nada disso torna `q = 5` correto por seleção. Ele continua sendo o que era: uma
escolha operacional associada a `r = 5`, agora com a informação adicional de que
o critério discorda **e** de que a alternativa que ele aponta não passa na régua
de força. A raiz máxima é a mesma (0,964858) nas três, então estabilidade não
desempata.

## 6. O que fica aberto

- **A decisão de `q` é do autor.** As saídas possíveis não são só "manter" e
  "migrar": há a de reportar a discordância como limitação declarada no §3.5, e a
  de procurar um critério de `q` que não dependa de diferenciar o painel.
- **A ressalva da padronização do 2º estágio** (§2) não foi corrigida: mudar
  `standardize` em `amengual_watson()` alteraria os `q_hat` registrados em
  `notas/2026-08-13_selecao_fatores_blocos_fatoriais.md` para 64 painéis × 2
  amostras. É mudança de critério, não de estilo, e precisa de decisão própria.
- **A grade de força agora cobre `q = 2:r`** para todos os `r` de 5 a 8. As 224
  linhas antigas foram reproduzidas com desvio **0**; as 128 novas são aditivas.
