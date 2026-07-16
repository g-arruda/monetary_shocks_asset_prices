# Coerência ponto a ponto das IRFs — especificação de produção

Gerado por `script/irf_coherence_check.R` em 2026-07-15.

Especificação: `z_jk_bs_purif` x `yield_6m`, r=6, q=5, p=6, full sample, choque +50bp, wild bootstrap nboot=800 (seed 123), bandas 68/90, h=0..48.

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
| scored | coerente_forte |    18 |
| scored | incoerente |     8 |
| scored | coerente |     6 |
| scored | parcial |     6 |
| soft | soft_depreciacao_fiscal_dom |     2 |
| soft | soft_risco_abre_fiscal_dom |     2 |

## Violações (incoerente / placebo_viola / sinal errado significativo)

| group | var | verdict | share_correct | wrong_sig90 | h0 | h12 | h24 |
|---|---|---|---|---|---|---|---|
| acoes | asset_ibov | incoerente | 0.1429 | FALSE | -0.01114 | 0.01505 | 0.007128 |
| acoes | asset_idiv | incoerente | 0.1429 | FALSE | -0.01258 | 0.0142 | 0.01414 |
| acoes | asset_imob | incoerente | 0.4286 | FALSE | -0.01864 | 0.01437 | 0.006885 |
| acoes | asset_mlcx | incoerente | 0.1429 | FALSE | -0.01219 | 0.01392 | 0.005988 |
| risco_cambio_soft | cambio_usd | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.1852 | 0.02082 | -0.05099 |
| risco_cambio_soft | cambio_eur | soft_depreciacao_fiscal_dom |     0 | TRUE | 0.1767 | 0.0121 | -0.03178 |
| risco_cambio_soft | embi_perc | soft_risco_abre_fiscal_dom |     0 | TRUE | 0.2505 | 0.02539 | -0.1578 |
| risco_cambio_soft | cds_5y | soft_risco_abre_fiscal_dom |     0 | TRUE |  3401 | 495.4 | -1528 |
| trabalho | trab_pop_ocupada | incoerente | 0.2903 | FALSE | 97.13 | 171.7 | 92.09 |
| credito | spread_icc_juridica | incoerente | 0.3846 | FALSE | -0.02412 | 0.02841 | 0.06173 |
| precos | price_core_ipca_ex0 | incoerente |     0 | FALSE | 0.08477 | 0.05062 | 0.06119 |
| precos | price_core_ipca_dw | incoerente | 0.4865 | FALSE | 0.06076 | 0.002896 | -0.002041 |
| placebo_externas | commodity_metal | placebo_viola |    NA | NA |  11.7 | 1.022 | 0.2333 |

## Trajetórias por grupo (unidades nativas; tcode aplicado)

### curva_juros

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| yield_3m | 0.003225 | 0.004534 | 0.004288 | 0.0007525 | -0.003731 | -0.006579 | -0.006248 |     1 | coerente_forte |
| yield_1y | 0.006938 | 0.008209 | 0.007107 | 0.001046 | -0.004372 | -0.006889 | -0.005613 |     1 | coerente_forte |
| yield_2y | 0.008446 | 0.009297 | 0.007913 | 0.001131 | -0.004225 | -0.006146 | -0.004434 |     1 | coerente_forte |
| yield_5y | 0.008754 | 0.008754 | 0.007562 | 0.001214 | -0.003613 | -0.004703 | -0.002845 |     1 | coerente_forte |
| yield_10y | 0.007824 | 0.007609 | 0.006637 | 0.001089 | -0.003236 | -0.004008 | -0.002273 |     1 | coerente_forte |
| juros_cdi | 0.07613 | 0.1688 | 0.2018 | 0.03581 | -0.314 | -0.5655 | -0.5747 |     1 | coerente |
| juros_selic | 0.07639 | 0.1688 | 0.2018 | 0.03535 | -0.315 | -0.5662 | -0.5749 |     1 | coerente |

### acoes

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ibov | -0.01114 | 0.005895 | 0.008152 | 0.01505 | 0.007128 | 0.00353 | -0.002932 | 0.1429 | incoerente |
| asset_smll | -0.02103 | -0.003489 | 0.0003161 | 0.01279 | 0.006364 | 0.003413 | -0.003653 | 0.5714 | parcial |
| asset_idiv | -0.01258 | 0.006248 | 0.006335 | 0.0142 | 0.01414 | 0.009992 | 0.001458 | 0.1429 | incoerente |
| asset_imob | -0.01864 | -3.103e-05 | 0.003112 | 0.01437 | 0.006885 | 0.00582 | -0.0001949 | 0.4286 | incoerente |
| asset_ifix | -0.01373 | -0.009863 | -0.005843 | 0.001498 | -0.004601 | -0.005815 | -0.007068 |     1 | coerente_forte |
| asset_mlcx | -0.01219 | 0.004155 | 0.006603 | 0.01392 | 0.005988 | 0.002858 | -0.003126 | 0.1429 | incoerente |

