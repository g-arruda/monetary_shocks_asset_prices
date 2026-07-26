# Coerência das IRFs — leitura e diagnóstico

**Escrito à mão em 2026-07-26. Nenhum script escreve neste arquivo.** O corpo
automático — contagens, tabelas por grupo, trajetórias — fica em
[`irf_coherence_report.md`](irf_coherence_report.md), que
`script/irf_coherence_check.R` **sobrescreve por inteiro** a cada rodada. Foi
assim que a versão anterior desta leitura se perdeu (commit `fc0ef58`,
2026-07-26). Prosa vai aqui; números gerados vão lá.

**Especificação:** `z_jk_bs_purif` × `yield_6m`, r = 7, q = 6, p = 6, amostra
cheia (2013-01 a 2025-09), choque +50bp, wild bootstrap nboot = 800 (seed 123),
bandas 68/90, h = 0-48. Fonte de todo número citado abaixo:
`irf_coherence_h.csv` e `irf_coherence_summary.csv` do mesmo run.

Este arquivo diagnostica **a régua de coerência**, não os resultados. A leitura
econômica dos resultados é o §5 do paper, em
[`irf_section.md`](irf_section.md) — que é o texto canônico. Quando os dois
divergirem, o §5 vence.

Placar: 21 `coerente_forte`, 5 `coerente`, 11 `parcial`, 1 `incoerente`,
6 `ambigua`, 4 soft, 3 `placebo_ok` e **1 `placebo_viola`**.

---

## O que está sólido

**A curva de juros é o bloco mais forte do painel.** Os cinco vértices
(`yield_3m`, `yield_1y`, `yield_2y`, `yield_5y`, `yield_10y`) são
`coerente_forte` com `share_correct = 1,000` **e** significância a 90% — os
únicos escorados que combinam as duas coisas. O impacto é ordenado e o CI90
exclui zero em todos: 2y +0,0092 [0,0071; 0,0131], 5y +0,0093 [0,0069; 0,0150],
10y +0,0081 [0,0058; 0,0131]. A curva sobe em nível e achata na ponta longa,
que é o padrão esperado.

**A atividade responde na direção e no timing certos.** Oito das nove séries do
bloco passam (5 `coerente_forte` + 3 `coerente`), com o vale concentrado em
h12: transformação −2,33, bens duráveis −7,73, bens de capital −4,61,
automóveis −7.166 unidades. Três chegam a significância a 90% em algum
horizonte da janela — bens de capital, vendas no varejo e capacidade
instalada —, o que para um painel mensal de 147 observações é razoável.
`pib` e `ibc_br` entram como `coerente` (não `forte`) só por falta de
significância, não por sinal.

**O crédito agregado e o crédito setorial fecham.** `credit_outstanding`
(`share` 1,000) e `credito_pessoa_fisica` (0,903) são `coerente_forte`, assim
como comércio, transporte e indústria no corte setorial — os três com vale
entre h12 e h24 (−2,18, −1,97, −1,63). Note que transporte e indústria têm
impacto **positivo** (+0,75 e +0,19) e ainda assim pontuam 0,97 e 1,00: a
janela teórica é longa e o que ela mede é a contração, não o impacto.

---

## Incoerências de régua vs incoerências reais

Dos 11 `parcial`, a maioria é **janela teórica mal calibrada em
`coherence_var_table()`**, não resposta errada. Vale a pena separar:

**Janela que começa cedo demais.** `trab_tx_desemprego` (janela h6-h36) só
acerta o sinal a partir de h13, e `trab_pop_ocupada` (mesma janela) a partir de
h19 — mas ambas terminam no lugar certo (desemprego +0,24 em h24, população
ocupada −253 em h24 e −493 em h48). Emprego reage com defasagem maior do que
seis meses; a janela é que está apertada. Mesmo diagnóstico para os spreads
ICC (janela h0-h12): `spread_icc_juridica` só abre em h3 e
`spread_icc_fisica` em h4, porque o ICC é taxa de **carteira**, que reprecifica
devagar. É exatamente o argumento do item aberto "spread de concessões novas"
em `pendencias.md` — a variável certa para a janela curta ainda não está no
painel.

**Janela que termina tarde demais.** `asset_ibov`, `asset_idiv` e `asset_mlcx`
(janela h0-h6) acertam o impacto e revertem para positivo por volta de h6-h12,
o que derruba o `share` para 0,714. O impacto está certo em todos os seis
índices de ações (−1,03 a −2,90); o que a janela captura na ponta é a
reversão, não uma falha de identificação. Registre-se: **nenhum índice de ações
é significativo a 90% no impacto** — `asset_ibov` tem h0 = −1,673 com CI90
[−7,77; 1,76] e CI68 [−5,43; 0,31], ambos contendo zero. O sinal é robusto,
a magnitude não.

