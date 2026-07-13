# Coerência ponto a ponto das IRFs — especificação de produção

Gerado por `script/irf_coherence_check.R` em 2026-07-12.

Especificação: `z_jk_purif` x `yield_6m`, r=6, q=5, p=6, full sample, choque +50bp, wild bootstrap nboot=800 (seed 123), bandas 68/90, h=0..48.

## Método

Para cada variável, cada horizonte h é checado quanto a sinal e significância
(CI68/CI90) contra a janela teórica [w_lo, w_hi] definida em
`R/identification/irf_coherence.R::coherence_var_table()`. Vereditos:
`coerente_forte` (≥80% da janela com sinal certo + significância CI68),
`coerente` (≥80% sem significância), `parcial` (50-80%, sem violação
significativa), `incoerente` (<50% ou sinal errado com CI90 excluindo 0),
`soft_*` (canal registrado — dominância fiscal admissível), `ambigua`
(sem prior forte), `placebo_ok/viola` (externas: CI90 deve conter 0 em ≥90% de h0-h24).

## Contagem de vereditos

| tier | verdict | n |
|---|---|---|
| ambiguous | ambigua |     6 |
| placebo | placebo_ok |     3 |
| placebo | placebo_viola |     1 |
| scored | coerente_forte |    17 |
| scored | incoerente |    11 |
| scored | coerente |     5 |
| scored | parcial |     5 |
| soft | soft_depreciacao_fiscal_dom |     2 |
| soft | soft_risco_abre_fiscal_dom |     2 |

## Violações (incoerente / placebo_viola / sinal errado significativo)

| group | var | verdict | share_correct | wrong_sig90 | h0 | h12 | h24 |
|---|---|---|---|---|---|---|---|
| curva_juros | juros_cdi | incoerente | 0.4286 | FALSE |  0.02 | -0.06371 | -0.1104 |
| curva_juros | juros_selic | incoerente | 0.1667 | FALSE | 0.02096 | -0.06385 | -0.1115 |
| acoes | asset_ibov | incoerente | 0.4286 | FALSE | -0.08929 | 0.009695 | 0.007556 |
| acoes | asset_imob | incoerente | 0.4286 | FALSE | -0.1093 | 0.009125 | 0.005319 |
| acoes | asset_mlcx | incoerente | 0.4286 | FALSE | -0.0882 | 0.008752 | 0.00618 |
| risco_cambio_soft | cambio_usd | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.2454 | 0.07924 | -0.0686 |
| risco_cambio_soft | cambio_eur | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.2463 | 0.08023 | -0.06639 |
| risco_cambio_soft | embi_perc | soft_risco_abre_fiscal_dom |     0 | TRUE | 0.464 | 0.08254 | -0.143 |
| risco_cambio_soft | cds_5y | soft_risco_abre_fiscal_dom |     0 | TRUE |  5604 |  1188 | -1299 |
| trabalho | trab_pop_ocupada | incoerente | 0.3226 | FALSE | 114.6 | -49.01 | 376.2 |
| credito | spread_icc_juridica | incoerente |     0 | TRUE | -0.03212 | -0.004756 | 0.08219 |
| credito | spread_icc_fisica | incoerente | 0.2308 | FALSE | 0.0003962 | 0.0169 | 0.1262 |
| credito_setorial | credito_transporte | incoerente | 0.7419 | TRUE | 1.973 | 0.2204 | -1.476 |
| precos | price_core_ipca_ex0 | incoerente |     0 | FALSE | 0.05906 | 0.05385 | 0.07015 |
| precos | price_core_ipca_dw | incoerente | 0.4865 | FALSE | 0.0599 | 0.02156 | 0.0006107 |
| placebo_externas | commodity_metal | placebo_viola |    NA | NA | 14.09 | 5.139 | -1.388 |

## Trajetórias por grupo (unidades nativas; tcode aplicado)

