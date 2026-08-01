# Nova estrutura do artigo — Metodologia, Resultados e Apêndices

**Data:** 2026-07-13 · **Revisão 2026-07-14:** números de relevância atualizados
para a régua MOSW (ξ_mp, Wald conjunta — `output/instrument/olea_alignment_audit.md`
e `mosw_strength_grid.md`); a max-F legada permanece citada onde é histórico do
sweep, sempre com a qualificação.
**Revisão 2026-07-15:** (i) o instrumento primário passou a ser **`z_jk_bs_purif`**
(ortogonalização Bauer-Swanson fiel, pré-evento, + filtro JK em resíduos
predeterminados — auditoria de fidelidade em
`relatorio/working-notes/2026-07-14_auditoria_fidelidade_jk_bs.md`); números de
relevância trocados para os do novo primário; (ii) **decisão do autor: o
instrumento por heterocedasticidade (z_het\*) fica fora do paper** — os blocos
het (antiga §3.4.4, antigo Apêndice C, itens het do §5.6) foram removidos deste
roteiro; o pipeline het permanece no repositório como diagnóstico interno;
(iii) cadeia de estimação (sweep, stage 2, model_alessi, coerência) re-rodada
sob o novo primário.
**Revisão 2026-07-26:** (i) produção migrou para **(r=7, q=6)** após o refresh de
vintage de 2026-07-24 (**106 séries**, não ~111) — todas as menções a (6,5) e os
ξ_mp abaixo foram atualizados; (ii) o **§5 foi reescrito** e está em
`output/irf/irf_section.md` (a pendência 6.1 está fechada, mas **várias
afirmações inverteram** — ver a tabela na pendência 6.1); (iii) removida do §5.6
a afirmação "F ≥ 10 ⇒ sinais corretos", contraditada pela working-note de
2026-07-15; (iv) todo o material het foi arquivado em `arquivo/`.
**Objetivo:** mapear a distância entre `tex/main.tex` (versão compilada atual) e o
estado real do projeto, e propor a estrutura das seções **Metodologia**,
**Resultados** e **Apêndice/Anexo** da próxima versão. Para cada subseção:
o que deve conter e qual artefato existente em `output/` alimenta cada
tabela/figura — **nada precisa ser re-estimado**.

---

## 1. Diagnóstico: onde o tex está vs. onde o projeto está

O `main.tex` está **duas gerações metodológicas atrás**:

| Dimensão | tex atual | Estado real do projeto |
|---|---|---|
| Identificação | Cholesky recursivo no VAR dos fatores ("3º fator = choque MP") | **Instrumento externo** `z_jk_bs_purif` (proxy-SVAR, Stock-Watson 2018), projeção `H = (Z'η)/(Z'Z)` |
| Instrumento | inexistente — citado como "pesquisa futura" na Conclusão | 10 variantes GK-style construídas e auditadas (surpresas DI em dias de Copom; primário = ortogonalização Bauer-Swanson pré-evento + filtro de sinal Jarociński-Karadi). As 4 variantes het-ID existem no pipeline mas ficam fora do paper (decisão 2026-07-15) |
| (r, q) | r=7, q=4 | **r=7, q=6** (única das 4 dimensões da varredura com ξ_mp > 10 nas **duas** janelas: 10,43 full / 12,22 pre-COVID; auto-IC (5,4) é borderline-weak) |
| VAR dos fatores | VAR(1) | VAR(**p=6**) |
| Painel | 71 variáveis, 2013–2024 | **106 séries**, 2013-01 a 2025-09 (147 meses efetivos após os lags do VAR(6)) |
| Variável de política | "variável de juros" genérica | **`yield_6m`** com normalização +50bp no impacto (`juros_selic` é controle negativo: F máx = 2.49) |
| Resultados | 2 parágrafos + 1 figura; magnitudes antigas | **§5 reescrito em 2026-07-26** em `output/irf/irf_section.md`, sob `z_jk_bs_purif` × (7,6) e vintage novo, sem material het. Pronto para conversão ao tex |
| Robustez | nenhuma | Varredura de especificações, coerência ponto-a-ponto (53 variáveis × 49 horizontes), grade MOSW ξ_mp por (r,q) × amostra × instrumento |
| Apêndice | só a tabela de variáveis (referenciada, não presente) | dezenas de artefatos prontos em `output/{instrument,validation,irf,benchmark}/` |

**Atenção — o Resultado atual do tex tem o sinal do câmbio INVERTIDO em relação
ao resultado de produção.** O abstract e o §Resultados dizem "apreciação de 8%";
a estimativa de produção é **depreciação** de ≈ +3,6% com CI90 (BRL/USD +0,1498
sobre média amostral 4,11), acompanhada de abertura de EMBI (+20bp) e CDS
(+29bp) — a leitura de dominância fiscal (Blanchard 2004). Abstract,
Intro e Conclusão precisam de rewrite completo (fora do escopo desta nota, mas
sinalizado no §6 abaixo).

**O que sobrevive do tex:**
- As equações (1)–(4) do SDFM (§3.1 atual) — apenas atualizar o texto ao redor.
- A subseção Base de Dados — atualizar números (71→**106** séries; 2024→2025-09) e
  manter Svensson + X-13.
- Bai-Ng / Amengual-Watson como ponto de partida da escolha de fatores (mas a
  decisão final agora é da varredura — ver §3.5).
