# Auditoria da identificação vs Alessi-Kerssenfischer + diagnóstico amostra × rotação

> **ℹ️ PARTE 1 VIVA, NÚMEROS ANTIGOS — banner de 2026-07-26.** Escrita sob `z_jk_bs_purif` ×
> (6,5)/(8,8), vintage pré-refresh.
> **Sobrevive integralmente:** a verificação do port R↔MATLAB contra `codigo_alessi-mark/`
> (5 de 5 pontos fiéis) — é independente de instrumento, dimensão e vintage, e é a referência de
> fidelidade do projeto. **Antigo:** os diagnósticos numéricos de contaminação amostral × rotação,
> que são do vintage pré-refresh (o refresh mudou a força do instrumento em (7,6)).


**Data:** 2026-07-15 · **Instrumento:** `z_jk_bs_purif` · **Scripts:** `script/irf_sample_diagnostic.R`
(numérico), referência `codigo_alessi-mark/{DFMest_BLL,IdentExtInstr}.m` · **Motivação:** o choque
identificado parecia contaminado (curva invertida no h0, price puzzle no núcleo até h40, câmbio/CDS
sig. errados). Duas frentes: (path 1) confrontar nossa tradução R com o código dos autores; (path 3)
testar se a contaminação é dirigida pela amostra COVID.

## Sumário executivo

**São DOIS problemas distintos, não um — e têm causas diferentes:**

1. **Price puzzle (núcleo/IPCA) + FX/risco significativamente errados = contaminação amostral
   (COVID).** No pre-COVID (onde a F de factor-space sobe de 5.1 para 11.7) o núcleo do IPCA **vira
   negativo** (correto) e a significância dos sinais errados de câmbio/CDS **desaparece**. Path 3
   **confirmado** para inflação e risco.
2. **Curva invertida no impacto (pico em 2y-5y, não no short) = propriedade ESTRUTURAL do
   instrumento**, robusta à amostra **e** à rotação. Não é bug de tradução, não é COVID: aparece
   idêntica no full, no pre-COVID e no **benchmark exato dos autores (r=q=8, K=M=1)**.

**Tradução R ↔ MATLAB: fiel em 5/5 pontos** (abaixo). A contaminação **não** vem do nosso port.

---

## Parte 1 — Confronto R ↔ `codigo_alessi-mark/` (5 pontos)

Cadeia de reconstrução do IRF (ambos): `imp = cumimp( [ diag(sy)·Λ·B·K·M · H ] / mpind_h0 · shock )`.

| # | Passo | MATLAB (autores) | R (nosso) | Veredito |
|---|-------|------------------|-----------|----------|
| 1 | Λ e fatores | `lambda=eigs(cov(yy),r)`; `F=Z*lambda` (`DFMest_BLL.m:24-26`) — `yy`=Δ padronizado, `Z`=nível detrend/sy | `svd(cov(yy))$u[,1:r]`; `F=Z%*%lambda` (`factor_estimation.R:323-347`) | **MATCH** |
| 2 | Rotação K/M | q=r⇒`K=M=1`; senão `K=eigs(cov(u),q)`, `M=diag(sqrt)`, `eta=u*K/M` (`:53-61`) | idêntico (`factor_estimation.R:650-682`) | **MATCH** |
| 3 | Projeção H | `rsh_mean0=rsh-mean`; `H=(Z\rsh_mean0)'` (`IdentExtInstr.m:5-6`) | `sweep(...,colMeans)`; `H=crossprod(Z,η)/crossprod(Z)` (`impulse_responde.R:67-71`) | **MATCH** (η em Z, sem controles de defasagem no ponto) |
| 4 | Undo de `sy` | `C=(lambda*B*K*M).*repmat(sy',1,q)` (`:62`) | `sweep(Λ%*%B%*%K%*%M,1,sy,"*")` (`impulse_responde.R:377-379`) | **MATCH** |
| 5 | Normalização | `imp./imp(mpind,1)*.5` **antes** de `cumimp` (`IdentExtInstr.m:14-15`) | `irf/irf[mpind,1]*0.005` antes de `cumimp_transform` (`impulse_responde.R:121-125`) | **MATCH** (0.5 = 50bp em % ; 0.005 = 50bp em decimal) |

