# Histórico de decisões — o que já foi tentado e por que morreu

Registro de **resultados negativos e decisões revertidas**. Existe para evitar
retrabalho: antes de propor um caminho, confira se ele já foi percorrido aqui.
Vários destes itens são material de rodapé ou de apêndice do paper — resultado
negativo bem documentado tem valor, e nenhum deles está descrito no código.

Criado em 2026-07-26 a partir do `pendencias.md` acumulado (2026-04 a 2026-07).
As pendências **abertas** vivem em `pendencias.md`; este arquivo é só memória.

---

## 0. Identificação não-gaussiana (GMR 2017) — ABANDONADA em 2026-08-17

**Veredito:** o estimador não tem poder neste painel — 6 células sig90 em 5.439 —
porque a agregação do DFM destrói a não-gaussianidade que a identificação exige.
A concordância de sinal com o proxy **não** é corroboração: o nulo de direções
aleatórias não a rejeita (p=0,149).

Corpo integral, com as armadilhas que custaram tempo (o `IdSS` quebrado para
n ≥ 4, o Rademacher inválido neste ramo, a subcobertura da Prop. 4):
`arquivo/nao_gaussiana/registro/historico_decisoes_secao0.md`.
Código, artefatos e notas em `arquivo/nao_gaussiana/`.

**Não reabrir sem evidência nova.**

---

## 1. Identificação por heterocedasticidade — ABANDONADA em 2026-08-17

**Veredito:** reprovada nas duas frentes. Como instrumento (`z_het*`,
Rigobon-Sack 2003), abandonada em 2026-07-16. Como identificação primária
(Rigobon 2003 nas inovações fatoriais), **zero das 252 células identificam** — a
única heterocedasticidade do painel mensal é a da COVID, e ela é fator de escala
comum, não separação de regimes.

Corpo integral: `arquivo/heterocedasticidade/registro/historico_decisoes_secao1.md`.
Código, artefatos e notas em `arquivo/heterocedasticidade/`.

**Não reabrir sem evidência nova.** A ponta solta declarada e nunca tentada —
heterocedasticidade *condicional* (GARCH-SVAR, Lanne-Saikkonen 2007 /
Normandin-Phaneuf 2004), que dispensa datas de regime — segue no arquivo.

## 2. Construção do instrumento — o que a auditoria de fidelidade mudou

**Auditoria 2026-07-14/15** (`pareceres/2026-07-15_auditoria_fidelidade_instrumento.md`
e `notas/2026-07-14_auditoria_fidelidade_jk_bs.md`). Duas infidelidades
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
| `z_jk_raw_purif_local` | re-estima a purificação só nos ~55 dias selecionados | Dominada, descartada 2026-07-14; **removida do código em 2026-08-05** |
| `z_jk_purif_us` | contemporânea + UST 2y Qua→Qui | Redundante (cor 0,999 com `z_jk_purif`); **removida do código em 2026-08-05** |
| `z_jk_raw_purif` | máscara bruta + valores purificados | Viva como robustez; foi a candidata a default em 07-14, perdeu para `z_jk_bs_purif` em 07-15 |

**Decisão revertida:** a nota de 2026-07-14 recomendava **manter `z_jk_purif`
como default**; a recomendação foi derrubada em menos de 24h pela auditoria de
fidelidade, e `z_jk_bs_purif` virou o primário em 2026-07-15.

### 2.2 Corte de 10 para 8 variantes (2026-08-05) — e as seis que **não** saíram

O pedido inicial da sessão de limpeza era manter só `z_bruto` e
`z_jk_bs_purif`. **Não foi feito**, e a razão é o achado desta mesma seção: a
frase "a força mora na máscara" é uma comparação entre as *três* variantes de
máscara predeterminada (10,55 / 10,43 / 10,39) e a família de resíduo
contemporâneo (`z_jk_purif` 5,77, `z_jk` 6,30). Cortar para duas apagaria a
evidência do §3.4 do paper. Além disso três varreduras vivas consomem o resto:
`xi_mp_robustness.R` e `instrument_construction_sweep.R` rodam 5 variantes
(tiers A2/A3), `mosw_strength_grid.R` roda todas (A4), e `irf_spec_sweep.R`
roda 8 — e a pendência D1 (comparação cross-instrumento do IPCA) cita
"320 células, 8 instrumentos".