- Wild bootstrap + Kilian (já descritos, só corrigir os detalhes: ponto = OLS,
  Kilian só no DGP do bootstrap; h=48, bandas 68/90).

**O que morre:**
- Todo o parágrafo de identificação por Cholesky/ordenamento recursivo (§3.3
  atual, `main.tex:244`).
- r=7, q=4, VAR(1), scree plot como justificativa central.
- A seção Resultados inteira e a figura `img/irf.png` (magnitudes e sinais da
  era Cholesky).
- Os grandes blocos comentados do tex (linhas 189–392) — já são material morto.

---

## 2. Seção **Metodologia e Estratégia Empírica** (proposta)

> Racional geral: a metodologia deixou de ser "SDFM + Cholesky" e virou
> "SDFM + proxy-SVAR com instrumento construído em 3 camadas (surpresa DI +
> ortogonalização Bauer-Swanson pré-evento + filtro de sinal JK)". A seção
> precisa de duas subseções novas (3.3 e 3.4) e de uma subseção de relevância
> do instrumento (3.6) que hoje não existem.

### 3.1 O Modelo de Fatores Dinâmicos Estruturais
- Mantém as equações atuais (observação, dinâmica dos fatores, choques
  estruturais, forma MA).
- Atualizar: VAR(**p=6**) nos fatores (não VAR(1)); normalização BLL (dividir
  pelo desvio da primeira diferença) apresentada como o tratamento para painel
  **não-estacionário por design** (Barigozzi-Lippi-Luciani), citando que
  Bai-Ng plano exigiria estacionariedade.
- Fechar com a lógica de não-fundamentalidade (já bem escrita no tex).

### 3.2 Base de Dados
- **106** séries mensais, 2013-01–2025-09 (147 meses efetivos); justificativa do
  início em 2013 (PNAD Contínua) permanece.
- Fontes (BCB, IBGE, B3, Tesouro, ANBIMA, EMBI/CDS/MSCI, EPU) e blocos
  (atividade, trabalho, inflação, commodities, monetário, crédito, ativos).
- Svensson (1994) sobre contratos DI para yields de maturidade fixa (3m, 6m,
  1y, 2y, 5y, 10y); X-13ARIMA-SEATS; logs em nominais.
- Lista completa de variáveis, fontes e transformações → **Apêndice A**.

### 3.3 Identificação por Instrumento Externo *(nova — substitui o Cholesky)*
- Proxy-SVAR / IV externo: Stock-Watson (2018), Mertens-Ravn (2013),
  Gertler-Karadi (2015); no contexto DFM, Alessi-Kerssenfischer (2019).
- Condições de relevância e exogeneidade; projeção do instrumento nas inovações
  fatoriais `H = (Z'η)/(Z'Z)` e alinhamento temporal (implementação:
  `R/modeling/impulse_responde.R::ident_ext_instr` / `sel_ext_inst_sample`).
- Normalização: choque de **+50bp no `yield_6m`** no impacto, em proporção
  decimal (+0.005). Justificar a escolha de `yield_6m` como variável de
  política: o Selic/CDI médio-mensal não embute a surpresa dentro do mês do
  choque (atenuação ~25×; `_instrucoes/justificativa_uso_yield-6m.md`) —
  F (y6m AR) = 25.18 do primário `z_jk_bs_purif` vs F ≤ 2.49 quando a Selic
  entra como variável de política (controle negativo do sweep).

### 3.4 Construção do Instrumento *(nova)*
- **3.4.1 Surpresas de alta frequência**: variação Qua→Qui do DI no vértice de
  126 du (≈ 6m) em dias de Copom (decisão após o fechamento → janela D→D+1),
  estilo Gertler-Karadi. 95 dias de Copom em 2013–2025. Agregação mensal por
  **soma dentro do mês** (esquema de Jarociński-Karadi; GK 2015 usam outro —
  atribuição corrigida na auditoria 2026-07-14).
- **3.4.2 Ortogonalização Bauer-Swanson (2023), versão fiel**: regressão da
  surpresa em preditores **pré-anúncio predeterminados** (tudo medido até o
  fechamento da quarta): tendência temporal + variações acumuladas em 65
  pregões de Ibov, SP500, VIX, Brent, BRL e inclinação da curva DI (2a−3m) +
  revisões de 20 pregões das medianas Focus (IPCA 12m suavizado e Selic
  fim-do-ano-seguinte). Resíduo = surpresa ortogonalizada. R² = 0.024, na
  faixa esperada (BS reportam 0.12–0.20 com surpresas de release que não
  existem em frequência diária no Brasil; R² alto indicaria vazamento
  contemporâneo). Trata a previsibilidade ex-ante da surpresa (canal de
  exogeneidade de BS). **Nota de contraste**: a antiga "purificação" por
  SP500/VIX/Brent contemporâneos (mesma janela Qua→Qui) não é a
  ortogonalização de BS — é uma limpeza de fator global da janela larga;
  variáveis domésticas contemporâneas seriam bad control, mas as
  predeterminadas são exatamente o desenho de BS.