### acoes_ambiguas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| asset_ifnc | -0.01484 | 0.009571 | 0.009327 | 0.01742 | 0.01535 | 0.009034 | -0.001128 |    NA | ambigua |
| asset_imat | 0.002808 | 0.01206 | 0.01177 | 0.0115 | 0.005048 | 0.007517 | 0.006366 |    NA | ambigua |

### risco_cambio_soft

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| cambio_usd | 0.1852 | 0.1611 | 0.134 | 0.02082 | -0.05099 | -0.01078 | 0.04706 |     0 | soft_depreciacao_fiscal_dom |
| cambio_eur | 0.1767 | 0.1449 | 0.1135 | 0.0121 | -0.03178 | 0.03066 | 0.09248 |     0 | soft_depreciacao_fiscal_dom |
| embi_perc | 0.2505 | 0.1811 | 0.1829 | 0.02539 | -0.1578 | -0.1486 | -0.06751 |     0 | soft_risco_abre_fiscal_dom |
| cds_5y |  3401 |  2785 |  2627 | 495.4 | -1528 | -1512 | -631.1 |     0 | soft_risco_abre_fiscal_dom |

### atividade

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| ibc_br | -0.5572 | -0.1205 | -0.4532 | -0.5525 | -0.1635 | -0.2353 | -0.1729 |     1 | coerente_forte |
| pib | -0.01267 | 0.1758 | 0.08568 | -0.1217 | -0.2468 | -0.5173 | -0.5397 | 0.7727 | parcial |
| ind_transformacao | -1.815 | -0.7984 | -1.757 | -2.153 | -1.502 | -1.196 | -0.4584 |     1 | coerente_forte |
| ind_bens_duraveis | -6.357 | -3.153 | -6.496 | -7.508 | -4.231 | -3.154 | -0.9023 |     1 | coerente_forte |
| ind_bens_capital | -2.714 | -1.194 | -2.824 | -3.902 | -3.401 | -2.78 | -1.154 |     1 | coerente_forte |
| vendas_varejo | -0.78 | -0.2701 | -0.8645 | -1.002 | -0.1656 | 0.114 | 0.394 |     1 | coerente_forte |
| vendas_servicos | -0.5982 | 0.0173 | -0.4105 | -0.827 | -0.8329 | -1.092 | -0.8671 | 0.9545 | coerente |
| ind_automoveis | -6544 | -2528 | -5867 | -7213 | -4375 | -4968 | -3476 |     1 | coerente_forte |
| capacidade_instalada_industria | -0.1757 | -0.07424 | -0.2197 | -0.2988 | -0.1788 | -0.09588 | 0.02519 |     1 | coerente_forte |

### trabalho

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| trab_tx_desemprego | -0.02566 | -0.07868 | -0.09475 | -0.02108 | 0.1359 | 0.274 | 0.2927 | 0.7419 | parcial |
| trab_pop_ocupada | 97.13 |   249 | 266.2 | 171.7 | 92.09 | -325.9 | -544.3 | 0.2903 | incoerente |
| trab_hrs_trabalhadas_industria | -0.9955 | -0.4396 | -0.9873 | -1.163 | -0.599 | -0.4983 | -0.1884 |     1 | coerente_forte |

### credito

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credit_outstanding | 0.2886 | 0.3212 | 0.3055 | -0.1307 | -0.8139 | -0.9546 | -0.7127 | 0.8387 | coerente_forte |
| credito_pessoa_fisica | 0.07593 | 0.2166 | 0.1921 | -0.086 | -0.518 | -0.7601 | -0.6806 | 0.8387 | coerente |
| spread_icc_juridica | -0.02412 | -0.0127 | -0.002098 | 0.02841 | 0.06173 | 0.02169 | -0.02269 | 0.3846 | incoerente |
| spread_icc_fisica | -0.005395 | -0.003056 | 0.02913 | 0.07118 | 0.08904 | 0.01832 | -0.05357 | 0.6923 | parcial |

