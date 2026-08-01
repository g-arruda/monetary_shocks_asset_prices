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

### 0.7 A causa: a agregação do DFM destrói a não-gaussianidade

| objeto | n | % rejeita JB (5%) | curtose mediana |
|---|---:|---:|---:|
| séries do painel (1ª dif.) | 106 | **88,7** | 6,67 |
| resíduos do VAR de fatores | 7 | 71,4 | 5,77 |
| `eta` (inovações dinâmicas) | 6 | **50,0** | 4,50 |

Gradiente monótono: **o `eta` mensal é o objeto mais gaussiano do pipeline.**
Agregação temporal (choque diário somado dentro do mês → TCL) e transversal
(combinação linear de 106 séries). O ICA precisa do que o DFM elimina.

**Não tente contornar com `q` menor.** A não-gaussianidade concentra-se em
`eta_1-3`, mas o Amengual-Watson em r = 7 dá **q̂ = 8** (critério −1,358 em q = 3
contra −1,398 no mínimo). Reduzir q para o gate passar é specification shopping.

Isto também explica §1.2 (het rejeitada neste painel): het e não-gaussianidade
exploram os **mesmos momentos de ordem superior**. Qualquer método futuro que
identifique por momentos de ordem > 2 nas inovações **mensais** do DFM vai bater
na mesma parede. Métodos que precisam disso devem rodar em frequência diária,
sobre observáveis, não sobre `eta`.

### 0.8 A corroboração é real como descrição e nula como teste (2026-08-01)

Rodada de corroboração sobre o GMR reestimado (`nboot = 800`, `NG_STARTS = 200`).
Scripts: `script/nongaussian_{corroboration,labelling}.R` sobre
`R/identification/nongaussian_labelling.R`. Nota:
`working-notes/2026-08-01_robustez_identificacao.md`.

**Três coisas que não se deve re-derivar.**

**(a) O número que o `results.md` publica está selecionado.** O `HEADLINE` de
`model_nongaussian.R:46-47` são 8 séries fixas e dão 8/8 de concordância de
sinal no impacto; no painel de 106 a mesma medida é **0,660**. A régua que
responde "o que eu afirmo sobrevive?" é condicionar em onde o proxy é
significativo: **0,971** nas 140 células sig90 (todas h ≤ 12), razão de
magnitude **1,11**, e **1,000** nos blocos de curva, câmbio/risco e preços.
Atividade é o único abaixo (0,733) e concentra as 4 discordâncias de sinal.

**(b) Essa concordância não sobrevive a um nulo.** 2.000 direções unitárias
sorteadas em ℝ⁶, cada uma normalizada a +50bp em `yield_6m`, dão concordância
mediana **0,786** nas mesmas células — e **um quarto delas iguala ou supera a
coluna rotulada** (p = 0,179). No bloco da curva o nulo tem mediana **exatamente
1,000**, porque normalizar na taxa de política força a curva inteira a subir. A
métrica **satura** (q95 do nulo no teto em 3 das 5 estatísticas): o resultado
**não** é "o GMR não corrobora", é "**concordância de sinal não é evidência de
que corrobora**". Sobrevivem duas afirmações, ambas de não-discriminação: o
ponto do proxy cai dentro do CI90 do GMR em **100% das 5.194 células**, e o
esquema recursivo é rejeitado (ξ = 149,3). Sugestivo e nunca significativo: a
coluna rotulada é a melhor das seis em razão de magnitude (|log| 0,101 contra
0,776 da segunda, p = 0,125) e em cosseno com a direção do proxy (0,620 contra
mediana 0,315 do nulo, p = 0,134).

