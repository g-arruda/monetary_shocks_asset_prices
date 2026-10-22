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
| 3 | A | Linha diária do Anexo B | — | janela do CDS sem reunião |
| 4 | A | Versão integrada | passo 3 | — |
| 4 | A | Ressalvas da linha diária no resumo | linha diária do Anexo B | é a própria decisão |
| 4 | A | Tabela antigo × novo | versão integrada | — |
| 5 | B | Promover a branch para `main` | versão integrada, tabela antigo × novo | — |
| depois | B | Amostra completa com `p = 2` | — | quando rodar; qual θ̂ |

---

## A. Texto do paper

- [ ] **Linha diária do Anexo B.** O câmbio realinhado e o CDS às 17h de Nova York em `tab:het_frequency`.
  - Câmbio: já realinhado em 10-13, falta levar ao `.tex` (nota `2026-10-13_cambio_yahoo_convencao`,
    seção 7). As frases da §3.3 continuam verdadeiras. ⚠ A janela vem da hora inferida do Yahoo, que é
    uma hipótese documentada. ⚠ O Anexo F descreve a janela do Yahoo só para o Anexo E; ao levar o câmbio
    ao `.tex`, decidir se ele passa a citar o B.
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
    depreciação. A frase já está na §4.2 desde 22-10, e faltam a introdução e a conclusão.
  - Manter os resultados menos favoráveis (os itens de influência e de placebos).
  - Três passagens ficaram fracas desde 2026-09-24:
    - "o mercado de trabalho responde com defasagem" (`paper.tex:434`), quando as horas caem no impacto;
    - a reversão "altamente sincronizada" (`paper.tex:430`) e "in close synchrony" no resumo, quando os
      cruzamentos de zero se espalham;
    - o silêncio do resumo e da conclusão sobre a atividade negativa e sobre a NFSP primária positiva.
  - A introdução ainda põe a regra de sinal de JK no instrumento (decisão do autor de 21-10: fica para
    este item).
  - ⚠ `\autoref` e as legendas imprimem "Figure/Table": os `\renewcommand` de `bd3a52c` ficaram em
    `paper_anpec.tex` (nota `2026-10-22_conferir_e_trajetoria_diaria`, seção 3).
  - Depende do passo 3. Desbloqueia a promoção.
- [ ] **Ressalvas da linha diária no resumo.** Decidir se o resumo as carrega.
  - O resumo (`paper.tex:112`) diz que a condição "holds daily but fails in our monthly panel", sem duas
    ressalvas. O vértice decide no diário, e a correção de curtose também (÷4,9). No corpo, o vértice está
    na §3.3, e a curtose, em `tab:het_frequency`.
  - ⚠ A mesma frase põe "frequency and identification strategy" como origem da divergência, e a
    introdução (`paper.tex:145`) diz o mesmo. A proibição de 2026-09-22 veda decompor frequência e objeto
    medido (nota `2026-09-22_condicao_het_svars`).
  - Depende da linha diária do Anexo B. Decide-se junto com a versão integrada.
- [ ] **Tabela antigo × novo.** O e-mail de 12-10 (item 1) a pede "para facilitar a revisão", sem dizer se
  vai no artigo ou na entrega; o de 19-10 não a menciona. Usa `compare_model()` e `compare_cells()` de
  `R/reporting/sensitivity.R`. Depende dos números finais e da versão integrada. Desbloqueia a promoção.

---

## B. Robustez estatística

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