- **3.4.3 Filtro de sinal Jarociński-Karadi (2020)**: classifica cada dia de
  Copom pelo co-movimento dos **resíduos pré-evento** ΔDI×Ibov; mantém os
  dias de co-movimento negativo (choque monetário: 62 de 95, 65.3%) e zera os
  de co-movimento positivo (information shocks: 34.7%). Como os preditores
  são predeterminados, a classificação preserva o co-movimento bruto do dia
  do anúncio — a máscara não depende de resíduos contemporâneos (a máscara
  residual antiga classificava 2020-03-19, pânico COVID, como monetário).
  Resultado: **`z_jk_bs_purif`**, o instrumento primário do paper.
- *(A antiga 3.4.4, identificação por heterocedasticidade, saiu do roteiro —
  decisão de 2026-07-15 de manter o het fora do paper.)*

### 3.5 Seleção de (r, q) e Estimação
- Bai-Ng IC2 / Amengual-Watson nas variantes BLL-standardized como *referência*
  (indicam (5,4)); decisão final **(r=7, q=6)**. Justificativa pela régua MOSW
  (ξ_mp) do primário `z_jk_bs_purif`: **é a única das quatro dimensões da
  varredura acima de 10 nas duas janelas — 10,43 full e 12,22 pre-COVID**
  ((5,4) 5,45/7,94; (6,5) 6,36/11,00; (8,8) 12,57/8,99). Na grade completa de 14
  células, (7,5) 10,45/12,76, (7,7) 12,90/12,27, (8,5) 10,01/10,33 e (8,6)
  10,03/10,76 também cruzam: **r=7 é um platô, não uma escolha de canivete** —
  esse é o argumento a levar ao texto. O conjunto AR 95% é limitado
  (ξ_mp > 3,84) em todas as 28 células do primário. Registrar que a força em
  (7,6) veio do **refresh de vintage de 2026-07-24**. Tabela ξ_mp por (r,q) ×
  janela no corpo. Fonte: `output/instrument/mosw_strength_grid.{md,csv}`.
- **Ressalva a declarar** (senão um referee cruza as tabelas e acha contradição):
  a varredura ainda classifica `failure_class` pela max-F legada (`f_factor`),
  sob a qual `z_jk_bs_purif` marca 6,31 em (7,6) e **não aparece em nenhuma
  célula "elegível"** do `spec_sweep_report.md`, enquanto `z_jk_purif` marca
  11,08 lá mas tem ξ_mp 5,77. A régua de decisão do paper é ξ_mp. Ver
  `output/irf/irf_section.md`, seção "Why this specification".
- Estimação: PCA sobre painel BLL-padronizado; VAR(6) nos fatores; ponto por
  OLS puro (fiel a `DFMest_BLL.m`); correção de Kilian (1998) apenas no DGP do
  **wild bootstrap** (Gonçalves-Kilian 2004), nboot=800, bandas 68/90, h=0–48.

### 3.6 Relevância do instrumento *(nova)*
- Exposição didática dos **três Fs de primeiro estágio** (working-note
  `2026-07-11_varredura_irf.md` §2): F (y6m AR) mede relevância univariada;
  F (DFM) contra o resíduo do primeiro fator; **F (factor-space)** — máximo
  sobre as q regressões das inovações fatoriais — governa o viés
  weak-IV na projeção `H = Z'η/(Z'Z)`. Os três podem discordar por uma ordem
  de grandeza (para o primário: F (y6m AR) = 25.18 e F (DFM) = 2.80), porque
  a variação relevante carrega em fatores além do primeiro.
- **Estatística de decisão: o bloco Wald MOSW** (auditoria 2026-07-14 contra o
  paper §4.2 e o código oficial `codigo_olea/`): **ξ_mp** — Wald robusta
  (Eicker-White + correção Shat, z residualizado nos lags do VAR de fatores)
  na direção do impacto de `yield_6m`, análogo exato do `Waldstat` oficial;
  o conjunto Anderson-Rubin 95% é intervalo limitado sse ξ_mp > 3.84. A
  **Wald conjunta** T·Γ̂'Ŵ⁻¹Γ̂ ~ χ²_q (F conjunta = ξ/q) entra como sanity
  check de relevância global — baixa em todo o grid, consistente com
  relevância unidirecional (Γ = α·Θ₀,₁) sob exogeneidade. Implementação
  validada end-to-end contra os números publicados (Kilian oil: ξ₁ = 4.399 vs
  4.4; F robusta = 9.438 vs 9.4, convenção HC1 — `script/validate_olea_kilian.R`).
- Números do primário `z_jk_bs_purif` (7,6): **ξ_mp = 10,43 (full) / 12,22
  (pre-COVID)** — bandas convencionais aproximadamente válidas nas duas janelas,
  conjunto AR limitado. No full, 7 de 14 células (r,q) cruzam ξ_mp ≥ 10
  (mediana 9,72); em pre-COVID, 9 de 14 (mediana 10,55). Tabela compacta no corpo;
  tabela completa variantes GK × {3 Fs legados + bloco MOSW} → **Apêndice B**
  (fontes: `output/instrument/instrument_diagnostics_report.md` §1-1.1,
  `factor_space_F_grid.csv`, `mosw_strength_grid.csv`,
  `olea_alignment_audit.md`).
- A identificação segue mais forte na janela pre-COVID do que na completa
  (12,22 vs 10,43), mas **as duas cruzam o limiar** — a leitura antiga de que as
  observações pós-2020 só adicionavam ruído era em parte artefato do bloco
  duplicado de séries removido no refresh de 2026-07-24.

