# Roadmap pós-council (2026-08-10)

**Nota de planejamento — nenhuma estimação nova, nenhum `.tex` tocado.**
**Atualização de 2026-08-12:** o item 11 e todas as suas conclusões numéricas
foram superados pela retirada da implementação Anderson-Rubin. O item está
adiado sem prazo e sem prioridade ativa; o restante deste roadmap preserva seu
status. Ver `registro/historico_decisoes.md` §7.
**Atualização do mesmo dia:** os **dois** itens da Fase 2 foram executados
depois que esta nota foi escrita — item 11 (bandas Anderson-Rubin) e item 10
(coincidência FOMC). Ambos estão riscados abaixo, e os resultados moram em
[`2026-08-10_bandas_anderson_rubin`](2026-08-10_bandas_anderson_rubin.md) e
[`2026-08-10_coincidencia_fomc`](2026-08-10_coincidencia_fomc.md).
**A Fase 2 está fechada; o que sobra dela é redação.** Todo o resto do
roadmap segue de pé.
Síntese de `registro/pendencias.md` (revisão 2026-08-10) +
`pareceres/council_2026-08-10.md`, organizada em ordem de execução em vez de
por tema. Não substitui `pendencias.md` — é um corte transversal dele.

**Por que este roadmap existe.** O council de 2026-07-31 dizia "faltam
ferramentas" (sem benchmark VAR, sem bandas AR) — resolvido, o benchmark
rodou. O council de 2026-08-10 diz outra coisa: **três das quatro
alegações-manchete do paper são contraditas por números que já estão no
repositório.** Não é preciso rodar nada novo para a maior parte das
correções abaixo; é preciso ir ao `irf_coherence_h.csv`,
`factor_stationarity.md` e `mosw_strength_grid.csv` já salvos e escrever o
que eles dizem. O fato central sobrevive nas quatro críticas — depreciação +
EMBI+/CDS em alta, sig90 no impacto — só a atribuição de mecanismo não.

---

## Fase 1 — pós-processamento puro (sem reestimar nada)

Maior valor por menor custo do relatório inteiro: tudo usa artefatos já
salvos (`irf_coherence_cell.rds`, `factor_stationarity.md`,
`mosw_strength_grid.csv`).

1. **Decomposição do wedge de UIP** (council R3a; macro-theorist, achado
   original). Tabela T ∈ {6, 12, 24, 48}, linhas {Δs_T, −ΣΔi/12, +ΣΔrp/12
   (CDS e EMBI), resíduo}, bandas dos 800 draws já salvos. Na conta feita
   pelo council sobre `irf_coherence_h.csv` a T=48 o diferencial de juros
   **contribui depreciação** (ΣΔyield_6m/12 ≈ −1,39pp) e o CDS **contribui
   apreciação** (ΣΔcds/12 ≈ −0,20pp) — o oposto do que o resumo atribui a
   cada termo. Ataca "domina" diretamente. Pendencias Tema B.

2. **Mostrar as 14 células do grid (r,q)**, não as 4 de `tab:rq_sweep`, e
   declarar o tie-break ex-ante — ou sobrepor as IRFs das 5 células do platô
   (7,5)/(7,6)/(7,7)/(8,5)/(8,6) e afirmar invariância. A regra como está
   escrita em `:264-266`/`:292` seleciona **(7,7)**, não (7,6): ξ_mp full
   12,90 contra 10,43. Achado do methodologist, ninguém mais viu. Pendencias
   Tema A.

3. **Corrigir o resumo** (`:115`, `:117`) que lista o câmbio entre as séries
   com "reversão altamente sincronizada" — contradiz `§4.2:369` e a
   conclusão `:545`. Considerar promover o fato descartado: `cambio_usd` é a
   única série cuja reversão sobrevive intacta (razão 1,004) à remoção do
   par dominante da companion — a única reversão não-mecânica do modelo.
   Verificado por 3 dos 4 críticos, sem dissenso. Pendencias Tema A.

4. **Corrigir a atribuição do "≥10"** em `:266` — é a regra de bolso
   Staiger-Stock/Stock-Yogo para F homoscedástico de primeiro estágio 2SLS,
   creditada erradamente a `\cite{montielolea}`. Nomear o desenho certo ou
   trocar pelo valor crítico de Montiel Olea-Pflueger (2013), o análogo
   robusto a heterocedasticidade. Pendencias Tema A.

5. **Corrigir "por completo" em `:538`** — `z_jk_bs_norisk`/`_cds` limpam os
   *valores* da surpresa (`e_di_bs`/`e_ibov_bs` ortogonalizados), não a
   *máscara* (60 meses não-nulos nas variantes `norisk` contra 62 na
   produção, mesma seleção). Contra a própria auditoria de fidelidade do
   projeto ("a força vive na máscara"), a frase deve dizer o que foi feito:
   ortogonalizar a surpresa ao risco contemporâneo. Pendencias Tema A.