**Saíram exatamente as duas já declaradas mortas na tabela acima** — e são
precisamente as duas que `irf_spec_sweep.R` já excluía, de modo que o conjunto
sobrevivente é o que aquela varredura sempre usou. Verificado por reexecução:
as 8 colunas sobreviventes de `instrumentos_mensais.csv` saíram
**bit-idênticas**, `instrument.csv` inalterado, e as 28 linhas de
`z_jk_bs_purif` em `mosw_strength_grid.csv` idênticas (as 8 células de
`tab:rq_sweep` reproduzem 5,4455 / 6,3562 / 10,4308 / 12,5662 no full e
7,9446 / 11,0002 / 12,2234 / 8,9862 na pré-COVID).

⚠ **A maquinaria diária do ramo `_us` ficou.** `e_di_us`, `e_ibov_us` e
`jk_monetary_us` continuam em `build_variants.R` e no
`copom_event_diagnostics.csv` porque `script/jk_sovereign_confound.R`
(tier S1, `DAY_SETS`) usa o conjunto de dias `jk_us` como uma de suas sete
máscaras de diagnóstico. Só a coluna **mensal** foi removida. Já `e_di_local`/`lm_di_local`
não tinham consumidor nenhum depois do corte e saíram — é a única coluna que
`copom_event_diagnostics.csv` perdeu.

**Descoberta lateral, registrada para não ser reinvestigada:** reexecutar
`mosw_strength_grid.R` **sem nenhuma alteração** não reproduz o CSV commitado
bit a bit — há deriva de ~6e-11 relativa (produção (7,6) full: 10,430830000 no
disco contra 10,430830653 ao reexecutar). O script é determinístico
(duas execuções seguidas dão arquivos idênticos), então a deriva é entre o
artefato commitado e o ambiente numérico atual (BLAS/versão), não entre versões
do código. Imaterial em qualquer dígito reportado, mas quem for comparar
artefatos precisa saber que a régua é "reexecutar antes e depois", não
"comparar contra o disco".

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
- **Por que morreu:** a partição custa metade da amostra e não compra conclusão
  nenhuma. Nenhum sinal de IRF inverte, e ξ_mp desaba nas duas metades por razão
  essencialmente mecânica, já que os meses não-nulos caem pela metade.
- **As três regras de classificação (FX, EMBI, CDS) discordam entre si** numa
  fração grande dos 62 dias, e a metade "política" de **todas** as três fica
  **abaixo de 3,84**, o limiar em que o conjunto AR deixa de ser limitado. A
  assimetria não é de uma regra, é da própria partição: toda metade "política" é
  pequena demais para ter primeiro estágio, de modo que promover qualquer uma
  delas tem impedimento aritmético e não só de tamanho de amostra.
- **Armadilha conceitual a não repetir:** condicionar a máscara num movimento
  cambial **contemporâneo** é exatamente o tipo de seleção same-window que a
  camada Bauer-Swanson existe para evitar. Purificar o câmbio na RHS pré-evento
  mitiga, **não elimina** — a classe é escolhida com informação da janela do
  evento, ao contrário da máscara JK-BS, que é predeterminada.
- **O que sobrevive do exercício** é o diagnóstico, não o instrumento: a máscara
  de produção foi **absolvida** da acusação de selecionar risco soberano, porque
  os dias retidos carregam *menos* risco por unidade de surpresa que uma quinta
  comum (EMBI 0,099 contra 0,326; CDS 0,140 contra 0,436; interações negativas
  nas cinco proxies). ⚠ **Absolvida não é "sem risco":** no CDS o coeficiente dos
  62 dias é **significativo** (p_boot 0,003), o que o EMBI não conseguia medir
  por arredondamento. Ver `registro/metodo.md`, status de 2026-07-31, e
  as notas `2026-07-31_confound_soberano_jk.md` +
  `2026-08-09_confound_soberano_cds.md`.