---

## 3. Seção **Resultados** (proposta)

> **Fonte canônica: `output/irf/irf_section.md`, reescrito em 2026-07-26** sob
> `z_jk_bs_purif` × `yield_6m`, (r=7, q=6), p=6, full sample, +50bp, nboot=800,
> seed 123, painel de 106 séries. **Use aquele arquivo, não o esqueleto 5.1–5.6
> abaixo**, que ficou da versão de 2026-07-12 e descreve a rodada antiga.
> As mudanças que invertem afirmações estão listadas na pendência 6.1.

**Política de figuras** (working-note `2026-07-12_irf_dentadas.md`): as figuras
principais são os blocos lisos de alta comunalidade — curva, crédito,
atividade, núcleos. Séries de baixa comunalidade (Ibov, IPCA headline) entram
com leitura focada no impacto; o serrilhado pós-h2 fica em nota de rodapé
(raízes complexas de 3–4 meses do VAR(6), módulo 0.82; correlação
rugosidade×comunalidade = −0.50). **Sem suavização ex-post.**

### 5.1 Estrutura a termo
- Tabela h0/h6/h12/h24 por maturidade (3m…10y): repasse **crescente com a
  maturidade** (+27bp em 3m → +122bp em 5y), CI90 no trecho longo até h7;
  cruzamento de zero em h≈13-18; leve negativo (CI68) em h≈35-38.
- Leitura: o oposto do padrão EUA (Kuttner 2001; GSS 2005) — assinatura de
  **prêmio de risco fiscal** em emergente (Blanchard 2004), consistente com
  §5.3. Recuo 5y→10y = expectativa de normalização.
- CDI/Selic +2bp n.s. — atenuação de medida, remete à justificativa do
  `yield_6m` (§3.3).
- Fonte: `irf_section.md` §5.1; tabela detalhada na working-note crédito/ativos §1.

### 5.2 Ações
- Tabela de impacto dos 8 índices B3 (−3.8% a −11.2%, CI90 em 6 de 8):
  repricing imediato e completo, sem horizonte positivo significativo depois.
- Cross-section (todos com teoria): SMLL>MLCX (Gertler-Gilchrist),
  IFNC maior queda (duration de bancos, English-Van den Heuvel-Zakrajšek),
  IFIX menor queda e única série sempre negativa (renda contratada = renda
  fixa longa), IMAT único com trecho positivo significativo h2-9 (canal
  cambial das exportadoras — conecta com §5.3).
- **Caveat honesto de magnitude**: −9% por +50bp é borda superior vs
  Bernanke-Kuttner (2005) e event studies brasileiros; decompor em (i) choque
  de *path* persistente (não target de 1 dia), (ii) resposta mensal GE (embute
  câmbio +6% e risco soberano +50bp), (iii) beta EM.
- Fonte: `irf_section.md` §5.2.

### 5.3 Câmbio e risco soberano — o canal de dominância fiscal
- BRL **deprecia** ≈ +6%, EMBI +46bp, CDS +56bp, todos CI90 no impacto;
  decaimento monotônico e **reversão abaixo do baseline com CI68 em h≈31-37**
  (quando chega a desinflação/flexibilização) — internamente consistente com a
  curva ficando negativa nos mesmos horizontes.
- **Benchmark GRG (2025)**: o desacordo de sinal do câmbio (GRG diário acha
  apreciação) precisa ser re-tratado — a reconciliação anterior usava uma
  célula het, que saiu do paper (decisão 2026-07-15). Sem ela, a discussão
  fica em: diferença de frequência (diário vs mensal GE), de janela amostral
  e de regime (dominância fiscal como propriedade de 2020-25, não universal).
  Como fechar essa discussão é decisão aberta (pendência 6.6).
- Fontes: `irf_section.md` §5.3 (o `grg_benchmark.csv` foi apagado em 2026-07-26 — era construído a partir de bundles het);
  `spec_sweep_conclusoes.md` §3.

### 5.4 Crédito
- Estoques PJ: **expansão significativa h0-h6 → cruzamento h≈10-14 → contração
  com vale h≈29-43** — a cronologia clássica do canal de crédito
  (Bernanke-Gertler 1995; Gertler-Gilchrist 1994: firmas sacam linhas
  pré-aprovadas). Cross-section que confirma o mecanismo: **pessoa física, sem
  linhas para sacar, não tem a alta inicial**.
- Crédito direcionado (Bonomo-Martins 2016): **construção confirma atenuação**
  (funding SFH isola o setor); **agro não** (equalização referencia Selic +
  fração livre crescente) — nota de rodapé, não reprovação do prior.
- **Spreads ICC em duas fases**: compressão mecânica h0-h7 (ICC é taxa da
  carteira, reprecifica mais devagar que a captação) e **abertura com CI68 em
  h19-h30** — o financial accelerator (BG95; Gilchrist-Zakrajšek 2012;
  Gertler-Karadi 2015) chegando com a defasagem de reprecificação do estoque.
- Fonte: `irf_section.md` §5.4; tabelas h-a-h na working-note crédito/ativos §3.

### 5.5 Atividade, trabalho e preços
- **Atividade**: canal de demanda completo — 9/9 variáveis negativas de h=3 com
  CI68+, desemprego sobe de h≥6, horas caem.
