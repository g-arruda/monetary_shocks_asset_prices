# Nova estrutura do artigo — Metodologia, Resultados e Apêndices

**Data:** 2026-07-13
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
| Identificação | Cholesky recursivo no VAR dos fatores ("3º fator = choque MP") | **Instrumento externo** `z_jk_purif` (proxy-SVAR, Stock-Watson 2018), projeção `H = (Z'η)/(Z'Z)` |
| Instrumento | inexistente — citado como "pesquisa futura" na Conclusão | 8 variantes construídas e validadas: 4 GK-style (surpresas DI em dias de Copom + purificação Bauer-Swanson + filtro de sinal Jarociński-Karadi) e 4 het-ID (Rigobon-Sack) |
| (r, q) | r=7, q=4 | **r=6, q=5** (justificado por varredura de 320 células; auto-IC (5,4) é borderline-weak, F=9.20) |
| VAR dos fatores | VAR(1) | VAR(**p=6**) |
| Painel | 71 variáveis, 2013–2024 | ~111 séries, 2013-01 a 2025-09 (147 meses alinhados) |
| Variável de política | "variável de juros" genérica | **`yield_6m`** com normalização +50bp no impacto (`juros_selic` é controle negativo: F máx = 2.49) |
| Resultados | 2 parágrafos + 1 figura; magnitudes antigas | §5 completo reescrito (2026-07-12) em `output/irf/irf_section.md` |
| Robustez | nenhuma | Suite T1–T8, varredura 320 células, coerência ponto-a-ponto (52 variáveis), testes de rank, A3 pre/post-COVID, benchmark GRG (2025) |
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
> "SDFM + proxy-SVAR com instrumento construído em 3 camadas + segunda
> identificação independente por heterocedasticidade". A seção precisa de duas
> subseções novas (3.3 e 3.4) e de uma subseção de relevância do instrumento
> (3.6) que hoje não existem.

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
  choque (atenuação ~25×; `_instrucoes/justificativa_uso_yield-6m.md`) — F=21.3
  vs F≈1.1 do `juros_selic`.

### 3.4 Construção do Instrumento *(nova)*
- **3.4.1 Surpresas de alta frequência**: variação Qua→Qui do DI no vértice de
  126 du (≈ 6m) em dias de Copom (decisão após o fechamento → janela D→D+1),
  estilo Gertler-Karadi. Agregação mensal.
- **3.4.2 Purificação Bauer-Swanson (2023)**: regressão das surpresas em fatores
  observáveis pré-anúncio (SP500, VIX, Brent, BRL) para remover o componente
  previsível / resposta ao ciclo global.
- **3.4.3 Filtro de sinal Jarociński-Karadi (2020)**: mantém apenas dias com
  co-movimento negativo juros×IBOV (choque monetário puro), zera os dias de
  co-movimento positivo (information shocks). Resultado: **`z_jk_purif`**, o
  instrumento primário do paper.
- **3.4.4 Identificação por heterocedasticidade (robustez)**: resumo em ~2
  parágrafos do `z_het` (Rigobon-Sack 2003): SVAR diário 4-var
  (DI_3m, DI_2y, IBOV, BRL) em pares Qua→Qui, regimes Copom vs não-Copom,
  `b_1 = sqrt(λ_1) v_1` do eigenpair dominante de `Σ_C − Σ_NC`, projeção GLS
  Mertens-Ravn, agregação mensal, variante 3-var como robustez à violação de
  A2 em DI_2y. Enfatizar dois pontos de posicionamento (blindspot 04-25):
  (i) o rank-1 da matriz de diferença de covariâncias é **testado** (Rigobon
  Prop. 1 + Lanne-Lütkepohl + CI bootstrap do rank-1 share), não assumido como
  na maior parte da literatura; (ii) aplicar o filtro JK sobre choques
  het-extraídos é uma combinação metodológica nova. Detalhes completos →
  **Apêndice C**.

### 3.5 Seleção de (r, q) e Estimação
- Bai-Ng IC2 / Amengual-Watson nas variantes BLL-standardized como *referência*
  (indicam (5,4)); decisão final **(r=6, q=5)** justificada pela varredura de
  especificações: (5,4) é borderline-weak no full sample (F factor-space 9.20)
  e (6,5) é a única escolha forte no full (10.08) que também é o **máximo do
  grid pre-COVID** (15.40) — mesma (r,q) nas duas janelas. Fonte:
  `output/irf/spec_sweep_conclusoes.md` §4.
