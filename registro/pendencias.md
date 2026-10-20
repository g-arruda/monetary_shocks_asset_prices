# Pendências

Só o que está aberto. Ao fechar, o item sai daqui e vai, comprimido, para [`fechados.md`](fechados.md).
O detalhe de cada rodada está na nota apontada, e o que morreu e por quê, em
[`historico_decisoes.md`](historico_decisoes.md). A especificação de produção é a do `CLAUDE.md` e de
`script/validation/validate_production_spec.R`. As regras de manutenção estão em `.claude/rules/writing.md`.

## Índice

Refeito em 2026-10-19 com base no e-mail do orientador de 19-10 (`email/email_professor_19-10_14h13.md`).
O e-mail encerra a auditoria de horários e fixa as 111 reuniões como base, com a de 104 como
sensibilidade. Pede que não se abra outra rodada ampla e põe como prioridade a versão integrada do artigo.
**Prazo combinado com o orientador para a versão integrada: 28/10.**

Os passos são estes, e itens do mesmo passo correm juntos:
1. produzir o que falta;
2. método e números;
3. resultados e robustez;
4. fechamento;
5. promover para `main`.

A amostra com `p = 2` fica para depois.

**Branch.** Tudo roda e se escreve na `feature/auditoria-janelas-copom`, que contém a
`feature/focus-horizonte-fixo`. A promoção para `main` é o último passo, com a versão integrada pronta.
Até lá, `main` guarda a versão anterior, que o orientador leu e que é coerente: artigo, figuras e saídas
estão todos na base de 102. `main` é ancestral da branch e não tem commit fora dela, então a promoção
continua sendo um avanço rápido, desde que nenhum commit vá para `main` até lá. É uma exceção à
convenção de branches, anotada em `.claude/rules/writing.md`.

| Passo | Tema | Item | Depende de | Decisão do autor |
|---|---|---|---|---|
| 1 | B | Rodar de novo na base de 111 as saídas que ainda estão na de 102 | — | rodar de novo influência e placebos? |
| 1 | A | Figura e tabela da ponte | — | — |
| 1 | B | Listar as cotações de CDS em feriados dos EUA | — | — |
| 1 | A | Apêndice com as convenções temporais e as fontes | — | Anexo E novo ou parte do D |
| 2 | A | Amostra e construção do instrumento na §3.3 e na §3.4 | rodar de novo | 26ª chave para Staiger e Stock? |
| 2 | A | Atualizar os números do artigo para a base de 111 reuniões | rodar de novo | — |
| 3 | A | Leitura da trajetória diária na §4 | figura e tabela da ponte | — |
| 3 | A | CDS estreito contra ampliado | lista de feriados | — |
| 3 | A | Influência, extremos e surpresa bruta no texto | rodar de novo, se decidido | base de 102 ou de 111 (passo 1) |
| 3 | A | Placebos na §3.3 e `fig:placebos` | rodar de novo, se decidido | base de 102 ou de 111 (passo 1) |
| 3 | A | Escrever o p = 0,54 do teste do EPU | junto com os placebos | — |
| 3 | A | Linha diária do Anexo B | — | janela do CDS sem reunião |
| 4 | A | Versão integrada | passos 2 e 3 | — |
| 4 | A | Ressalvas da linha diária no resumo | linha diária do Anexo B | é a própria decisão |
| 4 | A | Tabela antigo × novo | versão integrada | — |
| 5 | B | Promover a branch para `main` | versão integrada, tabela antigo × novo | — |
| depois | B | Amostra completa com `p = 2` | — | quando rodar; qual θ̂ |

---

## A. Texto do paper

- [ ] **Figura e tabela da ponte.** E-mail de 19-10, item 2. As saídas estão em `output/event_trajectory/`
  e `output/monthly_reduced_form/` e já usam a base de 111 (nota `2026-10-18_conferencias_ponte`).
  - Figura de dois painéis, câmbio e CDS, com a resposta acumulada na 1ª, 5ª, 10ª e 20ª cotações. Vai com
    um nível de confiança só ou com as faixas de 90% e 95% juntas. ⚠ Nenhum script desenha essa figura
    ainda. Falta um que leia os CSVs da ponte, sem reestimar nada.
  - A amostra comum é de 110 reuniões: o arquivo do Yahoo termina em 2025-12-31, e a reunião de
    2025-12-10 não tem 20ª cotação.
  - Tabela curta com a forma reduzida mensal e o DFM. Cada intervalo traz a transformação, a janela, a
    normalização, a amostra e o nível. ⚠ A trajetória e a forma reduzida são por +50 p.b. de surpresa; o
    DFM é por +50 p.b. no DI de 6 meses. A comparação mostra coerência de sinais e dinâmica, mas as
    magnitudes não medem o mesmo objeto.
  - ⚠ Na forma reduzida, o câmbio de fim de mês não é significante a 90%. Reportar.
  - Desbloqueia a leitura da trajetória.