**`juros_cdi` `parcial` é mecânica, não substantiva.** Impacto −0,048, igual ao
de `juros_selic` (−0,047), porque as duas são Selic overnight acumulada e não
casam com a maturidade do choque. `juros_selic` escapa de `parcial` só porque
sua janela começa em h1 e a do CDI em h0. É o controle negativo documentado em
`justificativa_uso_yield-6m.md` funcionando como esperado.

**A única incoerência de fato é `price_core_ipca_ex0`,** com
`share_correct = 0,000`: o núcleo por exclusão 0 é positivo em **todos** os
horizontes da janela h12-h48 (+0,056 em h12, +0,027 em h24, +0,009 em h48).
Duas ressalvas importam para não superinterpretar:

1. `wrong_sig90 = FALSE`. Ele nunca é significativamente positivo dentro da
   janela escorada — a violação é de sinal persistente, não de banda.
2. **A corcova de preços não é o que produz esse veredito.** A corcova vive em
   h2-h8, *fora* da janela h12-h48. Ela é real e é o pedaço significativo:
   `price_ipca` é sig90 em h5 (+0,181 [0,000; 0,372]),
   `price_core_ipca_ex0` em h2 e h4-h8 (pico +0,131 em h5), e
   `price_core_ipca_dw` em h4, h5 e h7. Ou seja, o price puzzle aparece cedo e
   com banda, e o que a régua penaliza depois é outra coisa: o núcleo ex0 não
   volta para território negativo no médio prazo, enquanto `price_ipca`,
   `price_core_ipca_dw` e `price_inpc` voltam (por isso são `parcial` e não
   `incoerente`, com `first_correct_h = 12` nos três) e `price_core_ipca_ex1`
   volta cedo o bastante para ser `coerente_forte` (`share` 0,919).

Fechar o diagnóstico do price puzzle depende da comparação cross-instrumento do
IPCA sob (7,6), que continua aberta em `pendencias.md` — o `spec_sweep_irf_long.csv`
regenerado em 2026-07-26 é a fonte para isso.

---

## Canais soft e placebos

**Os quatro soft violam a régua textbook por construção, e isso é o resultado.**
`cambio_usd`, `cambio_eur`, `embi_perc` e `cds_5y` têm `theory_sign = −1`
(apreciação e compressão de risco) e `share_correct = 0` com
`wrong_sig90 = TRUE` — mas todos os quatro se movem na direção oposta **com
CI90 excluindo zero no impacto**: câmbio +0,150 [0,079; 0,297], EMBI +0,200
[0,078; 0,509], CDS +2.907bp [1.652; 6.251]. Depreciação e abertura de risco
sob aperto monetário é o canal de dominância fiscal, tratado no §5.3. Estão
marcados como `soft` justamente para não contaminarem o score: a régua não tem
prior forte aqui, e forçar um não seria honesto.

**Três placebos passam e um viola.** `sp500_vix` (contém zero em 96% dos
horizontes), `msci` (100%) e `epu_us` (100%) passam folgado. **`commodity_metal`
viola**, com `contain0_share = 0,80` contra o limiar de 0,90: +10,4% no impacto
com CI90 [4,49; 17,51], e o CI90 continua excluindo zero até h4 (+9,65
[0,66; 19,29]). É o caveat de exogeneidade mais concreto contra o instrumento —
metais não estão entre os preditores pré-evento da ortogonalização
Bauer-Swanson (Brent está), então o instrumento plausivelmente retém um
componente global de commodity/risco. Item aberto em `pendencias.md`; não
esconder atrás dos três placebos que passam.

Os 6 `ambigua` (`asset_ifnc`, `asset_imat`, `credito_agro`,
`credito_construcao`, `price_igp_m`, `price_ipp`) não têm prior de sinal e não
entram em nenhum score — estão no painel para leitura, não para validação.

---

## Ponteiros

- [`irf_section.md`](irf_section.md) — §5 do paper, texto canônico dos
  resultados sob (7,6).
- [`irf_coherence_report.md`](irf_coherence_report.md) — corpo gerado
  (contagens, tabelas por grupo); regerado a cada run.
- `irf_coherence_h.csv` — ponto + bandas 68/90 + flags por horizonte, fonte de
  todos os números acima.
- `R/identification/irf_coherence.R::coherence_var_table()` — onde as janelas
  `[w_lo, w_hi]` são definidas; é o arquivo a editar se a régua for recalibrada.
- `relatorio/working-notes/_indice.md` — leituras anteriores, escritas sob
  (6,5) e `z_jk_purif`; todas com banner de vintage. Não reaproveitar números
  de lá.
