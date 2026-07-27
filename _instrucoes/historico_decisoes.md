# Histórico de decisões — o que já foi tentado e por que morreu

Registro de **resultados negativos e decisões revertidas**. Existe para evitar
retrabalho: antes de propor um caminho, confira se ele já foi percorrido aqui.
Vários destes itens são material de rodapé ou de apêndice do paper — resultado
negativo bem documentado tem valor, e nenhum deles está descrito no código.

Criado em 2026-07-26 a partir do `pendencias.md` acumulado (2026-04 a 2026-07).
As pendências **abertas** vivem em `pendencias.md`; este arquivo é só memória.

---

## 0. Identificação não-gaussiana (GMR 2017) — achados que não se repetem

Aberta em 2026-07-27 na branch `identificacao-nao-gaussiana`. O ramo está vivo
(`identification = "nongaussian"`); o que está aqui são os **resultados
negativos e as armadilhas** que custaram tempo e não devem ser redescobertos.

### 0.1 O pacote `IdSS` do próprio autor está quebrado para n ≥ 4

`github.com/jrenne/IdSS` (commit `20c8ea6`, v0.1.0) é o material de apoio do
livro do Renne e implementa o estimador do artigo. **Três defeitos independentes
aparecem só a partir de n = 4** — a aplicação publicada é n = 3, onde os três
são invisíveis:

1. **`make.M`** preenche o triângulo superior de `A` na ordem coluna-a-coluna
   das *posições*, que não é a transposta da ordem do triângulo inferior. Para
   n ≥ 4 o `A` resultante **não é antissimétrico**, logo
   `C = (I+A)(I−A)^{-1}` **não é ortogonal** e a SIR3 é violada. É o caminho
   que `estim.SVAR.ICA` usa para montar o `C.PML` que devolve.
2. **`make.C`** repete o mesmo erro por conta própria, então a função objetivo
   (`pseudo.log.L` → `func.2.minimize`) é avaliada sobre o mesmo conjunto errado.
3. **O gradiente analítico** usa `dvec(C)/dvec(A) = R' ⊗ (I + A)`. O diferencial
   de Cayley é `dC = (I + C) dA R`, logo o correto é `R' ⊗ (I + C)`. Conferido
   contra `numDeriv` — a forma do pacote erra por ordens de grandeza.

Consequência prática: **nada do caminho ICA do `IdSS` serve em q = 6.** Daí a
tradução em `R/identification/nongaussian_gmr.R`. As três funções que recebem
`C` como argumento em vez de construí-lo — `make.Omega`, `make.A.matrix`,
`make.Asympt.Cov.delta` — estão **corretas em qualquer n** e são usadas como
alvo de validação cruzada (batem com a tradução a 1e-15 em n = 3 e n = 6).
`script/validate_gmr_ica.R` bloco E é um teste-guarda: se o upstream corrigir,
ele avisa.

### 0.2 A não-gaussianidade do painel é dirigida pela COVID

Gate em `output/nongaussian/gate.md` (`script/nongaussian_gate.R`). Jarque-Bera
nas q = 6 inovações fatoriais de (7,6):

| janela | componentes que **não** rejeitam normalidade a 5% |
|---|---|
| full (T = 147) | 3 de 6 |
| pré-COVID (T = 80) | **5 de 6** |

GMR e LMS exigem **no máximo um** gaussiano. No full a identificação é
**parcial** — `C` fica definida a menos de uma rotação dentro do bloco
quase-gaussiano, mas as colunas não-gaussianas seguem identificadas. **Na janela
pré-COVID a rota simplesmente não existe.** Isso é estrutural, não conjuntural:
não adianta re-tentar a comparação GMR × proxy pré-COVID, que é justamente a
janela onde o proxy é mais forte (ξ_mp 12,22). Confirmado por simulação em
`validate_gmr_ica.R` bloco D: com 2 fontes gaussianas em n = 6, a coluna dentro
do bloco gaussiano dobra de erro (0,39) enquanto a não-gaussiana não se mexe
(0,20).