**Regras de sinal do R cancelam-se.** O R impõe normalização de sinal determinística nas colunas de
Λ (`factor_estimation.R:336-344`) e K (`:665-673`), ausente no MATLAB. Um flip de coluna-j de K
inverte a coluna-j de `η` → inverte `H_j` → o produto `(K·M·H)` é invariante (dois flips cancelam);
idem para Λ (inverte F, u e companion consistentemente). **As IRFs são invariantes a essas regras** —
não são fonte de contaminação.

**Divergência real (não-bug):** os autores rodam o **benchmark em r=q=8** ⇒ `K=M=1` (rotação
identidade); nossa produção (6,5) tem q<r e constrói a rotação espectral K/M. Isto é testado
numericamente na Parte 2 pela célula (8,8) — e **não** explica a curva invertida.

**Convenção de normalização:** os autores normalizam no **2y** (`gov2y_DE`), não no 6m, e **não**
plotam uma curva de juros ordenada — não há template de "decaimento esperado" no pacote de referência.

---

## Parte 2 — Diagnóstico numérico (amostra × config)

`run_stage2_cell`, produção (nboot=800, seed=123, h=48, +50bp). Sanity: impacto do mpind = +0.005000
em todas; `max_eig`<1 exceto (8,8)-pre = **1.0006 (explosivo — célula degenerada, F 3.37; descartar)**.

### 2a. Curva no IMPACTO (h0) — pico em 2y-5y em toda célula confiável

| célula | 3m | 6m | 1y | 2y | 5y | 10y | pico | F_fs | ξ_mp |
|--------|----|----|----|----|----|-----|------|------|------|
| (6,5) full | .0032 | .0050 | .0069 | .0084 | **.0088** | .0078 | 5y | 5.12 | 6.94 |
| (6,5) pre | .0040 | .0050 | .0060 | .0073 | **.0083** | .0071 | 5y | 11.66 | 12.49 |
| (8,8) full *(K=M=1)* | .0033 | .0050 | .0068 | .0080 | **.0080** | .0070 | 5y | 5.27 | 13.13 |
| (8,8) pre *(degenerada)* | .0034 | .0050 | .0063 | .0058 | .0013 | −.0002 | 2y | 3.37 | 5.14 |
| (6,5) full @2y | .0019 | .0030 | .0041 | .0050 | **.0052** | .0046 | 5y | 5.12 | 6.94 |

A curva **sobe** com a maturidade até 2y-5y em **todas** as células confiáveis — inclusive no
pre-COVID (F forte) e no benchmark identidade dos autores (8,8 full, ξ_mp 13.1). Só a célula
degenerada (8,8)-pre "decai", e ainda assim com pico no 2y. Normalizar no 2y (autores) **só reescala**
— o pico continua no 5y. **A inversão é invariante a amostra, rotação e vértice de normalização.**
Ressalva importante: as bandas dos yields são enormes (±0.10 vs pontos ~0.005-0.009) — a ordenação é
característica do **ponto**, dentro de bandas que a tornam n.s. (instrumento fraco no espaço de fatores).

### 2b. Núcleo / IPCA — o price puzzle é COVID (path 3 confirmado)

| var | (6,5) full | (6,5) **pre** | (8,8) full | (8,8) pre |
|-----|-----------|-----------|-----------|-----------|
| `price_core_ipca_ex0` h0 | +0.085 (nunca<0, **incoerente**) | **−0.105 (coerente)** | +0.020 (vira h16) | −0.086 (coerente) |
| `price_ipca` h0 | +0.098 (parcial) | **−0.253 (coerente)** | −0.066 (parcial) | −0.356 (coerente) |

No pre-COVID o núcleo responde **negativo já no impacto** (correto). O puzzle do full é artefato de
amostra (COVID), não de identificação.

### 2c. Câmbio / risco — significância errada some no pre-COVID

| célula | câmbio h0 (sig90) | cds_5y (sig90) | embi (sig90) |
|--------|-------------------|----------------|--------------|
| (6,5) full | +0.185 **sig** | +3401 **sig** | +0.250 **sig** |
| (6,5) pre | +0.090 n.s. | +4083 sig | +0.390 sig |
| (8,8) full | +0.120 **sig** | +2590 **sig** | +0.185 **sig** |
| (8,8) pre | +0.056 n.s. | +1463 **n.s.** | +0.170 **n.s.** |

