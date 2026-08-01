# Identificação não-gaussiana (GMR 2017) — resultados

Gerado por `script/model_nongaussian.R` em 2026-08-01.
r = 7, q = 6, p = 6, h = 0-48, nboot = 800, seed = 123.

A identificação vem da **não-gaussianidade** das q inovações fatoriais
(Gouriéroux-Monfort-Renne 2017, pseudo-ML sob SIR3). O instrumento não
identifica nada aqui: apenas **rotula** qual coluna estimada é a monetária.
Pré-requisito e sua avaliação: [`gate.md`](gate.md).

## 1. Estimativa e rotulagem

- Coluna monetária: **2** de 6
- |cor(ε_mp, z)| = **0.200**; segunda colocada 0.154; folga **0.046**
- Pseudo log-verossimilhança: -1208.62 (1/200 partidas no melhor ótimo)
- Partidas pedidas: 200; folga do melhor para o segundo ótimo: 0.4183
- Referência do gate (100 partidas): -1209.30 — este run está **no ótimo do gate ou melhor**
- cond(A) = 3.225e+01



> **Ressalva de rotulagem.** A folga entre a coluna escolhida e a segunda é de apenas 0.046. O ICA estima as colunas com precisão, mas o *nome* "monetária" é atribuído por uma correlação que mal distingue duas delas.

## 2. Testes

### 2.1 A restrição do proxy é rejeitada?

Sob a identificação não-gaussiana o proxy deixa de ser hipótese mantida e
vira restrição testável: a direção de impacto `H = (Z'η)/(Z'Z)` deveria
coincidir com a coluna monetária do ICA.

- Alinhamento: **cos(b_GMR, H_proxy) = 0.6201**
- Wald na coluna: ξ = **122.926**, gl = 5, **p = 0.0000**

A restrição do proxy é **rejeitada a 5%**: as duas identificações não apontam para a mesma direção estrutural. Isso é informação, não falha — significa que pelo menos uma das duas está mal especificada, e o paper tem de escolher qual reportar como primária com argumento.

> Este teste é uma **adaptação** da §2.5: o artigo testa `C ∈ P(C_0)` com
> χ²(n(n−1)/2); aqui a restrição toca uma coluna só, então a forma quadrática
> usa o bloco correspondente de V com pseudo-inversa e gl = n−1.

### 2.2 Teste literal da §2.5: H0: C ∈ P(Id)

- ξ = **149.255**, gl = 15, **p = 0.0000**

É o esquema recursivo (Cholesky) nas inovações fatoriais — a restrição que a literatura impõe sem testar. Rejeitada a 5%.

## 3. Robustez à pseudo-densidade (Prop. 3)

A Prop. 3 do GMR garante consistência **mesmo com `g` mal especificada**.
Se isso vale aqui, a coluna monetária não deve depender da família escolhida.
Mas a Prop. 3 pressupõe a **A.5** (pseudo-densidades distintas *e* assimétricas);
as famílias abaixo a violam em graus diferentes, de propósito, para separar as
duas coisas.

| família | A.5 | coluna | \|cor\| | cos vs baseline | cos vs proxy | log-lik |
|---|---|---:|---:|---:|---:|---:|
| misturas de gaussianas (baseline) | satisfeita (distintas e assimétricas) | 2 | 0.200 | 1.0000 | 0.6201 | -1208.62 |
| Student-t (5..10 gl) | parcial — distintas mas **simétricas**, sinais não fixados | 3 | 0.235 | 0.9176 | 0.7290 | -1199.03 |
| secante hiperbólica | **violada** — idênticas e simétricas, todo P(C) empata | 4 | 0.239 | 0.9431 | 0.7419 | -802.42 |

> A secante hiperbólica é um **contra-exemplo deliberado**, não uma alternativa:
> com q densidades idênticas e pares todo elemento de P(C) atinge o mesmo máximo
> (GMR §2.2), então o que ela estima não é interpretável. Está na tabela para
> mostrar que a A.5 morde. A comparação que testa a Prop. 3 é a linha Student-t
> contra o baseline: formas funcionais bem diferentes, ambas admissíveis.