- Estimação: PCA sobre painel BLL-padronizado; VAR(6) nos fatores; ponto por
  OLS puro (fiel a `DFMest_BLL.m`); correção de Kilian (1998) apenas no DGP do
  **wild bootstrap** (Gonçalves-Kilian 2004), nboot=800, bandas 68/90, h=0–48.

### 3.6 Relevância do instrumento *(nova)*
- Exposição didática dos **três Fs de primeiro estágio** (working-note
  `2026-07-11_varredura_irf.md` §2): F (y6m AR) mede relevância univariada;
  F (DFM) contra o resíduo do primeiro fator; **F (factor-space)** — máximo
  sobre as q regressões das inovações fatoriais — é o único que governa o viés
  weak-IV na projeção `H = Z'η/(Z'Z)`. Os três podem discordar por 20×
  (caso documentado: `z_het_jk_3var` com F(y6m)=55.98 e F(factor-space)=2.74).
- Números do primário: F factor-space = **10.08** (full) / **15.40**
  (pre-COVID, o pico do grid). Tabela compacta no corpo; tabela completa
  8 variantes × 3 Fs → **Apêndice B** (fonte:
  `output/instrument/instrument_diagnostics_report.md` §1 +
  `factor_space_F_grid.csv`).
- **Não enterrar** (blindspot 04-26): (i) `drop_covid` F (24.2) > full F (21.3)
  — remover a janela COVID-aguda **fortalece** a identificação, i.e. 2020-Q2/Q3
  contamina ativamente, não é só "robustness check passes"; (ii) nota de rodapé
  de método: toda a suite de validação replicada de forma independente em
  Python (NumPy/statsmodels) com concordância a 6 casas decimais
  (`relatorio/correspondence/referee2/replication/`).

---

## 3. Seção **Resultados** (proposta)

> Fonte canônica: `output/irf/irf_section.md` (rewrite 2026-07-12) — a seção
> praticamente existe em md e precisa ser convertida para LaTeX. Especificação
> de produção: `z_jk_purif` × `yield_6m`, (6,5), p=6, full sample, +50bp,
> nboot=800, seed 123. Figuras: `output/irf/irf_model_alessi_r6q5.pdf` (blocos)
> e `irf_coherence_plots.pdf`.

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
  apreciação) é **regime/horizonte-driven, não method-driven** — a célula
  `z_het_3var` × pre-COVID × (6,5), a identificação mais próxima da de GRG, é a
  única do grid com apreciação + desinflação + ordenação amortecida da curva.
  Reportar como robustez qualitativa (§5.6); dominância fiscal é propriedade do
  regime 2020-25, não universal.
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
  - a corcova é **universal nos 8 instrumentos** (inclusive het-ID, de origem
    totalmente distinta) e o filtro JK não a reduz → descarta contaminação por
    information shocks;
  - com a **mesma identificação, pre-COVID mostra desinflação em todo h** —
    exatamente onde o instrumento é mais forte (F 15.4 > 10.1) → puzzle
    amostral (composição 2021-22), não estrutural;
  - ancorar na literatura: Sims (1992), Ramey (2016 — CPI flat/positivo por
    12-24m mesmo em GK2015), Minella (2003) para o Brasil.
- **Medida primária de preços: núcleo ex1** (84% de sinal correto h12-48,
  desinflação CI68 de h≈15), corroborada pela difusão (92%); ex0/dw reportados
  com a leitura da limitação do canal de desinflação do `z_jk_purif`.
- Fonte: `irf_section.md` §5.5.

### 5.6 Robustez (versão curta no corpo; detalhes nos apêndices)
1. **Pre-COVID cross-instrument (a robustez-manchete)**: em 2013-2019 ×
   (6,5), **cinco instrumentos cruzam Stock-Yogo** (z_jk_purif 15.4, z_jk 15.2,
   z_het_jk_3var 11.1, z_het_3var 10.8, z_bruto_purif 10.4), abrangendo **dois
   paradigmas de identificação independentes** (timing Copom e
   heterocedasticidade), e concordam nos sinais hard e de transmissão —
   inclusive IPCA negativo em todo h nos 8. Figura:
   `output/irf/irf_spec_stage2_overlay.pdf`.
2. **Célula GRG-style** (`z_het_3var` pre-COVID): reconciliação qualitativa com
   GRG 2025 (§5.3); condicionada a bandas Anderson-Rubin se promovida além de
   robustez qualitativa.