**(c) A coluna monetária não é bem definida sem o instrumento.** Quatro regras
de rotulagem, fixadas antes de medir: R0 `|cor(ε,z)|` → coluna 2; R1 impacto em
`yield_6m` → **coluna 1**; R2 FEVD de `yield_6m` h0-12 → **coluna 1**; R3 FEVD do
bloco da curva → coluna 2. **As duas regras ancoradas na variável de política —
as mais naturais — escolhem a coluna 1, que concorda 0,600 e responde com um
quinto da magnitude.** A que melhor corrobora (coluna 3: 1,000 nas sig90, 0,907
global) nenhuma regra escolhe. Isso fecha, com resposta negativa, a pendência de
inspecionar a vice-líder.

**Armadilha de desenho, e a razão de o módulo existir.** A IRF é normalizada por
`irf / irf[mpind, 1] * 0.005`, que divide pela própria resposta de impacto da
coluna — **depois disso toda coluna vale 0,005 em `yield_6m` em h = 0**, e
qualquer regra de seleção aplicada à IRF normalizada é degenerada. A seleção tem
de ler a resposta **pré-normalização**. Há um `stopifnot` que prova isso a cada
corrida.

**Dois defeitos de processo corrigidos na mesma rodada.** (i) O cache de 07-27
era de safra anterior ao painel (regerado em 07-28, fix de locale B1): exatamente
`cds_5y`, `msci` e `sp500_vix` diferiam por fator estável de **100** nos 49
horizontes. Não contaminava conclusões — a padronização BLL absorve reescala
pura, as outras 103 séries reproduziam a 1,4e-07, e sinal/cobertura/razão são
invariantes a escala —, mas as **unidades reportadas** dessas 3 estavam erradas,
e 2 são placebos. (ii) `NG_STARTS = 60` não alcançava o ótimo que o gate acha com
100 partidas (logLik −1209,61 contra −1209,30, rotulando colunas diferentes, com
`n_at_best = 1` de 60). Subiu para **200** e o run passa a bater o gate
(−1208,60); o `results.md` agora reporta essa reconciliação a cada corrida. O
índice da coluna muda entre ótimos (6 → 2) mas a direção estimada quase não muda
— o índice é rótulo de permutação, não conteúdo.

**Quadruplicar os draws não estreita as bandas**, como previsto: a largura vem
da instabilidade da direção entre reamostragens (cosseno mediano 0,703), não de
ruído de Monte Carlo. As células sig90 próprias do GMR **caíram** de 4 para 1.

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

### 2.1 Classificação de três vias (política / soberano / informação) — construída e **não** promovida (2026-07-31)

O council review levantou que o filtro JK descarta o efeito-informação (juros ↑,
ações ↑) mas retém a assinatura fiscal doméstica (juros ↑, ações ↓, câmbio ↑).
A resposta natural seria uma terceira via. Ela foi construída — em memória, em
`script/jk_sovereign_confound.R`, sem tocar `build_variants.R` — e **não deve ser
promovida**. Registro para ninguém re-propor:

- **A terceira via usa o câmbio**, com a mesma forma do JK: sob UIP um aperto
  **aprecia** o BRL (sinais de `e_di_bs` e `e_brl_bs` diferem = política), uma
  surpresa fiscal **deprecia** (sinais iguais = soberano). As pernas de FX e EMBI
  são purificadas na **mesma** RHS pré-evento do BS, para a máscara continuar
  predeterminada.
- **Por que morreu:** os 62 dias partem em **31 política / 30 soberano / 1 n/c**
  (regra FX) e **nenhum sinal de IRF inverte**. ξ_mp cai de 10,43 para **3,52 e
  3,50** — queda essencialmente mecânica, já que os meses não-nulos vão de 62
  para ~30. Custa metade da amostra e não compra conclusão nenhuma.
- **A regra alternativa pelo EMBI é pior e assimétrica:** 24 política / 37
  soberano, com ξ_mp **0,89** na metade política contra **7,77** na soberana. Se
  alguém quiser reabrir isso, é aqui que a assimetria tem de ser explicada antes.