### 0.3 O wild bootstrap Rademacher é inválido neste ramo

O multiplicador ±1 zera **todos os terceiros momentos**
(`E[u³r³] = E[u³]E[r³] = 0`). A assimetria é exatamente o que a Assumption A.5
do GMR exige para o máximo global do critério ser único, então o DGP do
bootstrap viraria um mundo simetrizado onde o ICA é muito menos identificado.
O ramo usa **reamostragem i.i.d. com reposição**, como o apêndice online do
próprio GMR (§E) e `IdSS::nonparam.bootstrap`. Os ramos proxy e het seguem no
Rademacher, inalterados.

### 0.4 Estabilidade multi-start só significa algo condicionada ao ótimo

O critério tem muitos ótimos locais em q = 6 (15 parâmetros livres): de 100
partidas, **1** chega ao melhor. Medir a dispersão de `C` sobre *todas* as
partidas convergidas mistura não-identificação com falha do otimizador e produz
um número catastrófico e enganoso (cosseno mínimo 0,67). Condicionando às
partidas a ≤ 2 unidades de log-verossimilhança do ótimo, a coluna monetária é
estável a **cosseno 0,996**. A métrica útil é o *perfil* por tolerância, que é o
que o `gate.md` reporta.

### 0.5 As bandas assintóticas da Prop. 4 subcobrem em T ≈ 150, n = 6

Simulação em `validate_gmr_ica.R` bloco D: intervalo nominal de 95% cobre
**0,79**. O artigo valida a aproximação assintótica em n = 2 com T = 200; em
n = 6 com T = 150 — exatamente a nossa dimensão — ela é otimista. Os
erros-padrão de `gmr_asympt_cov` devem ser lidos como piso, não como medida
calibrada.

### 0.6 O resultado empírico: o estimador não tem poder neste painel

Rodada de produção (`output/nongaussian/results.md`, 200 draws i.i.d.):

- Bandas de 90% no impacto **contêm zero em todas as variáveis** exceto a
  normalizada. `asset_ibov` = −10,7 com CI90 **[−49,5, +80,8]**; o proxy dá
  −1,67 com [−7,6, +1,8].
- Cosseno mediano de **0,703** entre a direção monetária do draw e a do ponto,
  com **49%** dos draws abaixo de 0,7. Zero trocas de rótulo em 200 (o
  `C_ref` + warm start resolveram o label switching).
- A Wald assintótica rejeita a restrição do proxy (ξ = 117,3, gl = 5,
  p < 0,0001) e o esquema recursivo (ξ = 148,4, gl = 15, p < 0,0001). **Ambas
  as rejeições são suspeitas** pela subcobertura documentada em §0.5.

**A leitura errada é "as duas identificações discordam".** A leitura certa é que
o GMR não determina nada aqui: o intervalo dele para a bolsa é compatível com o
ponto do proxy e com quase tudo mais. Se alguém reabrir esta rota esperando um
segundo conjunto de magnitudes para o §5, é este o resultado que já existe.

Robustez à pseudo-densidade (Prop. 3) **funciona**: a coluna monetária é 0,916
alinhada entre misturas de gaussianas e Student-t. E a A.5 morde como o artigo
diz — com q secantes hiperbólicas idênticas, 58 de 60 partidas empatam no mesmo
valor do critério (§2.2: se as `g_i` são iguais e pares, todo `P(Ĉ)` é máximo).

---

## 1. Identificação por heterocedasticidade — abandonada em duas frentes

### 1.1 Como instrumento (`z_het*`, Rigobon-Sack 2003)

**Construída e validada, depois demovida.** SVAR diário sobre pares Qua→Qui
(DI_3m, DI_2y, IBOV, BRL), regimes C = quarta de Copom / NC = demais,
`b_1 = sqrt(λ_1) v_1` do autopar dominante de `Σ_C − Σ_NC`, choque diário
recuperado por projeção GLS Mertens-Ravn (2013), agregação mensal. Quatro
variantes (`z_het`, `z_het_jk`, `z_het_3var`, `z_het_jk_3var`).

