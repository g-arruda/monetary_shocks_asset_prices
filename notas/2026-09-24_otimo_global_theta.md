# O ótimo global de θ̂: multi-start na caixa inteira

> **CURRENT — 2026-09-24. θ̂ confirmado como máximo global; nada da produção mudou.**
> - Produção de 115 séries, 2012-03 a 2025-12, `(r, p) = (5, 4)`, 162 meses de resíduo, `t*` =
>   2020-03, s̄ ≥ 1 e ρ ∈ [0, 1] (desenho do autor de 2026-09-14). θ̂ não depende de `q`.
> - Fecha o item "Confirmar o ótimo global de θ̂" de `registro/pendencias.md` (Tema B). Fecha
>   também o "não verificado" 3 de `2026-09-16_fidelidade_lenza_primiceri` e o 6.2 de
>   `2026-09-17_volatilidade_covid_producao`.
> - `output/factors/covid_volatility_theta.csv` sai **byte-idêntico**. `validate_production_spec.R`
>   passa, e o smoke test do `CLAUDE.md` sai bit-idêntico. Nada em `R/` mudou.
> - Fonte de todos os números: `output/factors/covid_volatility_multistart.csv`, a segunda saída de
>   `script/covid_volatility_theta.R` (decisão do autor, que reverte em parte a redução a uma saída de
>   2026-09-18).

## 1. O que faltava

`estimate_covid_theta()` maximiza (B5) com **um** L-BFGS-B, que parte da regra de LP aplicada aos
fatores, (5,78; 7,92; 3,92; 0,8). A única trava de globalidade era o perfil em ρ: 101 pontos, com
(s̄0, s̄1, s̄2) reotimizados **a partir de θ̂**. O perfil mostrou dois máximos, e um terceiro fora dessa
fatia não estava descartado. Desde 2026-09-17 θ̂ é número publicado (§3.1 do paper), e a lacuna
passou a ser sobre ele.

## 2. O desenho

`script/covid_volatility_theta.R` ganhou um bloco de multi-start depois da trava do perfil:
- **Grade de inícios:** s̄0, s̄1, s̄2 ∈ {1; 2,51; 6,32; 15,9; 40}, log-espaçados, e ρ ∈ {0; 0,2;
  0,4; 0,6; 0,8; 1}, as duas fronteiras incluídas. São 5³ × 6 = **750 inícios**.
- **O teto 40 basta.** Quando qualquer s̄ → ∞, o termo −r log s̄ de (B5) vai a −∞, e Σ̂ fica
  limitada, porque o mês governado por aquele s̄ só perde peso. O teto fica 3× acima do maior
  componente de θ̂ (12,47).
- **Otimizador:** o de `estimate_covid_theta()`, L-BFGS-B na caixa do desenho com `factr = 1e3`.
- **Duas travas**, com a tolerância da trava do perfil, `tol = 1e-6·|ℓ̂|` = 1,58e-3:
  - para se algum ponto final tem ℓ > ℓ̂ + tol, porque haveria máximo acima de θ̂; a trava lê só o
    valor, com qualquer código de convergência;
  - para se algum ponto final tem ℓ ≥ ℓ̂ − tol e fica a mais de 5% de θ̂ em algum componente, porque
    o máximo não seria único.
- **Saídas:** as duas CSVs só são gravadas depois de todas as travas passarem. O script inteiro leva
  1 min 47 s, quase todo no multi-start; antes levava cerca de 4 s.

## 3. O resultado

Os 750 pontos finais caem em **três conjuntos**, sem nenhum ponto isolado:

| conjunto | s̄0 | s̄1 | s̄2 | ρ | ℓ − ℓ̂ | inícios |
|---|---|---|---|---|---|---|
| **θ̂** | 6,551–6,642 | 12,447–12,479 | 1,7597–1,7616 | 0,94388–0,94395 | −4,1e-4 a +3,8e-7 | **137** (18,3%) |
| pico de três meses | 6,2181–6,2184 | 12,4268–12,4273 | 4,6428–4,6430 | 0 | −2,621130 | **368** (49,1%) |
| pico de dois meses | 6,1916 | 11,3024 | 1 (piso) | 0 a 0,8, não identificado | −4,792468 | **245** (32,7%) |

- **Nenhum início termina acima de θ̂.** O melhor ponto final fica 3,8e-7 log-ponto acima de ℓ̂, a
  1,7e-4 de θ̂: é precisão do otimizador, cerca de 4.000 vezes menor que a tolerância. Nenhum ponto empata
  com ℓ̂ longe de θ̂.
- **Convergência:** 742 inícios devolvem código 0 e 8 devolvem 52
  (`ABNORMAL_TERMINATION_IN_LNSRCH`), 6 no conjunto de θ̂ e 2 no piso. Os oito terminam no valor do
  seu conjunto.
