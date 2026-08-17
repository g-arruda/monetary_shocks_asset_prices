# Tema E — rodada de fechamento (2026-08-17)

Log de sessão, descartável. O que é durável está em `registro/pendencias.md`
(Tema E, bloco `Fechados`) e em
`notas/2026-08-17_selecao_q_e_fidelidade_amengual_watson.md`. Este arquivo
guarda as **medições intermediárias** que sustentaram as decisões e que sairiam
caro re-derivar.

## 1. `kilian_correction` — as quatro matrizes, medidas

Instrumentação em `kilian_correction`, produção `(5,5)` e VAR pequeno de
`cds_5y` (N=4, p=6).

| matriz | n (DFM) | det | rcond | ramo antigo (`det<1e-12`) | ramo novo (`rcond`) |
|---|---|---|---|---|---|
| Lyapunov (DFM) | 900 | 6,29e-19 | 1,705e-06 | ginv ❌ | solve ✓ |
| I_minus_B (DFM) | 30 | 2,046e-05 | 3,872e-04 | solve | solve |
| I_minus_B2 (DFM) | 30 | 9,151e-04 | 5,855e-04 | solve | solve |
| SIGMAY (DFM) | 30 | 2,893e+24 | 2,108e-05 | solve | solve |
| Lyapunov (VAR) | 576 | 3,493e-11 | **7,278e-17** | solve ❌ | ginv/abort ✓ |
| I_minus_B (VAR) | 24 | 1,082e-04 | 2,265e-09 | solve | solve |
| I_minus_B2 (VAR) | 24 | 1,853e-03 | 3,480e-09 | solve | solve |
| SIGMAY (VAR) | 24 | **1,136e-66** | **3,845e-05** | ginv ❌ | solve ✓ |

**Duas leituras que o item não previa.** (i) O mesmo defeito de subfluxo do
determinante estava em **SIGMAY**, com efeito invertido: pseudo-inversa numa
matriz perfeitamente invertível. (ii) O aviso "Usando pseudo-inversa para
SIGMAY" que o item dizia sair em toda rodada **não reproduz** em `(5,5)` —
`det(SIGMAY)` é 2,9e+24.

### A tentativa errada, registrada de propósito

Primeira versão usou `tryCatch(solve(...), error = ginv)`. **Regrediu o
benchmark VAR**: LAPACK só erra em pivô exatamente zero, então numa Lyapunov de
`rcond` 7,3e-17 o `solve()` retorna em silêncio, o `Abias` explode e as 800
réplicas de `cds_5y` falham — bandas NA em 49 de 49 horizontes, com o ponto
intacto. Pegou-se re-rodando `model_var.R` e comparando com o HEAD.

**Raiz do problema, e por que a solução final é abortar.** Se a equação de
Lyapunov é singular, `SIGMAY` (covariância incondicional do estado) **não está
definida**; a `ginv` devolve um objeto que não é essa covariância, e a fórmula de
Pope alimentada com ele dá viés enorme. `var_proxy.R:156` já cai para
coeficientes não corrigidos — o comportamento honesto. Com o limiar
`.Machine$double.eps^(2/3)` ≈ 3,7e-11, os **17** VARs pequenos passam a recusar
explicitamente a correção (rcond entre 7,3e-17 e 3,3e-13), e o DFM (1,7e-06)
segue com `solve`.

Raízes máximas das companions dos VARs core, para contexto: `cds_5y` 0,988814,
`embi_perc` 0,987584, `cambio_usd` 0,997443, `asset_ibov` 0,990122,
`yield_2y` 0,988263 — todas ~0,99, que é por que `1 − λᵢλⱼ` colapsa.

## 2. Amengual-Watson — a decomposição do gap

| comparação | gap | dispersão |
|---|---|---|
| MATLAB × projeto (`standardize = FALSE`, como está) | 1,636893 | 1,849e-02 |
| MATLAB × projeto (`standardize = TRUE`) | **0,0068259651** | **4,163e-16** |
| constante esperada `log(147/146)` | 0,0068259651 | — |

`q_hat` = 5 nos dois. A padronização do 2º estágio é a única divergência de
substância; o resto é desvio padrão populacional (`nanstd .* mult`) contra
amostral (`sd()`).

**`apply_bll = TRUE` medido:** `prcomp(yy)$rotation[,1:5]` ≡ `lambda` da produção
a 2,165e-15, e `cor(PC_k(yy), diff(F_prod)_k)` = 1,000000 nos cinco. Não é
espaço fatorial rival — é a produção diferenciada.

## 3. `cumsum` — o que entregou e o que não entregou

| métrica | antes | depois | o item previa |
|---|---|---|---|
| razão de largura h36/h0 (índices) | 27,573 | 0,920 | 10,46 → 0,38 |
| pico do Ibovespa | +17,71% em h=21 | +2,01% em h=8 | some o de +20,3% em h≈24 |
| sig68 em h ≤ 12 | 20 | **20** | 19 → 35 ❌ |
| sig90 total (índices) | 4 | **2** | — |
| sig90 em h=0 | 1 | 1 | invariante ✓ |
| vereditos `incoerente` | 9 | **9** (mesmo conjunto) | Ibov/IDIV/IMOB voltariam ❌ |
| `coerente_forte` → `parcial` | — | 4 (ibov, smll, idiv, imob) | não previsto |

Desvios no `irf_coherence_h.csv`: séries **não-asset** têm ponto com desvio
**exatamente 0** e bandas ≤ 1,65e-06 (efeito Kilian); `asset_*` em h=0 tem ponto
0 e bandas ≤ 1,67e-10. Das 8 figuras, só `fig_acoes` mudou — as outras 7 saíram
**pixel-idênticas** (pdftoppm + sha256).

⚠ Armadilha de verificação: `pdftoppm -r 60 -png arq.pdf -` grava **0 bytes** no
stdout neste build, então a primeira comparação de figuras deu "idêntica" para
todas por comparar string vazia com string vazia. Usar prefixo de arquivo.

## 4. Cache do `model_nongaussian.R`

A chave de validade comparava `nboot`, `r`, `q` e `var_names`, mas **não
`tcode`**, que ela mesma guarda. Resultado: a troca 2 → 6 reusou em silêncio o
caminho cumulado (proxy `asset_ibov` h24 = +16,83 contra os −0,47 de produção).
Corrigido com `identical(cached$tcode, tcode)`.

## 5. Upstream do DI, verificado na API do GitHub

- `b3_di.parquet` **não existe mais**; a release traz `b3_futures.parquet`,
  `anbima_tpf.parquet`, `vna_ntnb.parquet`.
- Schema novo: `TradDt`, `TckrSymb`, `AdjstdQtTax` — sem `ExpirationDate`,
  `BDaysToExp`, `CloseRate` (eram derivadas).
- Cobertura do asset novo: **2018-01-02 a 2026-08-14**. `load_di_panel()` pede
  desde 2012-06-01.
- Releases mantidas: ~30 (`data-2026-02-10` já dá 404).
- `pyield` 0.43.1 **está instalado** — é o caminho para reconstruir as derivadas.