Passou por auditoria externa completa (referee2 rounds 1 e 2, réplica em
Python batendo em 6+ casas) e pela suíte T1-T8 de validação (placebo, máscara
aleatória, sub-período, correlação, anti-JK, curva F(k), sensibilidade AR,
QLR de Andrews).

**Por que morreu:** força no espaço dos fatores. Sob a régua rigorosa ξ_mp
(Montiel Olea-Stock-Watson), `z_het_3var` chega a **0,45 no full em (7,6)** e
`z_het` a 1,95 — contra 10,43 do `z_jk_bs_purif`. A F legada (max-F ou F contra
a inovação AR do `yield_6m`) mascarava isso: `z_het` tinha F(y6m AR) ≈ 7,6 com
F(DFM) ≈ 1,5. Lição transferível: **as três Fs legadas podem discordar por uma
ordem de grandeza da estatística que realmente governa a projeção**
`H = (Z'η)/(Z'Z)`.

- 2026-05-08 — `DEFAULT_VARIANT` trocado de `z_het_jk_3var` para `z_jk_purif`.
- 2026-07-15 — decisão editorial: het fora do paper, pipeline como diagnóstico interno.
- 2026-07-26 — código arquivado em `arquivo/`, artefatos apagados.

**Achado que sobrevive:** A3 (constância de `B_d`) sustentada —
cos(b_1_pré, b_1_pós) = 1,000 com norm_ratio 0,687; a direção da coluna de
impacto é estável, só a magnitude cai 31% pós-2020. E o segundo autopar `b_2`
tem perfil de *tilt* (curto sobe, longo cai), consistente com forward guidance
quando A2 falha em DI_2y — descritor, nunca usado como segundo instrumento.

### 1.2 Como identificação primária (Rigobon 2003 nas inovações fatoriais)

**Pivô de 2026-07-16, reprovado no mesmo dia, nas duas variantes.** A motivação
era boa: o Copom anuncia ~18h30, depois do fechamento, e a janela Qua→Qui de
~24h fragiliza a exclusion restriction do proxy (crítica Rigobon-Sack 2004 ao
event-study). O código foi implementado e validado por simulação
(`validate_het_primary_sim.R`: cos 0,994, tamanho do J 4,5%, poder 85,5%), e o
ramo proxy ficou byte-idêntico ao de produção.

| variante | desenho | veredito |
|---|---|---|
| **Calendário** | regimes = meses com/sem Copom; 16 células (r,q) | **Reprovada.** Placebo de permutação p entre 0,26 e 0,86; proporcionalidade `Σ_C ∝ Σ_NC` nunca rejeitada ⇒ A1/rank condition inexistentes na frequência mensal |
| **Episódio (BPSS 2021)** | S2 pré/pós-2020 + partição fina S4; 4 células | **Reprovada.** A volatilidade se move como **fator de escala comum**; autovalores generalizados indistinguíveis (gap mínimo 0,04-0,19); a coluna com o loading de `yield_6m` tem λ ≈ 1 |

**Leitura:** a heterocedasticidade que identifica no diário (Rigobon-Sack)
simplesmente não sobrevive à agregação mensal — a variância muda de nível, não
de composição. Isso é um resultado sobre a frequência, não sobre o método.

Decisão do autor no mesmo dia: **abandonar qualquer identificação por
instrumento/proxy** e escolher uma nova primária. Essa decisão foi **revertida
em 2026-07-24**: o refresh de vintage devolveu força ao proxy (ξ_mp > 10 nas
duas janelas em (7,6)) e a produção seguiu no proxy-SVAR. A nota
`working-notes/2026-07-24_auditoria_analise_gemini.md` foi escrita durante essa
janela de 8 dias e ainda carrega a premissa antiga.

