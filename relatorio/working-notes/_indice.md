# Índice das working-notes

**Revisado em 2026-07-27.** Cada nota carrega um banner no topo com o mesmo
veredito. Antes de citar qualquer número de uma nota, confira o vintage: o
**refresh de base de 2026-07-24** (106 séries, remoção do bloco duplicado de
tempo de procura e das colunas ANBIMA vazias) e a **correção de tcode dos
índices B3** na mesma data mudaram magnitudes em todo o painel.

**Estado corrente:** proxy-SVAR com `z_jk_bs_purif` × `yield_6m`, r=7, q=6, p=6,
ξ_mp 10,43 full / 12,22 pre-COVID. Ver `_instrucoes/pendencias.md` (o que está
aberto) e `_instrucoes/historico_decisoes.md` (o que já foi tentado).

**Rota não-gaussiana (07-27):** implementada, validada contra a aplicação
publicada do GMR, e **empiricamente sem poder** neste painel — a agregação do DFM
destrói os momentos de ordem superior que o ICA precisa (rejeição de JB cai de
88,7% nas séries para 50,0% em `eta`). Mesmo mecanismo que derrubou a
heterocedasticidade. Qualquer método futuro que identifique por momentos de
ordem superior a 2 nas inovações **mensais** vai bater na mesma parede — métodos
assim têm de rodar em frequência diária, sobre observáveis, não sobre `eta`.

| nota | data | veredito | escrita sob | o que sobrevive |
|---|---|---|---|---|
| [`2026-07-27_robustez_xi_mp_e_construcao`](2026-07-27_robustez_xi_mp_e_construcao.md) | 07-27 | **CURRENT** | (7,6), `z_jk_bs_purif`, vintage 106 séries | Tudo. **Nenhuma decisão de produção mudou** — o exercício confirmou a construção herdada. ξ_mp: conjunto AR limitado sob qualquer amostra a menos de um mês (0/147 abaixo de 3,84), mas "bandas convencionais valem" é marginal (24/147 abaixo de 10); NW(0) é conservador. Vértice: 126 du **não** é o argmax, mas as diferenças são menores que o ruído LOO, e **os 13 vértices dão a mesma IRF** (overlay A4). Agregação GK colapsa ξ_mp para 0,30, como previsto antes de rodar — `yield_6m` é de fim de mês, e a nota 11 do GK condiciona a ponderação a indicador de média mensal |
| [`2026-07-27_identificacao_nao_gaussiana_gmr`](2026-07-27_identificacao_nao_gaussiana_gmr.md) | 07-27 | **CURRENT** | (7,6), `z_jk_bs_purif` | Tudo. GMR (2017) implementado e validado contra a aplicação publicada. **O estimador não tem poder neste painel** (CI90 da bolsa: [−49, +81]; bandas contêm zero em tudo), a rejeição assintótica da restrição do proxy é espúria (Prop. 4 subcobre 0,79 em T=150, n=6), e o gate só passa no full sample por causa da COVID. Serve como **teste**, não como estimativa |
| [`2026-07-24_avaliacao_5_artigos_robustez`](2026-07-24_avaliacao_5_artigos_robustez.md) | 07-24 (+ adendos até 07-27) | **parcialmente superada** | (7,6), `z_jk_bs_purif` | Corpo + Adendos 1-3: o toolkit **ACF (2024)** segue aberto e intocado, e o `IdSS` é mesmo o código de referência do GMR — **mas está quebrado para n ≥ 4**. **Caiu o Adendo 4**: recomendava acoplar o GMR, que foi implementado em 07-27 e não tem poder. O veredito de venue (**ANPEC**) sobrevive |
| [`2026-07-24_auditoria_analise_gemini`](2026-07-24_auditoria_analise_gemini.md) | 07-24 | premissa corrigida | (6,5), pré-refresh | A refutação técnica (F conjunta não é a estatística que governa; ξ_mp é). **Não vale** o enquadramento de "proxy abandonado" nem a recomendação P1 |
| [`2026-07-15_auditoria_identificacao_vs_alessi`](2026-07-15_auditoria_identificacao_vs_alessi.md) | 07-15 | superseded | (6,5)/(8,8), pré-refresh | A verificação do port R↔MATLAB (5/5) — independente de spec e vintage. É a referência de fidelidade do projeto |
| [`2026-07-15_sweep_instrumentos_irf`](2026-07-15_sweep_instrumentos_irf.md) | 07-15 | superseded | 6 instr. × 3 (r,q), pré-refresh | **Relevância ≠ validade**: a inversão da curva é ortogonal à força do instrumento. Derruba a afirmação central da nota de 07-11 |
| [`2026-07-15_reacao_por_variavel`](2026-07-15_reacao_por_variavel.md) | 07-15 | superseded | idem, pré-tcode-fix | A escolha de instrumento quase não move as IRFs; **a amostra é que dirige tudo**. Linhas `asset_*` fora de escala |
| [`2026-07-15_irf_rq_candidates`](2026-07-15_irf_rq_candidates.md) | 07-15 | superseded (auto-marcada) | `z_jk_bs_purif`, pré-refresh | Recomendou (7,6), que **virou produção em 07-24** por outro motivo. As "Ressalvas para periódico" seguem abertas |
| [`2026-07-14_auditoria_fidelidade_jk_bs`](2026-07-14_auditoria_fidelidade_jk_bs.md) | 07-14 | conclusão adotada | (6,5), pré-refresh | *A força mora na máscara, não nos valores* — **confirmado independentemente em 07-26**. Justifica o instrumento primário; alimenta §3.4 + Apêndice B |
| [`2026-07-14_ordem_purificacao_jk`](2026-07-14_ordem_purificacao_jk.md) | 07-14 | decisão revertida | (6,5), pré-refresh | O mecanismo da máscara 2020-03-19 e o descarte de `z_jk_raw_purif_local`. A recomendação "default fica" durou 24h |
| [`2026-07-12_irf_dentadas`](2026-07-12_irf_dentadas.md) | 07-12 | vintage antigo | `z_jk_purif` (6,5) | O mecanismo inteiro (raízes complexas de 3-4 meses do VAR(6) × baixa comunalidade). Não depende de instrumento nem de (r,q) |
| [`2026-07-12_price_puzzle_ipca`](2026-07-12_price_puzzle_ipca.md) | 07-12 | **conclusão caiu** | `z_jk_purif` (6,5) | Só como hipótese. "Corcova nunca significativa a 90%" **é falso** em (7,6). Re-rodar a comparação cross-instrumento é item aberto |
| [`2026-07-12_irf_credito_ativos_financeiros`](2026-07-12_irf_credito_ativos_financeiros.md) | 07-12 | superseded | `z_jk_purif` (6,5), pré-tcode-fix | O mapeamento de literatura e o diagnóstico da janela de scoring dos spreads. **Todas as magnitudes morreram** |
| [`2026-07-11_varredura_irf`](2026-07-11_varredura_irf.md) | 07-11 | **contraditada** | `z_jk_purif` (6,5) | A taxonomia das três Fs (§2) e o desenho do grid. **"F ≥ 10 ⇒ sinais certos" é falso** — ver a nota de 07-15 |

