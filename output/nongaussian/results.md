# Identificação não-gaussiana (GMR 2017) — resultados

Gerado por `script/model_nongaussian.R` em 2026-08-17.
r = 5, q = 5, p = 6, h = 0-48, nboot = 800, seed = 123.

A identificação vem da **não-gaussianidade** das q inovações fatoriais
(Gouriéroux-Monfort-Renne 2017, pseudo-ML sob SIR3). O instrumento não
identifica nada aqui: apenas **rotula** qual coluna estimada é a monetária.
Pré-requisito e sua avaliação: [`gate.md`](gate.md).

## 1. Estimativa e rotulagem

- Coluna monetária: **1** de 5
- |cor(ε_mp, z)| = **0.270**; segunda colocada 0.226; folga **0.044**
- Pseudo log-verossimilhança: -1001.95 (1/200 partidas no melhor ótimo)
- Partidas pedidas: 200; folga do melhor para o segundo ótimo: 0.2693
- cond(A) = 2.895e+01

> **Ressalva de rotulagem.** A folga entre a coluna escolhida e a segunda é de apenas 0.044. O ICA estima as colunas com precisão, mas o *nome* "monetária" é atribuído por uma correlação que mal distingue duas delas.

## 2. Testes

### 2.1 A restrição do proxy é rejeitada?

Sob a identificação não-gaussiana o proxy deixa de ser hipótese mantida e
vira restrição testável: a direção de impacto `H = (Z'η)/(Z'Z)` deveria
coincidir com a coluna monetária do ICA.

- Alinhamento: **cos(b_GMR, H_proxy) = 0.7045**
- Wald na coluna: ξ = **33.368**, gl = 4, **p = 0.0000**

A restrição do proxy é **rejeitada a 5%**: as duas identificações não apontam para a mesma direção estrutural. Isso é informação, não falha — significa que pelo menos uma das duas está mal especificada, e o paper tem de escolher qual reportar como primária com argumento.

> Este teste é uma **adaptação** da §2.5: o artigo testa `C ∈ P(C_0)` com
> χ²(n(n−1)/2); aqui a restrição toca uma coluna só, então a forma quadrática
> usa o bloco correspondente de V com pseudo-inversa e gl = n−1.

### 2.2 Teste literal da §2.5: H0: C ∈ P(Id)

- ξ = **73.813**, gl = 10, **p = 0.0000**

É o esquema recursivo (Cholesky) nas inovações fatoriais — a restrição que a literatura impõe sem testar. Rejeitada a 5%.

## 3. Robustez à pseudo-densidade (Prop. 3)

A Prop. 3 do GMR garante consistência **mesmo com `g` mal especificada**.
Se isso vale aqui, a coluna monetária não deve depender da família escolhida.
Mas a Prop. 3 pressupõe a **A.5** (pseudo-densidades distintas *e* assimétricas);
as famílias abaixo a violam em graus diferentes, de propósito, para separar as
duas coisas.

| família | A.5 | coluna | \|cor\| | cos vs baseline | cos vs proxy | log-lik |
|---|---|---:|---:|---:|---:|---:|
| misturas de gaussianas (baseline) | satisfeita (distintas e assimétricas) | 1 | 0.270 | 1.0000 | 0.7045 | -1001.95 |
| Student-t (5..10 gl) | parcial — distintas mas **simétricas**, sinais não fixados | 3 | 0.345 | 0.8656 | 0.9507 | -990.16 |
| secante hiperbólica | **violada** — idênticas e simétricas, todo P(C) empata | 2 | 0.293 | 0.9722 | 0.8233 | -660.40 |

> A secante hiperbólica é um **contra-exemplo deliberado**, não uma alternativa:
> com q densidades idênticas e pares todo elemento de P(C) atinge o mesmo máximo
> (GMR §2.2), então o que ela estima não é interpretável. Está na tabela para
> mostrar que a A.5 morde. A comparação que testa a Prop. 3 é a linha Student-t
> contra o baseline: formas funcionais bem diferentes, ambas admissíveis.

