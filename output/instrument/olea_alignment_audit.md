# Auditoria de alinhamento — estatísticas de relevância de Montiel Olea, Stock & Watson (2021)

**Data:** 2026-07-14
**Fontes primárias:** artigo (`artigos/olea, stock e watson - .../*.md`, §4.2 e §5) e código MATLAB oficial dos autores (https://github.com/jm4474/SVARIV, clonado em `codigo_olea/`, referência read-only).
**Validação end-to-end:** `script/validate_olea_kilian.R` reproduz os números publicados na aplicação Kilian (oil): **ξ₁ = 4.399 vs 4.4 publicado; F robusta = 9.438 vs 9.4 publicado**.

---

## 1. O que o paper e o código oficial definem

- **F de primeiro estágio robusta (§4.2):** regressão de Y₁ₜ (variável normalizadora) em zₜ com os lags do VAR como controles; comparar com Stock-Yogo / regra F > 10.
- **ξ₁ = T·Γ̂²_{T,1}/Ŵ_{Γ,11} (§4.2):** Wald para irrelevância do instrumento na direção da variável normalizadora. Propriedade central: o conjunto Anderson-Rubin 100(1−a)% é um **intervalo limitado sse ξ₁ > χ²_{1,1−a}** (3.84 a 5%). Implementação oficial: `MSWfunction.m:374`, `Waldstat = ((√T)·Γ̂_nvar)²/Ŵ[Γ_nvar,Γ_nvar]`.
- **Wald conjunta (os próprios autores a escreveram, comentada):** `MSWfunction.m:388-390`, `WaldstatFull = T·Γ̂'(Ŵ_ΓΓ)⁻¹Γ̂ ~ χ²_n` — cobertura da relevância em *qualquer* direção do vetor de inovações.
- **Ŵ_Γ (CovAhat_Sigmahat_Gamma.m):** Eicker-White (Newey-West com `NWlags = 0` nas aplicações) sobre os produtos de momento, **com a correção Shat** que propaga o erro de estimação do VAR para Γ̂. Algebricamente, o bloco `−kron(Q₂Q₁⁻¹, I)` equivale a **residualizar z nos regressores do VAR (lags + constante)** antes de formar os produtos zₜη̂ₜ (Γ̂ não muda in-sample, pois η̂ ⊥ X; apenas Ŵ muda).
- **Advertência anti-screening (§4.2, footnote 6):** condicionar a inferência padrão no valor do F induz distorção de tamanho (pré-teste). A recomendação é reportar F/ξ **e** usar rotineiramente os conjuntos AR robustos.

## 2. Veredito por função do projeto

| Função | Local | Veredito |
|---|---|---|
| `first_stage_F` | `R/identification/validation_tests.R:42-57` | **Alinhada na forma** (Wald robusta = t² com 1 instrumento). **Achado de convenção:** o 9.4 publicado corresponde a **HC1** (correção T/(T−k), default do Stata), não HC0 — na aplicação Kilian, HC0 dá 11.914. Com nosso k≈8 e T≈150 a diferença é ~5% (anti-conservadora); imaterial para as decisões T1–T8, mas documentada aqui. |
| `xi1` | `script/instrument_diagnostics.R` | **Fórmula alinhada** (T·γ̂²/Ŵ₁₁ com produtos centrados, NW 0 lags), **faltava a correção Shat**. Corrigido de forma aditiva: nova coluna `xi1_mosw` com z residualizado em `ctrl_al` + constante. Diferenças observadas: pequenas e de sinal variado (ex.: z_bruto 4.12→4.23; z_jk 2.98→2.36). |
| `compute_factor_space_F` | `R/modeling/impulse_responde.R` | **Divergente** em dois pontos: F homocedástica (`summary()$fstatistic`) e agregação por **máximo** entre as q equações (anti-conservador, cherry-pick). Mantida **inalterada** como métrica legada (comparabilidade com o spec sweep de 2026-07-11); substituída como headline pela nova `compute_factor_space_wald`. |
| `ident_ext_instr` (H = Z'η/Z'Z) | `R/modeling/impulse_responde.R` | **Alinhada**: H ∝ Γ̂ e a escala cancela na normalização (eq. 2.8-2.9 do paper). O bloco `diagnose` agora também imprime a Wald conjunta. |

## 3. Estatísticas novas (implementadas em `compute_factor_space_wald`)

Todas com Eicker-White (NW 0 lags) e correção Shat (z residualizado nos lags do VAR de fatores + constante), exatamente como o código oficial:

- **ξ_k por fator** — Wald robusta de cada inovação de fator ηₖ em z; min/max reportados.
- **Wald conjunta ξ = T·Γ̂'Ŵ⁻¹Γ̂ ~ χ²_q** — o `WaldstatFull` dos autores. **F conjunta = ξ/q** como forma-F. Leitura: sob instrumento válido, Γ = α·Θ₀,₁ vive em **uma** direção, então a conjunta dilui a não-centralidade por q graus de liberdade — é o teste conservador de "relevância em alguma direção", não a régua Stock-Yogo (que é calibrada para 1 regressor endógeno).
- **ξ_mp** — Wald na direção c'Γ̂, com c = linha de `yield_6m` na matriz de impacto Λ·K·M. É o **análogo exato do `Waldstat` oficial** na nossa parametrização (a normalização divide por c'Γ̂, como o oficial divide por Γ̂_nvar): governa o denominador da normalização e a **limitação do conjunto AR (sse ξ_mp > 3.84)**.