## 4. IRFs no impacto — manchetes do §5

| variável | GMR não-gaussiano | proxy-SVAR | razão |
|---|---:|---:|---:|
| yield_6m | 0.0050 | 0.0050 | 1.00 |
| yield_2y | 0.0109 | 0.0092 | 1.19 |
| yield_5y | 0.0123 | 0.0093 | 1.33 |
| asset_ibov | -10.5993 | -1.6726 | 6.34 |
| cambio_usd | 0.2348 | 0.1498 | 1.57 |
| price_ipca | -0.0530 | -0.0703 | 0.75 |
| embi_perc | 0.4461 | 0.1995 | 2.24 |
| commodity_metal | 12.1189 | 10.4064 | 1.16 |

Figura: [`irf_comparison.pdf`](irf_comparison.pdf). Série completa em
[`irf_comparison.csv`](irf_comparison.csv).

### Bandas de 90% no impacto — a leitura que decide

| variável | GMR (ponto) | GMR CI90 | proxy (ponto) | proxy CI90 |
|---|---:|---|---:|---|
| yield_6m | 0.005 | [0.005, 0.005] | 0.005 | [0.005, 0.005] |
| yield_2y | 0.011 | [-0.011, 0.026] | 0.009 | [0.007, 0.013] |
| yield_5y | 0.012 | [-0.022, 0.039] | 0.009 | [0.007, 0.015] |
| asset_ibov | -10.599 | [-66.459, 69.476] | -1.673 | [-7.771, 1.759] |
| cambio_usd | 0.235 | [-0.686, 1.087] | 0.150 | [0.079, 0.297] |
| price_ipca | -0.053 | [-1.458, 1.895] | -0.070 | [-0.371, 0.143] |
| embi_perc | 0.446 | [-1.893, 2.305] | 0.200 | [0.078, 0.509] |
| commodity_metal | 12.119 | [-28.633, 55.318] | 10.406 | [4.487, 17.511] |

## 6. Reconciliação: a Wald assintótica e o bootstrap discordam

As duas inferências deste ramo dão respostas opostas e é preciso escolher.

- **Assintótica (Prop. 4):** rejeita a restrição do proxy com p = 0.0000.
- **Bootstrap i.i.d. (800 draws):** cosseno mediano 0.707 entre a direção do
  draw e a do ponto, com **0.474** dos draws abaixo de 0,7 — e as bandas de
  90% no impacto contêm zero em **todas** as variáveis exceto a normalizada.

A simulação do bloco D de `validate_gmr_ica.R` desempata: em T = 150 e n = 6 — exatamente esta dimensão — o intervalo nominal de 95% da Prop. 4 cobre **0,79**. Os erros-padrão assintóticos são pequenos demais aqui, então a rejeição da restrição do proxy é **provavelmente espúria**.

> **Conclusão.** O estimador GMR não contradiz o proxy neste painel: ele é
> **pouco informativo**. O ponto de −10,7% no `asset_ibov` vem com CI90 de
> [−49, +81], compatível com quase qualquer coisa. Isso não desqualifica a
> rota como *teste* (o esquema recursivo é rejeitado, e o próprio artigo usa
> a identificação assim), mas desqualifica-a como **estimativa concorrente**
> das magnitudes do §5.

## 5. Estabilidade do bootstrap

- Cosseno mediano entre a direção do draw e a do ponto: **0.7073**
- Fração de draws com cosseno < 0,7: **0.474**
- Trocas de rótulo: 0 de 800

O ramo GMR usa reamostragem **i.i.d. com reposição**, não o wild bootstrap Rademacher do proxy: o multiplicador ±1 zera os terceiros momentos e destrói a assimetria que a Assumption A.5 exige. É o que o apêndice online do próprio GMR (§E) faz.

> **Ressalva.** Um cosseno mediano de 0.707 indica que a direção monetária estimada se move bastante entre reamostragens. As bandas abaixo já incorporam isso, e é a razão de elas serem largas.