### curva_juros

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| yield_3m | 0.002746 | 0.003131 | 0.002021 | 0.0001241 | -0.001294 | -0.005532 | -0.006505 |     1 | coerente_forte |
| yield_1y | 0.00774 | 0.008039 | 0.006193 | 0.001397 | -0.001923 | -0.006505 | -0.006057 |     1 | coerente_forte |
| yield_2y | 0.01046 | 0.01018 | 0.008084 | 0.00207 | -0.002138 | -0.006235 | -0.004929 |     1 | coerente_forte |
| yield_5y | 0.01219 | 0.01095 | 0.008845 | 0.002541 | -0.002177 | -0.005178 | -0.0033 |     1 | coerente_forte |
| yield_10y | 0.01115 | 0.009961 | 0.008106 | 0.002365 | -0.002101 | -0.004505 | -0.002666 |     1 | coerente_forte |
| juros_cdi |  0.02 | 0.005744 | -0.03969 | -0.06371 | -0.1104 | -0.4413 | -0.586 | 0.4286 | incoerente |
| juros_selic | 0.02096 | 0.006375 | -0.03907 | -0.06385 | -0.1115 | -0.4421 | -0.5861 | 0.1667 | incoerente |

### acoes

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ibov | -0.08929 | 0.00975 | -0.001921 | 0.009695 | 0.007556 | 0.005918 | -0.00223 | 0.4286 | incoerente |
| asset_smll | -0.1044 | -0.001699 | -0.01018 | 0.006139 | 0.006109 | 0.006785 | -0.002532 | 0.7143 | parcial |
| asset_idiv | -0.08975 | 0.002945 | -0.006739 | 0.008221 | 0.01459 | 0.01187 | 0.001992 | 0.5714 | parcial |
| asset_imob | -0.1093 | 0.005725 | -0.004388 | 0.009125 | 0.005319 | 0.007888 | 0.0008699 | 0.4286 | incoerente |
| asset_ifix | -0.03842 | -0.008687 | -0.008156 | -0.001643 | -0.004157 | -0.003105 | -0.006389 |     1 | coerente_forte |
| asset_mlcx | -0.0882 | 0.008166 | -0.002749 | 0.008752 | 0.00618 | 0.00529 | -0.002362 | 0.4286 | incoerente |

### acoes_ambiguas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ifnc | -0.1119 | 0.004306 | -0.00768 | 0.009814 | 0.01702 | 0.0118 | -0.0005966 |    NA | ambigua |
| asset_imat | -0.04717 | 0.02486 | 0.01245 | 0.01218 | 0.002075 | 0.005896 | 0.006702 |    NA | ambigua |

### risco_cambio_soft

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| cambio_usd | 0.2454 | 0.2902 | 0.2341 | 0.07924 | -0.0686 | -0.04799 | 0.04085 |     0 | soft_depreciacao_fiscal_dom |
| cambio_eur | 0.2463 | 0.286 | 0.2362 | 0.08023 | -0.06639 | -0.01691 | 0.08719 |     0 | soft_depreciacao_fiscal_dom |
| embi_perc | 0.464 | 0.3527 | 0.2986 | 0.08254 | -0.143 | -0.1692 | -0.07653 |     0 | soft_risco_abre_fiscal_dom |
| cds_5y |  5604 |  4659 |  3825 |  1188 | -1299 | -1815 | -765.7 |     0 | soft_risco_abre_fiscal_dom |

### atividade

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| ibc_br | -0.9792 | -1.055 | -0.7521 | -0.5812 | -0.07004 | -0.1831 | -0.1817 |     1 | coerente_forte |
| pib | 0.003168 | -0.2969 | -0.2851 | -0.2263 | -0.02609 | -0.3908 | -0.5545 |     1 | coerente_forte |
| ind_transformacao | -2.772 | -2.755 | -1.765 | -1.898 | -1.502 | -1.155 | -0.4541 |     1 | coerente_forte |
| ind_bens_duraveis | -8.17 | -10.44 | -6.714 | -6.701 | -4.313 | -3.08 | -0.8906 |     1 | coerente_forte |
| ind_bens_capital | -3.644 | -4.095 | -2.409 | -3.276 | -3.377 | -2.732 | -1.159 |     1 | coerente_forte |
| vendas_varejo | -1.176 | -1.344 | -0.7918 | -0.8135 | -0.2871 | -0.002374 | 0.3846 |     1 | coerente_forte |
| vendas_servicos | -1.057 | -1.221 | -0.8582 | -0.876 | -0.5346 | -0.9215 | -0.8899 |     1 | coerente_forte |
| ind_automoveis | -8774 | -1.203e+04 | -8506 | -7323 | -3295 | -4127 | -3512 |     1 | coerente_forte |
| capacidade_instalada_industria | -0.1908 | -0.2884 | -0.1576 | -0.2306 | -0.2063 | -0.119 | 0.0239 |     1 | coerente_forte |

