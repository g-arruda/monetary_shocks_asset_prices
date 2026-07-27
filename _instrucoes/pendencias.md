# Pendências

**Última revisão:** 2026-07-26. Só o que está **aberto**. O que foi tentado,
fechado ou revertido está em [`historico_decisoes.md`](historico_decisoes.md) —
consulte antes de propor um caminho novo.

---

## Especificação corrente

| item | valor |
|---|---|
| Identificação | proxy-SVAR (instrumento externo), `H = (Z'η)/(Z'Z)` |
| Instrumento | **`z_jk_bs_purif`** — surpresa DI Qua→Qui no vértice 126 du + ortogonalização Bauer-Swanson **pré-evento** + máscara JK em resíduos predeterminados |
| Variável de política | `yield_6m`, choque +50bp no impacto (+0,005 em proporção decimal) |
| Dimensão | **r = 7, q = 6**, VAR(p = 6) nos fatores |
| Painel | 106 séries, 2013-01 a 2025-09 (147 meses alinhados) |
| Inferência | wild bootstrap Gonçalves-Kilian, Kilian (1998) só no DGP do bootstrap; nboot = 800, seed 123, bandas 68/90, h = 0-48 |
| Força | ξ_mp = **10,43** full / **12,22** pre-COVID; conjunto AR limitado nas duas |

## Rota metodológica decidida (2026-07-24)

Manter o **primário frequentista** e blindar o proxy no limiar com duas camadas,
sem virar bayesiano. Fonte:
`relatorio/working-notes/2026-07-24_avaliacao_5_artigos_robustez.md`.

1. **Corroboração independente do instrumento** — identificação por
   **não-gaussianidade**: Lanne-Meitz-Saikkonen (2017, *JoE*, ML paramétrico) e
   Gouriéroux-Monfort-Renne (2017, *JoE*, pseudo-ML/ICA, imune ao chute de
   densidade). Identificam sem usar o proxy, que passa a **rotular** a coluna
   monetária — e a restrição do proxy vira **testável** (Wald/LR). Rota mais
   barata e a única que preserva o paradigma. Código em R para as duas:

   - **GMR (2017) literal** — ~~pacote `IdSS`~~ **traduzido para o repo em
     2026-07-27**: `R/identification/nongaussian_gmr.R`. O pacote do Renne
     (`remotes::install_github("jrenne/IdSS")`, commit `20c8ea6`) tem o caminho
     ICA **quebrado para n ≥ 4** — `make.M`, `make.C` e o gradiente, os três —
     e este projeto roda em q = 6. Ver `historico_decisoes.md` §0.1. O pacote
     segue instalado e é usado **só** como alvo de validação cruzada em
     `script/validate_gmr_ica.R` (`make.Omega`, `make.A.matrix`,
     `make.Asympt.Cov.delta` estão corretas em qualquer n, e o dataset
     `US3var` é o da aplicação publicada). Livro dos autores:
     <https://jrenne.github.io/IdentifStructShocks/NonGaussian.html>.
   - **LMS (2017)** — `svars::id.ngml` (ML paramétrico, Lange et al., *JSS* 2021).
   - **Atenção à atribuição:** `svars::id.dc` e `id.cvm` são **Matteson-Tsay
     (2017)** e **Herwartz-Plödt**, ICA baseada em dependência — do mesmo
     espírito semiparamétrico do GMR, mas **não** o PML do artigo. Citá-los como
     "GMR" seria erro de citação no paper; para GMR, use `IdSS`.
2. **Robustez a IV fraco dentro do paradigma** — Angelini-Cavaliere-Fanelli
   (2024, *JoE*): pré-teste de força por bootstrap robusto a heterocedasticidade
   condicional e a proxies *zero-censored* (é o caso da máscara JK), sem viés de
   pré-teste; conjuntos de confiança robustos por inversão de teste. **Sem
   replication package público** — codificar do zero.

Bayesiano (Braun-Brüggemann, Caldara-Herbst) fica como apêndice **opcional**.
Nenhum dos métodos é escrito para modelo de fatores: todos exigem a mesma
adaptação "identificar nas q inovações e propagar via Λ" que os ramos existentes
de `compute_irf_dfm` já implementam.

---

## Aberto — bloqueante para o paper

