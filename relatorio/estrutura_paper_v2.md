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
| (r, q) | r=7, q=4 | **r=6, q=5** (justificado por varredura de especificações; auto-IC (5,4) é borderline-weak; sob a régua MOSW ξ_mp do primário: forte em pre-COVID (12.49), zona AR no full (6.94)) |
| VAR dos fatores | VAR(1) | VAR(**p=6**) |
| Painel | 71 variáveis, 2013–2024 | ~111 séries, 2013-01 a 2025-09 (147 meses alinhados) |
| Variável de política | "variável de juros" genérica | **`yield_6m`** com normalização +50bp no impacto (`juros_selic` é controle negativo: F máx = 2.49) |
| Resultados | 2 parágrafos + 1 figura; magnitudes antigas | §5 reescrito (2026-07-12) em `output/irf/irf_section.md` — **desatualizado desde 2026-07-15**: a cadeia foi re-estimada sob `z_jk_bs_purif` e o §5 precisa de releitura com os novos artefatos |
| Robustez | nenhuma | Varredura de especificações (480 células, 12 instrumentos), coerência ponto-a-ponto (52 variáveis), grade MOSW ξ_mp (392 células) |
| Apêndice | só a tabela de variáveis (referenciada, não presente) | dezenas de artefatos prontos em `output/{instrument,validation,irf,benchmark}/` |

**Atenção — o Resultado atual do tex tem o sinal do câmbio INVERTIDO em relação
ao resultado de produção.** O abstract e o §Resultados dizem "apreciação de 8%";
a estimativa de produção é **depreciação** de ≈ +6% com CI90, acompanhada de
abertura de EMBI/CDS — a leitura de dominância fiscal (Blanchard 2004). Abstract,
Intro e Conclusão precisam de rewrite completo (fora do escopo desta nota, mas
sinalizado no §6 abaixo).

**O que sobrevive do tex:**
- As equações (1)–(4) do SDFM (§3.1 atual) — apenas atualizar o texto ao redor.
- A subseção Base de Dados — atualizar números (71→111 séries; 2024→2025-09) e
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
- ~111 séries mensais, 2013-01–2025-09 (147 meses alinhados); justificativa do
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
  (indicam (5,4)); decisão final **(r=6, q=5)**. Justificativa em duas camadas:
  (i) a varredura de especificações apontou (6,5) como a escolha consistente
  nas duas janelas (auto-IC (5,4) é borderline-weak); (ii) a régua rigorosa
  MOSW (ξ_mp) para o primário `z_jk_bs_purif`: **(6,5) é o único par ≥ 10 em
  pre-COVID (12.49, bandas padrão OK); no full fica na zona AR (6.94 > 3.84,
  conjunto AR limitado)**. O full-sample favorece r=8 ((8,8): 13.13), mas
  r ∈ {7,8} colapsa em pre-COVID ((7,6): 6.90; (8,8): 5.14; T = 84 meses não
  sustenta r alto) — argumento de força, além do IC, para não subir a
  dimensão. Tabela ξ_mp do primário por (r,q) × janela no corpo. Fontes:
  `output/instrument/mosw_strength_grid.md`;
  `output/irf/spec_sweep_conclusoes.md` + adendos 2026-07-14/15.
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
- Números do primário `z_jk_bs_purif` (6,5): **ξ_mp = 6.94 (full, zona AR:
  intervalo AR limitado, bandas AR pendentes) / 12.49 (pre-COVID, bandas
  padrão OK)**; F conjunta 1.75 (p = 0.12) / 2.74 (p = 0.018). No full, 6 de
  14 células (r,q) cruzam ξ_mp ≥ 10 (mediana 9.73). Tabela compacta no corpo;
  tabela completa variantes GK × {3 Fs legados + bloco MOSW} → **Apêndice B**
  (fontes: `output/instrument/instrument_diagnostics_report.md` §1-1.1,
  `factor_space_F_grid.csv`, `mosw_strength_grid.csv`,
  `olea_alignment_audit.md`).
- A identificação é mais forte na janela pre-COVID do que na amostra completa
  (12.49 vs 6.94): as observações pós-2020 adicionam ruído à relevância, não
  informação — mesma leitura da varredura de especificações.

---

## 3. Seção **Resultados** (proposta)

> Fonte canônica: `output/irf/irf_section.md` (rewrite 2026-07-12) — **escrita
> sob o primário antigo (`z_jk_purif`) e desatualizada desde 2026-07-15**: a
> cadeia foi re-estimada com `z_jk_bs_purif` × `yield_6m`, (6,5), p=6, full
> sample, +50bp, nboot=800, seed 123, e os artefatos
> (`irf_model_alessi_r6q5.pdf`, `irf_coherence_*.{csv,md,pdf}`,
> `irf_coherence_cell.rds`) já refletem o novo primário. As subseções 5.1–5.5
> abaixo descrevem a rodada antiga; a história qualitativa sobrevive (curva
> sobe, BRL deprecia com EMBI/CDS abrindo, corcova n.s. do IPCA, crédito em
> duas fases), mas as magnitudes caem ~30–45% (BRL h0 +0.185 vs +0.245; EMBI
> +25bp vs +46bp; Ibov h0 −1.1% vs −8.9%) e o bloco de crédito/juros melhora
> de veredito. O §5 precisa ser reescrito a partir dos novos artefatos antes
> de ir ao tex (pendência 6.1).

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
- Fontes: `irf_section.md` §5.3; `output/benchmark/grg_benchmark.csv`;
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
2. **Varredura de 480 células** (12 instrumentos × 5 mp_vars × 4 (r,q) × 2
   janelas): zero `sign_puzzle`, zero `unstable_normalization` — toda
   inversão de sinal do grid é F factor-space < 10; sempre que F ≥ 10 os
   sinais saem corretos → **Apêndice C**.