3. **Varredura de 320 células**: zero `sign_puzzle`, zero
   `unstable_normalization` — toda inversão de sinal do grid é F factor-space
   < 10; sempre que F ≥ 10 os sinais saem corretos → **Apêndice D**.
4. **Heterogeneidade pre/post-COVID como achado próprio** (blindspot 04-26,
   não enterrar): β do first stage **sobe** +37% pós-2020 enquanto o SE sobe
   +151% e var(innov) cresce 3.6×; QLR de Andrews não rejeita quebra no slope
   (sup F = 6.88 < cv5 = 8.85, e o τ* é 2015, não 2020) — a transmissão não
   enfraqueceu, a **identificação ficou ruidosa** (mudança no regime de
   comunicação do BCB é a hipótese interpretativa). Merece 1-2 parágrafos
   próprios, não uma linha de tabela.
5. **Coerência ponto-a-ponto** (52 variáveis × 49 horizontes): anomalias
   localizadas todas rastreadas a medida ou amostra, nenhuma a identificação
   → **Apêndice D**.

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
- Tabela completa 8 variantes × {F factor-space, F DFM, F y6m-AR} + n efetivo.
  Fontes: `output/instrument/instrument_diagnostics_report.md` §1,
  `output/instrument/factor_space_F_grid.csv`.
- Scatterplot das surpresas purificadas em dias de Copom
  (`output/instrument/scatterplot_surpresas_copom.png`).