### trabalho

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| trab_tx_desemprego | 0.004322 | 0.03164 | 0.05212 | 0.03909 | 0.02769 | 0.2065 | 0.2982 |     1 | coerente |
| trab_pop_ocupada | 114.6 | -241.9 | -302.8 | -49.01 | 376.2 | -162.5 | -562.7 | 0.3226 | incoerente |
| trab_hrs_trabalhadas_industria | -1.307 | -1.73 | -1.123 | -1.071 | -0.5653 | -0.4697 | -0.1926 |     1 | coerente_forte |

### credito

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credit_outstanding | 0.4313 | 0.4263 | 0.367 | -0.08152 | -0.6302 | -0.872 | -0.7312 | 0.8387 | coerente |
| credito_pessoa_fisica | 0.01178 | 0.004806 | -0.007055 | -0.1483 | -0.2942 | -0.6348 | -0.6963 |     1 | coerente |
| spread_icc_juridica | -0.03212 | -0.07436 | -0.07489 | -0.004756 | 0.08219 | 0.03885 | -0.02249 |     0 | incoerente |
| spread_icc_fisica | 0.0003962 | -0.06383 | -0.08156 | 0.0169 | 0.1262 | 0.04796 | -0.05352 | 0.2308 | incoerente |

### credito_setorial

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credito_comercio | 0.4773 | 0.7824 | 0.8014 | -0.2298 | -1.624 | -1.567 | -0.9391 | 0.8387 | coerente |
| credito_transporte | 1.973 | 2.036 | 1.795 | 0.2204 | -1.476 | -1.614 | -0.8388 | 0.7419 | incoerente |
| credito_industria_total | 0.8751 | 1.183 | 1.029 | 0.07085 | -1.191 | -1.214 | -0.7171 | 0.7742 | parcial |
| credito_agro | 0.8931 | 1.232 | 1.155 | -0.06555 | -1.466 | -1.632 | -1.014 |    NA | ambigua |
| credito_construcao | 0.01871 | 0.473 | 0.4267 | -0.2787 | -1.448 | -1.801 | -1.569 |    NA | ambigua |

### precos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_ipca | 0.1049 | 0.1113 | 0.1658 | 0.02704 | -0.01965 | -0.03103 | 0.0512 | 0.5405 | parcial |
| price_ipca_difusao | 1.153 | 0.7413 | 0.9663 | 0.07758 | -0.4702 | -0.8982 | -0.581 | 0.9189 | coerente |
| price_core_ipca_ex0 | 0.05906 | 0.09745 | 0.08142 | 0.05385 | 0.07015 | 0.03342 | 0.02756 |     0 | incoerente |
| price_core_ipca_ex1 | 0.0559 | 0.0407 | 0.07614 | 0.005334 | -0.03075 | -0.03538 | 0.006403 | 0.8378 | coerente_forte |
| price_core_ipca_dw | 0.0599 | 0.07294 | 0.08058 | 0.02156 | 0.0006107 | -0.01318 | 0.01566 | 0.4865 | incoerente |
| price_inpc | 0.1097 | 0.08727 | 0.1624 | 0.001219 | -0.07956 | -0.07063 | 0.03738 | 0.7838 | parcial |

### precos_ambiguos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_igp_m | 0.3943 | 0.515 | 0.488 | 0.1261 | -0.1024 | -0.06334 | 0.1667 |    NA | ambigua |
| price_ipp | 1.159 | 0.9241 | 0.8182 | 0.2468 | -0.08199 | 0.0249 | 0.3936 |    NA | ambigua |