- [ ] **Apêndice com as convenções temporais e as fontes.** E-mail de 19-10, item 4. Reúne:
  - a grade de horários do DI na B3 e o Ofício Circular 094/2020-PRE;
  - as fontes secundárias de 2012–2018, que dão o limite de 18h15;
  - a hipótese do carimbo do Yahoo;
  - o horário do CDS e a margem de 30 minutos.

  As URLs estão no item 5 de `email/email_meu_18-10_20h26.md`. ⚠ O orçamento de chaves está cheio, então
  as fontes vão em rodapé, com URL. Anexo E novo ou parte do Anexo D: decisão do autor. Não depende de
  nada.
- [ ] **Amostra e construção do instrumento na §3.3 e na §3.4.** E-mail de 19-10, item 3.
  - A base são as 111 reuniões, e a sensibilidade são as 104. Na trajetória diária, a sensibilidade
    exclui as sete reuniões. No DFM e na forma reduzida mensal, elas entram com z = 0. Descrever o z = 0
    como regra de construção do instrumento, sem afirmar que o choque foi nulo.
  - Documentar como o z = 0 entra nos momentos e na variância deles. É o preenchimento por zero de MOSW
    (`SVARIV.m:128`), e o VAR usa os 162 meses.
  - Separar relevância, limitação dos conjuntos AR e força do instrumento. O 10 de Staiger e Stock entra
    só como referência convencional. ⚠ O orçamento de 25 chaves está cheio (`dovern2012` é a 25ª), e
    citar Staiger e Stock exige uma 26ª.
  - Depende de rodar de novo a grade de força e os diagnósticos do instrumento (Tema B).
- [ ] **Atualizar os números do artigo para a base de 111 reuniões.** E-mail de 12-10, item 1, com a base
  fixada pelo de 19-10.
  - Todo número da §3.4, da §4, da §5 e dos anexos C e D passa à base congelada. O que cita 102 reuniões
    passa a 111, com a BS refeita.
  - Reportar também os horizontes não significantes. Conferir se a reversão de longo prazo continua
    significante só a 80%, como na base de 102.
  - ⚠ "O IPCA nunca fica positivo" (§4) deixa de valer.
  - A §3.2 e o Anexo A já foram escritos na branch em 17-10.
  - Depende de rodar de novo. Desbloqueia a versão integrada e a tabela antigo × novo.
- [ ] **Leitura da trajetória diária na §4.** E-mail de 19-10, item 1; os números estão na nota
  `2026-10-18_conferencias_ponte`.
  - A apreciação na 1ª cotação é uma estimativa pontual imprecisa.
  - A depreciação na 20ª cotação pede linguagem de consistência, porque o limite inferior está perto de
    zero.
  - A troca de sinal não é datada.
  - Os intervalos são por horizonte, sem correção para múltiplos horizontes.
  - A alta do CDS vai com o nível de cada horizonte. Uma frase, sem leitura causal, diz que o CDS é
    significante já na 10ª cotação e o câmbio só na 20ª.
  - O horizonte é dado em cotações, não em dias corridos.
  - Depende da figura e tabela da ponte.
- [ ] **CDS estreito contra ampliado.** E-mail de 19-10, item 4.
  - Entra como sensibilidade ao alinhamento temporal, não como evidência de um mecanismo, porque a janela
    ampliada também pega outras notícias.
  - Sem as sete janelas longas (104 reuniões), a ampliada deixa de ser significante a 90%.
  - A cotação de 2013-11-28 fica, com a limitação: é um valor inteiro e caiu no feriado de Ação de Graças
    nos EUA.
  - Depende da lista de feriados (Tema B).
- [ ] **Influência, extremos e surpresa bruta no texto.** E-mails de 12-10, item 1, e de 19-10, item 5,
  que pede para manter os resultados menos favoráveis. Entram:
  - sem as dez reuniões mais influentes, os conjuntos viram a reta toda, e a inferência é inconclusiva,
    não uma resposta zero (nota `2026-10-08_influencia_reunioes`);
  - a regra das 11 reuniões com movimento extremo, fixada antes de rodar (`2cad8bd`); com ela, o CDS fica
    estável e o câmbio perde magnitude e precisão, sobretudo pelo Brent (nota
    `2026-10-12_exclusao_extremos`);
  - com a surpresa bruta no DFM, câmbio e CDS não são significantes a 90% (nota
    `2026-10-05_evento_diario`).

  ⚠ Os números são da base de 102 (a decisão está no Tema B). Alimenta a versão integrada.