## 4. IRFs no impacto — manchetes do §5

| variável | GMR não-gaussiano | proxy-SVAR | razão |
|---|---:|---:|---:|
| yield_6m | 0.0050 | 0.0050 | 1.00 |
| yield_2y | 0.0069 | 0.0074 | 0.93 |
| yield_5y | 0.0062 | 0.0078 | 0.80 |
| asset_ibov | 1.1825 | -1.7227 | -0.69 |
| cambio_usd | 0.1247 | 0.1579 | 0.79 |
| price_ipca | 0.0781 | -0.0618 | -1.26 |
| embi_perc | 0.1186 | 0.2620 | 0.45 |
| commodity_metal | 9.4930 | 7.4556 | 1.27 |

Figura: [`irf_comparison.pdf`](irf_comparison.pdf). Série completa em
[`irf_comparison.csv`](irf_comparison.csv).

### Bandas de 90% no impacto — a leitura que decide

| variável | GMR (ponto) | GMR CI90 | proxy (ponto) | proxy CI90 |
|---|---:|---|---:|---|
| yield_6m | 0.005 | [0.005, 0.005] | 0.005 | [0.005, 0.005] |
| yield_2y | 0.007 | [-0.007, 0.021] | 0.007 | [0.006, 0.009] |
| yield_5y | 0.006 | [-0.016, 0.030] | 0.008 | [0.006, 0.011] |
| asset_ibov | 1.183 | [-46.631, 41.503] | -1.723 | [-6.910, 0.775] |
| cambio_usd | 0.125 | [-0.776, 0.729] | 0.158 | [0.092, 0.249] |
| price_ipca | 0.078 | [-1.734, 3.747] | -0.062 | [-0.276, 0.117] |
| embi_perc | 0.119 | [-1.195, 1.495] | 0.262 | [0.172, 0.473] |
| commodity_metal | 9.493 | [-21.493, 40.032] | 7.456 | [1.972, 11.154] |

## 5. Reconciliação: a Wald assintótica e o bootstrap discordam

As duas inferências deste ramo dão respostas opostas e é preciso escolher.

- **Assintótica (Prop. 4):** rejeita a restrição do proxy com p = 0.0000.
- **Bootstrap i.i.d. (800 draws):** cosseno mediano 0.710 entre a direção do
  draw e a do ponto, com **0.482** dos draws abaixo de 0,7 — e as bandas de
  90% no impacto contêm zero em **todas** as variáveis exceto a normalizada.

A simulação do bloco D de `validate_gmr_ica.R` alerta para a distorção: em T = 150 e n = 6 — dimensão próxima e ligeiramente maior que q = 5 da produção — o intervalo nominal de 95% da Prop. 4 cobre **0,79**. Os erros-padrão assintóticos são pequenos demais aqui, então a rejeição da restrição do proxy é **provavelmente espúria**.

> **Conclusão.** O estimador GMR não contradiz o proxy neste painel: ele é
> **pouco informativo**. O ponto de 1.18% no `asset_ibov` vem com CI90 de
> [-46.6, 41.5], compatível com quase qualquer coisa. Isso não desqualifica a
> rota como *teste* (o esquema recursivo é rejeitado, e o próprio artigo usa
> a identificação assim), mas desqualifica-a como **estimativa concorrente**
> das magnitudes do §5.

## 6. Estabilidade do bootstrap

- Cosseno mediano entre a direção do draw e a do ponto: **0.7100**
- Fração de draws com cosseno < 0,7: **0.482**
- Trocas de rótulo: 0 de 800

O ramo GMR usa reamostragem **i.i.d. com reposição**, não o wild bootstrap Rademacher do proxy: o multiplicador ±1 zera os terceiros momentos e destrói a assimetria que a Assumption A.5 exige. É o que o apêndice online do próprio GMR (§E) faz.

> **Ressalva.** Um cosseno mediano de 0.710 indica que a direção monetária estimada se move bastante entre reamostragens. As bandas abaixo já incorporam isso, e é a razão de elas serem largas.