- **Preços — reportar com a decomposição honesta**
  (working-note `2026-07-12_price_puzzle_ipca.md`):
  - headline IPCA tem corcova h0-h12 **nunca significativa a 90%** (CI68 só
    h4-h8), cruza zero em h≈21;
  - a corcova é **universal nas variantes do grid** (máscaras e
    ortogonalizações distintas, com e sem filtro de sinal) e o filtro JK não
    a reduz → descarta contaminação por information shocks;
  - com a **mesma identificação, pre-COVID mostra desinflação em todo h** —
    exatamente onde o instrumento é mais forte (ξ_mp 12.49 pre-COVID vs 6.94
    no full para o primário) → puzzle amostral (composição 2021-22), não
    estrutural;
  - ancorar na literatura: Sims (1992), Ramey (2016 — CPI flat/positivo por
    12-24m mesmo em GK2015), Minella (2003) para o Brasil.
- **Medida primária de preços: núcleo ex1** (84% de sinal correto h12-48,
  desinflação CI68 de h≈15), corroborada pela difusão (92%); ex0/dw reportados
  com a leitura da limitação do canal de desinflação do primário.
- Fonte: `irf_section.md` §5.5.

### 5.6 Robustez (versão curta no corpo; detalhes nos apêndices)
1. **Pre-COVID cross-instrument (a robustez-manchete)**: em 2013-2019 ×
   (6,5), sob a régua rigorosa ξ_mp a família GK inteira cruza ou tangencia
   Stock-Yogo (z_jk_purif 13.25, z_jk 12.72, **z_jk_bs_purif 12.49**,
   z_bruto_purif 12.04, z_bruto 11.62, z_bs_purif 11.53, z_jk_raw_purif
   10.80, z_jk_raw 10.53) e os sinais hard e de transmissão concordam —
   inclusive IPCA negativo em todo h. Máscaras e valores construídos por
   quatro receitas distintas (bruto/ortogonalizado × com/sem filtro de sinal)
   entregam a mesma resposta onde a identificação é forte. Figura:
   `output/irf/irf_spec_stage2_overlay.pdf`.
2. **Varredura de especificações**: zero `sign_puzzle` e zero
   `unstable_normalization` no full sample — nenhuma inversão de sinal do grid
   vem de normalização instável ou de puzzle genuíno → **Apêndice C**.
   ⚠️ **Não** afirmar "sempre que F ≥ 10 os sinais saem corretos": a
   working-note de 2026-07-15 (`sweep_instrumentos_irf`) mostra
   `cor(curve_slope, ξ_mp) = −0,04` — relevância não implica validade.
3. **Coerência ponto-a-ponto** (53 variáveis × 49 horizontes): anomalias
   localizadas todas rastreadas a medida ou amostra, nenhuma a identificação
   → **Apêndice C**. Releitura sob o novo primário pendente (6.1).
4. **Robustez à forma de identificação (2026-08-01) — disponível, e com um
   teto baixo que precisa ser respeitado.** Os itens 1-3 acima variam a receita
   do instrumento, o (r,q) e a janela; **nenhum varia a identificação**. A rota
   não-gaussiana (GMR 2017) é a única implementada que identifica sem `z` — o
   instrumento apenas **rotula** a coluna monetária. Fonte:
   `working-notes/2026-08-01_robustez_identificacao.md`,
   `output/nongaussian/{corroboration,labelling}_*.csv`.
   **Só duas afirmações são defensáveis, e nenhuma é de discriminação:**
   (i) **não contradiz** — o ponto do proxy cai dentro do CI90 do GMR em
   **100% das 5.194 células**; (ii) **rejeita o esquema recursivo** (Cholesky,
   ξ = 149,3), a restrição que a literatura de menor dimensão impõe sem testar
   — o que conversa diretamente com o argumento anti-VAR-pequeno da Introdução.
   ⚠️ **Não** escrever "outra identificação independente dá a mesma direção"
   sem a ressalva: sob 2.000 direções aleatórias normalizadas ao mesmo choque a
   concordância mediana já é **0,786** e um quarto delas iguala a coluna
   rotulada (p = 0,179) — a métrica satura e o teste não tem poder. E a
   rotulagem **ainda depende de `z`**: as regras que não o usam selecionam uma
   coluna que corrobora mal (0,600, um quinto da magnitude).
   ⚠️ **Não** existe robustez de identificação por heterocedasticidade: a perna
   que seria identificação alternativa nunca produziu uma IRF (reprovada no gate
   em 2026-07-16); a que produziu IRFs é o **mesmo proxy-SVAR com outro `z`**.

### O que NÃO entra em Resultados
- Os "paper-worthy findings" (`irf_section.md` §5.7) são o **roteiro da
  Introdução e da Conclusão** (contribuições), não uma subseção de Resultados.
- A tabela de unidades/escalas (`irf_section.md` §Caveats) vai para o
  **Apêndice E**, com as IRFs completas.

---

## 4. **Apêndices/Anexos** (proposta)

> Racional: o corpo carrega uma tabela síntese por bloco de resultado + a
> tabela compacta de primeiro estágio; todo o aparato de validação vive nos
> apêndices, cada um espelhando um artefato que já existe.