- **Também não repetir:** tentar corrigir o alinhamento dos arquivos de risco.
  Os dois são **do mesmo dia** (ΔEMBI com S&P/Ibov em t = −0,498 / −0,508 contra
  −0,045 / −0,088 em t−1; ΔCDS −0,541 / −0,580 contra −0,040 / −0,089). A janela
  Qui→Sex é resposta defasada, não
  desalinhamento.

### 2.4 As duas baterias de confound foram enxugadas — 2026-08-10

Três testes saíram do código no mesmo dia, e os números que os mataram estão
todos acima ou na entrada do FOMC em `pendencias.md`. **O corte foi verificado
como não-perturbativo**: rodando os dois scripts antes e depois, toda linha que
sobreviveu bate com `max |dif| = 0`, `p_boot` inclusive, porque
`wild_coef_test()` semeia cada célula pela própria identidade (`key =`). O
veredito do FOMC também não mudou.

- **Teste B (três vias) e Teste D (tabela datada) saíram de
  `script/jk_sovereign_confound.R`.** B pela aritmética do parágrafo anterior, a
  metade "política" de todas as três regras ficando abaixo de 3,84. D porque seu
  único consumidor era a ressalva de concentração de `paper_anpec.tex`, retirada
  do paper na mesma data por decisão do autor;
  `output/instrument/jk_sovereign_days.csv` foi apagado do repositório.
- **Teste 4 (divisão FOMC / sem-FOMC) saiu de `script/fomc_coincidence.R`,** e
  com ele a terceira perna da regra de veredito pré-registrada. **A perna havia
  passado** na rodada de 2026-08-10, sem acionar a cláusula de poder, enquanto a
  metade *com* FOMC saía com conjunto AR ilimitado e portanto incitável em
  qualquer direção. Retirar uma perna satisfeita torna a regra estritamente mais
  permissiva, de modo que o veredito não pode ter mudado por causa do corte.
- **Os números dos três testes não são reproduzíveis e não devem ser citados.**
  As seções correspondentes das notas de 07-31, 08-09 e 08-10 foram removidas
  junto, e o registro fica no histórico do git, que é onde ele pertence.
- **O que entrou no lugar, e por que não é adição gratuita:** com B fora, o
  Teste C passa a carregar a subseção sozinho, e a objeção viva contra ele era
  justamente que ele limpava os **valores** da surpresa sem tocar na **seleção**
  dos 62 dias (council de 2026-08-10, `pendencias.md`). A perna de ações passou
  a ser ortogonalizada na mesma RHS de risco e a regra de sinal do JK
  re-derivada nos resíduos duplos, gerando `z_jk_bs_norisk_mask`. **O resultado
  é assimétrico e tem de ser lido assim:** ortogonalizar os valores *aumenta*
  ξ_mp (10,43 → 10,72 → 12,68), re-derivar a máscara *derruba* para **5,57** na
  amostra cheia, porque o bloco de risco explica 15,4% de `e_di_bs` mas **40,4%**
  de `e_ibov_bs`. O conjunto AR continua limitado e todo sinal de manchete se
  preserva, então a variante sustenta direção, não intervalo. Na janela
  pré-COVID a ordem se inverte (10,94 contra 12,22 da produção).
  ⚠ **Os quatro ξ_mp deste parágrafo são da vintage de 106 séries** e ficam aqui
  só como registro da decisão. Sob a produção de 111 séries `(5,5)` a cadeia é
  6,27 → 6,62 → 7,58 nos valores e **4,26** na máscara re-derivada, com as mesmas
  frações de 15,4% e 40,4%. Fonte corrente:
  `output/instrument/jk_sovereign_confound.md`.

---

## 3. Migrações de (r, q) — e a leitura que não vale mais

| data | spec | motivo |
|---|---|---|
| até 2026-07-11 | auto-IC (5,4) / legado r=7,q=7-8 | Bai-Ng / Amengual-Watson BLL |
| 2026-07-11 | **(6,5)** | Varredura de 320 células; auto-IC (5,4) borderline-weak |
| 2026-07-24 | **(7,6)** | Refresh de vintage; única das 4 dimensões da varredura com ξ_mp > 10 nas **duas** janelas |
| 2026-08-13 | recomendação intermediária `(4,3)`, painel 123 | Regra conjunta sobre 64 painéis; superada no mesmo dia pela migração deliberada seguinte |
| 2026-08-13 | **produção `(5,5)`, painel 111** | Bai--Ng IC2 fixa `r=5`; removidos setor externo, EUA, crédito, imóveis e as duas quase-duplicatas; `q=5` provisório |

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
`notas/2026-07-31_acoes_representacao.md`. **Não reabrir sem
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