- [x] **Gate de não-gaussianidade em η** (2026-07-27). `script/nongaussian_gate.R`
  → `output/nongaussian/gate.md`. Resultado: **3 de 6** componentes não rejeitam
  normalidade no full, **5 de 6** pré-COVID. A rota existe só no full sample e a
  identificação é **parcial**. Correção: o gate **não** pode reusar
  `output/irf/irf_coherence_cell.rds` — aquele arquivo guarda só
  `irf`/`var_names`/`tcode`/`mpind`/..., não o objeto DFM; o script re-estima
  (barato, sem bootstrap). Detalhes em `historico_decisoes.md` §0.2.
- [x] **Ramo `identification = "nongaussian"`** (2026-07-27), branch
  `identificacao-nao-gaussiana`. GMR (2017) PML-ICA **traduzido para o repo** em
  `R/identification/nongaussian_gmr.R` + adaptador em `nongaussian_branch.R`;
  cinco costuras em `compute_irf_dfm` (switch de 3 vias, parsing do instrumento
  para rotulagem, despacho do ponto, esquema de reamostragem por ramo, bloco
  `ng_point`/`ng_boot`). **Não** se usa `IdSS::estim.SVAR.ICA`: o pacote está
  quebrado para n ≥ 4 e q = 6 cai em cheio — ver `historico_decisoes.md` §0.1.
  Validação em `script/validate_gmr_ica.R` reproduz a aplicação publicada do
  artigo (§3.2). Smoke test do proxy inalterado.
- [ ] **Converter o §5 para o tex.** `output/irf/irf_section.md` foi reescrito
  em 2026-07-26 sob (7,6); falta levar para `tex/main.tex`, onde a seção de
  resultados hoje **não existe** (a `\section{Resultados}` da era Cholesky foi
  removida). O §3 já está migrado — ver a subseção abaixo.
- [ ] **Abstract, Introdução e Conclusão** — rewrite completo. Os sinais e
  magnitudes são da era Cholesky e a Conclusão promete "instrumento de alta
  frequência como pesquisa futura", que hoje é o coração do paper. Roteiro:
  §5.7 do `irf_section.md`.
- [ ] **Revisão de literatura** — falta o eixo de identificação: Stock-Watson
  (2018), Gertler-Karadi (2015), Jarociński-Karadi (2020), Bauer-Swanson (2023),
  Mertens-Ravn (2013), Montiel Olea-Stock-Watson (2021), GRG (2025),
  Bonomo-Martins (2016) para crédito direcionado, Blanchard (2004) para
  dominância fiscal.

### Estado do `main.tex` (§3 já migrado)

Auditado contra a working tree em 2026-07-26. As quatro correções herdadas do
antigo `_instrucoes/prompt.md` (arquivado na mesma data) **já estão aplicadas** —
o `prompt.md` descrevia o tex do `HEAD`, não o do disco:

- [x] **§3.4** — a frase sobre preditores predeterminados foi expandida e agora
  explicita que é a variante fiel às duas metodologias de origem (BS predeterminado
  + regra de sinal JK com agregação por soma).
- [x] **§3.5** — a frase "(6,5) é o único acima de 10 na janela pré-COVID, com
  12,49" **foi removida**. O texto atual traz $(7,6)$ com **10,43 full / 12,22
  pré-COVID** e a tabela `tab:rq_sweep` foi reescrita com as três estatísticas
  MOSW (ξ_mp, Wald conjunta, forma-F) × duas janelas.
- [x] **§3.5** — a frase sobre a correção de Kilian está **correta**, pode ficar.
  Verificado no código em 2026-07-26: `factor_estimation.R:759` estima o ponto
  sempre por VAR OLS puro (fiel a `DFMest_BLL.m`) e só calcula os coeficientes
  corrigidos quando `apply_kilian = TRUE`, usados apenas no DGP do bootstrap
  (`impulse_responde.R:436`); cada réplica do bootstrap re-estima com
  `apply_kilian = FALSE`.
- [x] **§3.6** — o segundo parágrafo e a frase sobre reproduzir os números
  publicados de Olea et al. (2021) para o choque de petróleo de Kilian foram
  comentados. (A validação continua no repositório em
  `script/validate_olea_kilian.R`; só não vai ao corpo do texto.)