## Fora desta pasta

- `relatorio/2026-07-15_relatorio_auditoria_fidelidade_instrumento.md` — versão
  completa da auditoria de fidelidade; é o documento que motivou a troca de
  instrumento primário. Mesmo vintage antigo, mesma conclusão viva.
- `relatorio/estrutura_paper_v2.md` — roteiro seção-a-seção do paper com o mapa
  artefato → seção.

## Arquivadas em `arquivo/relatorio/`

Todas do track de heterocedasticidade, abandonado em 2026-07-16 e fora do paper
desde 2026-07-15. Preservadas porque documentam resultados negativos; nenhuma
descreve a identificação corrente.

| arquivo | o que era |
|---|---|
| `2026-04-25_blindspot_het_instrument.md` | Ruling condicional sobre `z_het_jk`; propunha reposicionar o paper em torno de identificação por variância |
| `2026-04-26_blindspot_validation.md` | Auditoria da suíte T1-T4; apontou que a F do JK fica *no* percentil 99 das máscaras aleatórias |
| `correspondence/referee2/2026-04-25_round1_report.md` | Referee interno round 1 — *Minor Revisions* sobre o bloco het |
| `correspondence/referee2/2026-04-26_round2_report.md` | Round 2 — *Accept*. Contém o único achado não-het reaproveitado: janelas não-contíguas exigem residualização AR full-sample antes do subset (registrado em `historico_decisoes.md` §4) |
| `correspondence/referee2/replication/` | Réplica NumPy do bloco Rigobon-Sack + CSVs de saída (10 arquivos) |