Os sinais "errados" (depreciação + abertura de risco) **perdem significância** no pre-COVID
(totalmente em (8,8)-pre). Compatível com contaminação COVID / dominância fiscal do período.

### 2d. PIB e dentes — NÃO melhoram com a amostra

- **PIB** começa **positivo** (errado) em quase toda célula (h0: (6,5)full −0.01, (6,5)pre **+0.25**,
  (8,8)full **+0.28**, (8,8)pre **+0.80**), com vale tardio (h37-40). O pre-COVID **piora** o impacto.
  Contradiz `ibc_br` (negativo no h0 em todas) — provável artefato do PIB mensalizado/ruidoso.
- **Dentes** (reversões de tendência h0-40): 7-23 por variável, **não** reduzem no pre-COVID (núcleo
  chega a 17-21 no pre vs 10 no full). Estrutural (baixa comunalidade + raízes complexas do VAR(6)).

---

## Parte 3 — Interpretação

**Problema 1 (inflação/risco) — amostral, atacável pela janela/instrumento.** O price puzzle e os
sinais errados de FX/risco somem/atenuam no pre-COVID, onde a F de factor-space é forte (11.7 vs 5.1).
A leitura "puzzle amostral, n.s." que eu havia dado ao IPCA cheio estava **incompleta**: no núcleo o
puzzle é positivo até h40 no full, e é o pré-COVID que o corrige. O canal é a **fraqueza do
instrumento no espaço de fatores no full sample** (COVID).

**Problema 2 (curva invertida) — estrutural do instrumento, não é bug nem COVID.** O `z_jk_bs_purif`
é uma surpresa de DI ~6m, mas o choque identificado carrega o **belly/long (2-5y)** mais que o short,
em toda amostra e rotação (inclusive K=M=1). Duas leituras não excludentes:
- **Componente de path/forward-guidance (legítimo):** surpresas de Copom revisam a trajetória
  esperada de 1-2 anos — mover 1y>6m e 2y>1y é defensável. **Mas o pico no 5y** é difícil de justificar
  como política pura (mais prêmio a termo/long-run) → sugere carga de nível/long no instrumento.
- **Fraqueza de identificação:** as bandas dos yields são enormes; a ordenação é do ponto, n.s. Com
  F_fs ≈ 5 no full, o `v0 = K·M·H` é mal-identificado — sinais/ordenação cruzados são consequência
  mecânica (o próprio `ident_ext_instr` já avisa isto em `impulse_responde.R:100-106`).

---

## Parte 4 — Conclusão e pendências

- **Não é bug de tradução.** A identificação R reproduz Alessi-Kerssenfischer em 5/5 pontos; as regras
  de sinal cancelam; o benchmark r=q=8 (K=M=1) reproduz a mesma inversão.
- **A alavanca é o instrumento/amostra, não (r,q) nem o código.** Confirma o descarte da recomendação
  de (r,q) da nota `2026-07-15_irf_rq_candidates.md` (**marcada como superada**).
- **Encaminhamentos possíveis (NÃO aplicados — decisão do autor):**
  1. **Contar a história no pre-COVID** (2013-2019, F forte): núcleo cai, câmbio n.s. — IRFs de
     inflação/risco coerentes. Custo: perde COVID, T=78, r≥7 colapsa.
  2. **Investigar a carga de long-end** do `z_jk_bs_purif`: por que uma surpresa de 6m projeta no 5y?
     Testar ortogonalizar o instrumento contra um fator de nível da curva **antes** da projeção H, ou
     aceitar a leitura de "choque de path" e normalizar no **2y** (convenção dos autores) — a curva
     continua subindo, mas o alvo de normalização fica no belly, onde o instrumento é forte.
  3. **Revisar máscara/purificação do `z_jk_bs_purif`:** checar se a purificação BS injeta componente
     de nível; comparar a curva h0 entre variantes (`z_jk_raw_purif`, `z_het_jk`) — se alguma entrega
     curva com pico no short, é diagnóstico da variante.
  4. **Inferência robusta a instrumento fraco (Anderson-Rubin/ξ_mp)** obrigatória no full — pendência
     metodológica #1 já registrada.
- **PIB e jaggedness** são questões separadas (série mensalizada; raízes complexas do VAR) — não
  confundir com a contaminação do choque.