### Apêndice A — Dados
- Tabela completa: variável, fonte, bloco, transformação (tcode), dessazonalização.
- Detalhe do Svensson (parametrização, L-BFGS-B, interpolação nos vértices) —
  o texto já existe comentado no tex (linhas 348-350), recuperar e enxugar.
- Protocolo de dessazonalização (QS/Friedman/Kruskal-Wallis + X-13).

### Apêndice B — Instrumento e primeiro estágio
- Tabela completa das variantes GK × {F factor-space, F DFM, F y6m-AR} + n
  efetivo. Fontes: `output/instrument/instrument_diagnostics_report.md` §1,
  `output/instrument/factor_space_F_grid.csv`.
- **Bloco Wald MOSW**: definição de ξ_mp / Wald conjunta / ξ₁ (Shat), grade
  completa (r ∈ 5–8, q ∈ 4–r) × {full, pre-COVID} × variantes GK, e a
  validação end-to-end contra os números publicados (Kilian oil). Fontes:
  `output/instrument/mosw_strength_grid.{csv,md}`, `olea_alignment_audit.md`,
  `instrument_diagnostics_report.md` §1.1, `script/validate_olea_kilian.R`.
- **Auditoria de fidelidade JK/BS** (2026-07-14): matriz 2×2 máscara ×
  valores, mecanismo "a força mora na máscara" (2020-03-19), R² da regressão
  pré-evento. Fonte:
  `relatorio/working-notes/2026-07-14_auditoria_fidelidade_jk_bs.md`.
- Scatterplot das surpresas em dias de Copom
  (`output/instrument/scatterplot_surpresas_copom.png`).
- Grid vértice × amostra de purificação (`arquivo/output/instrument_grid.csv`, arquivado — cobre só as 4 variantes legadas, anterior ao `z_jk_bs_purif`; regerar se for ao apêndice).

*(O antigo Apêndice C, identificação por heterocedasticidade, e a suite
T1–T8 associada saíram do roteiro — decisão de 2026-07-15 de manter o het
fora do paper. Os artefatos permanecem em `output/{instrument,validation}/`
como diagnóstico interno.)*

### Apêndice B' — Exogeneidade do instrumento em frequência diária *(novo, 2026-07-31)*

Responde ao item de topo do council review. Fontes:
`output/instrument/jk_sovereign_confound.{csv,md}`, `jk_sovereign_days.csv`,
`jk_sovereign_irf_overlay.pdf`; leitura em
`relatorio/working-notes/2026-07-31_confound_soberano_jk.md`.

**Veredito: a acusação não se sustenta.** ΔEMBI carrega a surpresa com coef
**0,326** (t = 3,97, R² 0,13) nas 498 quintas não-Copom contra **0,099**
(t = 1,74, R² 0,04) nos 62 dias retidos — a máscara **empobrece** o conteúdo de
risco. Interações `x:1(jk_bs)` negativas nas quatro proxies da janela do evento
(BRL −0,036, p_boot 0,066). Três vias: 31 política / 30 soberano, **nenhum sinal
inverte**. Ortogonalizar ao risco diário mantém ξ_mp (10,72 vs 10,43) e todas as
manchetes sig90. **A frase que carrega a subseção:** os 31 dias "política" foram
selecionados por *apreciação* diária do BRL e ainda entregam **depreciação**
mensal (+0,129) — a depreciação do §4 é propagação, não seleção de dias.
**Duas ressalvas obrigatórias no corpo, não em nota:** o coeficiente nos 62 dias
é positivo e marginal (p = 0,097), então é "menos risco que um dia comum" e não
"zero risco"; e os 5 dias de maior alavancagem valem **28,6%** de Σ|z|, o maior
sendo 2021-10-27. Declarar em uma frase a **lacuna do CDS diário** (não existe
fonte gratuita 2013-2025; a proxy é o EMBI+). **Sem referência nova** —
`jarocinski2020` e `bauer2023` bastam.
A ordem do argumento não pode ser embaralhada: (i) enuncia a acusação, (ii) o
**controle não-Copom** que dá sentido ao coeficiente, (iii) a **interação
negativa**, (iv) a concentração em 2021-10-27. Figura: cortar o overlay de 9
painéis para quatro (`cambio_usd`, `embi_perc`, `cds_5y`, `yield_2y`).

### Apêndice D — Dinâmica dos fatores e alcance do médio prazo *(novo, 2026-07-31)*

Fontes: `output/factors/factor_{companion_spectrum,unit_root,cointegration,
lag_sensitivity_irf,irf_mode_decomposition}.csv` + `factor_stationarity.md`;
leitura em `relatorio/working-notes/2026-07-31_estacionariedade_fatores.md`.
Cobre o que o metodologista e o harsh-referee pediram por ângulos diferentes:

- **ADF / PP / KPSS** nos 7 fatores (nível e diferença) e nas 106 séries do
  painel. 4 de 7 fatores I(1), **nenhum I(2)**; PP concorda com ADF em 14 de 14.
- **Cointegração de Johansen** com K ∈ {2,4,6} e a correção de Reinsel-Ahn. O
  posto **não é identificado** (2 / 4 / 0), e sob qualquer um deles o VAR em
  nível é consistente — Sims-Stock-Watson (1990) + BLL (2016b), **as duas chaves
  já citadas**. Justifica não estimar VECM em uma frase.