Validação end-to-end (`script/validate_olea_kilian.R`): na aplicação oficial (VAR(24), 3 variáveis, T=356), nossa implementação entrega ξ₁ = 4.399 (publicado 4.4), F robusta HC1 = 9.438 (publicado 9.4) e WaldstatFull = 5.111 (χ²₃, p = 0.164). `stopifnot` garante regressão futura.

## 4. Leitura conservadora dos resultados (DFM r=8, q=8, amostra completa)

Tabela completa em `instrument_diagnostics_report.md` §1.1. Destaques:

- **F conjunta ∈ [1.5, 2.2] para todas as 8 variantes** — nenhuma variante é forte "em todas as direções" do espaço de fatores com q=8. As Wald conjuntas rejeitam irrelevância a 5% para 6 de 8 variantes (p ∈ [0.025, 0.054]), mas rejeição de irrelevância ≠ instrumento forte.
- **ξ_mp discrimina:** z_het_jk = 11.85 e z_bruto = 10.01 acima de 10; z_bruto_purif = 8.93; **z_jk_purif (default de produção) = 5.28** — zona MOSW "usar intervalos Anderson-Rubin"; **z_het_3var = 2.68 < 3.84 → conjunto AR 95% potencialmente ilimitado** nesta especificação (8,8).
- Consistência interna: o contraste entre ξ₁ (fator 1) e ξ_mp (direção da normalização) mostra que a relevância dos instrumentos het não está no primeiro fator (ξ₁ de z_het_jk = 0.03 vs ξ_mp = 11.85) — mais uma razão para aposentar o max-F legado como critério.

**Cautelas:**
1. Os números acima são da especificação de diagnóstico (r=8, q=8). A grade completa (r ∈ 5–8, q ∈ 4–r) × {full, pre_covid} × 8 instrumentos foi rodada em 2026-07-14 — ver §4.1 abaixo e `mosw_strength_grid.md`.
2. Pela advertência anti-screening do próprio paper, o protocolo recomendado para o texto do artigo é: **reportar ξ_mp e F conjunta, e apresentar bandas AR robustas (ou ao menos qualificar as bandas bootstrap) sempre que ξ_mp < 10** — não simplesmente filtrar instrumentos pelo F.

### 4.1 Grade (r,q) × amostra — força de cada instrumento sob a régua rigorosa (2026-07-14)

`script/mosw_strength_grid.R` grida ξ_mp, Wald conjunta/F conjunta, min/max ξ_k e a F legada sobre 224 células (14 combinações (r,q) × 2 amostras × 8 instrumentos), com DFM cacheado por (r,q,amostra). Relatório completo: `output/instrument/mosw_strength_grid.md`; CSV: `mosw_strength_grid.csv`. Destaques:

- **Produção (r=6, q=5), pre_covid:** a família GK é forte na régua rigorosa — z_jk_purif ξ_mp = 13.25, z_jk = 12.72, z_bruto_purif = 12.04, z_bruto = 11.62 (todos ≥ 10, AR limitado). Os het não cruzam 10: z_het_jk_3var = 9.27 (borderline), z_het_3var = 6.29, z_het_jk = 3.42 (< 3.84, AR potencialmente ilimitado), z_het = 1.59.
- **Produção (r=6, q=5), full:** nenhum instrumento ≥ 10 — z_het_jk 6.26 > z_jk 5.47 > z_jk_purif 5.20 > ... ; z_het (2.76) e z_het_3var (0.24) abaixo de 3.84.
- **A max-F legada superestimava os het em pre_covid** (z_het_3var: legada 10.8 vs ξ_mp 6.29; z_het_jk_3var: 11.1 vs 9.27) e **subestimava z_het_jk no full** (ξ₁ contra fator 1 ≈ 0.03, mas ξ_mp mediano 9.41, ≥ 10 nas células r=8): a relevância vive na direção de yield_6m, não no primeiro fator.
- **r ∈ {7,8} colapsa em pre_covid** (ξ_mp ≈ 0–4.7 na maioria das células com q ≤ 6): T = 84 meses não sustenta r alto — argumento de força adicional (além do IC) para (6,5)/(6,6) em pre_covid.
- **F conjunta ≤ 5.8 em todas as 224 células**: relevância unidirecional, consistente com Γ = α·Θ₀,₁ sob exogeneidade. A régua de decisão é ξ_mp; a F conjunta serve de sanity check de "relevância em alguma direção".

## 5. Arquivos alterados/criados

- `R/modeling/impulse_responde.R` — nova `compute_factor_space_wald()`; `diagnose` de `ident_ext_instr` imprime o bloco Wald.
- `R/identification/factor_space_diagnostics.R` — `diagnose_instrument_in_factor_space()` retorna `wald_k/min/max/joint`, `F_joint`, `p_joint`, `wald_mp` (controles = lags do VAR de fatores, correção Shat).
- `script/instrument_diagnostics.R` — coluna `xi1_mosw`, tabela §1.1 (bloco MOSW) e legenda/interpretação atualizadas; tabela legada intocada (diff aditivo verificado).
- `script/validate_olea_kilian.R` — validação end-to-end contra os números publicados (novo).
- `script/mosw_strength_grid.R` — grade ξ_mp/F conjunta sobre (r,q) × amostra × instrumento (novo, 2026-07-14); saídas em `mosw_strength_grid.{md,csv}`.
- `output/irf/spec_sweep_conclusoes.md` — adendo 2026-07-14 revisando as conclusões do sweep sob a régua ξ_mp.
- `codigo_olea/` — clone do repositório oficial (referência read-only).