- **A dispersão dentro do conjunto de θ̂ é a de s̄0.** Dez dos 137 inícios param a mais de 1e-6 de
  ℓ̂. A maior distância a θ̂ é 0,9%, em s̄0, onde ℓ é quase plana: cada s̄ de um mês depende de uma
  observação só (`2026-09-14_estimacao_theta_volatilidade_covid` §3.3).
- **O pico de três meses é o máximo ρ = 0 que o perfil já mostrava.** A distância de 2,6211 é a
  mesma que as notas citam contra o máximo livre.

**O terceiro conjunto é novo: uma crista no piso s̄2 = 1.** O perfil não podia vê-la, porque
reotimizava a partir do s̄2 de θ̂.
- Com s̄2 = 1, `s_t = 1` em todo mês de 2020-05 em diante, qualquer que seja ρ. ℓ não depende de ρ
  ali: vale −1584,383 em ρ = 0; 0,5; 0,94 e 1. O otimizador para no ρ em que chega.
- A crista é **máximo local fraco só para ρ < ρ\* = 0,8346**. A derivada de ℓ em s̄2 no piso,
  pelo envelope `Σ_{j≥2} ρ^{j−2}(m_t − 5)` em Mahalanobis, é negativa abaixo de ρ\* e positiva acima.
  Os 245 pontos finais ficam em ρ ∈ [0; 0,8].
- A leitura é um pico em março e abril de 2020, e mais nada. Em ρ = 0, s̄2 governa só 2020-05.
  ℓ tem então dois máximos em s̄2: com peso cheio, maio é bem ajustado (tamanho 0,79 por dimensão) e
  s̄2 fica no piso; com peso baixo, ele deixa de ser ajustado, o resíduo cresce, e s̄2 = 4,64 se
  sustenta sozinho. É a bimodalidade típica de um peso de uma observação só.

**Veredito: θ̂ é o máximo global de (B5) na caixa do desenho**, dentro do que uma grade de 750
inícios alcança (§5). A estimativa publicada não muda.

## 4. O que a grade revela sobre o estimador de um início só

A bacia de θ̂ é estreita em ρ0:

| ρ0 | 0 | 0,2 | 0,4 | 0,6 | 0,8 | 1 |
|---|---|---|---|---|---|---|
| inícios que chegam a θ̂ (de 125) | 0 | 0 | 0 | 32 | 22 | 83 |

- **Nenhum início com ρ0 ≤ 0,4 chega a θ̂** (0 de 375). Nenhum com s̄2₀ = 40 chega também.
- **O θ̂ de produção dependia do ρ0 = 0,8 da regra de LP.** Com ρ0 ≤ 0,4, o mesmo L-BFGS-B teria
  devolvido um dos dois máximos inferiores. A trava das condições de primeira ordem não pegaria
  isso, porque s̄0 e s̄1 são interiores nos três conjuntos.
- A trava do multi-start existe para isso. Ela roda a cada reestimação de θ̂, e não só nesta
  rodada.

## 5. Validação

**Teste de mutação**, em cópias no scratchpad que gravam fora de `output/`. Nada foi commitado.
Cada mutante reescreve `fit` logo antes do multi-start:

| mutante | trava que dispara |
|---|---|
| `fit` trocado pelo máximo ρ = 0, a partir de (30, 2, 10, 0,3) | a 1: um início termina em −1579,5910, acima de −1582,2121 |
| s̄0 de θ̂ registrado 10% acima, com o ℓ̂ verdadeiro | a 2: 137 inícios empatam com ℓ̂ a mais de 5% de θ̂ |

**Regressão:**
- `covid_volatility_theta.csv` sai byte-idêntico (`git diff --quiet`);
- `script/validation/validate_production_spec.R` passa, e ele rederiva θ̂ do painel;
- o smoke test do `CLAUDE.md` sai `identical()` aos cinco literais.

## 6. O que segue não verificado

1. **A grade é finita.** Um máximo com bacia menor que o espaçamento da grade não está excluído. O
   espaçamento é de um fator 2,5 em cada s̄ e 0,2 em ρ.
2. **Há um otimizador só.** Nenhum segundo algoritmo (Nelder-Mead, `csminwel` de LP) varreu a caixa.
   O Nelder-Mead de 09-14 conferiu um único ponto do perfil.
3. **A confirmação é condicional ao desenho**: `t*`, o piso s̄ ≥ 1 e a caixa de ρ. Outro `t*` é outra
   verossimilhança.
4. **Os θ próprios do item D** (o VAR mensal das tabelas de heterocedasticidade sob a escala LP, um θ
   por vértice) não estão cobertos. A trava vive no produtor do θ̂ do DFM. Se aquela rodada estimar θ
   por `estimate_covid_theta()`, precisa da mesma checagem, e a bimodalidade da §3 diz que ela não é
   formalidade.