### credito_setorial

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| credito_comercio | 0.2714 | 0.2201 | 0.1747 | -0.5098 | -1.717 | -1.601 | -0.9266 | 0.9355 | coerente_forte |
| credito_transporte | 1.279 | 1.122 | 0.9849 | -0.2033 | -1.612 | -1.524 | -0.7824 | 0.8065 | coerente_forte |
| credito_industria_total | 0.6014 | 0.4784 | 0.4864 | -0.1732 | -1.276 | -1.211 | -0.6973 | 0.8387 | coerente_forte |
| credito_agro | 0.6892 | 0.7163 | 0.5877 | -0.3629 | -1.648 | -1.639 | -0.9745 |    NA | ambigua |
| credito_construcao | 0.1213 | 0.1926 | 0.2941 | -0.3121 | -1.782 | -2.031 | -1.558 |    NA | ambigua |

### precos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_ipca | 0.09794 | 0.1219 | 0.06962 | -0.02145 | -0.01721 | 0.01009 | 0.06293 | 0.5946 | parcial |
| price_ipca_difusao | 0.7114 | 0.7563 | 0.6214 | -0.08392 | -0.7068 | -0.8491 | -0.5098 |     1 | coerente |
| price_core_ipca_ex0 | 0.08477 |   0.1 | 0.08617 | 0.05062 | 0.06119 | 0.04674 | 0.03335 |     0 | incoerente |
| price_core_ipca_ex1 | 0.03588 | 0.03925 | 0.02236 | -0.01701 | -0.03184 | -0.01938 | 0.01156 | 0.8649 | coerente |
| price_core_ipca_dw | 0.06076 | 0.07269 | 0.05018 | 0.002896 | -0.002041 | 0.00291 | 0.02097 | 0.4865 | incoerente |
| price_inpc | 0.07363 | 0.08818 | 0.03579 | -0.05783 | -0.07186 | -0.02915 | 0.04816 | 0.7838 | parcial |

### precos_ambiguos

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| price_igp_m | 0.356 | 0.3791 | 0.2484 | -0.02068 | -0.06005 | 0.04567 | 0.1881 |    NA | ambigua |
| price_ipp | 0.7096 | 0.6277 | 0.425 | -0.008246 | 0.0212 | 0.2223 | 0.4258 |    NA | ambigua |

### placebo_externas

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | share_correct | verdict |
|---|---|---|---|---|---|---|---|---|---|
| sp500_vix | -34.44 | -93.85 | -79.37 | -47.07 | 9.175 | -13.35 | -33.79 |    NA | placebo_ok |
| msci | 245.3 | 139.8 | 203.6 | 51.73 | -412.5 | -201.3 | 50.47 |    NA | placebo_ok |
| commodity_metal |  11.7 | 11.34 | 8.195 | 1.022 | 0.2333 | 3.418 | 6.753 |    NA | placebo_viola |
| epu_us | 8.439 | 5.414 | 4.718 | 1.138 | -1.191 |  3.51 | 6.551 |    NA | placebo_ok |


## Canais soft (câmbio / risco soberano)

| var | h0 | h6 | h12 | h24 | channel | right_sig90 |
|---|---|---|---|---|---|---|
| cambio_usd | 0.1852 | 0.134 | 0.02082 | -0.05099 | depreciacao_fiscal_dom | FALSE |
| cambio_eur | 0.1767 | 0.1135 | 0.0121 | -0.03178 | depreciacao_fiscal_dom | FALSE |
| embi_perc | 0.2505 | 0.1829 | 0.02539 | -0.1578 | risco_abre_fiscal_dom | FALSE |
| cds_5y |  3401 |  2627 | 495.4 | -1528 | risco_abre_fiscal_dom | FALSE |


---

> **Nota (2026-07-15):** a seção abaixo foi escrita para a rodada de
> 2026-07-12 com o primário antigo (`z_jk_purif`). O corpo acima foi
> re-gerado com `z_jk_bs_purif` (default desde 2026-07-15). A releitura
> interpretativa sob o novo primário está pendente. Diferenças headline da
> re-rodada: mesma história qualitativa (curva sobe, BRL deprecia,
> EMBI/CDS abrem, corcova do IPCA n.s.), magnitudes menores (~30-45%:
> BRL h0 +0.185 vs +0.245; EMBI +0.25 vs +0.46; Ibov h0 -1.1% vs -8.9%);
> bloco de crédito e juros_cdi/selic melhoram de veredito; pib e
> desemprego caem de coerente_forte/coerente para parcial.

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