### placebo_externas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| sp500_vix | 247.8 | -165.4 | -124.1 | -67.46 | 23.47 | 5.819 | -31.99 |    NA | placebo_ok |
| msci | 26.88 | 787.6 | 717.5 | 229.5 | -520.1 | -294.4 |  49.2 |    NA | placebo_ok |
| commodity_metal | 14.09 | 17.08 |  14.9 | 5.139 | -1.388 | 0.1386 | 6.201 |    NA | placebo_viola |
| epu_us |  11.8 | 16.46 | 11.71 | 4.892 | -4.401 | 0.9567 | 6.598 |    NA | placebo_ok |


## Canais soft (câmbio / risco soberano)

| var | h0 | h6 | h12 | h24 | channel | right_sig90 |
|---|---|---|---|---|---|---|
| cambio_usd | 0.2454 | 0.2341 | 0.07924 | -0.0686 | depreciacao_fiscal_dom | FALSE |
| cambio_eur | 0.2463 | 0.2362 | 0.08023 | -0.06639 | depreciacao_fiscal_dom | FALSE |
| embi_perc | 0.464 | 0.2986 | 0.08254 | -0.143 | risco_abre_fiscal_dom | FALSE |
| cds_5y |  5604 |  3825 |  1188 | -1299 | risco_abre_fiscal_dom | FALSE |

## Leitura e diagnóstico (ponto a ponto)

### O que está sólido (21 de 35 variáveis pontuadas)

- **Curva inteira coerente_forte**: yield_3m/1y/2y/5y/10y sobem com CI68+ já em
  h=0 e share = 100% da janela. asset_ifix idem (queda significativa).
- **Atividade 9/9 coerente_forte**: ibc_br, pib, ind_transformacao, bens
  duráveis, bens de capital, varejo, serviços, automóveis e capacidade
  instalada — todas negativas a partir de h=3 com significância CI68+ e share
  100%. O canal de demanda está inteiro.
- **Trabalho**: desemprego ↑ (h≥6) e horas trabalhadas na indústria ↓
  (coerente_forte); crédito em estoque (outstanding e PF) contrai a partir de
  h≈6-11.
- **Preços**: difusão do IPCA e núcleo ex1 desinflacionam de h≈15 em diante
  (ex1 com significância); INPC e IPCA cheio parciais (corcova curta, sinal
  correto de h≈15-21 em diante).

### Incoerências de régua vs incoerências reais

1. **Ações (ibov, imob, mlcx `incoerente`; smll, idiv `parcial`)** — a queda em
   h=0 é significativa (CI90) e em h=1 (CI68); de h=2 em diante a resposta
   reverte a ≈ 0, **sem nenhum horizonte positivo significativo**. É repricing
   imediato sem persistência — a previsão teórica nítida (impacto) é atendida;
   o veredito `incoerente` vem da régua de share na janela h0-h6, não de
   violação econômica. Não é defeito de identificação.
2. **juros_cdi / juros_selic** — +2bp em h0-h1 (atenuação ~25×, nunca
   significativo), depois ≈ 0/negativo. É o mismatch de maturidade já
   documentado em `justificativa_uso_yield-6m.md`; o overnight médio-mensal não
   capta a surpresa de 6m. Confirma a decisão de não usar Selic como mp_var.
3. **Spreads ICC (`juridica` share 0%, quedas com CI90 em h0-h6; `fisica` 23%)**
   — **achado genuíno**: sinal oposto ao prior financial-accelerator (+). Leitura
   provável: o ICC é taxa média da *carteira*; na alta da Selic a captação
   reprecifica mais rápido que a carteira → o spread comprime mecanicamente no
   curto prazo. Ação: reavaliar o prior ou trocar a medida (spread de concessões
   novas), antes de tratar como falha do modelo.
4. **Núcleos ex0 (0%) e dw (49%)** — a limitação de desinflação do z_jk_purif
   concentra-se nesses dois; **ex1 é coerente_forte (84%)**. Para o paper,
   preferir ex1 (ou reportar os três com essa leitura).
