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
   monetária — e a restrição do proxy vira **testável** (Wald/LR). Pacote R
   nativo (`svars::id.ngml`, `id.dc`/`id.cvm`). Rota mais barata e a única que
   preserva o paradigma.
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

- [ ] **Gate de não-gaussianidade em η** — Jarque-Bera + curtose por fator no
  (7,6); a rota LMS/GMR exige **no máximo uma** inovação gaussiana. Barato:
  reusa `output/irf/irf_coherence_cell.rds`, sem re-estimar. **Decide se o item
  seguinte acontece.**
- [ ] **Ramo `identification = "nongaussian"`** em `compute_irf_dfm`
  (`R/modeling/impulse_responde.R`) — condicionado ao gate. Chamar
  `svars::id.ngml` / `id.dc` nas inovações fatoriais, rotular a coluna monetária
  por `corr(coluna, z)`, propagar por Λ, e reportar o teste LR/Wald da restrição
  do proxy. O ramo `identification = c("proxy","het")` é o molde: consome `eta`
  e devolve IRFs no mesmo formato.
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

## Aberto — robustez e conteúdo

- [ ] **Placebo `commodity_metal` violado** — responde +10,4% no impacto com
  CI90 até h4 a um choque monetário brasileiro. Metais **não** estão entre os
  preditores pré-evento da ortogonalização BS (Brent está), então o instrumento
  plausivelmente retém um componente global de commodity/risco. Testar
  ortogonalização estendida com um fator de metais, ou documentar como ressalva
  de exogeneidade. É o caveat mais concreto contra a validade do instrumento.
- [ ] **Re-rodar a comparação cross-instrumento do IPCA sob (7,6)** — o
  argumento "a corcova é universal entre instrumentos e some pre-COVID" fecha o
  diagnóstico do price puzzle, mas foi construído no vintage e instrumento
  antigos e **não reproduz**. Sem ele, o §5.5 não pode afirmar que a corcova é
  amostral. Fonte a regenerar: `spec_sweep_irf_long.csv`.
- [ ] **Benchmark GRG (2025) sem a célula het** — a reconciliação do sinal do
  câmbio usava `z_het_3var` × pre-COVID, que saiu do paper. Decidir como
  discutir o desacordo (frequência diária × mensal GE, janela amostral, regime
  de dominância fiscal 2020-25). Ver §5.3 do `irf_section.md`.
- [ ] **Bandas Anderson-Rubin** — agora **opcionais**. Com ξ_mp > 10 nas duas
  janelas em (7,6) as bandas convencionais bastam; manter AR como robustez
  (protocolo anti-screening de MOSW, footnote 6: reportar ξ, não filtrar pelo F).
- [ ] **Spread de concessões novas** como complemento ao ICC — deve abrir já no
  curto prazo, ao contrário do ICC (taxa da carteira, reprecifica devagar).
  Desejável, não bloqueante.
- [ ] **Decidir a subseção het comentada no `main.tex`** — remover ou manter
  como nota de resultado negativo.

## Aberto — código e higiene

- [ ] **Taxonomia do `irf_spec_sweep.R` usa a régua errada.** `failure_class`
  classifica por `f_factor` (max-F legada), não por ξ_mp. Consequência prática:
  o instrumento de produção **não aparece em nenhuma célula `ok`** do
  `spec_sweep_report.md` (em (7,6) full, `z_jk_bs_purif` tem f_factor 6,31 e
  ξ_mp 10,43; `z_jk_purif` tem o inverso, 11,08 e 5,77). Migrar a taxonomia para
  ξ_mp, ou documentar a divergência em todo lugar que cite as duas tabelas.
  Hoje está documentada só no `irf_section.md`.
- [ ] **Re-apensar "Leitura e diagnóstico"** em
  `output/irf/irf_coherence_report.md` — o corpo auto-gerado sobrescreve o
  arquivo a cada rodada, e a seção manual + adendos datados se perdem.
  Considerar emitir o corpo em arquivo separado.
- [ ] **`irf_mp_raw` mal nomeado** em `ident_ext_instr`
  (`R/modeling/impulse_responde.R`): o retorno acontece **depois** da
  normalização, então é normalized-pre-tcode, não raw. Renomear para
  `irf_mp_pre_tcode` ou acrescentar um campo separado. Não altera output.
- [ ] **`script/run_all.R`** — orquestrador end-to-end
  (`download → yield_curve → clean → instrument → model_alessi`).
- [ ] **Branch** — `identificacao-heterocedasticidade` não descreve mais o
  trabalho. Merge para `main` ou rename.