- **Armadilha conceitual a não repetir:** condicionar a máscara num movimento
  cambial **contemporâneo** é exatamente o tipo de seleção same-window que a
  camada Bauer-Swanson existe para evitar. Purificar o câmbio na RHS pré-evento
  mitiga, **não elimina** — a classe é escolhida com informação da janela do
  evento, ao contrário da máscara JK-BS, que é predeterminada.
- **O que sobrevive do exercício** é o diagnóstico, não o instrumento: a máscara
  de produção foi **absolvida** da acusação de selecionar risco soberano, porque
  os dias retidos carregam *menos* risco por unidade de surpresa que uma quinta
  comum (coef 0,099 contra 0,326; interações negativas nas quatro proxies). Ver
  `_instrucoes/Instrumento.md`, status de 2026-07-31, e
  `relatorio/working-notes/2026-07-31_confound_soberano_jk.md`.
- **Também não repetir:** tentar corrigir o alinhamento do arquivo de EMBI. Ele é
  **do mesmo dia** (cor de ΔEMBI com S&P/Ibov em t = −0,498 / −0,508 contra
  −0,045 / −0,088 em t−1). A janela Qui→Sex é resposta defasada, não
  desalinhamento.

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

### 3.1 Painel de ações em log-nível — testado, venceu, e **deixado de lado por decisão do autor** (2026-07-31)

`script/asset_representation.R` → `output/assets/`. Nota:
`relatorio/working-notes/2026-07-31_acoes_representacao.md`. **Não reabrir sem
evidência nova**: o teste foi feito, o resultado é claro, e a decisão de não
promover é do autor, não do dado.

**O que o teste mostrou.** Pôr os 8 índices da B3 em log-nível
(`log(cumprod(1+r))`, tcode 4) leva o bloco de **0 para 39** células sig90,
todas em h=0-5, em 7 dos 8 índices; o ponto dobra e a banda encolhe (Ibovespa
−1,67 [−7,77; 1,76] → −3,68 [−8,70; −0,86]; proxy de |t| em h=0 de 0,676 para
1,826). O resto do modelo quase não se mexe: 79 dos 92 pares sig90 sobrevivem.
Ou seja, **o resultado nulo do bloco acionário é da representação, não do dado.**

**Por que foi deixado de lado.** Custa força de instrumento: ξ_mp full
**10,43 → 8,94** (abaixo dos 10 em que as bandas convencionais são
aproximadamente válidas, que é a faixa em que o §3 justifica (7,6)), e
**pré-COVID o painel quebra** — ξ_mp 3,91, companion **explosiva (1,0030)**,
correção de Kilian sem convergir. Somado ao custo de reescrever todo o §4-§5,
re-selecionar (r,q) e repassar o `clean.R`, o autor optou por **corrigir só o
`cumsum`** e não mexer no painel.

**⚠ O que a correção do `cumsum` sozinha NÃO entrega, medido em 2026-07-31:**
o bloco continua nulo a 90% — **1 célula de 392** (só `asset_ifix` em h=1), e
**0 de 8 em h=0**. Isso é matemática, não amostra: em h=0 o `cumsum` é no-op e o
×100 é escalar positivo, então **a significância em h=0 é invariante ao tcode**.
Quem entrega o resultado acionário é a representação do painel, e só ela.
Qualquer texto futuro que atribua a recuperação do bloco à correção do `cumsum`
está errado.

**A reconstrução do nível é exata e não precisa de rede**, caso alguém retome:
`cumprod(1+r)` reproduz o fechamento mensal do índice porque o produto
intramensal telescopa — conferido contra `data/processed/ibov_daily.csv` com sd
relativo da razão de **1,4e-15**.

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
  hard-codava `juros_selic` em escala percentual. **Atualização de 2026-07-31:**
  o `model_var.R` foi reescrito e passou a normalizar em `yield_6m` via
  `norm_value_for()`, então **esse default não tem mais consumidor** — todo
  chamador passa o valor explicitamente. Ele espelha o `*.5` hard-coded de
  `IdentExtInstr.m:14` e por isso não foi removido.
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

