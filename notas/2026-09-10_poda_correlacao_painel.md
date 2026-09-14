# Poda por correlação: nove séries saem, Bai-Ng cai de 5 para 3 e o `q` de Amengual-Watson fica em 2

> **CURRENT — 2026-09-10.** Rodada feita sob a produção corrente:
> - painel de 115 séries `drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, 2012-03--2025-12, `(r,q,p)=(5,5,4)`;
> - branch `feature/poda-correlacao-painel`;
> - código novo:
>   - `prune_correlated_series()` e a extensão de `base_block_taxonomy()` aos blocos fiscal e de expectativas, em `R/identification/experimental_panel.R`;
>   - o argumento `standardize_resid` de `amengual_watson()`, em `R/modeling/factor_estimation.R`;
>   - `script/panel_pruning.R` e `script/factor_selection_pruned.R`;
> - saídas geradas:
>   - `output/panel_experimental/poda_correlacao/`: `pruning_manifest.csv`, `pairs_above_080.csv`, `panel_pruning.{md,pdf}`;
>   - `output/factors/`: `factor_selection_pruned.{md,pdf}`, `factor_selection_pruned_summary.csv`, `factor_selection_pruned_aw.csv`.
>
> **A produção não muda.** O painel podado é um diagnóstico. Nele não se calculou ξ_mp nem IRF.

## 1. A pergunta

A rodada responde às sugestões 2 e 3 do e-mail do orientador de 2026-09-04 (`email/email_professor_04-09_16h42.md`):
- **Sugestão 2:** "dentro de cada bloco, calcule a matriz de correlação par a par e, para grupos de séries com correlação acima de um limiar (por exemplo, 0,9), mantenha apenas uma série representativa do grupo (ou use a média)".
- **Sugestão 3:** "refazer a seleção de r,q no painel podado e conferir se a divergência em relação a Bai-Ng diminui".

O autor acrescentou uma pergunta: o `q` de Amengual-Watson também muda?

A hipótese vem do e-mail do autor de 2026-09-03 (`email/email_meu_03-09_17h14.md`). Séries muito correlacionadas dentro de um bloco levariam a subestimar `r` e `q`, porque com a padronização cada série pesa igual na PCA e o bloco mais numeroso domina. O orientador apoiou a hipótese em Boivin-Ng (2006). Se ela vale, podar as duplicatas deveria **aumentar** o número de fatores selecionado.

O autor tomou três decisões antes da rodada:
- **Sem ξ_mp e sem IRF no painel podado.** A seleção fica cega à força do instrumento, que é a cautela do e-mail contra *specification search*.
- **Descartar em vez de fazer média.** Cada grupo mantém uma série, e o excesso sai da PCA.
- **Podar entre grupos.** Os grupos saem da matriz do painel inteiro, sem restringir ao bloco. A versão literal do e-mail, dentro do bloco, roda ao lado para comparação.

## 2. O objeto e a regra

**Objeto.** É a correlação das primeiras diferenças na janela de produção, com T = 165 e N = 115.
- A padronização BLL não muda uma correlação. Por isso a matriz é `cor(estimate_static_factors()$yy)`, a mesma que a PCA de produção decompõe. O auto-teste (b) de `panel_pruning.R` confirma a igualdade a 2,2e-16.
- Em nível a correlação seria espúria, porque o painel é não-estacionário.

**Regra.** Foi fixada no plano, antes de qualquer seleção no painel podado.
- **Grupos:** ligação completa (`hclust(method = "complete")`) sobre `1 − |ρ|`, com corte em `1 − 0,90`. A ligação completa garante que **todo par** dentro de um grupo tem |ρ| ≥ 0,90, que é a leitura literal de "grupo de séries com correlação acima de 0,9". Usar |ρ| trata a correlação negativa também como redundância.
- **Série mantida em cada grupo:** `yield_6m`, se estiver no grupo, porque a normalização precisa dela. Senão, a primeira de `yield_2y, yield_5y, asset_ibov, cambio_usd, price_ipca` presente no grupo. Senão, a série de maior |ρ| média contra o resto do bloco.
- **Sensibilidade:** os limiares 0,80, 0,85 e 0,95 e a ligação simples em 0,90.

**Por que não a ligação simples.** Ela encadeia pares. Em 0,90 junta yield 3m-6m-1y-2y num grupo em que o par 3m-2y tem |ρ| = 0,561. Junta também as quatro séries industriais num grupo cujo menor |ρ| é 0,739. Isso já não é um "grupo acima de 0,9".

## 3. O que sai

Na regra principal saem **9 das 115 séries**, e o painel fica com N = 106. São 8 grupos:

| grupo | bloco | mantida | sai | mín. \|ρ\| cheia | mín. \|ρ\| pré-COVID |
|---|---|---|---|---|---|
| 1 | câmbio | `cambio_usd` | `cambio_cny`, `cambio_inr` | 0,916 | 0,896 |
| 2 | curva | `yield_6m` | `yield_3m` | 0,921 | 0,8998 |
| 3 | curva | `yield_2y` | `yield_1y` | 0,925 | 0,926 |
| 4 | curva | `yield_5y` | `yield_10y` | 0,958 | 0,955 |
| 5 | indústria | `ind_bens_consumo` | `ind_bens_nao_duraveis` | 0,947 | 0,954 |
| 6 | indústria | `ind_transformacao` | `ind_bens_duraveis` | 0,907 | 0,875 |
| 7 | ações | `asset_ibov` | `asset_idiv` | 0,938 | 0,935 |
| 8 | preços | `price_ipca` | `price_inpc` | 0,945 | 0,907 |

Nos grupos 5 e 6 a série mantida saiu da regra da maior |ρ| média no bloco. Nos outros seis, da lista de prioridade.

- **Nenhum par entre blocos passa de |ρ| = 0,80.** Os 32 pares acima desse piso estão todos dentro de um bloco. Por isso a poda entre grupos e a poda dentro do bloco dão o mesmo painel nas cinco configurações.
- **⚠ Na pré-COVID, três dos oito grupos não passariam inteiros em 0,90:** câmbio (0,896), `yield_3m`–`yield_6m` (0,8998) e `ind_bens_duraveis`–`ind_transformacao` (0,875). Na margem do limiar, a composição depende da amostra.
- **⚠ As sensibilidades mais frouxas trazem pares que o COVID fabrica.** Em 0,85 e 0,80 saem séries de trabalho. Na pré-COVID, a correlação delas cai de 0,894 para 0,421 (`trab_pop_forca_trab`–`trab_pop_ocupada`) e de 0,897 para 0,664 (`trab_employment_southest`–`trab_employment_south`).
- **Tamanho da poda nas sensibilidades:** em 0,80 saem 18 séries, em 0,85 saem 16, em 0,95 sai só `yield_10y`, e a ligação simples em 0,90 tira 12.

## 4. O resultado da seleção

| estimador | atual (115) | podado (106) |
|---|---|---|
| Bai-Ng IC1 / IC2 / IC3 | 5 / 5 / 20 | 4 / **3** / 11 |
| AH ER / GR | 2 / 2 | 1 / 1 |
| ABC IC*₁ / IC*₂ | 9 / 9 | 11 / 11 |
| Amengual-Watson `q̂`, `r = 5` | 2 | **2** |
| Amengual-Watson `q̂`, `r = r̂_IC2` | 2 | 2 |

**Vereditos pré-registrados:**
- **R1, divergência em relação a Bai-Ng: aumenta.** D = |ER − IC2| + |GR − IC2| + |ABC-IC*₁ − IC2| vai de 10 para 12.
- **R2, hipótese de subestimação: contrária.** `r̂_IC2` cai de 5 para 3, e `q̂_AW(r = 5)` fica em 2.

A coluna do painel atual reproduz as sete estatísticas da rodada AH/ABC de 2026-09-10, pelo auto-teste (a) de `factor_selection_pruned.R`.

## 5. O que o resultado permite dizer

- **A poda não sustenta a hipótese de subestimação. O sentido observado é o oposto.**
  - Tirar as duplicatas reduz o número de fatores que Bai-Ng reconhece. O IC2 cai para 3 no painel principal e em todas as sensibilidades que removem mais de uma série: 0,80, 0,85 e ligação simples. O IC1 cai para 4 ou 3 nessas mesmas configurações.
  - Só em 0,95, onde sai apenas `yield_10y`, Bai-Ng fica em 5. Nenhuma configuração faz `r̂` subir.
  - Isso é compatível com a leitura de que parte da co-movimentação que Bai-Ng contava como fator comum era específica de pares quase duplicados. A rodada, porém, registra a direção e não testa esse mecanismo.
- **⚠ As margens de Bai-Ng são estreitas nos dois painéis.** No atual, IC2(5) = −0,17655 contra IC2(4) = −0,17404. No podado, IC2(3) = −0,14104 contra IC2(4) = −0,13781. A queda de 5 para 3 é robusta em direção, porque se repete em quatro das cinco configurações, mas não em magnitude.
- **A divergência não diminui.** Ela sobe de 10 para 12 porque os dois lados se afastam: Bai-Ng e AH descem, e o ABC sobe para 11. ⚠ Esse veredito depende do limiar. Em 0,80 e 0,85, onde o ABC cai para 5, D cai para 6. Na ligação simples fica em 10. A direção de Bai-Ng não depende do limiar.
- **AH continua lendo 1 ou 2 fatores.** ⚠ Já no painel atual, ER(1) = 1,450 e ER(2) = 1,474 quase empatam. Retirar só `yield_10y` (em 0,95) basta para levar ER e GR de 2 para 1. A mudança de AH é um empate que se desfaz, não um deslocamento.
- **O ABC continua frágil.** O 11 do painel podado vem de um intervalo de 2 pontos da grade (c ∈ [0,68; 0,69]), e logo depois vem um intervalo de 13 pontos para `r̂ = 3`. Nas 100 permutações, o IC*₁ dá 5 em 37, 9 em 28, 3 em 15 e 11 em só 7. É o mesmo padrão do painel atual: o procedimento para no primeiro intervalo estreito depois de `r_max`.
- **O `q` de Amengual-Watson não se move.** Na convenção do projeto, `q̂ = 2` em todos os painéis e em todo `r` de 3 a 8. A poda até alarga a margem em `r = 5`. No atual, IC2(q=2) = −0,451118 contra IC2(q=3) = −0,450142, uma distância de 0,001; no podado, a distância é de 0,011.
- **A ressalva da padronização do 2º estágio (`notas/2026-08-17_selecao_q_e_fidelidade_amengual_watson.md` §2) agora tem número.** Padronizar os resíduos coluna a coluna, como faz `factor_estimation_ls.m`, muda o `q̂` em 2 das 34 células painel × `r`. Nas duas, que são `r = 8` no painel atual e no de 0,95, ele passa a 3. Em nenhuma célula o `q̂` passa de 3.
- **Consequência para o item B4 (`r = q = 8`).** A amarração que o e-mail pedia não aparece. Ela era "nossos próprios dados são consistentes com a hipótese de subestimação por correlação".
  - A rodada AH/ABC deu veredito misto no painel atual. A poda dá veredito contrário.
  - `r = q = 8` ainda pode ser defendido pela comparabilidade com Alessi-Kerssenfischer (nota de rodapé 4). Não pode ser defendido com o argumento de que os dados indicam subestimação.
  - Em `r = 8`, Amengual-Watson dá `q = 2` (3 na convenção do MATLAB), não 8.
- **O paper não deve citar a poda como evidência a favor de mais fatores.**

## 6. O que não foi feito

- ξ_mp e IRF no painel podado, por decisão do autor.
- A média do grupo como alternativa à série representativa, por decisão do autor.
- A seleção na janela pré-COVID. Não foi pedida, como também não foi na rodada AH/ABC.
- A promoção do painel podado. Ele também não foi gravado em `data/processed/`: os painéis são montados em memória a partir do manifesto.

## 7. Verificação

- O smoke test do `CLAUDE.md` sai bit-idêntico nas cinco séries em h0.
- Sobre a fixture de validação, `amengual_watson()` no padrão reproduz a coluna `aw_projeto` de `output/validation/amengual_watson_validation.md` (−1,727473 … −1,971470).
- Com `standardize_resid = TRUE`, reproduz a coluna `aw_projeto_std` (−0,089945 … −0,352427), que `script/validate_amengual_watson.R` tinha montado com um espelho próprio.
- `base_block_taxonomy()` ganhou duas linhas, para os prefixos `fiscal_`/`dlsp_` e `expect_focus_`. O único chamador anterior passa só nomes-base, e a saída dele não muda.