- **Espectro completo da companion** (42 autovalores, módulo, argumento, período
  implicado, meia-vida), e a **decomposição espectral da IRF**: apagar o par
  dominante inverte o vale de médio prazo em 12 de 14 séries. É o que fundamenta
  a ressalva do §4 sobre o tier de 68% — a reversão e a persistência do VAR são o
  mesmo objeto, não dois fatos que se corroboram.

### Apêndice E — Benchmark contra o VAR de menor dimensão *(novo, 2026-07-31)*

Fontes: `output/var/var_benchmark.{md,...}` (3 CSV + 4 PDF); leitura em
`relatorio/working-notes/2026-07-31_benchmark_var_vs_dfm.md`. É a tradução de
`codigo_alessi-mark/MAIN_VARloop.m` — 18 VARs de 4 variáveis, mesmo instrumento e
mesma spec do DFM. **Sustenta metade da frase da introdução e refuta a outra
metade**, então precede a reescrita de `tex/main.tex:183`:

- *mais forte* 16 de 18 (razão mediana 2,32 no impacto, 1,61 no pico de mesmo
  sinal); *mais rápido* **só nas ações** (7 de 8, contra 9 de 18 no conjunto);
- a contrapartida em precisão: banda de 68% do DFM nunca mais estreita (razão
  mediana 4,35) e **37 células sig90 contra 266 do VAR** (nas ações, 0 contra
  132);
- o argumento mais forte pró-DFM é o diagnóstico core de AK
  (`MAIN_plotfigs.m:49-71`): as respostas core do VAR pequeno variam entre
  especificações **mais do que a própria magnitude**, e o VAR com `ibc_br` é
  explosivo (1,008).

Figura no formato do original: VAR à esquerda, DFM à direita, **eixo y
compartilhado por linha** (`linkaxes`) — é o eixo comum que torna a comparação
visível em vez de afirmada.

### Apêndice C — Varredura de especificações e coerência
- Desenho do grid de 480 células (12 instrumentos × 5 mp_vars × 4 (r,q) × 2
  janelas), taxonomia de falhas e sistema de score
  (working-note `2026-07-11_varredura_irf.md` §3; re-rodado 2026-07-15 com
  as 4 variantes da auditoria).
- **Resultado central**: **0 sign_puzzle / 0 unstable_normalization** —
  inversão de sinal é sempre e somente instrumento fraco no espaço dos
  fatores (`output/irf/spec_sweep_cells.csv`, `spec_sweep_report.md`).
- Mapa de F por (r,q) × instrumento × janela (as duas tabelas do §4.3 da
  working-note) — é a justificativa do (6,5) citada em §3.5.
- Overlay das células stage-2 bootstrapped (`irf_spec_stage2_overlay.pdf`,
  `spec_sweep_stage2.md`).
- **Tabela cross-instrument do IPCA** (h6/h24, full vs pre-COVID — a prova
  de universalidade da corcova e do seu desaparecimento pre-COVID;
  working-note price puzzle §2, `spec_sweep_irf_long.csv`).
- Coerência ponto-a-ponto: 53 variáveis × 49 horizontes contra janelas
  teóricas, vereditos e anomalias localizadas
  (`output/irf/irf_coherence_{h,summary}.csv`, `irf_coherence_report.md`).
- Jaggedness: tabela rugosidade × p ∈ {3,6,12} + espectro do companion
  (working-note dentadas) — justifica manter p=6 sem suavização.

### Apêndice D — IRFs completas
- Painel completo por bloco (curva, ações, câmbio/risco, crédito, atividade,
  trabalho, preços), 68/90, h=0-48
  (`output/irf/irf_model_alessi_r7q6.pdf`, `irf_coherence_plots.pdf` —
  re-gerados 2026-07-24 sob (7,6) e o vintage de 106 séries).
- Tabela de unidades e escalas (proporção decimal para yields; log-pontos para
  ações; nível BRL/USD; escala ×100 do CDS; tcode 4 para estoques de crédito)
  — transcrever de `irf_section.md` §Caveats.

---

## 5. Mapa artefato → seção (verificação de cobertura)

| Artefato existente | Vai para |
|---|---|
| `output/irf/irf_section.md` | corpo §5 (fonte canônica, reescrita 2026-07-26 sob (7,6)) |
| `output/irf/irf_model_alessi_r7q6.pdf` | figuras §5 + Apêndice D |
| `output/irf/spec_sweep_{cells,irf_long}.csv`, `spec_sweep_*.md` | §3.5, §5.6, Apêndice C |
| `output/irf/irf_spec_stage2_overlay.pdf` | §5.6 figura |
| `output/irf/irf_coherence_*.{csv,md,pdf}` | Apêndice C, D |
| `output/instrument/instrument_diagnostics_report.md`, `factor_space_F_grid.csv` | §3.6 + Apêndice B |
| `output/instrument/mosw_strength_grid.{csv,md}`, `olea_alignment_audit.md` | §3.5, §3.6, §5.6 + Apêndice B |
| `relatorio/working-notes/2026-07-14_auditoria_fidelidade_jk_bs.md` | §3.4 + Apêndice B |
| `R/data_download/focus_fred.R` → `data/processed/focus_daily.csv`, `data/fred_dgs2.csv` | insumos do §3.4.2 (preditores pré-evento) |
| `output/instrument/scatterplot_surpresas_copom.png` | Apêndice B |
| `output/instrument/jk_sovereign_confound.{csv,md}`, `jk_sovereign_days.csv` | **Apêndice B'** + subseção nova do §5 (confound soberano) |
| `output/instrument/jk_sovereign_irf_overlay.pdf` | figura do §5 — **cortar de 9 para 4 painéis** (`cambio_usd`, `embi_perc`, `cds_5y`, `yield_2y`) |
| `relatorio/working-notes/2026-07-31_confound_soberano_jk.md` | leitura do Apêndice B' + §5 |
| `output/irf/irf_coherence_h.csv` | fonte numérica do §5 (ponto + bandas 68/90 + flags de significância) |
| `_instrucoes/justificativa_uso_yield-6m.md` | §3.3 |
| `relatorio/working-notes/2026-07-1*` | leituras econômicas do §5 + Apêndice C |

