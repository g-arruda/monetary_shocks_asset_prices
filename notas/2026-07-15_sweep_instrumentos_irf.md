# Varredura de instrumentos × (r,q): nenhum salva as IRFs — e por que ξ_mp>0 gera IRF errada

> **⚠️ SUPERADA — banner de 2026-07-26.** Vintage pré-refresh, grade com 6 instrumentos incluindo
> `z_het_jk_3var`, dimensões (6,5)/(7,6)/(8,8).
> **Sobrevive e é importante:** relevância ≠ validade — a inversão da curva é estatisticamente
> **independente** da força do instrumento (`cor(curve_slope, ξ_mp) = −0,04`), logo fortalecer o
> instrumento não conserta as IRFs. É esta nota que derruba a afirmação central de
> `2026-07-11_varredura_irf.md`. **Antigo:** os números, e o próprio diagnóstico de "0 de 36 células
> limpas" — no vintage atual em (7,6) a curva não está invertida (ver `output/irf/irf_section.md` §5.1).


**Data:** 2026-07-15 · **Script:** `script/irf_instrument_diag_sweep.R` ·
**Grade:** 6 instrumentos × 3 (r,q) {(6,5),(7,6),(8,8)} × 2 amostras {full, pre_covid} = **36 células**,
config de produção idêntica (nboot=800, seed=123, p=6, h=48, +50bp, `mp_var=yield_6m`). Sanity: impacto
do mpind = +0.005000 em todas; 6 células (r=8, pre_covid) são **explosivas** (`max_eig`=1.0006) — marcadas
degeneradas, não sustentam conclusão.

## Resposta curta

1. **Nenhum instrumento é bom: 0 de 36 células limpas.** "Limpa" = curva decai da maturidade curta **e**
   núcleo do IPCA fica negativo na janela **e** câmbio não é significativamente errado no impacto. Nenhuma
   célula passa nos três.
2. **Por que ξ_mp>0 (às vezes >10) gera IRF errada:** o defeito central — a **curva invertida** — é
   **estatisticamente independente da força**: `cor(curve_slope, ξ_mp) = −0.04` (≈0) e
   `cor(curve_slope, F_factor) = +0.24` (sinal errado). Força mede relevância **numa direção** (yield_6m);
   as IRFs erradas vêm da **direção/validade** do choque, que a força não corrige.

## Veredito por célula (resumo)

| dimensão | full (18 células) | pre_covid (18 células) |
|---|---|---|
| **curva invertida** (slope>0, pico em 2y-5y) | **18/18** — todos os 6 instrumentos, todo (r,q) | (6,5)/(7,6): sim; r=8: slope<0 mas **degenerado**, e pico em 1y (nunca no short) |
| **price puzzle no núcleo** (`core_ex0` não fica <0) | **17/18** (exceção só `z_het_jk_3var` (8,8)) | **2/18** (só (7,6)) — em geral **limpa** |
| **câmbio sig. errado no h0** (depreciação sig.) | **18/18** | **0/18** — some no pre-COVID |
| **nº de defeitos {curva,núcleo,câmbio}** | **2-3 em todas** | **1 em quase todas** (só a curva residual) |
| **células limpas** | **0** | **0** |

Ordenando por ξ_mp (força): no full, a célula **mais forte** (`z_jk_bs_purif` (8,8), ξ_mp **13.1**) é tão
invertida (slope +0.0047) quanto a **mais fraca** (`z_het_jk_3var` (6,5), ξ_mp 4.25, slope +0.0053). No
gráfico `inst_diag_curve_h0_by_rq.pdf`, os 6 instrumentos **se sobrepõem** em cada painel não-degenerado —
a escolha de instrumento não muda a forma da curva.

## Por que força (ξ_mp>0) não compra IRF limpa — mecanismo

Tudo referenciado em `inst_diag_summary.csv` e `inst_diag_contam_vs_strength.pdf`.

1. **Relevância é DIRECIONAL; a IRF depende de TODAS as direções.** ξ_mp é o Wald de MOSW **na direção de
   impacto de `yield_6m`** — uma projeção escalar. Ele certifica que o instrumento move a combinação de
   inovações de fatores que carrega o 6m. Mas a IRF de **cada** variável (curva inteira, preços, câmbio) é
   regida pela direção **completa** do choque `v0 = K·M·H` no espaço de q fatores. Como `v0` carrega os
   demais fatores é algo sobre o qual ξ_mp **nada diz**. Logo "ξ_mp alto **e** curva invertida" não é
   contradição — é o esperado quando a relevância direcional não implica choque limpo nas outras dimensões.
2. **Nenhuma métrica de força prevê a limpeza.** `cor(slope, ξ_mp) = −0.04`; `cor(slope, F_factor) = +0.24`
   (se algo, F maior → mais invertida). A F reduzida contra `yield_6m` é enorme (25-70) e não ajuda. As três
   Fs medem relevância; a curva errada é problema de **validade/direção**, não de magnitude.
3. **Relevância ≠ validade.** O instrumento é relevante (prevê juros), mas o choque identificado **não é um
   choque puro de juros curtos**: carrega estruturalmente o belly/long (componente de path/nível). As
   purificações testadas — JK contemporânea (`z_jk_purif`), BS pré-evento (`z_jk_bs_purif`), máscara crua
   (`z_jk_raw_purif`), heterocedástica (`z_het_jk_3var`), cru (`z_bruto`), JK sem purif (`z_jk`) — **não
   removem** essa carga: as 6 curvas coincidem. É propriedade do que a surpresa de DI de Copom mede, não da
   receita de purificação nem da força.
4. **O puzzle de preços e o câmbio errado são de AMOSTRA (COVID), não de força.** Universais no full
   (qualquer instrumento, qualquer ξ_mp), somem no pre-COVID (qualquer instrumento). Portanto também não
   rastreiam ξ_mp — rastreiam a janela. No scatter, os pontos separam-se por **cor (amostra)**, não pela
   posição no eixo ξ_mp.

## Conclusão

- **A restrição efetiva é a direção/validade do choque** (e a amostra COVID para preços), **não a força do
  instrumento.** Fortalecer ξ_mp — trocar de instrumento, subir r/q — **não** conserta as IRFs: 0/36 limpas,
  e a curva invertida é ortogonal a toda métrica de força.
- **Nenhum dos 6 instrumentos é adequado** para ler as IRFs de política como estão. O melhor que a grade
  alcança é o **pre-COVID** (núcleo e câmbio limpam para qualquer instrumento), mas mesmo lá a curva não
  decai do short (pico em 1y-2y) e as células de r=8 são explosivas.
- **Encaminhamento** (não neste escopo): o problema é a **composição do choque** (carrega path/nível).
  Opções coerentes com o diagnóstico — (i) ortogonalizar o instrumento contra um fator de nível/inclinação
  da curva **antes** da projeção H; (ii) assumir explicitamente um choque de "path" e normalizar/ler no 2y
  (convenção dos autores), aceitando que não é um choque de short puro; (iii) restringir a inferência ao
  pre-COVID para a história de preços/risco, com inferência robusta a instrumento fraco (AR/ξ_mp). Ver
  `2026-07-15_auditoria_identificacao_vs_alessi.md`.

**Artefatos:** `output/irf/inst_diag_{summary,verdict,h,curve_h0}.csv`,
`inst_diag_{curve_h0_by_rq,contam_vs_strength,paths}.pdf`.