### 3.2 O painel de 106 séries deixou de ser o universo decisório (2026-08-13)

A recomendação dimensional `(5,4)` obtida isoladamente no painel canônico foi
**superada**, não refutada numericamente. O problema era o universo: aquele
painel ainda continha `juros_cdi` e `asset_mlcx`, duas quase-duplicatas já
diagnosticadas, e não permitia decidir conjuntamente a presença dos seis
blocos candidatos.

A auditoria em `diagnostics/rq_block_dimension_audit/` partiu das 123 séries da
união sem as duplicatas, percorreu as 64 combinações de blocos e estimou os 36
pares `r=1,...,8`, `q=1,...,r` na amostra completa. Em cada painel, eliminou
células não finitas, instáveis ou com `xi_mp<=3,84` e ordenou as demais por
distância ao mínimo BLL/AW full, raiz, sinais e parcimônia. A pré-COVID só
reestimou a escolha full.

Nenhum bloco chegou perto da regra de remoção de 24 vitórias em 32 contrastes:
fiscal 3, setor externo 0, expectativas 2, EUA 8, crédito 2 e imóveis 5. A
decisão é, portanto, **manter os seis blocos**, remover apenas as duas
quase-duplicatas e usar `(4,3)`. No painel de 123 séries, a célula tem
`xi_mp/F_rob,mp=5,05/8,42` e raiz 0,9626; pré-COVID dá 10,78/13,13 e raiz
0,9927. Quatro finalistas de bootstrap completaram 800 réplicas, semente 123,
sem falhas nem bandas de 90% no sentido contrário nas janelas hard.

**Estado da decisão:** esta recomendação foi superada no mesmo dia. A produção
foi migrada para 111 séries em `(5,5)`, preservando a grade de 123 séries como
proveniência histórica. O paper permaneceu intocado nesta rodada.

### 3.3 Produção de 111 séries em `(5,5)` (2026-08-13)

A decisão corrente usa o painel
`drop_setor_externo__eua__credito__imoveis`: remove `juros_cdi`, `asset_mlcx`
e os blocos candidatos setor externo, EUA, crédito e imóveis; mantém fiscal e
expectativas. `r=5` vem do Bai--Ng IC2 BLL. `q=5` é provisório e permanece
aberto em `pendencias.md`.

O gate de 800 réplicas terminou sem falhas, com normalização exata em +50 pb.
Na amostra completa, `xi_mp/F_rob,mp=6,27085/10,12054` e a raiz máxima é
0,9648577. Na pré-COVID, os valores são 10,99268/9,74746 e a raiz 1,0002017,
logo a janela é marginalmente instável. A nota de decisão e proveniência é
`notas/2026-08-13_migracao_producao_painel_111_r5q5.md`.

---

## 4. Itens de código fechados

Resolvidos e verificados; ficam aqui só para não serem reabertos.

- **`script/yield_curve.R` apagado** (2026-07-26). Ajuste Svensson próprio sobre
  os contratos DI, escrito para gerar a curva a vértices fixos. **Não dava bom
  resultado** e foi abandonado pelo autor; a curva que o painel usa sempre foi
  `data/raw/yields/yields_dia.csv`, **insumo externo fixo fornecido pelo
  orientador**, lido direto pelo `script/download.R`. A saída do script
  (`data/raw/curva_juros/`) nunca foi consumida por estágio nenhum. Recuperável no
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
  rejeita em nenhum bloco (poder limitado com n_C ≈ 50). Pertence à rota het,
  abandonada em 2026-08-17 — ver `arquivo/heterocedasticidade/`.
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