O que **continua aberto** no tex, além do §5:

- [ ] **§3.2** diz "cerca de 110 séries"; o painel tem **106** desde o refresh de
  vintage de 2026-07-24. Trocar pelo número exato.
- [ ] **Resumo, introdução, revisão de literatura e conclusão** seguem da era
  Cholesky — ver o item de rewrite acima.

## Aberto — decisão sobre a rota não-gaussiana (2026-07-27)

O ramo GMR está implementado e validado, e produziu um resultado que **não** é
o que a rota foi buscar. Registro completo em
`relatorio/working-notes/2026-07-27_identificacao_nao_gaussiana_gmr.md`.

- [ ] **Decidir o enquadramento do GMR no paper.** O autor optou por
  "identificação de manchete" em 2026-07-27, antes de os números existirem. O
  que eles dizem: **o estimador não tem poder neste painel.** As bandas de 90%
  no impacto **contêm zero em todas as variáveis** exceto a normalizada —
  `asset_ibov` é −10,7 com CI90 **[−49,5, +80,8]**, contra −1,67 com
  [−7,6, +1,8] do proxy. O bootstrap (200 draws i.i.d.) dá cosseno mediano 0,703
  entre a direção do draw e a do ponto, com 49% dos draws abaixo de 0,7. A
  rejeição assintótica da restrição do proxy (ξ = 117,3, p < 0,0001) é
  **provavelmente espúria**: a simulação mostra a Prop. 4 cobrindo 0,79 contra
  0,95 nominal em T = 150, n = 6. Não há contradição entre as duas
  identificações a resolver — há um estimador que não determina nada.
  **Recomendação:** usar o GMR como **teste** (ele rejeita o esquema recursivo,
  que é o que o artigo original faz) e não como estimativa concorrente.
  Argumentado na working-note.
- [ ] **Inspecionar a IRF da segunda coluna mais correlacionada com `z`.** A
  rotulagem escolhe por |cor| = 0,20 contra 0,17 — folga pequena demais para
  sustentar sozinha o nome "monetária". Barato: o objeto está em
  `output/nongaussian/gmr_cell.rds`.
- [ ] **LMS (2017) como terceira leitura** — `svars::id.ngml`, ML paramétrico
  sobre a mesma premissa de não-gaussianidade. Se LMS concordar com GMR, a
  discordância é do proxy; se ficar no meio, é do método. É o desempate mais
  barato disponível.

## Aberto — robustez e conteúdo

- [ ] **Placebo `commodity_metal` violado** — responde +10,4% no impacto com
  CI90 até h4 a um choque monetário brasileiro. A hipótese original era que o
  instrumento retém um componente global de commodity/risco (metais **não**
  estão entre os preditores pré-evento da ortogonalização BS; Brent está).
  **Revisar essa atribuição (2026-07-27):** a identificação não-gaussiana, que
  **não usa o instrumento**, viola o mesmo placebo com magnitude parecida
  (+12,0). Se a violação sobrevive sem `z`, a fonte mais provável é o **espaço
  de fatores / o painel**, não a construção do instrumento — e a
  ortogonalização estendida com um fator de metais não resolveria. Testar:
  quanto do `commodity_metal` é comunalidade contra idiossincrático em (7,6).
- [ ] **Comparação cross-instrumento do IPCA sob (7,6)** — *destravado em
  2026-07-26; falta só a análise.* O argumento "a corcova é universal entre
  instrumentos e some pre-COVID" fecha o diagnóstico do price puzzle, mas foi
  construído no vintage e instrumento antigos e não reproduzia. A fonte
  (`output/irf/spec_sweep_irf_long.csv`) **já foi regenerada** junto com a
  migração da taxonomia — 320 células, 8 instrumentos, (7,6) e as duas janelas
  inclusos. Falta rodar a comparação e escrever o resultado; sem ele o §5.5 não
  pode afirmar que a corcova é amostral. Contexto novo do
  `irf_coherence_leitura.md`: a corcova vive em **h2-h8** e é o pedaço
  significativo (`price_ipca` sig90 em h5; `ex0` em h2 e h4-h8; `dw` em h4/h5/h7),
  **fora** da janela escorada h12-h48 — então o veredito `incoerente` do
  `price_core_ipca_ex0` é outra coisa (ele nunca volta a negativo no médio
  prazo), e a comparação tem que olhar h2-h8, não a janela da régua.