6. **Corrigir a descrição do placebo `sp500_vix`** (`:501`/`:509`) — é só o
   VIX (média 18,58, min 9,51, max 53,54); o painel não tem nenhuma série de
   nível do S&P 500. Enfraquece o argumento de `:519` ("uma surpresa fiscal
   também deixaria o S&P 500 parado" — não há S&P 500 para checar) e é
   exatamente onde o item 9 (FOMC) morde. Pendencias Tema B.

7. **Base de comparação do 3,64%.** Câmbio entra em nível (Anexo A, código
   1) e a conversão usa a média amostral (`:351`, divisor implícito 4,11) —
   não é escala-livre: o mesmo choque em reais vale 6,8% no nível de 2013 e
   2,7% no de 2025. Em base equivalente (100bp) este paper reporta **7,3%**,
   maior em módulo que a faixa de GRG citada em `:357` ("3,4% a 5,6%"), não
   dentro dela. Mesmo defeito no Ibovespa (`:491`, GK) e na comparação com o
   repasse de crédito corporativo americano de Gertler-Karadi (`:324` — não
   é o mesmo objeto que amplificação de curva soberana; o comparável correto
   é a própria curva de Alessi-Kerssenfischer). Reportar toda comparação por
   100bp e contra o mesmo objeto. Pendencias Tema A.

8. **Rebaixar a reversão de médio prazo** de "evidência adicional de um
   mecanismo comum" (`:115`, `:142`) para "o que o modelo implica".
   Reportar a participação de variância do par dominante **por bloco**
   (curva/risco vs. crédito vs. atividade) — se concentrada em câmbio/risco/
   curva, a leitura "mesmo prêmio revertendo" ainda tem uma versão
   defensável; se distribuída igualmente, a frase não sobrevive em nenhuma
   forma, porque o mesmo modo produz o vale também nos seis agregados de
   crédito e em `juros_selic`, atribuídos hoje a um canal diferente
   (acelerador financeiro). Pendencias Tema A, council D4.

9. **Reportar o resultado em nível do bloco acionário** — já rodado em
   `output/assets/asset_representation.md`: 0 → 39 células sig90 (28 em
   nível simples), todas h=0-5, 7 de 8 índices, ξ_mp quase parado
   (10,23 vs 10,43). Acompanhar com comunalidade por série
   (`1 − var(êᵢ)/var(Xᵢ)` de `Chi`/`Idio`, já construído) — decide entre a
   leitura do harsh-referee (artefato de transformação) e a do
   methodologist (baixa comunalidade, poder fraco de qualquer forma).
   Council O1, pendencias Tema B item de comunalidade.

---

## Fase 2 — testes decisivos com dado ausente ou computação nova barata

10. ~~**Coincidência FOMC**~~ — **FEITO em 2026-08-10, depois desta nota.**
    Era o achado mais grave do council e o único sem nenhum registro prévio
    no repo. Os quatro passos (i)-(iv) foram executados na ordem pedida, mais
    um teste de horário que não estava previsto.
    `R/data_download/fomc_dates.R` + `R/instrument/event_tests.R` +
    `script/fomc_coincidence.R`. **Veredito: confound FOMC não detectado.**
    A exposição é **maior** do que esta nota estimou — 24 dos 62 dias retidos
    e **35,5% de Σ|z|**, 8 dos top-20 (não 7) — mas o bloco americano não
    explica a surpresa nos dias retidos (p_boot 0,458), a interação com a
    coincidência é nula (0,466), e nos **35 dias em que Copom e FOMC caem no
    mesmo dia** o R² é **0,005**, o menor da tabela; o maior (0,108) está nos
    dias que o filtro **rejeita**. ⚠ A divisão em metades com e sem FOMC foi
    removida do script em 2026-08-10 e nada do que ela produziu é citável
    (`historico_decisoes.md` §2.4). ⚠ O argumento de horário vale para
    a perna de taxa e **não** para a de ações. **O que resta é redação.** Nota:
    [`2026-08-10_coincidencia_fomc`](2026-08-10_coincidencia_fomc.md).

11. ~~**Bandas Anderson-Rubin**~~ — **FEITAS no mesmo dia em que esta nota foi
    escrita (2026-08-10), depois dela.** A motivação estava certa: ξ_mp=10,43
    full raspa o limiar em que bandas convencionais são só "aproximadamente
    válidas", o LOO mostra 24 de 147 meses derrubando ξ_mp abaixo de 10, e
    nenhum abaixo de 3,84 — a inversão entrega intervalo e não reta.
    `R/identification/weak_iv_ar.R` + `script/ar_bands.R`, validados contra a
    aplicação do petróleo dos autores. **Conjunto limitado em 31.164/31.164
    células; 87 das 91 sig90 sobrevivem; prêmio de IV fraco = fator de escala
    comum 1,164 a 90%.** ⚠ As 4 perdas são 3 impactos do bloco de atividade
    mais `cambio_eur` h3; ⚠ e a banda AR sai mais estreita que a de bootstrap
    (0,646) por condicionar em `Λ̂` — não é resultado a favor. **O que resta é
    redação**, item aberto no Tema A. Nota:
    [`2026-08-10_bandas_anderson_rubin`](2026-08-10_bandas_anderson_rubin.md).

12. **Reconciliação com GRG para o corpo do §6** — a réplica já existe
    (`arquivo/relatorio/correspondence/referee2/replication/
    referee2_py_b1.csv`): BRL apreciando 4,53%/100bp, dentro do IC95 de GRG;
    proporcionalidade rejeita fortemente no diário (LR=135,1, p_boot=0,005)
    contra nenhuma rejeição em 252 células mensais — desacordo de
    **frequência e propagação, não identificação**. Falta só rodar na
    vintage atual antes de virar número citável e reportar ao lado a célula
    inconveniente (IBOV +2,83%/100bp, sinal errado, participação espectral
    0,0015 — ações não identificadas naquele sistema). Council O2,
    pendencias Tema A/D.

---

## Fase 3 — robustez declarada, ainda não implementada

13. **Parágrafo sobre validade do wild bootstrap (Jentsch-Lunsford)** — o
    bootstrap multiplica instrumento e resíduos pelo mesmo draw Rademacher
    (`impulse_responde.R:608-610`), esquema Mertens-Ravn que Jentsch-Lunsford
    mostram inválido para proxy-SVAR independente da força do instrumento.
    Mínimo aceitável: um parágrafo no §3 declarando a escolha e citando o
    debate — não é bug, é replicação fiel de AK (`DFMest_BLL_Boot.m`), e o
    debate Mertens-Ravn não fechou. Implementar block bootstrap fica como
    decisão separada. Pendencias Tema B.

14. **Reportar a IRF pré-COVID como validação**, não só seleção (`:292` usa,
    nunca valida). ξ_mp 12,22 lá, mais forte que o full-sample; replica o
    wedge UIP-invertido, mas com amplificação de curva ~1,3× contra 1,85×
    full — número inconveniente a reportar junto. Council R2(f) / Skeptic.

15. **Bandas simultâneas ao longo do caminho** (Montiel Olea-Plagborg-Møller
    2021) — se a reversão de médio prazo é dominada por um único modo, os
    horizontes h≈20-40 são quase perfeitamente correlacionados e uma banda
    pontual é enganosa para qualquer afirmação de **trajetória** (o tier de
    68% do §4 inteiro: vale setorial, contração de crédito, reversão da
    curva). Exige citação nova — colide com a regra das 25 chaves, decisão
    do autor. Pendencias Tema B.

---

## Fase 4 — rota metodológica original (2026-07-24), ainda de pé

Não descartada pelo council — só adiada em prioridade porque ataca um
problema diferente (identificação alternativa) do que os councils atacaram
(coerência entre o que o paper afirma e o que o repo já mostra).

16. **Angelini-Cavaliere-Fanelli (2024)** para robustez a IV fraco dentro do
    paradigma frequentista — pré-teste de força por bootstrap robusto a
    heterocedasticidade condicional e a proxies zero-censored (a máscara
    JK). Sem replication package público, codificar do zero.

17. **LMS (2017)** via `svars::id.ngml` como terceira leitura do
    não-gaussiano — desempate mais barato disponível para a decisão de
    framing do GMR (item C aberto em pendencias.md: se LMS concordar com
    GMR, a discordância é do proxy; se ficar no meio, é do método).

18. **LP-IV como robustez à especificação dinâmica** — desejável, não
    bloqueante. Estimador diferente da mesma identificação, não depende de
    `p=6` nem da forma funcional do VAR; `IdSS::make.LPIV.irf` já entra no
    projeto pela rota não-gaussiana.

---

## Decisão de framing em aberto, não uma fase

O council (Harsh Referee, Open Pass O3) sugere reenquadrar o título em torno
da **amplificação de prêmio a termo** — o choque move o vértice de 5 anos a
1,85× o vértice de 6 meses em que normaliza, com o overnight parado no
impacto, achado que sobrevive a toda a Fase 1 — em vez de "UIP Invertida",
que precisa de uma medida de expectativas que o paper não tem e é
justamente o resultado mais corroído pela decomposição do item 1. Sob esse
enquadramento a inversão cambial vira corolário e boa parte da Fase 1 (itens
1, 3, 8) muda de ênfase de "correção defensiva" para "resultado secundário
de um argumento mais forte". Decisão do autor, não tomada nesta nota.