- [ ] **Placebos na §3.3 e `fig:placebos`.** E-mails de 08-10, de 12-10 (item 4) e de 19-10 (item 5). Os
  números estão na nota `2026-10-12_msci_emergentes`, seção 6.
  - A figura descreve as respostas, e a legenda diz que os conjuntos são pontuais. A contagem de pontos
    significantes não serve como evidência conjunta.
  - Holm controla as comparações pontuais da família e não é um Wald conjunto. Dizer por que difere do
    teste conjunto por série e pôr os p-valores sem ajuste ao lado dos ajustados.
  - A leitura: não rejeitamos resposta zero depois do ajuste, o que não comprova exogeneidade e pode
    refletir pouca precisão.
  - ⚠ A queda do índice de emergentes em h0, h1 e h3 fica visível e entra como limitação. O exercício não
    separa o peso do Brasil no índice, as repercussões do choque e as notícias comuns aos emergentes.
  - Vai também a ressalva do VIX em h0: o mês se sobrepõe à janela da ortogonalização. Nenhum placebo
    novo.
  - ⚠ O parágrafo atual diz que o EPU é significante a 90% em h1–h3. Na base nova, não é em nenhum
    horizonte.
  - ⚠ Os números são da base de 102 (a decisão está no Tema B). Escrever junto com o p = 0,54.
- [ ] **Escrever o p = 0,54 do teste do EPU.** E-mails de 03-10 (passo 4) e de 12-10 (item 4).
  - Explicitar a hipótese testada: H0 β_EPU = 0 na regressão BS da surpresa com `pre_epu` (nota
    `2026-10-09_placebos_holm`, seção 5).
  - Descrever o resultado como ausência de evidência de poder preditivo nessa especificação, sem lê-lo
    como validação da exogeneidade. Vai no corpo ou em nota.
  - ⚠ O teste só existe na branch `feature/placebo-epu`.
- [ ] **Linha diária do Anexo B.** O câmbio realinhado e o CDS às 17h de Nova York em `tab:het_frequency`.
  - Câmbio: já realinhado em 10-13, falta levar ao `.tex` (nota `2026-10-13_cambio_yahoo_convencao`,
    seção 7). As frases da §3.3 continuam verdadeiras. ⚠ A janela vem da hora inferida do Yahoo, que é
    uma hipótese documentada.
  - CDS: `het_conditions.R` ainda usa a janela de quarta a quinta. Falta definir a janela das semanas sem
    reunião, que não têm anúncio, e rodar de novo.
  - ⚠ Na base nova, a linha fatorial não rejeita nada a 10%, e a nota da tabela, que imprime 0,035, 0,021
    e 0,013, muda.
  - Não depende de outro item. Desbloqueia a decisão sobre as ressalvas no resumo.
- [ ] **Versão integrada.** Introdução, resultados e conclusão coerentes com a ponte: e-mail de 19-10, item
  5 e último parágrafo. Absorve a conclusão com o DFM e o evento lado a lado (e-mail de 12-10, item 5) e a
  leitura da §4 migrada (nota `2026-09-24_migracao_secao_4`, §5).
  - A depreciação e a alta do CDS em horizontes posteriores aparecem também fora do DFM. A evidência é
    consistente com uma transmissão associada ao risco, mas não identifica que o risco causa a
    depreciação.
  - Manter os resultados menos favoráveis (os itens de influência e de placebos).
  - Três passagens ficaram fracas desde 2026-09-24:
    - "o mercado de trabalho responde com defasagem" (`paper.tex:431`), quando as horas caem no impacto;
    - a reversão "altamente sincronizada" (`paper.tex:427`) e "in close synchrony" no resumo, quando os
      cruzamentos de zero se espalham;
    - o silêncio do resumo e da conclusão sobre a atividade negativa e sobre a NFSP primária positiva.
  - ⚠ Os números dessas passagens são de `main` e mudam com a base de 111.
  - Depende dos passos 2 e 3. Desbloqueia a promoção.
- [ ] **Ressalvas da linha diária no resumo.** Decidir se o resumo as carrega.
  - O resumo (`paper.tex:111`) diz que a condição "holds daily but fails in our monthly panel", sem duas
    ressalvas. O vértice decide no diário, e a correção de curtose também (÷4,9). No corpo, o vértice está
    na §3.3, e a curtose, em `tab:het_frequency`.
  - ⚠ A mesma frase põe "frequency and identification strategy" como origem da divergência, e a
    introdução (`paper.tex:144`) diz o mesmo. A proibição de 2026-09-22 veda decompor frequência e objeto
    medido (nota `2026-09-22_condicao_het_svars`).
  - Depende da linha diária do Anexo B. Decide-se junto com a versão integrada.