> **Nota de leitura (2026-08-17).** Esta subseção é uma medição datada e seus
> ponteiros de código valem para a árvore de 2026-07-31. Leia
> `impulse_responde.R` como `R/modeling/impulse_response.R`
> ([`mapa_renomeacoes.md`](mapa_renomeacoes.md)) e **não confie nos números de
> linha**: o refactor de 2026-08-17 moveu `main_sdfm` para
> `R/modeling/dfm_pipeline.R`, e a correção do teste de singularidade de
> `kilian_correction` (mesma data) acrescentou `solve_or_pseudo()` acima dela em
> `factor_estimation.R`. O achado — os `Re()` são no-ops e o Kilian não entra no
> ponto — não depende de nenhuma dessas linhas.

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

Fonte: `notas/2026-07-31_estacionariedade_fatores.md`, seção
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
  escopo; o núcleo frequentista de robustez ficaria **ACF (2024) +
  não-gaussianidade (LMS/GMR)**. A perna não-gaussiana caiu em 2026-08-17 (§0).
- **2026-07-24** — GMMO (2018) fora do escopo (não faz proxy + sinais);
  Braun-Brüggemann e Caldara-Herbst são bayesianos e ficam como apêndice
  opcional; Antolín-Díaz-Rubio-Ramírez é Tier 3 (maior esforço, paradigma mais
  distante). Detalhe em
  `notas/2026-07-24_avaliacao_5_artigos_robustez.md`.
- **2026-08-14 — cinco decisões na migração da §3, da §5 e do apêndice**, todas
  do autor, todas com o efeito de **encolher** o que o paper afirma.
  1. **A `tab:rq_sweep` sai do paper.** Como `r` é decidido pelo Bai--Ng IC2
     BLL, a grade de força deixa de ser justificativa de dimensão, e mantê-la
     convidaria a leitura de que a especificação foi escolhida pelo maior ξ_mp.
     Saíram junto as três remissões e a nota que definia ξ_mp e F_rob,mp, hoje
     no corpo da §3.6. **Consequência não intencional:** o paper ficou sem
     nenhuma tabela de força, o que eleva a prioridade da `tab:first_stage`.
  2. **Anderson-Rubin sai do `.tex` por completo**, inclusive a menção genérica
     da §3.7 a intervalos AR como alternativa sob IV fraco. A régua de 3,84 não
     entrou no lugar.
  3. **A §5 fica só com as três subseções existentes.** Heterocedasticidade,
     GMR, construção do instrumento e Limitações não entram enquanto o
     enquadramento do GMR (Tema C) estiver aberto e a ressalva de §4 não
     existir. *(As duas primeiras deixaram de ser questão em 2026-08-17: as
     rotas foram abandonadas — §0 e §1.)*
  4. **A atribuição da curva a Svensson permanece** em §3.2 e na coluna Fonte do
     apêndice, embora não exista estágio de ajuste neste repositório. É
     afirmação sobre a proveniência do insumo do orientador, não sobre o
     pipeline.
  5. **Os oito EPU não entram na §5.1** e a máscara re-derivada não entra na
     §5.2. A segunda cria assimetria com a §5.3, que já a reportava, e virou
     item aberto em `pendencias.md`.

---

## 6. Afirmações antigas que foram contraditadas

Cuidado ao reusar texto destas fontes — os documentos ainda circulam.