**Itens LEVE que morreram junto:** guard de sign-flip em
`het_shock_extraction.R:208`; alinhamento de NA handling entre
`validate_variance_split` (por coluna, n_C=104) e `extract_shock_rigobon_sack`
(complete.cases, n_C=97); documentar `MAX_GAP_DAYS` no nível do script.

---

## 2. Construção do instrumento — o que a auditoria de fidelidade mudou

**Auditoria 2026-07-14/15** (`relatorio/2026-07-15_relatorio_auditoria_fidelidade_instrumento.md`
e `working-notes/2026-07-14_auditoria_fidelidade_jk_bs.md`). Duas infidelidades
encontradas e corrigidas:

1. **JK aplicado nos objetos errados.** O filtro é fiel na regra e na agregação
   mensal (soma dentro do mês), mas o projeto classificava e agregava
   **resíduos**, enquanto Jarociński-Karadi classificam os valores **brutos**.
2. **A "purificação Bauer-Swanson" não era Bauer-Swanson.** Era uma limpeza de
   fator global contemporânea (SP500/VIX/Brent na mesma janela Qua→Qui). BS
   ortogonalizam em preditores **predeterminados** até o fechamento da quarta
   (tendências financeiras de 65 pregões + revisões Focus de 20 pregões +
   tendência). A versão fiel foi construída (`z_bs_purif`, `z_jk_bs_purif`).

**Achado central, que virou resultado do paper:** *a força do instrumento mora
na máscara, não nos valores purificados.* Uma máscara classificada em resíduos
contemporâneos rotula **2020-03-19** (pânico de liquidez COVID) como dia
monetário; qualquer máscara predeterminada (bruta ou pré-evento BS) exclui esse
dia e domina. Confirmado de forma independente em 2026-07-26: em (7,6) full, as
**únicas três variantes com ξ_mp ≥ 10 são exatamente as de máscara
predeterminada** (`z_jk_raw` 10,55, `z_jk_bs_purif` 10,43, `z_jk_raw_purif`
10,39), contra `z_jk_purif` 5,77 e `z_jk` 6,30.

**Variantes testadas e descartadas:**

| variante | o que era | veredito |
|---|---|---|
| `z_jk_raw_purif_local` | re-estima a purificação só nos ~55 dias selecionados | Dominada, descartada 2026-07-14 |
| `z_jk_purif_us` | contemporânea + UST 2y Qua→Qui | Redundante (cor 0,999 com `z_jk_purif`) |
| `z_jk_raw_purif` | máscara bruta + valores purificados | Viva como robustez; foi a candidata a default em 07-14, perdeu para `z_jk_bs_purif` em 07-15 |

**Decisão revertida:** a nota de 2026-07-14 recomendava **manter `z_jk_purif`
como default**; a recomendação foi derrubada em menos de 24h pela auditoria de
fidelidade, e `z_jk_bs_purif` virou o primário em 2026-07-15.

---

## 3. Migrações de (r, q) — e a leitura que não vale mais

| data | spec | motivo |
|---|---|---|
| até 2026-07-11 | auto-IC (5,4) / legado r=7,q=7-8 | Bai-Ng / Amengual-Watson BLL |
| 2026-07-11 | **(6,5)** | Varredura de 320 células; auto-IC (5,4) borderline-weak |
| 2026-07-24 | **(7,6)** | Refresh de vintage; única das 4 dimensões da varredura com ξ_mp > 10 nas **duas** janelas |

**A leitura antiga "pre-COVID (6,5) é o pico do grid / r ≥ 7 colapsa pre_covid
(T=84)" NÃO VALE MAIS.** No vintage atual: (5,4) 5,45/7,94; (6,5) 6,36/11,00;
(7,6) 10,43/12,22; (8,8) 12,57/8,99. E na grade completa de 14 células, (7,5),
(7,7), (8,5) e (8,6) também cruzam 10 nas duas janelas — r=7 é um platô, não uma
escolha de canivete. Qualquer documento que ainda cite o colapso em r≥7 está no
vintage velho.