5. **trab_pop_ocupada (32%)** — ocupação não cai de forma consistente apesar de
   desemprego ↑ e horas ↓; padrão compatível com resposta da participação.
   Tratar como ambígua, não como violação.

### Canais soft e placebo

- **Dominância fiscal significativa**: cambio_usd/eur depreciam e EMBI/CDS
  abrem com CI90 no impacto — o canal soft é *significativo*, não só de sinal.
- **Placebo**: sp500_vix, msci e epu_us contêm zero (ok). **commodity_metal
  viola** (contain0 = 0.64; +14 a +19 pts com CI90 excluindo zero em h0-h8).
  Metais não entram na purificação Bauer-Swanson (SP500/VIX/Brent) — indício de
  componente global residual no instrumento ou de correlação metal×ciclo BR.
  Ação: testar purificação incluindo índice de metais; se persistir, documentar
  como caveat de exogeneidade.

### Adendo (2026-07-12): a corcova do IPCA headline não é erro de identificação

O `parcial` do price_ipca (corcova positiva h0-h12, zero só em h≈21) foi
diagnosticado por completo — ver
`relatorio/working-notes/2026-07-12_price_puzzle_ipca.md`:

1. **N.s. em todo o horizonte**: CI90 contém zero em todos os h=0..48; CI68 só
   exclui zero em h4-h8 (pico +0.21). Não é um "IPCA sobe" estatístico.
2. **Universal entre os 8 instrumentos** em (6,5) full — inclusive os het
   (Rigobon-Sack, sem timing Copom). O filtro JK não reduz a corcova
   (z_bruto h6 +0.10 vs z_jk_purif +0.17) → não é contaminação por info shocks.
3. **Desaparece pre-COVID com a mesma identificação**: IPCA negativo em todos
   os h (h9 −0.21, h24 −0.15, n.s.), justamente na janela onde F é maior
   (15.4 vs 10.1).

Leitura: price puzzle transitório padrão (Sims 1992; Ramey 2016 — CPI
flat/positivo por 1-2 anos mesmo em GK com instrumento externo; Brasil:
Minella 2003) amplificado pela composição amostral 2021-22 (Selic 2%→13,75%
com IPCA subindo por oferta/commodities/fiscal). Framing no §5: headline com
corcova n.s. + robustez pre-COVID; ex1 como medida de preço primária.

### Adendo (2026-07-12b): composição h-a-h dos blocos crédito e ativos financeiros

Análise completa em `relatorio/working-notes/2026-07-12_irf_credito_ativos_financeiros.md`.
Cinco variáveis de crédito setorial adicionadas à tabela (agro/construção como
`ambiguous` — crédito direcionado). Achados que revisam leituras anteriores:

1. **Estoques de crédito sobem com CI90 em h0-h6 antes de contrair** (trough
   h≈29-43, n.s.) — padrão Bernanke-Gertler (1995)/Gertler-Gilchrist (1994):
   firmas sacam linhas de crédito para capital de giro no aperto; a contração
   vem com a defasagem clássica de 1-2 anos. PF não tem alta inicial
   (households não têm linhas) — consistente com a heterogeneidade GG94.
2. **Spreads ICC**: a compressão inicial (juridica CI90 h0-h4) é seguida de
   **abertura com CI68 em h19-h30** (juridica pico +0.08 h25; fisica +0.13
   h25) — o financial accelerator aparece com defasagem; a janela h0-h12 da
   régua é que estava errada, não o prior. Pendência ICC atualizada.
3. **Curva amplifica com a maturidade** (h0: 3m +27bp < 1y +77 < 2y +105 <
   5y +122 > 10y +112; CI90 até h7 no trecho longo) — oposto ao padrão EUA
   (Kuttner 2001), consistente com prêmio de risco fiscal em EM
   (Blanchard 2004; GRG 2025): EMBI +46bp e CDS +56bp com CI90 h0-h7.
4. **imat** cai no impacto (CI90) e sobe com CI68 em h2-h9 — exportadoras
   beneficiadas pela depreciação; o canal cambial explica a ambiguidade.