- [ ] **Benchmark GRG (2025) sem a célula het** — a reconciliação do sinal do
  câmbio usava `z_het_3var` × pre-COVID, que saiu do paper. Decidir como
  discutir o desacordo (frequência diária × mensal GE, janela amostral, regime
  de dominância fiscal 2020-25). Ver §5.3 do `irf_section.md`.
- [ ] **Bandas Anderson-Rubin** — agora **opcionais**. Com ξ_mp > 10 nas duas
  janelas em (7,6) as bandas convencionais bastam; manter AR como robustez
  (protocolo anti-screening de MOSW, footnote 6: reportar ξ, não filtrar pelo F).
- [ ] **LP-IV como robustez à especificação dinâmica** — *desejável, não
  bloqueante; o autor quer tentar se houver tempo (2026-07-26).* Local
  Projections com o mesmo instrumento: `IdSS::make.LPIV.irf` (uma regressão IV
  por horizonte, controles opcionais de defasagens de `Y` e `Z`, erro-padrão HAC
  via `tsls` com Newey-West em `h + 1`). O pacote já entra no projeto pela rota
  não-gaussiana, então o custo marginal é baixo.
  - **Por que vale:** é um **estimador diferente da mesma identificação**. Não
    inverte o polinômio autorregressivo nem propaga por potências da companion,
    logo **nada nele depende de `p = 6`** nem da forma funcional do VAR. E roda
    nativamente em observáveis, dispensando a adaptação ao espaço de fatores que
    todos os outros métodos do roadmap exigem. Rodar em `yield_6m`,
    `asset_ibov`, `cambio_usd` e nas demais manchetes do §5 contra
    `z_jk_bs_purif`, comparando com `output/irf/irf_coherence_h.csv`.
  - **Cuidado na leitura:** LP-IV em observáveis crus **descarta o DFM**, então
    uma divergência pode ser a especificação dinâmica *ou* a perda da estrutura
    de fatores (variável omitida / notícia). Para isolar a primeira, incluir os
    fatores estimados como controles. E a precisão de LP degrada nos horizontes
    longos — com T = 147 a comparação em h próximo de 48 é frágil.
  - **Detalhe de implementação:** `make.LPIV.irf` normaliza para efeito unitário
    na **primeira coluna de `Y`** — ordenar `yield_6m` primeiro.
  - **Ressalva:** continua dependendo de `z_jk_bs_purif` ser relevante e exógeno.
    **Não** responde ao ξ_mp no limiar nem ao placebo `commodity_metal` — só a
    rota não-gaussiana faz isso, porque só ela identifica sem `z`.
- [ ] **Spread de concessões novas** como complemento ao ICC — deve abrir já no
  curto prazo, ao contrário do ICC (taxa da carteira, reprecifica devagar).
  Desejável, não bloqueante.
- [ ] **Decidir a subseção het comentada no `main.tex`** — remover ou manter
  como nota de resultado negativo.

## Aberto — código e higiene

- [ ] **Seleção da etapa 2 é dominada pela janela pre-COVID** (aberto em
  2026-07-26). Com a taxonomia migrada, 23 células ficam `ok` em `yield_6m` e
  **todas empatam** em `score_hard_frac = 1` e `score_ext = 3`, então o
  desempate é só ξ_mp — que é sistematicamente maior pre-COVID. Resultado: o
  top-5 é inteiramente `pre_covid`, e o baseline de produção (full, 7, 6) entra
  pelo force-append. A comparação da etapa 2 acaba confundindo escolha de
  instrumento com escolha de janela. Considerar um teto por amostra análogo ao
  `MAX_PER_INSTRUMENT`, ou desempatar por `f_reduced`.
- [ ] **`R/modeling/svensson_model.R` ficou sem consumidor** (aberto em
  2026-07-26). Era o motor do `script/yield_curve.R`, apagado na mesma data — a
  curva do painel é o insumo fixo do orientador (`data/yields/yields_dia.csv`).
  O `source()` no `download.R` era chamada morta e foi removido; nenhuma das 7
  funções do módulo é chamada em lugar nenhum. São ~600 linhas de código de
  modelagem reutilizável, então **não apaguei**. Decidir: apagar, mover para
  `arquivo/` (convenção do repo para código não executado e não citado pelo
  paper), ou manter como utilitário. Ver `historico_decisoes.md` §4.