- [ ] **Tabela antigo × novo.** O e-mail de 12-10 (item 1) a pede "para facilitar a revisão", sem dizer se
  vai no artigo ou na entrega; o de 19-10 não a menciona. Usa `compare_model()` e `compare_cells()` de
  `R/reporting/sensitivity.R`. Depende dos números finais e da versão integrada. Desbloqueia a promoção.

---

## B. Robustez estatística

- [ ] **Rodar de novo na base de 111 as saídas que ainda estão na de 102.** Já estão na base de 111 o
  evento diário, as duas pontes e o cache `irf_coherence_h.csv`. Faltam:
  - `ar_precision.R`, `mosw_strength_grid.R`, `instrument_diagnostics.R` e `model_var.R`;
  - os anexos: `q_sensitivity.R`, `p_sensitivity.R`, `pandemic_sensitivity.R` e
    `instrument_layers_irf.R`;
  - as figuras: `fig_section5.R` e `fig_weak_iv.R`.

  ⚠ `meeting_influence.R` e `placebo_holm.R` dependem de decisão do autor. Os e-mails de 17-10 e de 18-10
  dispensam repeti-los agora, mas o de 19-10 pede os resultados no texto. Ou rodam de novo, ou o texto diz
  que estão na base de 102. Se rodarem, entra a emenda de 16-10 à regra de 10-12: nas duas reuniões de
  Ação de Graças, S&P 500, VIX e Brent vão de quarta a sexta, nunca 0.

  Roda na branch e não depende de outro item. Desbloqueia, no Tema A: os números do artigo, a amostra e o
  instrumento, e a influência e os placebos.
- [ ] **Listar as cotações de CDS em feriados dos EUA.** E-mail de 19-10, item 4, só como checagem de
  calendário. `output/copom_timing/cds_calendar.csv` já conta 72 dias de feriado só nos EUA, todos com CDS;
  falta a lista de datas. Não depende de nada. Desbloqueia a limitação de 2013-11-28 no item do CDS
  estreito contra ampliado.
- [ ] **Promover a branch para `main`.** É o último passo e leva junto a base de 111 e a versão integrada.
  - A base: as Focus a horizonte fixo, a `msci` como índice MSCI de emergentes e o instrumento nas 111
    reuniões (notas `2026-10-03_focus_horizonte_fixo`, `2026-10-12_msci_emergentes` e
    `2026-10-17_auditoria_janelas_copom`).
  - É um avanço rápido de `main` até a `feature/auditoria-janelas-copom`. Só continua possível se nenhum
    commit for para `main` antes disso.
  - Ao promover, a lista de branches abertas do `CLAUDE.md` perde a `focus-horizonte-fixo` e a
    `auditoria-janelas-copom`, e o teste rápido de `main` passa aos valores da branch.
  - ⚠ Até a promoção, `main` segue com a ação da MSCI Inc. no painel, nos anexos, em `paper/img/` e no
    `.tex`. É de propósito: é a versão anterior, coerente.
  - ⚠ O `download.R` da branch não escreve mais a `msci`, que vem do estágio `msci`. Rodá-lo tira a coluna
    do `raw_data.csv` que `main` lê.
  - ⚠ O `data/processed/` é o mesmo para todas as branches. Se trocar para `main` antes da promoção, rodar
    `Rscript script/run_all.R --only=clean` antes de estimar, e rodar `--only=clean` e `--only=instrument`
    de novo ao voltar.
  - Depende da versão integrada e da tabela antigo × novo.
- [ ] **Amostra completa com `p = 2`.** E-mail de 12-10.
  - Os conjuntos pré-COVID só existem em `p = 2`: em `p = 4`, `hac_dim` 135 ≥ T = 90 (nota
    `2026-10-05_precisao_ar`). A janela completa em `p = 2` separa a mudança de amostra da mudança de
    defasagem. O texto não apresenta `p = 2` como a mesma especificação.
  - ⚠ O e-mail de 19-10 não menciona esse item. Rodar antes ou depois da versão integrada é decisão do
    autor.
  - O θ̂ também é decisão do autor: reestimado em `p = 2`, como no Anexo C, ou o de `p = 4`.
  - Roda na base de 111: na branch, se for antes da promoção, ou em `main`, se for depois.
