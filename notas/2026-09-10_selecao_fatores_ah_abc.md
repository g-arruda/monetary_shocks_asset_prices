# Seleção de `r` por Ahn-Horenstein e Alessi-Barigozzi-Capasso: AH escolhe 2, ABC escolhe 9 com pouca estabilidade, e o `factorselect` diverge dos papers

> **CURRENT — 2026-09-10.** Rodada feita sob a produção corrente:
> - painel de 115 séries `drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, 2012-03--2025-12, `(r,q,p)=(5,5,4)`;
> - branch `feature/ahn-horenstein-abc`;
> - código novo: `R/modeling/factor_selection.R` (funções) e `script/factor_selection_alt.R`;
> - saídas geradas: `output/factors/factor_selection_alt.{csv,md,pdf}`, `factor_selection_alt_abc.csv`, `factor_selection_alt_summary.csv`.
>
> **A produção não muda.** `r=5` continua vindo do Bai-Ng BLL.

## 1. A pergunta

A rodada responde à sugestão 1/5 do e-mail do orientador de 2026-09-04 (`email/email_professor_04-09_16h42.md`): rodar Ahn-Horenstein (2013, *Econometrica* 81(3)) e Alessi-Barigozzi-Capasso (2010, *SPL* 80) para `r` e comparar com Bai-Ng. A regra de leitura do e-mail é esta: "se esses dois derem r visivelmente maior que 5, isso vira evidência direta de subestimação". A subestimação viria da correlação dentro dos blocos (Boivin-Ng 2006).

O e-mail não fixa painel, janela nem grade de `r`. Adotei a leitura da superfície Bai-Ng de produção: o mesmo painel, a mesma janela e `k = 1..20`, para comparar diretamente com IC1/IC2/IC3.

## 2. O objeto

O objeto é `yy`, as primeiras diferenças do painel de produção, centradas e divididas pelo desvio-padrão das diferenças (padronização BLL). Tem T = 165 e N = 115. O código o constrói de forma idêntica em dois lugares de `R/modeling/factor_estimation.R`:
- `:57-62`, como o `X_std` de `bai_ng_criteria(apply_bll = TRUE)`, que `script/model_alessi.R:23` usa para gravar `output/factors/production_bai_ng_bll_surface.csv`;
- `:242-247`, como `estimate_static_factors()$yy`, cuja `cov(yy)` a SVD da produção decompõe.

O auto-teste (b) do script mostra que é o mesmo objeto: `log V(k)` de `yy` somado às penalidades de Bai-Ng reproduz a superfície salva a 4,4e-16. O auto-teste (c) liga o espectro aos autovalores das cargas de produção, a 1,6e-15 relativo.

Trabalhar em diferenças é o que o próprio AH prescreve quando há fatores I(1) (§2, citando Bai-Ng 2004).

## 3. Auditoria do pacote `factorselect`

**Proveniência.** O código auditado está no GitHub, em `penny4nonsense/factorselect` @ `f0f08d5953488bf2c0db0aa8b341b16e5f28dc7c` (HEAD, v0.1.2).
- É o que está instalado em `~/R/library`: `RemoteSha` é o mesmo, a instalação é de 2026-09-03 e o pacote carrega sem erro.
- O CRAN publica a v0.1.3 (2026-04-28). O corpo de código dos seis arquivos relevantes é idêntico ao do commit auditado; só mudaram roxygen e quebras de linha (CRLF). A auditoria vale para as duas versões.

### Ahn & Horenstein (2013) — `R/ahn_horenstein.R`

| item | paper | código @ f0f08d5 | veredito |
|---|---|---|---|
| Autovalores | `μ̃_k = ψ_k[X'X/(NT)]`, `k=1..m` (§2) | `extract_eigenvalues.R:54-60` usa X'X/T (N≤T) ou XX'/N; `:62-76` guarda só `kmax+1` autovalores | A escala difere por uma constante, e ER e GR são invariantes a escala. A truncagem importa (ver V(k)) |
| ER(k) | `μ̃_k/μ̃_{k+1}`, `k=1..kmax` | `:52` | **Bate**: 4,0e-15 relativo na base de produção |
| k̂_ER | `argmax_{1≤k≤kmax}` (Teorema 1) | `:64` `which.max(er)` | **Bate** (2 = 2) |
| Autovalor fictício para k=0 (Corolário 1, eq. 4) | `μ̃_0 = V(0)/ln m`, com `V(0)=Σ_{k=1}^{m} μ̃_k` | `:47-48` monta o valor, mas `er` e `gr` começam no índice 2 | **Diverge.** O roxygen (`:31-32`) diz que k=0 é tratado, mas o código que monta o valor nunca é usado, e o V(0) dele é truncado em `kmax+1`. As simulações do paper usam a versão modificada (§3) |
| V(k) | `Σ_{j=k+1}^{m} μ̃_j` | `:57` soma só até `kmax+1` | **Diverge** (truncagem) |
| μ*_k | `μ̃_k / V(k)` | `:58` prefixa V(0) pela segunda vez (`V <- c(V0, V)`); `:59` fica `μ̃_k / V_trunc(k−2)` para k≥2 | **Diverge**: os índices estão deslocados em dois e V está truncado. Na base de produção, `μ̃_k/V_trunc(k−2)` reproduz o GR do pacote a 2,0e-15 |
| GR(k) | `ln(1+μ*_k)/ln(1+μ*_{k+1})` | `:61` aplica a fórmula certa ao μ* errado | **Diverge**: até 27,8% de desvio relativo, e o argmax cai de 2 para 1 |
| O que `select_factors` reporta | — | `select_factors.R:147-150` faz `k["ahn_horenstein"] <- res$k_gr` | O "ahn_horenstein" do pacote é o GR divergente, não o ER |
| Pré-processamento | recomenda dados duplamente centrados, `x_it − x̄_i − x̄_t + x̄` (§2), sem padronizar | `prepare_matrix.R:61-66` faz a média das colunas e depois a das linhas, o que é exato; `:71-79` padroniza **depois** | O centramento **bate**. A padronização é um passo do pacote, não do paper |
| kmax | Teorema 1: `kmax ∈ (r, [d^c m]−r−1]`; o paper sugere `2·r_max` ou `kmax₂ = min(kmax*, 0,1m)` | `select_factors.R:126-128` usa por padrão `min(⌊√n⌋, 8)` | Esse padrão não vem do paper |
| Testes | — | `test-ahn_horenstein.R` cobre formato, argmax e recuperação de k em processos gerados com fatores fortes | Nenhum teste fixa a fórmula do GR |

### Alessi, Barigozzi & Capasso (2010) — `R/abc.R`

| item | paper | código @ f0f08d5 | veredito |
|---|---|---|---|
| V(k) | eq. (2): `(1/nT)ΣΣ(x − λ̂'F̂)²` | `:72-73` `V0 − cumsum(eig)/N` | **Bate** para N ≤ T, que é o nosso caso. Com N > T, o código decompõe XX'/N e continua dividindo por N; diverge **fora do nosso caso** |
| Critério | eq. (3): `argmin_{0≤k≤rmax} log V(k) + k·p(n,T)` | `:89-91` | **Bate** |
| IC*₁ | `c·k·((n+T)/nT)·log(nT/(n+T))` | `:76` | **Bate** |
| IC*₂ | `c·k·((n+T)/nT)·log(min{√n,√T})²` | `:77` `log(m)` | **Bate** se o termo for lido como `log C²_nT = log min(n,T)`, a IC_p2 de Bai-Ng que o ABC reescala. A tipografia do paper é ambígua |
| IC3 | o ABC define só IC*₁ e IC*₂ | `:78` | Extra do pacote |
| Subamostras `(n_j, τ_j)` e S_c | §3; simulações do §4 com `n₁=⌊3n/4⌋`, `n_{j+1}=n_j+1` | **ausentes** | **Diverge (estrutural)** |
| Regra de escolha | `ĉ` no 2º intervalo de estabilidade, porque o 1º (em `r_max`) é inadmissível | `:95-98` escolhe a **moda** de `k̂(c)` na grade | **Diverge.** Na base de produção, o pacote devolve **20 = r_max**, justamente a fronteira que o ABC declara inadmissível: a moda é dominada por c ≤ 0,66, onde r̂ = 20 |
| Grade de c | `(0, 5]`, passo 0,01 | `:66` `seq(0, 1, by = 0.01)` | **Diverge.** A grade inclui c = 0 e para em 1; com isso a penalidade nunca excede a de Bai-Ng e a moda nunca fica abaixo dele |
| Testes | — | `test-abc.R` confere a moda | Testa a regra do próprio pacote, não a do ABC |

O Bai-Ng do pacote (IC1-IC3, `bai_ng.R`) reproduz a superfície de produção a 1,8e-15.

**Pontos que não dá para verificar:**
- O ramo RSpectra (`extract_eigenvalues.R:66-70`) valeria para N = 115, mas o RSpectra não está instalado aqui.
- O MATLAB dos autores do ABC (nota 1 do paper) não foi encontrado.
- O único port encontrado, `rmfd4dfm::abc_crit`, é de terceiros e também se afasta do paper: usa V(k) sem log, sorteia subconjuntos independentes, fixa `n₁ = n−⌊n/10⌋` e `c_max = 3`. Não serve de referência.

## 4. Decisão

**Reimplementar do zero a partir das equações dos papers.**
- O GR e o ABC do pacote divergem das equações.
- O único estimador que bate, o ER, é uma linha de código.
- Depender do pacote não economizaria nada e traria dois estimadores errados.

O pacote fica no script apenas como comparador auditado, preso ao SHA. As funções novas estão em `R/modeling/factor_selection.R`:
- `panel_eigenvalues()`;
- `ahn_horenstein()`, com o espectro inteiro, o Teorema 1, o Corolário 1 e `kmax₂`;
- `abc_criterion()`, com subamostras aninhadas, S_c e o segundo intervalo.

## 5. Escolhas do ABC que o paper deixa abertas

- **Ordem das séries nas subamostras aninhadas:** uma permutação aleatória fixa das colunas (seed 123 = `SPEC$bootstrap_seed`), por decisão do autor. O CSV agrupa as séries por bloco, então a ordem original descartaria blocos inteiros. A distribuição de r̂ em 100 permutações entra como sensibilidade.
- **Subamostras e grade:** `n_j = ⌊3n/4⌋..n` (86..115, J = 30), sem subamostra temporal, `c ∈ (0, 5]` com passo 0,01. É o desenho de simulação do §4 do paper.
- **Intervalo de estabilidade:** uma sequência de valores consecutivos de c com S_c = 0 e o mesmo r̂ na amostra cheia. O escolhido é o primeiro com r̂ < r_max. Nenhuma duração mínima é imposta, porque o paper não fixa uma.

## 6. Resultado

| estimador | variante | r̂ |
|---|---|---|
| Bai-Ng IC1 / IC2 / IC3 | produção, BLL | 5 / 5 / 20 |
| **AH ER** | Teorema 1, kmax = 20 | **2** |
| **AH GR** | Teorema 1, kmax = 20 | **2** |
| **ABC IC*₁** | permutação principal | **9**, com c ∈ [0,74; 0,75] |
| ABC IC*₂ | permutação principal | 9, com c ∈ [0,66; 0,68] |
| AH ER / GR | Corolário 1 (admite k = 0) | 2 / 2 |
| AH ER / GR | argmax em `kmax₂ = 11` | 2 / 2 |
| AH ER / GR | painel duplamente centrado | 2 / 2 |

**Veredito pré-registrado: misto.** ER = GR = 2 ≤ 5, e ABC-IC*₁ = 9 > 5. A regra ficou fixada no plano antes de qualquer estimativa: "apoia" se as três estatísticas passarem de 5, "não apoia" se as três ficarem em 5 ou menos, "misto" nos outros casos.

## 7. O que o resultado permite dizer

- **AH não indica subestimação.** ER e GR escolhem 2 em todas as variantes. Depois de k = 2 o espectro não tem um salto nítido: as razões ficam entre 1,0 e 1,35. Há um pico local em k = 5 (ER(5) = 1,346, GR(5) = 1,261), abaixo dos picos de k = 1 e k = 2. O primeiro autovalor responde por 14,4% da variância, então não há um fator dominante que explique o 2 pelo mecanismo que AH descrevem para o ER.
- **O 9 do ABC é frágil.** ⚠ O intervalo de r̂ = 9 tem só 2 pontos da grade (c ∈ [0,74; 0,75]), contra 11 pontos do intervalo seguinte, de r̂ = 5 (c ∈ [0,93; 1,03]). ⚠ Nas 100 permutações, o IC*₁ dá 9 em 45 e 5 em 39. A dispersão restante vai de 3 a 11. ⚠ *Leitura pós-hoc, fora da regra:* com a duração mínima de intervalo que o port `rmfd4dfm` impõe (> 0,05 em c), o intervalo de 9 cai e o ABC dá 5.
- **O e-mail pedia "r visivelmente maior que 5"** nos dois estimadores. Neste painel isso não se sustenta como fato robusto: um estimador aponta para menos fatores, e o outro para mais apenas numa leitura instável. Não é a "evidência direta de subestimação" que o e-mail esperava, e o paper não deve citar a rodada nesses termos.
- **O IC3 = 20 de produção** é o tipo de solução de fronteira que o procedimento do ABC foi desenhado para descartar. O primeiro intervalo de estabilidade (c ≤ 0,66) está exatamente em `r_max`, como o paper afirma que acontece.
- **Esta leitura vale para o painel atual.** Ela não substitui a poda por correlação intra-bloco (item B2) nem a releitura de `(r,q)` no painel podado (item B3).

## 8. O que não foi feito

- Não rodei a janela pré-COVID nem subamostras temporais do ABC. Nenhuma das duas foi pedida.
- Não rodei `script/validate_production_spec.R`, que regrava artefatos de validação e roda o gate de bootstrap. O auto-teste (a) refaz a checagem dele sobre a superfície Bai-Ng (5,55e-17). O smoke test do `CLAUDE.md` saiu bit-idêntico, e nenhum caminho de produção foi tocado.

## 9. `script/factorselect_run.R` foi apagado

O script era ad hoc, sem cabeçalho e sem saída gravada. Rodava o pacote com kmax = 8 sobre `diff(X)`, em quatro modos de centramento, e tinha três problemas:
- o que imprimia como `ahn_horenstein` era o GR divergente;
- o que imprimia como `abc` era a moda sobre c ∈ [0,1];
- para `bai_ng` e `abc`, usava as diferenças sem padronizar, que não são o objeto BLL.

Os números que ele imprimia não são citáveis. A rodada nova o substitui.