- [x] **Taxonomia do `irf_spec_sweep.R` migrada para ξ_mp** (2026-07-26).
  `classify_sweep_cells` agora classifica por `wald_mp` com os limiares MOSW
  (`weak_xi_mp_severe` < 3,84 — conjunto AR ilimitado; `weak_xi_mp` < 10), e as
  ordenações da etapa 1 e da etapa 2 desempatam por ξ_mp. `f_factor` continua
  reportado por célula e ganhou tabela própria sob o rótulo "régua legada", mas
  não decide mais. Artefatos regerados: 320 células, 8 instrumentos, coluna
  `wald_mp` conferida contra `mosw_strength_grid.csv`. O instrumento de produção
  agora é `ok` em (7,6) full — o force-append da etapa 2 virou rede de
  segurança (ver o item de seleção acima).
- [x] **Prosa do coherence separada do corpo gerado** (2026-07-26). A leitura
  interpretativa vive em `output/irf/irf_coherence_leitura.md`, escrita à mão e
  não tocada por script; `irf_coherence_report.md` continua sendo o corpo
  gerado, agora com aviso e ponteiro no cabeçalho. A leitura foi **reescrita sob
  (7,6)** a partir do `irf_coherence_h.csv` corrente — a versão perdida no
  `fc0ef58` era de 2026-07-12 sob `z_jk_purif` × (6,5) e não foi restaurada.
- [x] **`irf_mp_raw` renomeado para `irf_mp_pre_tcode`** (2026-07-26) em
  `ident_ext_instr` (`R/modeling/impulse_responde.R`). Não havia consumidor do
  campo em lugar nenhum; o docblock agora explicita que é pós-normalização e
  pré-tcode. Zero mudança de output (smoke test 5/5). A ocorrência em
  `arquivo/R/identification/het_primary.R` ficou congelada de propósito.
- [x] **`script/run_all.R`** (2026-07-26) — orquestrador de 8 estágios
  (`di → external_factors → focus_fred → ibov → download → clean → instrument
  → model`), **um processo `Rscript` por estágio**, porque os
  scripts começam com `rm(list = ls())` e os dois downloaders só executam sob
  `if (sys.nframe() == 0)`. Flags: `--list`, `--dry-run`, `--from`, `--to`,
  `--only`, `--skip`, `--skip-existing`, `--continue-on-error`. Preflight aborta
  antes de rodar qualquer coisa se faltar insumo; log por estágio em
  `output/logs/` (gitignored).
- [x] **Branches consolidadas** (2026-07-26). As cinco branches locais eram uma
  cadeia linear sem divergência; todas foram merged em `main` por fast-forward e
  apagadas. `codigo_olea/` (87 MB de referência MATLAB, commitado por engano no
  `4f39ad9`) foi removido da história não-enviada e entrou no `.gitignore`, junto
  dos três `codigo_*` irmãos.

## Convenção de branches

**`main` é o estado sempre reproduzível** — o smoke test de `CLAUDE.md` tem que
passar em qualquer commit dela.

- **Uma branch por aposta metodológica que pode ser rejeitada.** Foi o caso da
  het: se estivesse isolada, teria sido descartada inteira em vez de deixar
  resíduo espalhado por seis scripts. A próxima é
  **`identificacao-nao-gaussiana`** (gate em η + ramo
  `identification = "nongaussian"`).
- **Escrita vai direto na `main`**, em commits pequenos: §5 para o tex, resumo,
  introdução, conclusão, revisão de literatura. Não é experimento, não pode
  "falhar", e só toca `tex/`.
- **Higiene e re-runs de diagnóstico vão direto na `main`**: o bloco de higiene
  de 2026-07-26 (`run_all.R`, renomear `irf_mp_raw`, taxonomia por ξ_mp,
  separar a leitura do coherence) foi feito assim. Segue valendo para o placebo
  `commodity_metal` e a comparação cross-instrumento do IPCA.