- **Locale dos CSVs da investing.com** (2026-07-28, bug B1) — `download.R:222-243`
  lia três arquivos com separador decimal errado (`"138,19"` virava `13819`), e
  `cds_5y`, `msci` e `sp500_vix` entravam **100× inflados**. Corrigido: o CDS
  responde **+29,07bp**, não +2.907bp, o que o torna comparável ao EMBI
  (+19,95bp) em vez de 145× maior. **Nenhum resultado muda** — a padronização
  BLL absorve escala constante —, mas **todo número de CDS anterior a 07-28 está
  fora de escala** em documentos e notas.
- **`yield_6m` na tabela de coerência** (2026-07-28, B2) — a variável de
  normalização estava ausente de `coherence_var_table()`, o que tornava o +50bp
  não auditável a partir dos artefatos publicados. Incluída. Seu `h0` é
  **mecânico** (0,005000 exato, CI90 degenerada) porque as 800 reamostras são
  todas normalizadas ao mesmo ponto: a linha é checagem, não resultado.
- **`yield_ordering_ok` e `magnitude_flag`** (2026-07-28, B4) — computados,
  gravados, nunca lidos por `classify_sweep_cells`. Decisão do autor:
  **documentar como régua reportada, não promover a critério**. A taxonomia
  segue classificando por ξ_mp. `yield_ordering_ok` é FALSE na célula de
  produção e em 58 das 68 células `ok`, porque o pico da curva no impacto está
  em 2-5 anos (+91,6 / +92,7bp) e não no vértice de política (+50,0bp).

**Dois achados de método reutilizáveis** (rodada de auditoria 07-28):

1. **O χ² assintótico super-rejeita 2,3× a 5,3× nesta amostra.** Comparações de
   subamostra precisam de wild block bootstrap sob H0 — no teste conjunto da
   Tarefa 7, 6 de 7 rejeições assintóticas viram 1 de 7 pelo bootstrap
   (`qchisq(0.95,9)` = 16,9 contra q95 da nula bootstrap entre 38,9 e 89,1).
2. **`sandwich::NeweyWest` sobre um `lm` de segundo estágio usa a *meat* errada
   para IV.** `estfun.lm` monta o score com `y − X̂b`, mas o resíduo estrutural é
   `y − Xb`. `diagnostics/07_dominancia_fiscal.R` monta o sanduíche IV analítico
   à mão, com `stopifnot()` contra `sandwich::lrvar` na matriz de scores.

**Bug de método que vale para qualquer teste de sub-período** (referee2 round 2,
achado não-het): janelas **não-contíguas** (ex.: `drop_covid`) exigem
residualização AR **full-sample antes** do subset. Refitar o AR dentro da janela
faz outubro/2020 ser regredido em fevereiro/2020 sem que nada acuse o erro.
`first_stage_F` já implementa a versão correta.

### 4.1 Os `Re()` e a correção de Kilian **não** são a origem dos autovalores complexos (2026-07-31)

Pergunta levantada pelo autor ao ver o par complexo dominante da companion:
seria artefato numérico, herdado dos `Re()` acrescentados no passado para
contornar aparecimento de números complexos? **Auditado, e não.** Registrado
aqui porque é caro re-derivar e a resposta é definitiva.

1. **Nada no caminho do ponto estimado é sequer complexo.** Medido objeto a
   objeto, `max|Im| = 0` em `static_factors`, `static_loadings`, `Z`, `bet`, nos
   resíduos `u` **antes** do `Re()`, na `companion`, em `K`, `M`, `A²⁴` e em
   `Λ·B·K·M`. As duas fontes de vetores são `svd()` (`factor_estimation.R:326` e
   `:661`), real para entrada real. Logo os `Re()` de `estimate_var_ols:526`,
   `:574` e de `impulse_responde.R:450-452` são **no-ops**. Código defensivo
   morto — não descartam nada e não escondem nada. **Não apagar sem necessidade,
   mas também não tratar como sintoma.**
