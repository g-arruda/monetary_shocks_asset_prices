# `arquivo/nao_gaussiana/` — identificação por momentos (GMR 2017, PML-ICA)

**Abandonada em 2026-08-17, por decisão do autor.** Nada aqui é executado pelo
pipeline de produção nem citado pelo paper. A produção segue com uma única
identificação: o **proxy externo** `z_jk_bs_purif`.

> ⚠️ **Leia o banner de cada nota antes de reusar qualquer número.** A rodada de
> 07-27 é do vintage de 106 séries em `(7,6)`, com `nboot=200` e 60 partidas; a
> de 08-01 foi reestimada em 2026-08-13 na produção `(5,5)` de 111 séries com
> `nboot=800` e `NG_STARTS=200`. Os dois conjuntos não se comparam.

## Veredito

**O estimador não tem poder neste painel: 6 células sig90 em 5.439.** A causa é
estrutural, não de implementação — **a agregação do DFM destrói a
não-gaussianidade** de que a identificação depende. Os fatores são médias
ponderadas de 111 séries, e o teorema central do limite atua sobre elas.

O gate de "no máximo um gaussiano" (Comon 1994) **passa no full sample e falha
pré-COVID**: 0 de 5 inovações deixam de rejeitar normalidade no full, contra 2 de
5 na janela pré-COVID. Ou seja, a rota só existiria na janela cheia — que é
justamente onde a não-gaussianidade é dirigida pela COVID.

**O que era defensável dizer, e agora não se diz mais:**

- ✅ **Não contradiz** — o ponto do proxy cai dentro do CI90 do GMR em 100% das
  5.439 células.
- ✅ **Rejeita o esquema recursivo** (ξ = 73,81), a restrição que a literatura de
  menor dimensão impõe sem testar.
- ❌ **Concordância de sinal NÃO é corroboração.** A coluna rotulada concorda com
  o proxy em 0,963 das 353 células sig90, mas 2.000 direções aleatórias dão
  **p=0,149** — a métrica satura contra o nulo. Nunca escrever "o GMR corrobora".

A rejeição assintótica da restrição do proxy (ξ = 33,37; 4 gl) é
**provavelmente espúria**: a Prop. 4 cobre 0,79 contra 0,95 nominal em T=150,
n=6, e o bootstrap move a direção substancialmente.

## Armadilhas que custaram tempo — não redescobrir

1. **`IdSS::estim.SVAR.ICA` está quebrado para n ≥ 4.** `make.M`/`make.C`
   desordenam o preenchimento antissimétrico e o gradiente usa `(I+A)` onde a
   parametrização de Cayley exige `(I+C)`. A aplicação publicada é n=3, onde os
   defeitos são invisíveis; aqui q=5. Por isso o PML-ICA foi **traduzido no
   repositório** (`R/identification/nongaussian_gmr.R`). `make.Omega`,
   `make.A.matrix` e `make.Asympt.Cov.delta` *são* corretos e serviam de alvo de
   validação cruzada.
2. **O wild bootstrap Rademacher é inválido neste ramo.** O multiplicador ±1 zera
   todos os terceiros momentos, e a assimetria é exatamente o que a Assumption
   A.5 do GMR exige. Usava-se reamostragem i.i.d. com reposição, como o apêndice
   online do próprio GMR (§E).
3. **`NG_STARTS = 200`** — 60 partidas não alcançam o ótimo.
4. **`svars::id.dc` / `id.cvm` são Matteson-Tsay e Herwartz-Plödt, não GMR.**
   Citá-los como GMR seria erro de citação.
5. **Estabilidade multi-start só significa algo condicionada ao ótimo.**

## O que está aqui

| pasta | conteúdo |
|---|---|
| `registro/historico_decisoes_secao0.md` | corpo integral da antiga §0 de `registro/historico_decisoes.md` — a fonte detalhada das armadilhas acima |
| `R/identification/` | `nongaussian_gmr.R` (tradução do PML-ICA), `nongaussian_branch.R` (adaptador para `compute_irf_dfm`), `nongaussian_labelling.R` (só diagnóstico) |
| `script/` | `model_nongaussian.R` (rodada de produção), `nongaussian_gate.R`, `nongaussian_corroboration.R`, `nongaussian_labelling.R`, `validate_gmr_ica.R` |
| `output/nongaussian/` | 17 artefatos — gate, `gmr_cell.rds`, comparação de IRF, corroboração, rotulagem |
| `notas/` | `2026-07-27_identificacao_nao_gaussiana_gmr.md`, `2026-08-01_robustez_identificacao.md` |

## Itens que ficaram abertos e morrem com a rota

- Enquadramento do GMR no paper (era o Tema C de `pendencias.md`).
- Construir um teste **com poder** — a razão de magnitude (`p=0,087`) era mais
  promissora que a contagem de sinais, mas nunca rejeitou a 5%.
- **LMS (2017) via `svars::id.ngml`** como terceira leitura paramétrica. Nunca
  implementado; `svars` não está instalado.
- Rodar o GMR num VAR pequeno — já descartado em 2026-08-01, porque contradiria
  o argumento central do paper contra VARs de baixa dimensão.

## Referência

Gouriéroux, Monfort & Renne (2017), *Journal of Econometrics* 196(1) —
pseudo-máxima verossimilhança para ICA sob SIR3.