**Refresh de vintage (2026-07-24):** `download.R`/`clean.R` voltaram a persistir
a saída (`write_csv` — antes computavam e não gravavam); removido o bloco
duplicado de 4 séries de tempo de procura (`.x`/`.y`, join dobrado) e as colunas
de break-even ANBIMA 100% vazias. Painel: **106 séries**. Foi essa limpeza que
devolveu força ao instrumento em (7,6).

**Correção de tcode nos índices B3 (mesma data):** as séries `asset_*` são
retornos mensais, mas `infer_tcode_from_varnames` as tratava como nível
(tcode 1), então a janela de coerência (sinal negativo sustentado em h0-6,
própria de um nível de preço) marcava Ibov/IDIV/IMOB/MLCX como `incoerente`.
Corrigido para **tcode 2** (retorno → IRF acumulada = resposta de nível).
`incoerente` caiu de 5 para 1. **Toda magnitude de ações anterior a 2026-07-24
está fora de escala.**

---

## 4. Itens de código fechados

Resolvidos e verificados; ficam aqui só para não serem reabertos.

- **`script/yield_curve.R` apagado** (2026-07-26). Ajuste Svensson próprio sobre
  os contratos DI, escrito para gerar a curva a vértices fixos. **Não dava bom
  resultado** e foi abandonado pelo autor; a curva que o painel usa sempre foi
  `data/yields/yields_dia.csv`, **insumo externo fixo fornecido pelo
  orientador**, lido direto pelo `script/download.R`. A saída do script
  (`data/curva_juros/`) nunca foi consumida por estágio nenhum. Recuperável no
  histórico do git. Consequência: `R/modeling/svensson_model.R` ficou sem
  consumidor (o `source()` no `download.R` era chamada morta e foi removido) —
  **não reimplementar a curva sem antes decidir o que fazer com esse módulo.**

- **Mismatch de `mp_var`** (2026-05-05) — IRFs eram normalizadas por
  `juros_selic` (F≈1,1); passou a `yield_6m` (F=21,3). `juros_selic` fica como
  **controle negativo documentado** (F reduzida máx = 2,49 em todo o grid).
- **Unit scaling de `yield_6m`** (2026-05-07) — `normalize_value = bps/10000`
  (50bp → 0,005 em proporção decimal), não `/100`. Antes as IRFs saíam em escala
  +5000bp. **Relatórios anteriores a essa data estão 100× fora de escala em
  magnitude**; sinais e formas inalterados. O default legado `0.5` de
  `ident_ext_instr` foi mantido por compatibilidade com `model_var.R`, que
  hard-coda `juros_selic` em escala percentual.
- **F (factor-space) ≪ F (y6m AR)** (2026-05-08) — diagnóstico que expôs a
  fraqueza real do het. Helper `factor_space_diagnostics.R`; os três Fs passaram
  a ser reportados lado a lado.
- **Bloco Wald MOSW** (2026-07-14) — ξ_k por fator, Wald conjunta
  T·Γ̂'Ŵ⁻¹Γ̂ ~ χ²_q e **ξ_mp** (a Wald na direção de impacto do `yield_6m`,
  análogo exato do `Waldstat` oficial). Validado end-to-end contra os números
  publicados da aplicação Kilian-petróleo (ξ₁ = 4,4; F robusta = 9,4 — a F
  publicada é HC1, não HC0). `script/validate_olea_kilian.R`.
- **Suíte T1-T8 de validação** (2026-05-05/06) — placebo, máscara aleatória,
  sub-período, correlação, anti-JK, curva F(k), sensibilidade AR(p), QLR de
  Andrews. Escrita para `z_het_jk`; as funções em
  `R/identification/validation_tests.R` são agnósticas ao instrumento e ficam.
  **Resultados que sobrevivem:** anti-JK F = 0,194 contra JK F = 21,29 (o
  complemento sign-equal não carrega sinal — o filtro não é só esparsificação);
  QLR não rejeita quebra no slope do primeiro estágio (sup F = 6,88 em 2015-08,
  cv5 = 8,85), e a queda de F pós-COVID é explicada por var(innov) 3,6× maior,
  não por mudança de β.