2. **O único complexo legítimo é o do Kilian, e ali está certo.** A fórmula de
   Pope (1990) soma `λₕ(I − λₕB)⁻¹` sobre os 42 autovalores; pares conjugados se
   cancelam. Medido: `max|Im(sumeig)| = 0` **exato** e **0 de 42** termos pulados
   pelo `tryCatch` da linha 413. O `Re()` da linha 419 é aplicado à **soma**, não
   termo a termo — termo a termo seria erro. O `kiliancorr.m` original não tem
   `real()` nenhum e carrega o ruído adiante; a versão em R é mais limpa que o
   MATLAB nesse ponto, não divergente dele.
3. **E o Kilian não entra no achado.** `companion_corrected` **não aparece** em
   `impulse_responde.R`: o ponto usa `companion_matrix` (OLS puro, `:342`) e cada
   réplica do bootstrap re-estima por OLS (`:572`); o corrigido só monta o DGP
   (`:503`). Qualquer defeito lá não moveria o vale de médio prazo, que é do
   ponto.
4. **Autovalores confirmados fora do repo.** OLS por `qr.solve` (QR, não equações
   normais) e `vars::VAR` batem com o projeto a **7,9e-13** nos quatro maiores
   módulos, e os três dão período dominante de **117,90 meses**.

**Raiz complexa não é defeito:** todo VAR com dinâmica oscilatória tem
autovalores complexos, e num VAR(6) de 7 variáveis 40 das 42 serem complexas é o
esperado. Bug seria parte imaginária não-nula descartada, termo faltando na soma
de Pope, companion mal montada ou raiz explosiva — nenhum ocorre (|λ|máx =
0,9768 < 1).

**A preocupação legítima é estatística e aponta na direção contrária:** são ~301
parâmetros em 147 observações efetivas, e OLS **subestima** persistência em
amostra pequena — que é o problema que a correção de Kilian existe para tratar. A
companion corrigida tem módulo **maior** (0,98339) e período **mais longo**
(147,0 meses). Se há viés, a dinâmica verdadeira é ainda mais dominada por esse
modo.

Fonte: `relatorio/working-notes/2026-07-31_estacionariedade_fatores.md`, seção
"Isso não é bug?".

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
| "O placebo `commodity_metal` está violado; é o caveat mais concreto contra a validade do instrumento" | §5 antigo, `estrutura_paper_v2.md`, `working-notes/2026-07-24_{auditoria_analise_gemini,avaliacao_5_artigos_robustez}.md`, `2026-07-27_identificacao_nao_gaussiana_gmr.md` | `diagnostics/01_exogeneidade.R` §1.6: o IC-Br do BCB é **em R$** e herda mecanicamente o câmbio (+3,98% contra +3,27%). Num painel aumentado, os três índices em R$ violam e os três **em US$ passam limpo** (metal +0,42, CI90 [−1,44; +1,88], 0/25 sig). Se fosse fator global, o índice em dólar responderia. Reclassificado para `ambiguous` (B3, 2026-07-28) — **não estender a ortogonalização por causa dele** |
| "A cadeia perversa câmbio↑/risco↑ não é dependente de estado" (negativo limpo da Tarefa 7) | primeira versão de `diagnostics/diagnostico_dfm.md` §7, sob baseline EMBI | O mesmo relatório, §7.4d-g: o EMBI é o **único** dos 7 indicadores que não vê nada. Sob CDS e sob ΔDBGG a **persistência** em h=6-8 é dependente de estado (t = 2,46 a 3,60, primeiro estágio forte). O negativo sobrevive **só para o impacto** h=0-4 (\|t_dif\| ≤ 1,14 nos 7). EMBI e CDS correlacionam 0,933 em MA12 e ainda assim discordam de regime em 24 de 141 meses |
