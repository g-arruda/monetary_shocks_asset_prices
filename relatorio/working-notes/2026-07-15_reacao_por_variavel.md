# Reação de cada variável a +50bp, por instrumento × configuração

> **⚠️ SUPERADA — banner de 2026-07-26.** Vintage pré-refresh e **anterior à correção de tcode dos
> índices B3** — todas as linhas de `asset_*` estão fora de escala.
> **Sobrevive:** a conclusão de que a escolha de instrumento quase não move as IRFs (as 6 linhas se
> sobrepõem) e que **a amostra (full × pre-COVID) é que dirige tudo**.
> **Antigo:** as 36 células incluem `z_het_jk_3var` e usam (6,5)/(8,8) no vintage velho.


**Data:** 2026-07-15 · **Scripts:** `script/irf_instrument_report.R` (+ `_plots.R`) ·
**Grade:** 6 instrumentos × 3 (r,q) {(6,5),(7,6),(8,8)} × 2 amostras {full, pre_covid} = 36 células,
produção (nboot=800, seed=123, h=48, +50bp, `mp_var=yield_6m`). Lido ponto a ponto h=0..40.

**Plots:** `output/irf/inst_report_by_variable_instruments.pdf` (1 página/variável, 6 instrumentos
sobrepostos, 6 painéis (r,q)·amostra) e `..._bands.pdf` (instrumento default `z_jk_bs_purif` com
bandas 68/90). Dados: `inst_report_paths.csv` (ponto+bandas), `inst_report_summary.csv`.

## Como ler / achado transversal

**A escolha do instrumento quase não importa — a amostra (full vs pre-COVID) é que move tudo.** Em
todos os painéis, as 6 linhas de instrumentos se sobrepõem; o que separa "certo" de "errado" é a
janela. Por isso a tabela abaixo agrega as 18 células de cada amostra (6 instrumentos × 3 (r,q)).

Legenda: **h0 ok** = de 18 células, quantas têm sinal no impacto igual ao teórico; **impacto** = média
do h0; **share✓** = fração média de horizontes (0-40) com sinal correto; **sig** = células com ≥1
horizonte significativo a 90%.

| variável | esp. | **FULL** h0 ok · impacto · share✓ · sig | **PRE-COVID** h0 ok · impacto · share✓ · sig | leitura |
|---|:--:|---|---|---|
| **Yield 6m** (política) | + | 18/18 · +0.005 · 0.30 · 18 | 18/18 · +0.005 · 0.73 · 18 | normalizado; no full reverte e fica negativo (share 0.30) |
| **Yield 5y** | + | 18/18 · **+0.010** · 0.33 · 18 | 15/18 · +0.005 · 0.53 · 4 | sobe **mais que o 6m** (curva invertida); reverte após ~h8 |
| **IBOV** | − | 17/18 · −0.036 · 0.30 · 6 | 11/18 · −0.039 · 0.62 · 5 | cai no impacto (correto) mas **reverte** para positivo; raramente sig |
| **Câmbio USD** | − | **0/18** · +0.188 · 0.52 · **18** | 3/18 · +0.059 · 0.53 · **0** | **deprecia e é significativo no full** (errado); no pre atenua e vira n.s. |
| **CDS 5y** | − | **0/18** · +3854 · 0.64 · **18** | 1/18 · +2609 · 0.27 · 3 | **abre risco e é sig no full** (errado); pre menos sig |
| **Núcleo IPCA (ex0)** | − | **0/18** · +0.043 · **0.10** · **12** | 12/18 · −0.031 · 0.70 · 0 | **price puzzle puro e sig no full**; **limpa no pre** (fica negativo) |
| **IPCA cheio** | − | 11/18 · −0.021 · 0.51 · 2 | 16/18 · **−0.184** · 0.81 · 0 | hump n.s. no full; **claramente negativo no pre** |
| **Crédito total** | − | 3/18 · +0.209 · 0.76 · 9 | 7/18 · +0.006 · 0.71 · 0 | **sobe→contrai** (cronologia BG95); contração sig no full |
| **Crédito PF** | − | 6/18 · +0.006 · 0.83 · 0 | 2/18 · +0.117 · 0.56 · 5 | idem, share alta (0.83) mas nunca sig no full |
| **Spread ICC PJ** | + | **0/18** · −0.018 · 0.72 · 5 | 12/18 · +0.006 · 0.72 · 0 | **comprime no impacto** (errado), alarga tarde (bifásico) |
| **Spread ICC PF** | + | 9/18 · +0.005 · 0.71 · 0 | 15/18 · +0.044 · 0.80 · 0 | alarga (mais correto), nunca sig |

