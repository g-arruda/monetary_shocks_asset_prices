# Validação de `amengual_watson()` contra o MATLAB de Stock-Watson

Gerado por `script/validation/validate_amengual_watson.R` em 2026-09-17.
**Corpo gerado — não escrever prosa aqui.**

Fixture: `output/validation/amengual_watson_fixture.csv`, o painel de produção de 111 séries e 153 meses. Parâmetros do original: `nt_min = 20`, `tol = 1e-08` (`favar_kilian.m:57-59`).

## A. Fidelidade do motor — caminho sem BLL

O `amengual_watson.m` original não conhece BLL, então o único caminho com contrapartida no MATLAB é `apply_bll = FALSE`. É ele que esta seção compara.

| q | aw_matlab | aw_projeto | aw_projeto_std |
|---|---|---|---|
|     1 | -0.091648 | -1.585094 | -0.098382 |
|     2 | -0.156408 | -1.636697 | -0.163142 |
|     3 | -0.216693 | -1.704682 | -0.223427 |
|     4 | -0.280541 | -1.761777 | -0.287275 |
|     5 | -0.359381 | -1.817903 | -0.366115 |

### A1. Seleção: MATLAB **5**, projeto **5** — acordo exato

É o que o critério existe para responder, e as duas implementações respondem igual.

### A2. Isolamento: sob a mesma convenção de padronização, o acordo é numérico

A coluna `aw_projeto_std` é a do projeto com a padronização do 2º estágio ligada — o único ponto em que as duas implementações fazem coisas diferentes. Contra o MATLAB ela deixa:

- gap **0.0067340322** em todas as 5 entradas, com dispersão **6.523e-16** — constante a precisão de máquina;
- e essa constante é exatamente `log(149/148)` = **0.0067340322**, a diferença entre o desvio padrão populacional que o `nanstd .* mult` do MATLAB produz e o amostral do `sd()` do R.

Ou seja: casada a convenção, **a tradução reproduz o original**. O que resta é uma escolha de denominador, não um desvio de algoritmo.

### A3. O que a flag como está no projeto custa

`bai_ng_criteria(resid_mat, standardize = FALSE)` deixa os resíduos crus onde `factor_estimation_ls.m` os padronizaria coluna a coluna. O gap contra o MATLAB passa a **1.480297** em média com dispersão **3.492e-02** — não é constante, e reescala por coluna **pode** mover o `argmin` em outro painel. Neste não move: é o acordo de A1.

As outras duas diferenças mapeadas não têm efeito:

- O `trend` da linha 20 de `amengual_watson.m` é **índice de linha**, usado para devolver o resíduo à posição certa (`ii = tmp(:,1)`), não regressor. A versão do projeto não o inclui, e está certa.
- `packr` e o guarda `nt_min` só agem em painel desbalanceado. Aqui não há NaN além das `p` primeiras linhas do `lagmatrix`, que as duas implementações descartam igual.

## B. O que `apply_bll = TRUE` faz

`apply_bll = TRUE` não é um espaço fatorial rival: é **o espaço fatorial da produção, diferenciado**. Medido nesta rodada:

- Os autovetores de `cov(yy)` **são** o `lambda` da produção (`estimate_static_factors`): desvio máximo em valor absoluto **2.165e-15**.
- `cor(PC_k(yy), diff(F_prod)_k)` = 1.000000, 1.000000, 1.000000, 1.000000, 1.000000 nos 5 fatores.

Isso importa para a leitura, não para a fidelidade. Amengual-Watson é um critério de Bai-Ng, que exige estacionariedade; o painel é não-estacionário por desenho. Logo:

- **`q_hat = 2`** vem do caminho BLL, que é o admissível aqui, e **discorda do `q = 5` de produção**.
- **`q_hat = 5`** vem de rodar o critério no painel de níveis. É o comparável de fidelidade ao MATLAB, mas a ferramenta que `.claude/rules/identification.md` exclui neste painel. A coincidência com a produção não é endosso.

## Veredito: **tradução fiel** — mesma seleção, e acordo numérico assim que a convenção de padronização é casada

