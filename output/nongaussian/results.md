# Identificação não-gaussiana (GMR 2017) — resultados

Gerado por `script/model_nongaussian.R` em 2026-07-27.
r = 7, q = 6, p = 6, h = 0-48, nboot = 200, seed = 123.

A identificação vem da **não-gaussianidade** das q inovações fatoriais
(Gouriéroux-Monfort-Renne 2017, pseudo-ML sob SIR3). O instrumento não
identifica nada aqui: apenas **rotula** qual coluna estimada é a monetária.
Pré-requisito e sua avaliação: [`gate.md`](gate.md).

## 1. Estimativa e rotulagem

- Coluna monetária: **6** de 6
- |cor(ε_mp, z)| = **0.198**; segunda colocada 0.186; folga **0.012**
- Pseudo log-verossimilhança: -1209.61 (1/60 partidas no melhor ótimo)
- cond(A) = 3.704e+01

> **Ressalva de rotulagem.** A folga entre a coluna escolhida e a segunda é de apenas 0.012. O ICA estima as colunas com precisão, mas o *nome* "monetária" é atribuído por uma correlação que mal distingue duas delas.

## 2. Testes

### 2.1 A restrição do proxy é rejeitada?

Sob a identificação não-gaussiana o proxy deixa de ser hipótese mantida e
vira restrição testável: a direção de impacto `H = (Z'η)/(Z'Z)` deveria
coincidir com a coluna monetária do ICA.

- Alinhamento: **cos(b_GMR, H_proxy) = 0.6151**
- Wald na coluna: ξ = **117.333**, gl = 5, **p = 0.0000**

A restrição do proxy é **rejeitada a 5%**: as duas identificações não apontam para a mesma direção estrutural. Isso é informação, não falha — significa que pelo menos uma das duas está mal especificada, e o paper tem de escolher qual reportar como primária com argumento.

> Este teste é uma **adaptação** da §2.5: o artigo testa `C ∈ P(C_0)` com
> χ²(n(n−1)/2); aqui a restrição toca uma coluna só, então a forma quadrática
> usa o bloco correspondente de V com pseudo-inversa e gl = n−1.

### 2.2 Teste literal da §2.5: H0: C ∈ P(Id)

- ξ = **148.431**, gl = 15, **p = 0.0000**

É o esquema recursivo (Cholesky) nas inovações fatoriais — a restrição que a literatura impõe sem testar. Rejeitada a 5%.

## 3. Robustez à pseudo-densidade (Prop. 3)

A Prop. 3 do GMR garante consistência **mesmo com `g` mal especificada**.
Se isso vale aqui, a coluna monetária não deve depender da família escolhida.
Mas a Prop. 3 pressupõe a **A.5** (pseudo-densidades distintas *e* assimétricas);
as famílias abaixo a violam em graus diferentes, de propósito, para separar as
duas coisas.

| família | A.5 | coluna | \|cor\| | cos vs baseline | cos vs proxy | log-lik |
|---|---|---:|---:|---:|---:|---:|
| misturas de gaussianas (baseline) | satisfeita (distintas e assimétricas) | 6 | 0.198 | 1.0000 | 0.6151 | -1209.61 |
| Student-t (5..10 gl) | parcial — distintas mas **simétricas**, sinais não fixados | 3 | 0.235 | 0.9162 | 0.7290 | -1199.03 |
| secante hiperbólica | **violada** — idênticas e simétricas, todo P(C) empata | 4 | 0.239 | 0.9387 | 0.7419 | -802.42 |

> A secante hiperbólica é um **contra-exemplo deliberado**, não uma alternativa:
> com q densidades idênticas e pares todo elemento de P(C) atinge o mesmo máximo
> (GMR §2.2), então o que ela estima não é interpretável. Está na tabela para
> mostrar que a A.5 morde. A comparação que testa a Prop. 3 é a linha Student-t
> contra o baseline: formas funcionais bem diferentes, ambas admissíveis.

