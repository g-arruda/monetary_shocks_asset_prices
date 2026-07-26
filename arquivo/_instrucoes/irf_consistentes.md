## Contexto

Artigo em preparação para submissão ao Encontro Nacional de Econometria (não ao periódico ainda) —
portanto é aceitável que a escolha de (r,q) não esteja methodologicamente definitiva neste estágio.
Preciso decidir qual combinação (r,q) usar como especificação de trabalho, priorizando:

1. Força do instrumento no full sample (métrica principal).
2. Mas evitando combinações em que o instrumento fique fraco demais no pre-covid.
3. Objetivo maior no momento: IRFs com interpretação econômica plausível, sem "puzzles" de sinal.

## Tarefa

**Etapa 1 — Seleção de candidatos.**
Avalie se (8,4), (7,6) e (7,4) são combinações (r,q) razoáveis dado o estado atual das estatísticas
de diagnóstico do instrumento (F de primeiro estágio / Stock-Yogo, ξ_mp de Montiel Olea-Stock-Watson,
F em factor-space) — usar os artefatos já produzidos no projeto. Importante: priorize a estatistica de Montiel Olea-Stock-Watson.
(`output/instrument/mosw_strength_grid.{md,csv}`, `output/irf/spec_sweep_cells.csv`,
`output/irf/spec_sweep_report.md`) em vez de recalcular do zero, a menos que estejam desatualizados
para o instrumento default atual (`z_jk_bs_purif`).

Com base nisso, recomende **os 5 melhores candidatos de (r,q)** (pode incluir ou não os três acima),
ranqueados pelas estatísticas de força do instrumento, com a ponderação explícita:
- Priorizar desempenho no full sample.
- Penalizar/excluir candidatos em que o instrumento fique fraco no pre-covid.

Justifique o ranking citando os números reais (F, ξ_mp) de cada candidato nas duas amostras
(full e pre_covid).

**Etapa 2 — Estimação e leitura das IRFs.**
Para cada um dos 5 candidatos selecionados:
- Estime as IRFs (bootstrap completo, especificação de produção) para as 10 variáveis mais
  relevantes do painel (as mesmas de maior interesse econômico já usadas nas checagens de
  coerência — ex.: crédito, câmbio, IBOV, spreads, hiato/atividade, IPCA, conforme
  `R/identification/irf_coherence.R::coherence_var_table()`).
- Para cada variável, analise a resposta **ponto a ponto no horizonte h = 0, 1, 2, ..., 40**
  (não apenas o pico ou a janela agregada), reportando sinal, significância (bandas de confiança)
  e se a trajetória é consistente com a teoria (sem price puzzle, sem inversões de sinal
  espúrias, sem instabilidade de normalização).

**Etapa 3 — Síntese comparativa.**
Compare os 5 candidatos entre si: qual(is) produz(em) o conjunto de IRFs mais limpo e
economicamente coerente, e qual(is) tem problemas (puzzles, instrumento fraco, bandas
instáveis)? Termine com uma recomendação de qual (r,q) usar para a versão a ser enviada ao
encontro, sinalizando quaisquer ressalvas metodológicas a registrar como pendência para a
versão de submissão ao periódico.

## Verificação
- Não presuma que os arquivos de diagnóstico existentes já cobrem o instrumento e a amostra
  atuais — confira as datas/headers dos CSVs/relatórios citados antes de usá-los como fonte.
- Ao rodar as 5 estimações completas de IRF, confirme que o bootstrap (nboot, seed) segue o
  padrão de produção do projeto para que os candidatos sejam comparáveis entre si.