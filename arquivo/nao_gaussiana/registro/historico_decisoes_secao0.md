# Identificação não-gaussiana (GMR 2017) — corpo integral

> **Rota abandonada em 2026-08-17.** Este arquivo é a §0 de
> `registro/historico_decisoes.md` na íntegra, movida para cá quando a
> estratégia foi abandonada. Código em `../R/` e `../script/`, artefatos em
> `../output/nongaussian/`, notas em `../notas/`.

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
`notas/2026-08-01_robustez_identificacao.md`.

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