## Detalhe por variável (todos os 6 instrumentos, salvo nota)

**Yield 6m** — ancorada em +0.005 no h0 por construção. No **full** decai e cruza zero por ~h10,
ficando levemente negativa (overshoot); `share✓` 0.30. No **pre** mantém-se positiva bem mais tempo
(share 0.73). Instrumentos idênticos.

**Yield 5y** — sobe **acima** do 6m no impacto (~+0.010–0.015 vs +0.005) — a **curva invertida** — em
**todas** as 18 células full e na maioria pre; decai e vira levemente negativa após h8-10. Sinal (+)
"correto" mas magnitude na maturidade errada. Ver `inst_report...instruments.pdf` p.4.

**IBOV** — **cai no impacto** (−0.01 a −0.02, correto) em 17/18 full, mas **reverte** para ~0/positivo
em poucos meses (`share✓` full 0.30). Raramente significativo (6/18 full). No pre cai um pouco mais
persistente (share 0.62). É a "incoerência por trajetória", não por impacto.

**Câmbio USD** — **deprecia forte e significativamente** no impacto no **full** (+0.19, 18/18 sig) —
sinal **errado** para um aperto (deveria apreciar); decai e vira levemente negativa por h15-25. No
**pre** o impacto é pequeno (+0.06) e **não significativo** (0/18 sig), virando apreciação por h5-10.
→ o sinal errado é fenômeno **de amostra (COVID)**. Ver p.2.

**CDS 5y** — **abre (sobe) e é significativo** no impacto em todo o full (18/18 sig) — **errado**
(aperto deveria fechar risco); reverte para negativo depois (share 0.64). No pre, menos significativo
(3/18). Câmbio e CDS contam a mesma história de dominância fiscal/COVID.

**Núcleo IPCA (ex0)** — **price puzzle puro**: positivo em ~90% dos horizontes no full (`share✓` 0.10),
**significativo em 12/18 células** — o defeito mais grave. No **pre-COVID vira negativo** no impacto
(12/18 h0 ok, share 0.70) e nunca significativo. **A escolha de instrumento não muda** — só a amostra.
Ver p.10 e o `..._bands.pdf` p.10.

**IPCA cheio** — no full faz hump positivo e retorna a ~0 (share 0.51, quase nunca sig: 2/18); no
**pre** é **claramente negativo** (−0.18 no impacto, share 0.81). Mesma mensagem do núcleo, menos
extrema.

**Crédito total** — **cronologia rise-then-contract** (BG95/GG94): sobe no impacto (+0.2 a +0.5),
mantém-se positiva ~8-10 meses, depois **contrai forte** (−1 a −1.5) — a contração é significativa em
9/18 full. `share✓` 0.76. É a variável **mais coerente** no médio prazo. `z_het_jk_3var` (amarelo) é o
outlier que contrai menos. Ver p.7.

**Crédito PF** — igual, com `share✓` 0.83 (a maior de todas), mas nunca significativa no full.

**Spread ICC PJ** — **comprime no impacto** (−0.02, errado) em todo o full — compressão mecânica —,
depois **alarga** (acelerador) por h12-24; bifásico, `share✓` 0.72. A janela de score 0-12 pega a fase
errada (já registrado). No pre, alarga desde cedo (12/18 h0 ok).

**Spread ICC PF** — alarga mais consistentemente (9/18 full, 15/18 pre h0 ok), nunca significativo.

## Conclusão

- **A reação de cada variável é essencialmente a mesma nos 6 instrumentos** — as linhas coincidem em
  cada painel. Trocar de instrumento não muda a leitura de nenhuma variável.
- **O eixo que importa é a amostra.** No **full**, os defeitos são sistemáticos e vários **significativos**:
  núcleo em puzzle (sig 12/18), câmbio depreciando (sig 18/18), CDS abrindo (sig 18/18), curva
  invertida (5y>6m, 18/18). No **pre-COVID**, núcleo/IPCA ficam negativos e câmbio/CDS perdem
  significância — mas a **curva continua invertida** e crédito/IBOV pouco mudam.
- **Coerentes em qualquer amostra:** apenas **crédito** (sobe→contrai) e o **sinal de impacto do IBOV**
  (cai, embora reverta). Todo o resto é contaminado no full.

Coerente com `2026-07-15_sweep_instrumentos_irf.md` (0/36 células limpas; contaminação independe de
ξ_mp) e `..._auditoria_identificacao_vs_alessi.md` (curva = validade/direção; preços/FX = amostra).

**Artefatos:** `output/irf/inst_report_by_variable_instruments.pdf`, `..._bands.pdf`,
`inst_report_paths.csv`, `inst_report_summary.csv`.