*(Todo o material het foi arquivado em `arquivo/` em 2026-07-26 e os artefatos
regeneráveis apagados — ver `arquivo/README.md` e `_instrucoes/historico_decisoes.md` §1.)*

## 6. Pendências que a nova versão deve sinalizar (não bloqueiam a estrutura)

1. **§5 reescrito em 2026-07-26 — FECHADA.** Mas o esqueleto 5.1–5.6 desta nota
   e as working-notes de 2026-07-12 descrevem a rodada antiga. **Afirmações que
   inverteram** e que não podem ser recicladas do texto velho:

   | tema | texto antigo | rodada (7,6) |
   |---|---|---|
   | ações | 8 índices caem, CI90 em 6 de 8, −3,8% a −11,2% | −0,3% a −2,9%; **nenhum atinge CI90 no impacto**; IBOV −1,67% com CI90 [−7,77; +1,76] |
   | ações, médio prazo | "sem horizonte positivo significativo" | overshoot positivo em 6 de 8 índices (IBOV +20% em h24), CI68, nunca CI90 — tratar como não informativo |
   | crédito | expansão significativa do agregado em h0-h6 | agregado e PF **contraem monotonicamente**; a alta inicial é só setorial (transporte +0,75 CI90, agro +1,01 CI90, indústria +0,19 CI68) |
   | preços | "corcova nunca significativa a 90%" | headline **sig90 em h5**; ex0 sig90 em h2 e h4-8 e virou `incoerente`; DW sig90 em h4-5 e h7 |
   | câmbio/risco | BRL +6%, EMBI +46bp, CDS +56bp | BRL +3,6%, EMBI +20bp, CDS +29bp — sinal, significância e timing iguais |
   | placebo | (não reportado) | **3 placebos, todos passando.** `commodity_metal` deixou de ser placebo em 2026-07-28 (B3): o IC-Br é em R$ e herda o câmbio; o índice em US$ passa 25/25 horizontes |

   O caveat de magnitude das ações ("−9% é borda superior vs Bernanke-Kuttner")
   **deixa de ser necessário** — as magnitudes agora batem com os event studies
   brasileiros. Falta converter o §5 para o tex.
2. **Bandas Anderson-Rubin: agora OPCIONAIS.** Em (7,6) o primário tem
   ξ_mp ≥ 10 nas duas janelas (10,43 / 12,22), então bandas convencionais
   bastam. Manter AR como robustez, seguindo o protocolo anti-screening do
   próprio MOSW (footnote 6): reportar ξ, não filtrar pelo F.
3. ~~**Placebo `commodity_metal` violado**~~ — **RESOLVIDO em 2026-07-28, e a
   inversão é completa.** Não é falha de exogeneidade: o IC-Br do BCB é
   **denominado em R$**, logo é preço doméstico que herda mecanicamente a
   resposta cambial (+3,98% contra +3,27% do câmbio). O teste decisivo está em
   `diagnostics/01_exogeneidade.R` §1.6 — num painel aumentado, os três índices
   **em R$** violam e os três **em US$** passam limpo (metal +0,42, CI90
   [−1,44; +1,88], **0 de 25** horizontes sig). Se fosse fator global, o índice
   em dólar responderia. Reclassificado para `ambiguous` (B3) e **não é mais
   caveat de exogeneidade**. Não estender a ortogonalização por causa dele.
4. **Spread de concessões novas** como complemento ao ICC (deve abrir já no
   curto prazo) — desejável, não-bloqueante.
5. **Abstract, Introdução e Conclusão**: rewrite completo (sinais/magnitudes da
   era Cholesky; a Conclusão promete "instrumento de alta frequência como
   pesquisa futura" — que agora é o coração do paper). Roteiro: os findings
   do `irf_section.md` §5.7, revistos sob o novo primário (pendência 1).
6. **Benchmark GRG (2025) sem a célula het**: decidir como discutir o
   desacordo de sinal do câmbio agora que a célula de reconciliação saiu do
   paper (frequência diária vs mensal, janela, regime fiscal).
7. **Revisão de literatura**: acrescentar o eixo de identificação que hoje não
   existe no tex (Stock-Watson 2018; Gertler-Karadi 2015; Jarociński-Karadi
   2020; Bauer-Swanson 2023; Mertens-Ravn 2013; GRG 2025; Bonomo-Martins 2016
   para crédito direcionado; Blanchard 2004 para dominância fiscal).