- Grid vértice × amostra de purificação (`output/instrument/instrument_grid.csv`).
- **Suite de validação T1–T8** (fonte: `output/validation/het_validation_report.md`
  + CSVs/PNGs por teste):
  - T1 placebo por permutação (p = 0.0005);
  - T2 random-mask com o framing honesto ("JK F no percentil 99 das máscaras
    aleatórias — o gap é um percentil") + T2b benchmark pareado do z_het puro;
  - T3 sub-período (incluindo **drop_covid F 24.2 > full 21.3** com a leitura
    de contaminação ativa);
  - T4 correlação het×timing por janela (0.93-0.95 — convergência dos dois
    esquemas) + var(innov) por janela (3.6× pós-COVID);
  - T5 anti-JK (F = 0.19 — o complemento sign-equal carrega ~zero sinal);
  - T6 curva F(k) para k ∈ {20,42,60,80};
  - T7 sensibilidade AR p ∈ {3,6,12};
  - T8 QLR de Andrews (fail to reject; τ* = 2015-08).

### Apêndice C — Identificação por heterocedasticidade
- Setup do SVAR diário, hipóteses A1–A3, recuperação rank-1 do choque
  (síntese de `_instrucoes/Heteroscedasticidade.md`).
- Réplica da GRG (2025) Table 1: variance split C vs NC com `a2_status` por
  variável, blocos 4-var e 3-var lado a lado
  (`output/instrument/het_variance_validation{,_3var}.csv`).
- Espectro de autovalores de ΔΣ (`het_eigenvalues*.csv`, `.png`).
- **Testes formais de rank**: Rigobon Prop. 1 (proporcionalidade rejeitada,
  p ≤ 0.011 — gate satisfeito), Lanne-Lütkepohl rank-1 (fail to reject em
  todos os blocos), CI bootstrap do rank-1 share (3-var: [0.948, 0.995])
  (`het_rank_test*.csv`, `het_rank1_share_ci*.csv`). Framing: **evidência
  empírica da hipótese que a literatura assume**.
- `b_1` 4-var vs 3-var; `b_2` como descritor (perfil forward-guidance quando
  A2 falha em DI_2y) (`het_b_1*.csv`, `het_b_2*.csv`).
- **A3 pre/post-COVID**: cosine(b_1_pre, b_1_post) = 1.000, norm ratio 0.687 —
  direção estável, magnitude cai 31% (`het_a3_*.csv`).
- **Framing híbrido het+timing** (exclusion restriction mensal
  `E[z·η] = 0`, mais fraca que A1-A3 conjuntas) e o fato de o het-ID ser
  **subconjunto estrito** do timing-ID (42 vs 65 meses ativos, 36 em comum) —
  het como identificação mais conservadora, com os 29 meses timing-only como
  candidatos a contaminação (blindspot 04-26, não enterrar).

### Apêndice D — Varredura de especificações e coerência
- Desenho do grid de 320 células (8 instrumentos × 5 mp_vars × 4 (r,q) × 2
  janelas), taxonomia de falhas e sistema de score
  (working-note `2026-07-11_varredura_irf.md` §3).
- **Resultado central**: 208 weak_factor_space / 64 negative_control / 48 ok /
  **0 sign_puzzle / 0 unstable_normalization** — inversão de sinal é sempre e
  somente instrumento fraco no espaço dos fatores
  (`output/irf/spec_sweep_cells.csv`, `spec_sweep_report.md`).
- Mapa de F por (r,q) × instrumento × janela (as duas tabelas do §4.3 da
  working-note) — é a justificativa do (6,5) citada em §3.5.
- Overlay das células stage-2 bootstrapped (`irf_spec_stage2_overlay.pdf`,
  `spec_sweep_stage2.md`).
- **Tabela cross-instrument do IPCA** (h6/h24, full vs pre-COVID, 8
  instrumentos — a prova de universalidade da corcova e do seu desaparecimento
  pre-COVID; working-note price puzzle §2, `spec_sweep_irf_long.csv`).
- Coerência ponto-a-ponto: 52 variáveis × 49 horizontes contra janelas
  teóricas, vereditos e anomalias localizadas
  (`output/irf/irf_coherence_{h,summary}.csv`, `irf_coherence_report.md`).
- Jaggedness: tabela rugosidade × p ∈ {3,6,12} + espectro do companion
  (working-note dentadas) — justifica manter p=6 sem suavização.

### Apêndice E — IRFs completas
- Painel completo por bloco (curva, ações, câmbio/risco, crédito, atividade,
  trabalho, preços), 68/90, h=0-48
  (`output/irf/irf_model_alessi_r6q5.pdf`, `irf_coherence_plots.pdf`).
- Tabela de unidades e escalas (proporção decimal para yields; log-pontos para
  ações; nível BRL/USD; escala ×100 do CDS; tcode 4 para estoques de crédito)
  — transcrever de `irf_section.md` §Caveats.

---

## 5. Mapa artefato → seção (verificação de cobertura)

| Artefato existente | Vai para |
|---|---|
| `output/irf/irf_section.md` | corpo §5 (fonte canônica) |
| `output/irf/irf_model_alessi_r6q5.pdf` | figuras §5 + Apêndice E |
| `output/irf/spec_sweep_{cells,irf_long}.csv`, `spec_sweep_*.md` | §3.5, §5.6, Apêndice D |
| `output/irf/irf_spec_stage2_overlay.pdf` | §5.6 figura |
| `output/irf/irf_coherence_*.{csv,md,pdf}` | Apêndice D, E |
| `output/validation/het_validation_report.md` + T1-T8 CSVs/PNGs | Apêndice B |
| `output/instrument/instrument_diagnostics_report.md`, `factor_space_F_grid.csv` | §3.6 + Apêndice B |
| `output/instrument/het_*` (variance, eigenvalues, rank, b_1/b_2, A3) | Apêndice C |
| `output/instrument/scatterplot_surpresas_copom.png`, `instrument_grid.csv` | Apêndice B |
| `output/benchmark/grg_benchmark.csv` | §5.3 |
| `_instrucoes/justificativa_uso_yield-6m.md` | §3.3 |
| `relatorio/working-notes/2026-07-1*` (4 notas) | leituras econômicas do §5 + Apêndice D |

## 6. Pendências que a nova versão deve sinalizar (não bloqueiam a estrutura)

1. **Bandas Anderson-Rubin** (weak-IV robust): obrigatórias se qualquer
   variante het for promovida além de robustez qualitativa; to-do
   pré-submissão declarado em `irf_section.md` §Caveats.
2. **Placebo `commodity_metal` violado** (responde ao choque com CI90 h0-h8;
   metais não entram na purificação): testar purificação estendida ou
   documentar como caveat de exogeneidade (pendências 2026-07-11).
3. **Spread de concessões novas** como complemento ao ICC (deve abrir já no
   curto prazo) — desejável, não-bloqueante.
4. **Abstract, Introdução e Conclusão**: rewrite completo (sinais/magnitudes da
   era Cholesky; a Conclusão promete "instrumento de alta frequência como
   pesquisa futura" — que agora é o coração do paper). O roteiro são os 5
   findings do `irf_section.md` §5.7.
5. **Revisão de literatura**: acrescentar o eixo de identificação que hoje não
   existe no tex (Stock-Watson 2018; Gertler-Karadi 2015; Jarociński-Karadi
   2020; Bauer-Swanson 2023; Rigobon-Sack 2003/2004; Mertens-Ravn 2013;
   GRG 2025; Bonomo-Martins 2016 para crédito direcionado; Blanchard 2004 para
   dominância fiscal).