3. **Coerência ponto-a-ponto** (52 variáveis × 49 horizontes): anomalias
   localizadas todas rastreadas a medida ou amostra, nenhuma a identificação
   → **Apêndice C**. Releitura sob o novo primário pendente (6.1).

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
- Grid vértice × amostra de purificação (`output/instrument/instrument_grid.csv`).

*(O antigo Apêndice C, identificação por heterocedasticidade, e a suite
T1–T8 associada saíram do roteiro — decisão de 2026-07-15 de manter o het
fora do paper. Os artefatos permanecem em `output/{instrument,validation}/`
como diagnóstico interno.)*

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
- Coerência ponto-a-ponto: 52 variáveis × 49 horizontes contra janelas
  teóricas, vereditos e anomalias localizadas
  (`output/irf/irf_coherence_{h,summary}.csv`, `irf_coherence_report.md`).
- Jaggedness: tabela rugosidade × p ∈ {3,6,12} + espectro do companion
  (working-note dentadas) — justifica manter p=6 sem suavização.

### Apêndice D — IRFs completas
- Painel completo por bloco (curva, ações, câmbio/risco, crédito, atividade,
  trabalho, preços), 68/90, h=0-48
  (`output/irf/irf_model_alessi_r6q5.pdf`, `irf_coherence_plots.pdf` —
  re-gerados 2026-07-15 sob o novo primário).
- Tabela de unidades e escalas (proporção decimal para yields; log-pontos para
  ações; nível BRL/USD; escala ×100 do CDS; tcode 4 para estoques de crédito)
  — transcrever de `irf_section.md` §Caveats.

---

## 5. Mapa artefato → seção (verificação de cobertura)

| Artefato existente | Vai para |
|---|---|
| `output/irf/irf_section.md` | corpo §5 (fonte canônica — reescrever sob o novo primário, pendência 6.1) |
| `output/irf/irf_model_alessi_r6q5.pdf` | figuras §5 + Apêndice D |
| `output/irf/spec_sweep_{cells,irf_long}.csv`, `spec_sweep_*.md` | §3.5, §5.6, Apêndice C |
| `output/irf/irf_spec_stage2_overlay.pdf` | §5.6 figura |
| `output/irf/irf_coherence_*.{csv,md,pdf}` | Apêndice C, D |
| `output/instrument/instrument_diagnostics_report.md`, `factor_space_F_grid.csv` | §3.6 + Apêndice B |
| `output/instrument/mosw_strength_grid.{csv,md}`, `olea_alignment_audit.md` | §3.5, §3.6, §5.6 + Apêndice B |
| `relatorio/working-notes/2026-07-14_auditoria_fidelidade_jk_bs.md` | §3.4 + Apêndice B |
| `R/data_download/focus_fred.R` → `data/processed/focus_daily.csv`, `data/fred_dgs2.csv` | insumos do §3.4.2 (preditores pré-evento) |
| `output/instrument/scatterplot_surpresas_copom.png`, `instrument_grid.csv` | Apêndice B |
| `output/benchmark/grg_benchmark.csv` | §5.3 (re-tratamento pendente, 6.6) |
| `_instrucoes/justificativa_uso_yield-6m.md` | §3.3 |
| `relatorio/working-notes/2026-07-1*` | leituras econômicas do §5 + Apêndice C |

*(Artefatos het — `het_validation_report.md`, `het_*` — ficam fora do paper;
permanecem no repositório como diagnóstico interno.)*

## 6. Pendências que a nova versão deve sinalizar (não bloqueiam a estrutura)

1. **Reescrever o §5 (Resultados) sob o novo primário**: a cadeia foi
   re-estimada em 2026-07-15 com `z_jk_bs_purif`, mas `irf_section.md` e as
   leituras interpretativas das working-notes de 2026-07-12 (price puzzle,
   crédito, dentadas) descrevem a rodada antiga. História qualitativa igual,
   magnitudes ~30–45% menores (Ibov h0 −1.1% vs −8.9%; BRL +0.185 vs +0.245;
   EMBI +25bp vs +46bp). Releitura ponto-a-ponto + rewrite do
   `irf_section.md` antes de converter o §5 para o tex.
2. **Bandas Anderson-Rubin** (weak-IV robust): obrigatórias para o primário
   full-sample (`z_jk_bs_purif` (6,5): ξ_mp = 6.94 < 10; AR limitado,
   > 3.84). Pre-COVID (6,5) dispensa (12.49 ≥ 10, bandas padrão OK).
   Protocolo anti-screening do próprio MOSW (footnote 6): reportar ξ e usar
   AR, não filtrar pelo F.
3. **Placebo `commodity_metal` violado** (responde ao choque com CI90;
   persiste na rodada 2026-07-15): documentar como caveat de exogeneidade ou
   testar ortogonalização estendida (metais não entram nos preditores).
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