## 4. IRFs no impacto — manchetes do §5

| variável | GMR não-gaussiano | proxy-SVAR | razão |
|---|---:|---:|---:|
| yield_6m | 0.0050 | 0.0050 | 1.00 |
| yield_2y | 0.0109 | 0.0092 | 1.18 |
| yield_5y | 0.0123 | 0.0093 | 1.33 |
| asset_ibov | -10.7182 | -1.6726 | 6.41 |
| cambio_usd | 0.2382 | 0.1498 | 1.59 |
| price_ipca | -0.0759 | -0.0703 | 1.08 |
| embi_perc | 0.4418 | 0.1995 | 2.21 |
| commodity_metal | 11.9971 | 10.4064 | 1.15 |

Figura: [`irf_comparison.pdf`](irf_comparison.pdf). Série completa em
[`irf_comparison.csv`](irf_comparison.csv).

### Bandas de 90% no impacto — a leitura que decide

| variável | GMR (ponto) | GMR CI90 | proxy (ponto) | proxy CI90 |
|---|---:|---|---:|---|
| yield_6m | 0.005 | [0.005, 0.005] | 0.005 | [0.005, 0.005] |
| yield_2y | 0.011 | [-0.005, 0.020] | 0.009 | [0.007, 0.013] |
| yield_5y | 0.012 | [-0.023, 0.027] | 0.009 | [0.007, 0.016] |
| asset_ibov | -10.718 | [-49.459, 80.784] | -1.673 | [-7.599, 1.785] |
| cambio_usd | 0.238 | [-0.519, 0.657] | 0.150 | [0.085, 0.299] |
| price_ipca | -0.076 | [-1.354, 1.785] | -0.070 | [-0.399, 0.142] |
| embi_perc | 0.442 | [-1.739, 1.841] | 0.200 | [0.094, 0.536] |
| commodity_metal | 11.997 | [-21.142, 42.504] | 10.406 | [4.832, 18.605] |

## 6. Reconciliação: a Wald assintótica e o bootstrap discordam

As duas inferências deste ramo dão respostas opostas e é preciso escolher.

- **Assintótica (Prop. 4):** rejeita a restrição do proxy com p = 0.0000.
- **Bootstrap i.i.d. (200 draws):** cosseno mediano 0.703 entre a direção do
  draw e a do ponto, com **0.490** dos draws abaixo de 0,7 — e as bandas de
  90% no impacto contêm zero em **todas** as variáveis exceto a normalizada.

A simulação do bloco D de `validate_gmr_ica.R` desempata: em T = 150 e n = 6 — exatamente esta dimensão — o intervalo nominal de 95% da Prop. 4 cobre **0,79**. Os erros-padrão assintóticos são pequenos demais aqui, então a rejeição da restrição do proxy é **provavelmente espúria**.

> **Conclusão.** O estimador GMR não contradiz o proxy neste painel: ele é
> **pouco informativo**. O ponto de −10,7% no `asset_ibov` vem com CI90 de
> [−49, +81], compatível com quase qualquer coisa. Isso não desqualifica a
> rota como *teste* (o esquema recursivo é rejeitado, e o próprio artigo usa
> a identificação assim), mas desqualifica-a como **estimativa concorrente**
> das magnitudes do §5.

## 5. Estabilidade do bootstrap

- Cosseno mediano entre a direção do draw e a do ponto: **0.7030**
- Fração de draws com cosseno < 0,7: **0.490**
- Trocas de rótulo: 0 de 200

O ramo GMR usa reamostragem **i.i.d. com reposição**, não o wild bootstrap Rademacher do proxy: o multiplicador ±1 zera os terceiros momentos e destrói a assimetria que a Assumption A.5 exige. É o que o apêndice online do próprio GMR (§E) faz.

> **Ressalva.** Um cosseno mediano de 0.703 indica que a direção monetária estimada se move bastante entre reamostragens. As bandas abaixo já incorporam isso, e é a razão de elas serem largas.