- **Teste de rank para ΔΣ** (2026-05-07) — Rigobon Prop. 1 rejeita
  proporcionalidade no diário (p_boot ≤ 0,011); Lanne-Lütkepohl rank-1 não
  rejeita em nenhum bloco (poder limitado com n_C ≈ 50).
- **Framing T2 honesto** (2026-05-06) — a F do JK fica *no* percentil 99 das
  máscaras aleatórias de mesmo tamanho; a distância é de um percentil. Redação
  corrigida nos documentos públicos.

**Bug de método que vale para qualquer teste de sub-período** (referee2 round 2,
achado não-het): janelas **não-contíguas** (ex.: `drop_covid`) exigem
residualização AR **full-sample antes** do subset. Refitar o AR dentro da janela
faz outubro/2020 ser regredido em fevereiro/2020 sem que nada acuse o erro.
`first_stage_F` já implementa a versão correta.

---

## 5. Decisões editoriais

- **2026-05-06** — benchmark contra GRG (2025) apenas; Minella (2003) descartado
  como benchmark numérico (segue como referência de literatura para o price
  puzzle brasileiro).
- **2026-07-15** — het fora do paper (§3.4.4, antigo Apêndice C e itens het do
  §5.6 removidos do roteiro).
- **2026-07-16** — abandonar qualquer identificação por proxy. **Revertida em
  2026-07-24** (ver §1.2).
- **2026-07-24** — rota de sign-restriction set-ID frequentista retirada do
  escopo; o núcleo frequentista de robustez fica **ACF (2024) +
  não-gaussianidade (LMS/GMR)**.
- **2026-07-24** — GMMO (2018) fora do escopo (não faz proxy + sinais);
  Braun-Brüggemann e Caldara-Herbst são bayesianos e ficam como apêndice
  opcional; Antolín-Díaz-Rubio-Ramírez é Tier 3 (maior esforço, paradigma mais
  distante). Detalhe em
  `relatorio/working-notes/2026-07-24_avaliacao_5_artigos_robustez.md`.

---

## 6. Afirmações antigas que foram contraditadas

Cuidado ao reusar texto destas fontes — os documentos ainda circulam.

| afirmação | onde aparece | o que a contradiz |
|---|---|---|
| "Sempre que F ≥ 10 os sinais hard saem coerentes, em qualquer combinação" | `working-notes/2026-07-11_varredura_irf.md`; propagada em `estrutura_paper_v2.md` §5.6 | `working-notes/2026-07-15_sweep_instrumentos_irf.md`: 0 de 36 células limpas e `cor(curve_slope, ξ_mp) = −0,04` — relevância ≠ validade |
| "pre-COVID (6,5) é o pico do grid; r ≥ 7 colapsa pre_covid" | notas de 07-11 a 07-15, `estrutura_paper_v2.md` §3.5 | Grade MOSW de 2026-07-24 (§3 acima) |
| "A corcova do IPCA nunca é significativa a 90%" | `working-notes/2026-07-12_price_puzzle_ipca.md`, §5 antigo | Rodada (7,6): headline sig90 em h5; ex0 sig90 em h2 e h4-8; DW sig90 em h4-5 e h7 |
| "Os 8 índices caem com significância (CI90 em 6 de 8)" | §5 antigo (2026-07-12) | Rodada (7,6): nenhum índice atinge CI90 no impacto |
| "Crédito total se expande com significância em h0-h6" | §5 antigo, `working-notes/2026-07-12_irf_credito_ativos_financeiros.md` | Rodada (7,6): agregado e PF contraem monotonicamente; a expansão inicial é só setorial (transporte, agro, indústria) |
| "O proxy foi abandonado; escolher nova identificação primária" | `working-notes/2026-07-24_auditoria_analise_gemini.md` (09h24) | Nota das 23h46 do mesmo dia + produção: o proxy-SVAR segue primário sob (7,6) |