| afirmação | onde aparece | o que a contradiz |
|---|---|---|
| "Sempre que F ≥ 10 os sinais hard saem coerentes, em qualquer combinação" | `notas/2026-07-11_varredura_irf.md`; propagada em `estrutura_paper_v2.md` §5.6 | `notas/2026-07-15_sweep_instrumentos_irf.md`: 0 de 36 células limpas e `cor(curve_slope, ξ_mp) = −0,04` — relevância ≠ validade |
| "pre-COVID (6,5) é o pico do grid; r ≥ 7 colapsa pre_covid" | notas de 07-11 a 07-15, `estrutura_paper_v2.md` §3.5 | Grade MOSW de 2026-07-24 (§3 acima) |
| "A corcova do IPCA nunca é significativa a 90%" | `notas/2026-07-12_price_puzzle_ipca.md`, §5 antigo | Rodada (7,6): headline sig90 em h5; ex0 sig90 em h2 e h4-8; DW sig90 em h4-5 e h7 |
| "Os 8 índices caem com significância (CI90 em 6 de 8)" | §5 antigo (2026-07-12) | Rodada (7,6): nenhum índice atinge CI90 no impacto |
| "Crédito total se expande com significância em h0-h6" | §5 antigo, `notas/2026-07-12_irf_credito_ativos_financeiros.md` | Rodada (7,6): agregado e PF contraem monotonicamente; a expansão inicial é só setorial (transporte, agro, indústria) |
| "O proxy foi abandonado; escolher nova identificação primária" | `notas/2026-07-24_auditoria_analise_gemini.md` (09h24) | Nota das 23h46 do mesmo dia + produção: o proxy-SVAR segue primário sob (7,6) |
| "O placebo `commodity_metal` está violado; é o caveat mais concreto contra a validade do instrumento" | §5 antigo, `estrutura_paper_v2.md`, `notas/2026-07-24_{auditoria_analise_gemini,avaliacao_5_artigos_robustez}.md`, `2026-07-27_identificacao_nao_gaussiana_gmr.md` | `diagnostics/01_exogeneidade.R` §1.6: o IC-Br do BCB é **em R$** e herda mecanicamente o câmbio (+3,98% contra +3,27%). Num painel aumentado, os três índices em R$ violam e os três **em US$ passam limpo** (metal +0,42, CI90 [−1,44; +1,88], 0/25 sig). Se fosse fator global, o índice em dólar responderia. Reclassificado para `ambiguous` (B3, 2026-07-28) — **não estender a ortogonalização por causa dele** |
| "A cadeia perversa câmbio↑/risco↑ não é dependente de estado" (negativo limpo da Tarefa 7) | primeira versão de `diagnostics/diagnostico_dfm.md` §7, sob baseline EMBI | O mesmo relatório, §7.4d-g: o EMBI é o **único** dos 7 indicadores que não vê nada. Sob CDS e sob ΔDBGG a **persistência** em h=6-8 é dependente de estado (t = 2,46 a 3,60, primeiro estágio forte). O negativo sobrevive **só para o impacto** h=0-4 (\|t_dif\| ≤ 1,14 nos 7). EMBI e CDS correlacionam 0,933 em MA12 e ainda assim discordam de regime em 24 de 141 meses |

---

## 7. Inferência Anderson-Rubin no DFM — implementação retirada

**Decisão de 2026-08-12.** A adaptação Anderson-Rubin introduzida em
`cd9f6b1` foi retirada do caminho vivo. Ela reproduzia o código oficial de
Montiel Olea, Stock e Watson no VAR em observáveis, mas essa fidelidade não
validava a cobertura das respostas observáveis do DFM depois de estimar fatores,
loadings, escalas e o espaço dinâmico. A covariância plug-in condicionava nesses
objetos gerados, e não foi localizada fundamentação teórica que tornasse essa
omissão válida sob proxy localmente fraca. A auditoria externa preservada em
`pareceres/2026-08-12_auditoria_anderson_rubin_dfm.md` documenta essa lacuna e
permanece **não operacional**.

Há também um defeito lógico independente: a rotina de inversão tratava casos
lineares, constantes, discriminante zero e quase-degenerações como toda a reta
ou como intervalos numericamente instáveis. O defeito não movia as células
regulares publicadas na rodada de 2026-08-10, mas invalidava a API como
implementação geral e impedia aceitar o módulo sem correção e validação novas.

Foram removidos `R/identification/weak_iv_ar.R`, `script/ar_bands.R`,
`script/validate_mosw_ar.R` e os quatro artefatos `output/irf/ar_bands*`. O
fixture `output/validation/olea_oil_fixture.rds`, a estatística MOSW
`compute_factor_space_wald()`, as validações de força/HAC e todo o pipeline de
produção foram preservados. O paper voltou a usar apenas as bandas de 68% e 90%
do wild bootstrap como inferência operacional; Anderson-Rubin permanece apenas
como alternativa genérica futura.

**Condição para reabrir:** uma derivação que incorpore a estimação fatorial ou
um procedimento de reamostragem/duas etapas que a reproduza e demonstre
cobertura sob instrumentos fracos, acompanhado de um solucionador completo e
tolerante à escala para todos os casos degenerados. A tarefa está adiada sem
prazo e sem prioridade ativa.
