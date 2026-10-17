# Pendências

**Atualização de 2026-10-17 (auditoria das janelas, e-mail de 17-10):** na branch nova
`feature/auditoria-janelas-copom`, a partir da `focus`. A conferência 4/4 fechou (Tema B).
- O filtro residual saiu, e as 2 de Ação de Graças entram na produção da branch (104 reuniões, BS refeita).
- As 7 de feriado no Brasil, de quarta a sexta, ficam na sensibilidade (111).
- A tabela das 9 traz a classificação pré, pós ou ambígua, o anúncio como intervalo, a grade do DI1 e os
  horários do Yahoo e do CDS como hipóteses.
- Câmbio e CDS em h0 são significantes a 90% nas três bases.
- Decisões do autor no mesmo dia: só Ação de Graças na produção; ambígua a ≤ 30 min; meses excluídos a
  zero; o Ibovespa na janela do DI; o filtro removido.
- Abertos: mandar a tabela e a comparação, e rodar de novo o que lê o instrumento. ⚠ O ξ_mp pré-COVID é
  3,77.
- Nota `2026-10-17_auditoria_janelas_copom`.

**Atualização de 2026-10-17 (artigo, sem números):** na branch `feature/focus-horizonte-fixo`, a §3.2
e o Anexo A passaram à base nova (Focus a doze meses à frente por `dovern2012`, a 25ª chave; MSCI
índice 891800), a frase do Anexo C sobre `fig:lp_sensibilidade` foi reescrita e o ponteiro de
`fig:precovid_sensibilidade` foi consertado. Nenhum número mudou; o resto do passo 8 espera a base congelada.

**Atualização de 2026-10-16 (passo 2):** o e-mail que manda a 1/4, pergunta a janela ampliada do CDS e dá
as datas para a Bloomberg foi enviado (`email/email_meu_16-10_12h53.md`), e os dois itens do passo 2
fecharam (Tema B). Decisões do autor no mesmo dia: um e-mail só; 8 datas (maior |ΔDI| por
regime do anúncio e horário europeu, 6 no inverno europeu), mandadas só com os horários do anúncio, como o
orientador pediu, e, nas 3 anteriores a 2016-07, a primeira matéria do G1 depois do fim da ata; o e-mail
conferido contra o de 14-10, sem nada além do pedido; as 2 de Thanksgiving, fora por erro de um filtro
residual, entram na amostra principal (conferência 4/4); e as duas leituras da janela ampliada do CDS
prontas no código enquanto ele não responde (`cds_wide*` em `meetings.csv`; nota
`2026-10-16_janela_ampliada_cds_bloomberg`). Nada reestimado.

**Atualização de 2026-10-15 (conferência 1/4):** a tabela das reuniões afetadas rodou e fechou (Tema B,
nota `2026-10-15_conferencia_reunioes_fora`), em `output/copom_timing/excluded_meetings.csv`. Decisões do
autor no mesmo dia, antes de rodar:
- as "afetadas" são as 9 fora das 102;
- o Yahoo largo vai da linha de terça à de quinta, pelo calendário do Yahoo;
- a janela ampliada do CDS fica fora e vai como pergunta ao orientador;
- a duração vai em dias e cotações, e em horas onde há horário.

Das 9, 7 caem porque a quinta é feriado no Brasil (DI e PTAX de quarta a sexta, um pregão, mesmo
contrato) e 2 de Thanksgiving só pelo filtro de S&P 500, VIX e Brent. Entrou no Tema B o item de mandar a
tabela ao orientador com a pergunta do CDS (passo 2 do índice).

**Atualização de 2026-10-15:** entrou o e-mail do orientador de 14-10
(`email/email_professor_14-10_17h44.md`), resposta às três perguntas de `email_meu_14-10_10h55.md`. Ele
pede uma conferência em quatro entregas, cada uma enviada quando ficar pronta, e deixa a apreciação do
evento diário provisória até o fim dela. As quatro entraram no Tema B, mais um item para mandar a ele
datas de reuniões que um conhecido confere na Bloomberg. As perguntas do câmbio e das 9 reuniões
fecharam, respondidas.
- Câmbio: a PTAX de venda como diagnóstico adicional, numa janela diária mais ampla, e o Yahoo de terça a
  quinta, sem apresentá-lo como janela estreita. A série do DFM não muda agora. O autor segue o
  orientador, o que reverte a decisão de 14-10 de nunca usar a PTAX.
- CDS: a janela ampliada, com as duas mudanças adjacentes, com o fechamento às 17h de Nova York
  (decisão do autor de 14-10, mantida). ⚠ O corpo do e-mail pula o item do CDS, e a leitura de terça a
  quinta é do registro.
- 9 reuniões: nenhuma fica com z = 0 automaticamente. As 2 de Thanksgiving têm DI válido e não caem pela
  falta de um controle. As 7 de feriado no Brasil entram como sensibilidade, da última à primeira
  observação válida. Surpresa indisponível é ausente e sai dos momentos de Γ. ⚠ Isso muda o instrumento
  da base e toca o núcleo de identificação e o passo 0.

No mesmo dia o índice virou um passo a passo em ordem de prioridade pelos e-mails de 14-10 e 12-10, com
a branch sugerida para cada passo.

**Atualização de 2026-10-14 (ponte b):** a ponte (b) rodou e fechou (Tema B, nota
`2026-10-14_ponte_mensal_forma_reduzida`), com a regra commitada antes (`e19a754`). Decisões do autor no
mesmo dia:
- séries do painel e a outra agregação dos diários;
- três amostras para os meses com z = 0;
- surpresas ortogonalizada e bruta;
- h = 0 e 1;
- forma reduzida e IV pela `yield_6m`.

Na linha de referência, por +50 p.b. de surpresa ortogonalizada, o real deprecia R$ 0,145 no mês e o CDS
alarga 41,3 p.b., os dois significantes a 95%. Pela regra, a depreciação aparece no mensal sem fatores.
⚠ Com o câmbio de fim de mês, o ponto segue positivo e não é significante a 90%. A regressão IV escalar do
passo 2 passou a `R/identification/weak_iv_ar.R` (`fit_reduced_form_iv()`, `fbf9c35`).

**Atualização de 2026-10-14 (ponte a):** a ponte (a) rodou e fechou (Tema B, nota
`2026-10-14_ponte_trajetoria_evento`), com a regra commitada antes (`0b08071`). Decisões do autor no
mesmo dia: câmbio sempre do Yahoo, nunca a PTAX; CDS sempre com fechamento às 17h de Nova York, o que
fecha o item da janela do CDS; amostra comum de 101 reuniões; só a forma reduzida. Por +50 p.b. de
surpresa ortogonalizada:
- o real aprecia R$ 0,029 na primeira cotação (significante a 90%) e deprecia R$ 0,122 até a 20ª
  (significante a 95%);
- o CDS alarga 16,5 p.b. até a 10ª (significante a 95%).

Pela regra, a troca de sinal do câmbio já aparece na trajetória diária. Entrou um item no Tema B: o
passo 2 e a linha diária do Anexo B passam o CDS às 17h de NY.

**Atualização de 2026-10-14:** e-mail ao orientador às 10h55 (`email/email_meu_14-10_10h55.md`) com três
perguntas da conferência da ponte, todas no Tema B e aguardando resposta. (1) Câmbio: manter o Yahoo,
cuja primeira cotação posterior ao anúncio seria a da noite de quarta, ou usar outra fonte; item novo.
(2) CDS: a janela de quarta a quinta vale com fechamento em Londres, e com Nova York às 17h falha nas
reuniões do inverno americano desde meados de 2016. (3) As 9 reuniões fora das 102: mantê-las fora ou
incluí-las com o pregão seguinte.

**Atualização de 2026-10-13 (câmbio):** por decisão do autor, todo o câmbio diário passa ao Yahoo
`BRL=X`, lido pela convenção do anúncio (nota `2026-10-13_cambio_yahoo_convencao`). A cotação do Yahoo
é a da noite (20h–22h em Brasília). Na quarta, ela vem depois do anúncio em 96 das 102 reuniões. ⚠ A
leitura de 10-05 ("deslocado um pregão no inverno europeu, 45 das 102") estava errada: a janela pelas
datas perde o anúncio nas 51 reuniões de verão.
- O evento diário refeito dá −R$ 0,037 (p 0,012) na surpresa bruta e −R$ 0,029 (p 0,088) na
  ortogonalizada, que perde os 95%. Esses números substituem o R$ 0,048 da PTAX enviado em 12-10.
- O item do Tema D fechou. O do Anexo B (Tema A) ganhou os números: a razão diária do câmbio vai de
  1,04 a 0,69, e o `Qr` com DI de 3 meses de 0,003 a 0,002.
- Pontes (a) e (b) e as 9 reuniões: PTAX trocada por Yahoo, e o ⚠ de fim de mês corrigido.

**Atualização de 2026-10-13:** revisão dos itens abertos contra o `.tex`, os scripts e os e-mails.
Fecharam, por já estarem feitos, a conferência da figura de placebos (Tema A) e a resposta ao plano do
orientador (Tema B). O passo 0/5 perdeu o "falta o orientador ver câmbio e CDS", feito em 12-10. Saíram
o cabeçalho de 28-09, que cobria itens já fechados e ficara sobre dois abertos, o preâmbulo do Tema D
sobre os testes das Focus, removidos ou rodados como passo 0, e a frase "nenhum passo foi executado" do
Tema B. O item das ressalvas da linha diária entrou no índice e foi reapontado da §5.1, apagada em
24-09, para a §3.3 e o Anexo B. No mesmo dia entrou o e-mail do orientador de 12-10
(`email/email_professor_12-10_19h40.md`), resposta a `email_meu_12-10_17h22.md`: ele libera atualizar
o artigo com a base reconstruída e pede a última rodada de verificações antes da decisão de submissão,
com prazo em 19/20 de outubro. No Tema B entraram a ponte do evento diário ao resultado mensal (três
itens) e a amostra completa com `p = 2`; no Tema A, a atualização do artigo, a tabela antigo × novo,
influência e exclusão por extremos no texto e a frase da conclusão sobre câmbio. Os dois itens de
placebos do Tema A ganharam a redação que ele pede. O índice passou a seguir a ordem de execução da
entrega, com a coluna `Ordem`, em vez de agrupar por tema. Ainda em 10-13 rodou e fechou a conferência
da ponte (Tema B, nota `2026-10-13_ponte_horarios_copom`). DI e PTAX cumprem a convenção nas 102
reuniões. ⚠ A janela do CDS depende de um horário de fechamento que nem o arquivo nem os dados fixam.
⚠ 9 reuniões ficam fora, e os meses delas entram com z = 0. Saíram dois itens de decisão no Tema B: a
janela do CDS na ponte (a) e a inclusão das 9 reuniões.
**Atualização de 2026-10-12:** na branch `feature/focus-horizonte-fixo`, a série `msci` do painel
passou da ação da MSCI Inc. ao índice MSCI de emergentes, e os passos 0 a 4 rodaram de novo sobre a
base reestimada (nota `2026-10-12_msci_emergentes`). Fecha o item do Tema D. Câmbio e CDS não mudam.
⚠ Sem ajuste, o placebo do índice de emergentes cai no impacto e em h1. O passo 0 do Tema B segue à
espera do orientador e da promoção, e `main` segue com a ação. No mesmo dia o autor fixou, antes de
rodar, a regra do passo 3, parte 2 (Tema B): exclusão por movimentos extremos de VIX, S&P 500 ou
Brent, no Caminho A. A regra foi commitada (`2cad8bd`), rodou e o item fechou (nota
`2026-10-12_exclusao_extremos`). ⚠ O câmbio cai 26% no impacto sem as 11 reuniões marcadas e perde os
95%, e com isso a verificação de terça a quarta virou item aberto, à espera do autor.
**Atualização de 2026-10-09:** o passo 4/5 do Tema B (placebos com Holm) rodou na branch
`feature/focus-horizonte-fixo` e fechou (nota `2026-10-09_placebos_holm`). Dele saíram dois itens. No
Tema D, a série `msci` do painel é a ação da MSCI Inc., não o índice de emergentes. No Tema A, ficam o
parágrafo de placebos da §3.3 e a legenda de `fig:placebos`, que esperam a promoção da base.
**Atualização de 2026-10-08:** o e-mail do orientador de 08-10 (`email/email_professor_08-10_15h15.md`)
fixou o desenho dos passos 3 e 4 do Tema B. A parte de influência do passo 3 rodou na branch
`feature/focus-horizonte-fixo` e fechou (nota `2026-10-08_influencia_reunioes`). A exclusão por
movimentos extremos de VIX, S&P 500 e Brent virou item próprio, à espera da regra do autor.
**Atualização de 2026-10-05:** o passo 1/5 do Tema B (precisão) rodou na branch
`feature/focus-horizonte-fixo`, sobre a base do passo 0, e fechou (nota `2026-10-05_precisao_ar`).
No mesmo dia rodou e fechou o passo 2/5 (evento diário), na mesma base, com a PTAX como câmbio diário
(nota `2026-10-05_evento_diario`). Dele saiu um item no Tema D, com ponteiro no Tema A: o câmbio
diário do Yahoo está deslocado um pregão no inverno europeu, e alimenta a linha diária do Anexo B.
**Atualização de 2026-10-03:** o e-mail do orientador de 03-10 (`email/email_professor_03-10_11h31.md`)
entrou no Tema B como um plano de seis passos (0 a 5) e a resposta que ele pede ao autor. O item do
p = 0,54 do Tema A ganhou a redação que o orientador pede. No mesmo dia o passo 0 rodou na branch
`feature/focus-horizonte-fixo` (`notas/2026-10-03_focus_horizonte_fixo.md`) e espera o orientador ver
câmbio e CDS antes de congelar a base.
**Atualização de 2026-10-01:** quatro itens do e-mail do orientador de 30-09 entraram no
Tema A, todos abertos. No mesmo dia o item de DBGG e Focus PIB na janela pré-COVID ganhou o
diagnóstico (`notas/2026-10-01_precovid_dbgg_focus_pib.md`), sem frase no `.tex` por decisão do
autor, e entraram três itens: o ponteiro quebrado da §3.4 (Tema A) e dois testes da troca de
ano-alvo das Focus "ano seguinte", o t+12 publicado pela Focus e o de Dovern-Fritsche-Slacalek
(Tema D).

**Atualização de 2026-09-29:** quatro itens e um teste entraram do e-mail do
orientador de 28-09 (Temas A, B e D). Em 2026-09-30 fecharam o teste do EPU
como controle (Tema D) e o parágrafo de placebos (Tema A); os outros três seguem
abertos.

**Última revisão:** 2026-09-08 — **todos os itens abertos foram zerados por
decisão do autor**, para conter o acúmulo que vinha tomando o foco do
projeto. Nenhum foi marcado como feito: nenhum foi executado, testado ou
decidido. O texto de cada item, incluindo as ressalvas `⚠`, some deste
arquivo, mas continua recuperável no histórico do git (`git log -p --
registro/pendencias.md`) para quem quiser reabri-lo com desenho próprio.
Os blocos `Fechados (contexto)` de cada tema, que registram trabalho de fato
concluído, foram preservados. No mesmo dia, cinco itens novos entraram no
Tema B, transcritos em ordem das coordenadas do último email do orientador
(`email/email_professor_04-09_16h42.md`, 2026-09-04) — nenhum foi executado.
Itens abertos organizados por tema (A-E);
cada tema termina num bloco `### Fechados (contexto)` com o que já foi feito,
resumido a poucas linhas — o detalhe completo mora no working-note ou output
apontado ali, nunca duplicado aqui. Resultados negativos e decisões
revertidas ficam em [`historico_decisoes.md`](historico_decisoes.md) —
consulte antes de propor um caminho novo.

**Passada editorial em 2026-09-08:** todo bloco `Fechados (contexto)` (Temas
A-E) foi comprimido para a regra de 2-4 linhas que este arquivo já declarava
mas não seguia — nenhuma decisão, veredito ou número mudou, só a prosa
redundante com a nota/output já apontado saiu. As convenções de manutenção e
de branches, que não são pendência nem histórico, mudaram para
`.claude/rules/writing.md`. Texto integral pré-compressão recuperável em
`git log -p -- registro/pendencias.md`.

---

## Convenção de manutenção deste arquivo

Regras de manutenção e a convenção de branches movidas para
`.claude/rules/writing.md` (§"Maintaining `registro/pendencias.md`" e
§"Branch convention") em 2026-09-08, para tirar workflow estável de um
arquivo que deve conter só pendência viva. Consultar lá antes de abrir,
fechar ou comprimir um item.

---

## Especificação corrente

| item | valor |
|---|---|
| Identificação | proxy-SVAR (instrumento externo), `H = (Z'η)/(Z'Z)` |
| Instrumento | **`z_bs_purif`** desde 2026-09-26 (construída na branch `feature/bs-copom-surpresas-macro` e promovida para `main` no mesmo dia) — surpresa DI Qua→Qui no vértice 126 du + ortogonalização Bauer-Swanson **pré-evento** nas 102 reuniões (Tabela 3 + S&P 500 e VIX); o filtro de sinal JK saiu da produção, por ora, por decisão do autor. Até 2026-09-26 a produção era `z_jk_bs_purif` |
| Variável de política | `yield_6m`, choque +50bp no impacto (+0,005 em proporção decimal) |
| Dimensão | **r = 5, q = 5**, VAR(p = 4) nos fatores; Bai--Ng BLL dá IC1=5, IC2=5 e IC3=20; `q=r=5`; `p=4` herdado, com nova checagem AIC/BIC separada em `T=154` |
| Painel | **115 séries**, variante `drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, 2012-03 a 2025-12 (166 observações alinhadas; 162 inovações fatoriais após p=4) |
| Inferência | **conjuntos Anderson-Rubin por inversão de teste** (MOSW 2021), NW(0), h = 0-48, desde 2026-09-08; níveis **80/90** desde 2026-09-26 (eram 68/90). O wild bootstrap Gonçalves-Kilian e a correção de Kilian saíram do código em 2026-09-18. ⚠ `hac_dim < T` barra `(8,8)` em `p=4` e a janela pré-COVID inteira |
| Força | Com `z_bs_purif`: ξ_mp/F_rob,mp = **7,018990/8,616330** full e **6,836682/8,306648** pré-COVID, as duas abaixo de 10 nas duas janelas. Até 2026-09-26, com `z_jk_bs_purif`: **6,848035/11,765564** full, sob a escala COVID de Lenza-Primiceri desde 2026-09-17 (θ̂ reestimado com `ndeps = 1e-6` em 2026-09-25; antes 6,847997/11,765250), e **8,643436/13,809985** pré-COVID. Raiz máxima 0,983676 full e 0,993359 pré-COVID, que não dependem do instrumento; ambas estáveis |
| Benchmark VAR do paper | `{ibc_br, price_ipca, yield_6m, cambio_usd, cds_5y}` em nível, com constante e tendência linear; desde 2026-09-21 na **janela e no `p` do DFM** (2012-03--2025-12, `p=4`, `T_eff=162`), decisão de comparabilidade e **não** do AIC, que em `T=154` ainda escolhe `p=2` (BIC, `p=1`); respostas `C_h B_1`; raiz máxima `0,976522`; AR/MOSW com NW(0). Desde 2026-09-26: `z_bs_purif`, `xi_var=7,189765`, níveis 80/90%; antes: `z_jk_bs_purif`, `xi_var=7,258325`, 68/90% |

Esta tabela combina a produção vigente do DFM com a produção corrente do
benchmark VAR do paper. O código, os artefatos em `output/var/`, a figura e a
subseção weak-IV foram migrados em 2026-08-22.
O painel-base de 106 séries continua em arquivo separado somente para reproduzir
as grades históricas. A recomendação intermediária de 123 séries `(4,3)` foi
superada pela decisão e migração de 2026-08-13.

Na reestimação dos diagnósticos de validade em `p=4`, as regressões diárias
continuam sem confirmar confundimento soberano ou do FOMC. Contudo, a máscara
global rederivada do exercício FOMC reduz `xi_mp` para **3,671**, abaixo de
3,84; pela regra pré-fixada, o veredito passou a **sinal fraco de contaminação
FOMC**. Esta ressalva permanece no registro e nos artefatos, mas o paper reporta
apenas os exercícios que mantêm fixa a máscara de produção, por decisão do
autor em 2026-08-25.

Desde 2026-09-24 o paper inteiro, as figuras da §4 e `output/irf/irf_section.md`
estão na vintage de produção (`notas/2026-09-24_migracao_secao_4.md`). Desde
2026-09-26 as figuras `paper/img/fig_*.pdf` e o `.tex` estão na produção nova
(`z_bs_purif`, 80/90%), e o filtro JK saiu do paper inteiro
(`notas/2026-09-26_migracao_paper_bs_purif.md`). Grades
históricas de painel, `(r,q)` e instrumento condicionadas a `p=6` permanecem
evidência datada e não foram reestimadas. O benchmark VAR em níveis continua
separado, na janela e no `p=4` do DFM desde 2026-09-21, com seus conjuntos
AR/MOSW próprios.

---

## Índice de itens abertos

Passo a passo fixado em 2026-10-15, em ordem de prioridade pelos e-mails do orientador de 14-10 e 12-10; substitui a ordem de 2026-10-13. Passos com o mesmo número se fazem juntos.
- **1–6: a conferência do e-mail de 14-10**, na ordem dele. Cada entrega (1, 3, 4 e 6) vai ao orientador quando ficar pronta, sem esperar as outras, e até o fim da conferência a apreciação do evento diário é provisória. O 2 sai cedo porque depende de um terceiro. O 5 é da entrega de 19/20, não depende da conferência e pode rodar em segundo plano desde o 1. O 1 fechou em 15-10 e o 2 em 16-10, com o envio da 1/4, da pergunta do CDS e das datas da Bloomberg (Fechados do Tema B). Esperam o orientador só a Bloomberg, no 3, e o 4; o resto da conferência não depende dele.
- **7: congelar e promover a base.** Decide-se com o resultado do 6, que pode mudar o instrumento, e desbloqueia 8–13.
- **8–13: o artigo**, da migração para a base nova até a conclusão, que depende da conferência. O texto que não depende de número (§3.2, Anexo A e duas frases) entrou em 17-10 na `focus`; o orientador deixou em 12-10 a atualização avançar em paralelo à conferência. Ao fim do 13 sai a entrega de 19/20: a ponte, já feita, o `p = 2` e o artigo.
- **depois**: decisões do autor fora da entrega. O e-mail de 12-10 não as pede e chama a rodada de última.

Branch sugerida: `focus` é `feature/focus-horizonte-fixo`, onde rodam os diagnósticos sobre a base do passo 0, como os passos 1 a 4 e as pontes; `nova` é uma branch criada a partir dela, porque a conferência 4/4 muda o instrumento e pode ser recusada; `main` recebe a escrita depois da promoção, que é um avanço rápido, porque `main` é ancestral de `focus`.

| Passo | Tema | Branch | Item | Observação |
|---|---|---|---|---|
| 3 | B | — | Receber as cotações da Bloomberg e conferir a hora do Yahoo | aberto em 2026-10-16; as 8 datas foram enviadas em 16-10 (`email_meu_16-10_12h53.md`); depende do conhecido do orientador; se a hora não for a inferida, muda `load_yahoo_brl()` e roda de novo `copom_timing.R` e o que lê `meetings.csv`; toca a conferência 2/4 |
| 3 | B | `focus` | Conferência 2/4: câmbio, PTAX e Yahoo nas janelas do e-mail | e-mail de 14-10; a apreciação depende da fonte ou da janela?; PTAX de quarta ao 1º dia útil seguinte (decisão do autor de 15-10, que reverte a de 14-10); Yahoo da linha de terça à de quinta pelo calendário do Yahoo (decisão do autor de 15-10), sem apresentá-lo como janela estreita; as duas janelas já estão em `meetings.csv` desde a 1/4; não trocar a série do DFM |
| 4 | B | `focus` | Conferência 3/4: CDS na janela ampliada, com as duas mudanças adjacentes | e-mail de 14-10; fechamento às 17h de NY (decisão do autor de 14-10, mantida em 15-10); leva o CDS do passo 2 (`daily_event.R`) às 17h de NY; a leitura saiu do e-mail de 17-10: a estreita mais uma variação de cada lado (`cds_widened_*` em `meetings.csv`, na branch `feature/auditoria-janelas-copom`); falta rodar a regressão |
| 5 | B | `focus` | Amostra completa com `p = 2`, resto do desenho fixo | e-mail de 12-10; entrega de 19/20-10; separa mudança de amostra de mudança de defasagem na comparação pré-COVID; ⚠ decisão do autor antes de rodar: θ̂ reestimado em `p = 2` ou o de `p = 4`; se o passo 7 mudar a base, rodar de novo |
| 6 | B | `feature/auditoria-janelas-copom` | Mandar ao orientador a tabela corrigida e a comparação das três bases | e-mail de 17-10, item 4; feito em 17-10, falta enviar; depois a convenção corrigida entra na ponte |
| 7 | B | `feature/auditoria-janelas-copom` | Rodar de novo na produção de 104 as saídas que leem o instrumento | aberto em 2026-10-17; ar_precision, evento diário, pontes, influência, placebos, grade, VAR, anexos; ⚠ ξ_mp pré-COVID 3,77; depende da promoção |
| 7 | B | `focus` → `main` | Passo 0/5: congelar a base (Focus a horizonte fixo, `msci` índice de emergentes) e promover | aberto em 2026-10-03; o orientador liberou em 12-10 atualizar o artigo com a base reconstruída; ⚠ congelar com ou sem as reuniões recuperadas depende do passo 6 e é decisão do autor, assim como congelar sem ele se o 6 não ficar pronto a tempo de 19/20; promover exige rodar de novo figuras, anexos e números do `.tex`, e muda o smoke test e `CLAUDE.md`; ⚠ `main` segue com a ação da MSCI Inc.; **bloqueia** 8–13 e os dois itens de "depois" |
| 8 | A | `main` | Atualizar o artigo com a base reconstruída, os novos conjuntos e os exercícios de sensibilidade | e-mail de 12-10, item 1; entrega de 19/20-10; §3.2 e Anexo A já descrevem a base nova desde 17-10 (branch `focus`), falta o que é número; a reconstrução preserva câmbio e CDS no impacto e enfraquece a reversão longa; reportar os horizontes definidos, inclusive os não significantes; ⚠ "o IPCA nunca fica positivo" (§4) deixa de valer |
| 9 | A | `main` | §3.3 e `fig:placebos` na base do passo 0: Holm, conjuntos pontuais e o índice de emergentes | e-mail de 12-10, item 4: Holm não é Wald conjunto, p sem ajuste ao lado do ajustado, MSCI em h0/h1/h3 visível e como limitação, ressalva do VIX em h0 |
| 9 | A | `main` | Escrever o p = 0,54 do teste do EPU como controle | e-mails de 30-09 e 12-10, item 4; ⚠ o teste só existe na branch `feature/placebo-epu`; a hipótese está na nota `2026-10-09_placebos_holm`, seção 5 |
| 10 | A | `main` | Influência das reuniões, exclusão por extremos e surpresa bruta no texto | e-mail de 12-10, item 1; sem as 10, conjunto = reta toda é inconclusivo, não zero nem robustez; explicitar a regra das 11 reuniões e que foi fixada antes (`2cad8bd`) |
| 11 | A | `main` | Anexo B e §3.3: linha diária com o câmbio realinhado | aberto em 2026-10-05; razão diária do câmbio 1,04 → 0,69, `Qr` p 0,003/0,084/0,147 → 0,002/0,064/0,081; ⚠ na base da branch a linha fatorial não rejeita nada a 10%; ⚠ depende da janela do câmbio que sair do passo 3 |
| 11 | B | `main` | Linha diária do Anexo B: CDS às 17h de Nova York | aberto em 2026-10-14; `het_conditions.R` ainda usa quarta → quinta; falta definir a janela das semanas sem reunião; ⚠ depende da janela do CDS que sair do passo 4 |
| 12 | A | `main` | Tabela com resultados antigos e novos lado a lado e lista de mudanças entre as versões | e-mail de 12-10, item 1, "para facilitar a revisão"; depois de 8–11, com os números finais |
| 13 | A | `main` | Conclusão: resposta conjunta do DFM mensal e apreciação no evento diário, sem atribuir a divergência | e-mail de 12-10, item 5; depende da conferência (passos 1–6), que deixa a apreciação diária provisória; a decisão do posicionamento cabe ao orientador |
| 13 | A | `main` | Decidir se o resumo, a introdução e a conclusão absorvem a leitura da §4 migrada | aberto em 2026-09-24; três frases de argumento enfraquecidas (horas "com defasagem", reversão "sincronizada" com curva e risco ainda no vale em h36, silêncio sobre atividade persistente e NFSP primária positiva) |
| 13 | A | `main` | Decidir se o resumo carrega as duas ressalvas da linha diária | aberto em 2026-09-22; vértice (§3.3) e curtose (nota de `tab:het_frequency`) estão no corpo e não no resumo; ⚠ a mesma frase atribui a divergência a frequência e estratégia de identificação |
| depois | B | — | Passo 3/5, parte 2, condicional: a mesma regra na variação de terça a quarta | aberto em 2026-10-12; pela letra da regra a condição se cumpre no câmbio (impacto 0,145 → 0,107, sem os 95%), não no CDS; rodar ou não é decisão do autor; ⚠ o e-mail de 12-10 não o pede |
| depois | B | — | Passo 5/5: apêndice com surpresa bruta, ortogonalizada e filtro JK | aberto em 2026-10-03; ⚠ reverte a saída do JK do paper (2026-09-26); ⚠ o e-mail de 12-10 não o menciona nem o põe na entrega de 19/20 |

---

## A. Texto do paper


*Inclui os achados do council review de `arquivo/tex/main.tex` (archived draft; `paper/paper.tex` is now canonical) em 2026-07-31 —
revisão paralela de três críticos independentes (harsh-referee e
macro-theorist em Claude Opus, methodologist via Gemini 3.1 Pro como par
cross-vendor). Veredito da síntese: **Major Revision**, não Reject — os dois
problemas de aparência mais fatal (sem benchmark VAR, sem bandas AR) pareciam
trabalho não feito, não defeito estrutural. O benchmark VAR foi rodado (ver
"Fechados" abaixo); a tentativa AR de 2026-08-10 foi retirada em 2026-08-12 e
está adiada nas condições do Tema B. Relatório completo:
`pareceres/council_2026-07-31.md`.*

*Segundo council review, agora sobre `paper/paper.tex` diretamente
(não mais o draft arquivado), em 2026-08-10 — painel macro-paper de 4
críticos (methodologist, macro-theorist, skeptic, harsh-referee, todos Claude
Opus). Veredito: **Major Revision**, mesma classificação do round anterior,
mas por razão diferente: três das quatro alegações-manchete do paper
(reversão sincronizada de médio prazo, nulo do bloco de ações, reconciliação
com GRG) são contraditadas por evidência que já está no próprio repositório,
não por falha nova de identificação. **O fato central sobrevive** — câmbio +
EMBI+/CDS conjuntos, sig90 no impacto — só a atribuição de mecanismo
("domina o diferencial de juros", "dominância fiscal") não. Achado mais
grave: `data/raw/fomc_dates.csv` nunca existiu, então a flag `fomc_coincide` que
o código computa é sempre FALSE por default vazio — **fechado no mesmo dia**
(ver Fechados abaixo): a exposição era ainda maior do que o council estimou
(24 dos 62 dias retidos, 35,5% de Σ|z|, 8 dos 20 de maior alavancagem), mas
o teste **não encontra contaminação**. Segue aberto o item factual de que
`sp500_vix` é só o VIX (o painel não tem nenhuma série de nível do S&P 500).
Relatório completo, com as quatro críticas brutas e a síntese com Named
Dissents: `pareceres/council_2026-08-10.md`.*

*Auditoria blindspot de `paper/paper.tex` em 2026-08-12 — auditoria de
percepção, não de código: o que a saída mostra e o texto não vê. Relatório
completo em `relatorio/blindspot_2026-08-12.md`, com os quatro quadrantes e a
distinção entre achado novo e item já registrado. Veredito: **HOLD**, por um
motivo estreito e concreto — o defeito de `slice_tail` na curva de juros (Tema E),
que atinge a variável de normalização. Os achados se espalham por quatro temas:
seis itens de redação abaixo, quatro de robustez no Tema B, uma perna já feita da
comparação do IPCA no Tema D e o bloqueador no Tema E. **Nada na auditoria
contradiz o fato central** — as cinco moedas, a janela pré-COVID e a constelação
dos placebos empurram câmbio + risco soberano na direção do paper.*

*Quatro itens transcritos em 2026-10-01 do e-mail do orientador de 30-09
(`email/email_professor_30-09_23h55.md`), resposta a `email_meu_30-09_22h25.md`; são os ajustes
antes de escrever a introdução e traduzir para a submissão. A conferência da figura de placebos foi
feita em 2026-10-13 (Fechados); os demais seguem abertos.*

- [ ] **Escrever o p = 0,54 do teste do EPU como controle.** O parágrafo de placebos da §3.3 diz, em
  palavras, que a resposta permanece com o EPU diário na ortogonalização, mas o p = 0,54 (a
  tendência de 13 semanas do EPU diário não prevê a surpresa do Copom) não está no texto nem nas
  tabelas. Pôr no corpo ou em nota. ⚠ O teste só existe na branch `feature/placebo-epu`
  (nota `2026-09-29_placebo_epu`, ausente de `main`); o número vem de lá, e o parágrafo hoje diz
  só o que a branch sustenta. O e-mail de 03-10 (passo 4) diz como escrever: explicitar a hipótese a
  que o p = 0,54 corresponde e, por ele testar o coeficiente do EPU na previsão da surpresa,
  descrevê-lo como ausência de evidência de poder preditivo naquela especificação, sem lê-lo como
  validação da exogeneidade. O passo 4/5 do Tema B fechou em 10-09, e a hipótese está escrita na nota
  `2026-10-09_placebos_holm`, seção 5: H0 β_EPU = 0 na regressão do DI de quarta a quinta, nas 102
  reuniões, em constante, nos nove preditores da produção e em `pre_epu`, t HC1 −0,61. Falta pôr no
  texto, junto com o item abaixo. O e-mail de 12-10 (item 4) pede de novo que o p = 0,54 seja
  explicado corretamente.
- [ ] **§3.3 e `fig:placebos` na base do passo 0.** Aberto em 10-09, no passo 4/5 do Tema B (nota
  `2026-10-09_placebos_holm`). O e-mail de 08-10 pede três coisas: manter a figura como descrição das
  respostas, com os conjuntos identificados como pontuais na legenda; não usar a contagem de pontos
  significantes como evidência conjunta; e escrever "não rejeitamos a hipótese de resposta zero após o
  ajuste por múltiplos testes", sem lê-lo como prova de exogeneidade. O parágrafo de `main` diz que o
  EPU é significante a 90% em h1–h3 e trata isso como limitação.
  - **Na base da branch desde 10-12** (`msci` = índice MSCI de emergentes, nota
    `2026-10-12_msci_emergentes`, seção 6):
    - Holm nos 18 testes não rejeita nada a 10% (menor p ajustado 0,575);
    - o EPU não é significante a 90% em horizonte algum;
    - o VIX é significante a 90% em h2, h5 e h6;
    - o índice de emergentes é significante a 90% em h0, h1, h3 e h4, sempre negativo, e em h1 rejeita
      a 5% sem ajuste (p 0,032).
  - ⚠ A rejeição pontual do índice de emergentes no impacto e em h1 tem de ser reportada e discutida.
    A rodada não separa o peso do Brasil no índice, uma piora comum aos emergentes e uma contaminação.
  - O paper já chama a série de "MSCI de mercados emergentes" (§3.2, §3.3, Anexo A, `fig:placebos`),
    o que passa a estar certo com a promoção. A fonte em `tab:lista_variaveis` muda de
    "Investing.com" para a MSCI.
  - O e-mail de 12-10 (item 4) aprova Holm e fixa a redação:
    - descrever Holm como controle das comparações pontuais dessa família, **não** como teste conjunto
      de Wald, e explicar por que o procedimento difere do teste conjunto por série discutido de início,
      sem implementar outro teste;
    - p-valores sem ajuste ao lado dos ajustados, com o índice de emergentes em h0, h1 e h3 visível;
    - manter a leitura: não rejeitamos resposta zero após o ajuste, o que não comprova exogeneidade e
      pode refletir pouca precisão;
    - a ressalva do VIX em h0 (o mês se sobrepõe à janela da ortogonalização);
    - a queda pontual do índice como limitação: o exercício não separa a participação do Brasil no
      índice, repercussões do choque brasileiro e exposição do instrumento a notícias comuns aos
      emergentes. Nenhum placebo novo agora.
  - Depende da promoção do passo 0 (Tema B). Escrever junto com o p = 0,54 do item acima.

*Quatro itens transcritos em 2026-10-13 do e-mail do orientador de 12-10
(`email/email_professor_12-10_19h40.md`, itens 1 e 5), resposta a `email_meu_12-10_17h22.md`. Ele
libera atualizar o artigo com a base reconstruída, em paralelo às verificações do Tema B. A versão
atualizada faz parte da entrega de 19/20 de outubro, com a ponte e a comparação com `p = 2`. Os dois
itens de placebos acima ganharam a redação do item 4 do mesmo e-mail.*

- [ ] **Atualizar o artigo com a base reconstruída, os novos conjuntos e os exercícios de
  sensibilidade.** Depende da promoção do passo 0 (Tema B), que reestima figuras, anexos e números do
  `.tex`. A interpretação muda: a reconstrução das Focus preserva as respostas iniciais de câmbio e CDS
  e enfraquece a reversão de longo prazo, que deixa de ser significante a 90% e segue a 80%. Reportar os
  resultados dos horizontes definidos, inclusive os que não são significantes. ⚠ "O IPCA nunca fica
  positivo" (§4) deixa de valer na base nova (passo 0 do Tema B).
  - **17-10, na branch `feature/focus-horizonte-fixo`:** o que não depende de número já está escrito. A
    §3.2 (`sec:dados`) descreve as seis Focus anuais a doze meses à frente pela aproximação de
    `dovern2012`, com a meta Selic nos três novembros, e o Anexo A troca "ano seguinte" por "12 meses à
    frente" e a fonte do MSCI para o índice 891800 da MSCI, em dólares. `dovern2012` é a 25ª chave citada,
    o teto do orçamento. Falta tudo o que é número (§3.4, §4, §5, anexos C e D), que espera a base
    congelada, e o que cita as 102 reuniões, que espera a conferência 4/4.
- [ ] **Tabela com os resultados antigos e novos lado a lado e lista das mudanças entre as versões.**
  O e-mail a pede "para facilitar a revisão"; não diz se vai no artigo ou na entrega a ele. A
  comparação célula a célula já existe (`compare_model()` e `compare_cells()` em
  `R/reporting/sensitivity.R`; nota `2026-10-12_msci_emergentes`). Depende do item acima.
- [ ] **Influência das reuniões, exclusão por extremos e surpresa bruta no texto.** Depende do passo 0.
  O que o e-mail pede que apareça:
  - influência: nenhuma inversão de sinal nos primeiros horizontes, mas a precisão cai sem as reuniões
    mais influentes. Sem as dez, os conjuntos são a reta toda e a inferência fica **inconclusiva**; não
    ler como resposta zero nem como confirmação de robustez (nota `2026-10-08_influencia_reunioes`);
  - a regra que definiu as 11 reuniões com movimento extremo de VIX, S&P 500 ou Brent, e que ela foi
    fixada e commitada antes de rodar (`2cad8bd`);
  - exclusão por extremos: o CDS fica relativamente estável e o câmbio perde magnitude e precisão,
    sobretudo nas exclusões ligadas ao Brent (nota `2026-10-12_exclusao_extremos`);
  - no DFM com a surpresa bruta, câmbio e CDS não são significantes a 90% (nota
    `2026-10-05_evento_diario`).
- [ ] **Conclusão: a resposta conjunta do DFM mensal e a apreciação no evento diário, lado a lado.** Por
  ora a conclusão registra as duas e não atribui a divergência a explicação alguma. A redação final
  depende da ponte do Tema B (o que ela permitir afirmar sobre onde a inversão aparece). Toca o item da
  leitura da §4 no resumo, na introdução e na conclusão (abaixo).
  - A ponte (a) fechou em 14-10 (nota `2026-10-14_ponte_trajetoria_evento`). Até a 20ª cotação depois
    do anúncio, o real deprecia R$ 0,122 por +50 p.b. de surpresa, significante a 95%, e a troca de sinal
    já aparece na trajetória diária.
  - A ponte (b) fechou em 14-10 (nota `2026-10-14_ponte_mensal_forma_reduzida`). Na forma reduzida mensal
    sem fatores, com as séries do DFM, o real deprecia R$ 0,145 no mês por +50 p.b. de surpresa,
    significante a 95%. ⚠ Com o câmbio de fim de mês, o ponto segue positivo (+0,115) e não é
    significante a 90%.
  - ⚠ O e-mail de 14-10 deixa a apreciação diária relatada provisória até a conferência do Tema B
    (1/4 a 4/4), que pode mudar a fonte e a janela do câmbio e a amostra de reuniões.

*Item aberto em 2026-10-05, no passo 2/5 do Tema B.*

- [ ] **Anexo B e §3.3: linha diária com o câmbio realinhado.** O câmbio foi realinhado em 10-13 na
  branch (Tema D, fechado; nota `2026-10-13_cambio_yahoo_convencao`, seção 7), e a razão e o `Qr`
  mudaram. Falta levar ao `.tex`.
  - Em `tab:het_frequency`, a razão de variância diária do câmbio vai de 1,04 a 0,69, 0,70 e 0,70. O
    `Qr` p vai de 0,003, 0,084 e 0,147 a 0,002, 0,064 e 0,081 (Holm 0,006, 0,127 e 0,127).
  - `n_C` e `n_NC` vão a 103 e 554.
  - A frase da §3.3 de que a condição vale no diário com o DI de 3 meses continua verdadeira, e a de que
    só a variância do DI sobe também. A sensibilidade ao vértice diminui.
  - ⚠ Na base da branch, a linha fatorial não rejeita nada a 10% (`λ₁ = λ₂` p 0,312, 0,228 sem
    correção; `λ₁=…=λ₄` p 0,240; `λ₁=…=λ₅` p 0,145). A nota da tabela, que imprime 0,035, 0,021 e
    0,013, muda com a migração da base (passo 8 do índice).
  - O VAR mensal não muda.
  - Vai depois da migração do artigo (passo 8), porque `output/het/` da branch já está na base
    reconstruída, e junto com o CDS às 17h de NY da mesma linha (Tema B).
  - ⚠ A janela realinhada vem da hora inferida do Yahoo, que o e-mail de 14-10 pede para não apresentar
    como janela estreita antes e depois do anúncio (conferência 2/4 do Tema B). A janela do CDS também
    pode mudar (conferência 3/4).

- [ ] **Decidir se o resumo, a introdução e a conclusão absorvem a leitura da
  §4 migrada.** A rodada de 2026-09-24 reescreveu a §4 e, fora dela, só trocou
  números e datas, por decisão do autor. Três frases de argumento ficaram
  enfraquecidas pela leitura nova e não foram tocadas: "o mercado de trabalho
  responde com defasagem" na conclusão, quando as horas caem 1,23% já no impacto,
  com 90% excluindo zero; a reversão "altamente sincronizada" do resumo, porque os
  cruzamentos vão de h11 a h16, mas curva e risco soberano ainda estão no vale em
  h36; e o silêncio do resumo e da conclusão sobre a atividade negativa por 36
  meses (IBC-Br com 90% de h6 a h24) e sobre a NFSP primária positiva e
  significativa de h18 a h32. Duas frases da conclusão foram corrigidas só no
  fato: as ações ficaram "sem resposta de impacto significativa em nenhum dos sete
  índices", e a inflação com repasse passou a ser a "inflação ao produtor".
  Decisão editorial. Nota: `notas/2026-09-24_migracao_secao_4.md` §5.
  Desde 2026-09-26 as três frases continuam no texto, com números
  novos:
  - as horas caem 1,37% no impacto, com 90% excluindo zero;
  - os cruzamentos vão de h11 a h17;
  - o IBC-Br tem 90% em h0 e de h3 a h25;
  - a NFSP primária é significativa de h16 a h33.

  A frase da conclusão sobre o câmbio foi reescrita, porque tinha ficado falsa:
  o conjunto de 90% volta a excluir zero de h32 a h36. Nota:
  `notas/2026-09-26_migracao_paper_bs_purif.md`.
- [x] **O que o resumo diz sobre frequência — RESOLVIDO em 2026-09-22.**
  O resumo deixou de explicar a divergência com `goncalves2025` pela frequência ou
  pela agregação e passou a situá-la na **condição de identificação**: ela vale nas
  três séries diárias e falha nas mesmas três séries no painel mensal. "As condições"
  virou "a condição de posto" nas duas línguas, que é o que Rigobon enuncia. Duas
  afirmações opostas foram **revertidas do registro** no mesmo dia: a de que a
  agregação temporal **vira o sinal**, que se apoiava na quarta vertente, e a de que
  ela **não é o obstáculo**, que se apoiava na linha da soma das janelas Qua→Qui
  dentro do mês — objeto retirado por decisão do autor. A única agregação mensal é a
  do painel, a última cotação do mês de referência.
  Nota: `2026-09-22_condicao_het_svars`.
- [x] **O que a §2 diz sobre o CDS de Gonçalves, Rodrigues e Genta — RESOLVIDO em
  2026-09-22.** `paper.tex` deixou de repetir "não apresenta resposta
  sistemática" e passa a reportar o fechamento de 3 a 11 p.b., com o vértice de doze
  meses distinto de zero, registrando que os autores o descrevem como ausente. A
  unidade inferida fica documentada em `het_rigobon/_common.R` e no relatório
  `01_daily_grg.md`, não no corpo do artigo. Isto **reforça** o contraste: o DFM dá
  +30,5 p.b. de alargamento onde o diário identificado dá fechamento.
- [ ] **Decidir se o resumo carrega as duas ressalvas da linha diária.**
  Desde 2026-09-22 os dois sistemas usam **as séries de GRG** — DI, câmbio e CDS de 5
  anos. ⚠ Antes disso o projeto chamava de "linha diária publicada" um conjunto com
  DI de 2 anos e Ibovespa, que **não são de GRG**; o erro foi corrigido e a
  `tab:het_frequency` refeita. Duas ressalvas existem e **não** estão no resumo: o
  **vértice** decide no diário (p 0,0033 / 0,0844 / 0,1474 em 3, 6 e 12 meses,
  acompanhando a queda da razão de variância do DI com a maturidade nos próprios GRG),
  e a **correção de curtose** do teste também (÷4,9; sem ela as três células diárias
  rejeitariam). Desde a exclusão da §5.1 (2026-09-24) e a reescrita da §3.3 (2026-09-26),
  o vértice viaja no corpo, na cláusula "embora o resultado dependa do vértice", e a
  curtose, nas colunas corrigida e não corrigida de `tab:het_frequency`, no Anexo B.
  O resumo (`paper.tex:111`) diz que a condição "holds daily but fails in our monthly
  panel" sem qualificar nenhuma das duas. Decisão editorial.
  ⚠ A mesma frase do resumo atribui a divergência a "frequency and identification
  strategy". A decisão de 2026-09-22 proíbe afirmação que decomponha frequência e objeto
  medido, e o resumo de `CLAUDE.md` a situa na condição de identificação.
  ⚠ Fica registrada uma **lacuna de dados**: a quarta série de GRG é o *breakeven* de
  inflação entre títulos indexados e nominais, que este painel não tem. A medida
  disponível é a do Focus, que é survey — eles dizem "market-based (not survey data)" —
  e cuja variação diária é exatamente zero em 23% dos dias. Construir o breakeven a
  partir de NTN-B e LTN é uma rodada de dados, não editorial.
  Nota: `2026-09-22_condicao_het_svars`.
### Fechados (contexto)

- [x] **Frase do Anexo C sobre `fig:lp_sensibilidade` e ponteiro da §3.4 — 2026-10-17.** Branch
  `feature/focus-horizonte-fixo`, só texto. A nota de rodapé da §3.1, a que o orientador leu (e-mail de
  30-09, item 4), diz agora que a figura cruza o estimador (com a reescala e por mínimos quadrados
  ordinários) com `q` de 2 a 5. A legenda já dizia isso e ficou. A frase de `fig:precovid_sensibilidade`,
  partida em `b0a3a10` entre a §3.3 e a §3.4, voltou inteira ao fim do parágrafo de `tab:first_stage`.
- [x] **Figura de placebos no `.tex` conferida — 2026-10-13.** O orientador (e-mail de 30-09) dizia
  que `\autoref{fig:placebos}` não tinha figura nem rótulo. No `paper.tex`, `\includegraphics` e
  `\label{fig:placebos}` estão no Anexo D desde `1a150d0`, o PDF existe em `paper/img/`, o `paper.aux`
  resolve o rótulo (figura 15, p. 31) e o `paper.log` não tem referência indefinida. A versão que ele
  leu era anterior ao commit. ⚠ Conferência estática, sobre o log de 30-09; não recompilado.
- [x] **Rodapé sobre a saída do filtro Jarociński-Karadi — 2026-09-30.** Na §3.4: o filtro reduz
  ξ_mp de 7,02 para 5,01 (pré-COVID, 6,84 para 4,73) e F_rob de 8,62 para 7,59 (8,31 para 7,78),
  nenhum ponto sai do conjunto de 90% de produção (0/4255), e os pares significativos a 90% caem de
  1587 para 856. A §1 e os resumos, que `6e0bc00` tinha devolvido à descrição com o filtro, voltaram
  à de 26-09. ⚠ Com o filtro o impacto no Ibovespa exclui zero (−8,17%), em parte por construção, e
  o rodapé não o diz; o "3.64%" do resumo em inglês segue no item de resumo e conclusão acima.
  Branch `feature/robustez-pandemia`. Nota: `2026-09-30_nota_filtro_jk`.
- [x] **Sensibilidade a `q` com e sem a reescala de Lenza-Primiceri no Anexo C — 2026-09-30.**
  `script/pandemic_sensitivity.R` e `fig:lp_sensibilidade`: `q` de 2 a 5 em duas colunas, com a
  reescala e por MQO, uma linha de painéis por série, cada `q = 5` com os próprios conjuntos AR.
  Rodapé na frase de MQO da §3.1, nenhum número no corpo. Nas oito séries do anexo, 4, 26 e 26 de
  296 pontos de `q = 4`, 3 e 2 saem do conjunto de 90% com a reescala, contra 44, 132 e 154 sem
  ela (painel: 151/420/408 contra 589/1651/1805 de 4255). ⚠ Com a reescala as respostas não são
  insensíveis a `q`: em `q ≤ 3` o câmbio sai do conjunto de h0 a h9 e a DBGG de h0 a h7, e o
  impacto da DBGG troca de sinal. Em `q = 5` nenhum ponto de MQO sai do conjunto da produção
  (0/4255). Branch `feature/robustez-pandemia`. Nota: `2026-09-30_robustez_pandemia`.
- [x] **As oito séries das figuras do Anexo C — 2026-09-30.** Por decisão do autor, as cinco
  figuras desenham DI de 6 meses, DI de 2 anos, BRL/USD, CDS, Focus PIB, Focus IPCA 12 meses,
  Focus Selic e DBGG, no lugar de DI de 5 anos, IBC-Br, IPCA, Ibovespa e DLSP. Nada reestimado.
  ⚠ A figura pré-COVID deixa de mostrar atividade, preços e ações, que saem do conjunto em 12 a
  21 dos 37 horizontes. Nota: `2026-09-30_robustez_pandemia`, seção 6.
- [x] **Placebos na §3.3 e figura no Anexo D — 2026-09-30.** Desfecho "limitação reconhecida",
  em quatro linhas por decisão do autor: nos dois primeiros anos só o conjunto de 90% do EPU dos
  EUA exclui zero (h1–h3), e a resposta permanece com o EPU diário pré-reunião na ortogonalização
  (Tema D). `fig:placebos` foi para o Anexo D, depois da `tab:bs_ortogonalizacao`. As demais
  leituras (VIX e MSCI nulos no impacto, projeção local da série bruta) ficaram só na nota.
  Commit `1a150d0`. Nota (só na branch `feature/placebo-epu`): `2026-09-29_placebo_epu`.

- [x] **Paper migrado para a produção da branch — 2026-09-26, na branch, promovido
  para `main` no mesmo dia.**
  `z_bs_purif`, conjuntos de 80/90% e, por decisão do autor, o filtro JK fora do
  paper inteiro (§2, §3.3, linha 3 da `tab:first_stage`, coluna do Ibovespa da
  `tab:bs_ortogonalizacao`, camada JK da `fig:instrumento_camadas`). ξ_mp 7,02 / 6,84,
  BRL/USD 3,53%, CDS 34,0 p.b.; 143 + 20 números da §4 e da §5 conferidos contra o
  cache; sete passagens reescritas (ajuste cambial contém zero a 80%, IMAT
  negativo no impacto, câmbio de volta a 90% em h32–h36 na conclusão). Promovido
  para `main` no mesmo dia. Nota: `2026-09-26_migracao_paper_bs_purif`.

- [x] **Bandas das IRFs em 80/90%, como em AK, do lado do código — 2026-09-26,
  na branch.** `CI_LEVELS`, o default de `main_sdfm()`, as colunas `*80` de
  `irf_coherence_h.csv` e `instrument_layers_irf.csv`, as faixas das figuras e o
  benchmark VAR (`model_var.R`, `fig_weak_iv.R`) passaram a 80/90%;
  `validate_mosw_ar.R` fica em 68/95%, os níveis do oráculo. Todos os conjuntos
  seguem `interval` a 80 e 90% (2841 + o `singleton` da normalização). O lado do
  paper está no item de migração acima. Nota:
  `2026-09-26_producao_bs_purif_bandas_80_90`.

- [x] **`q = r` justificado na §3.1 e sensibilidade a `q` no Anexo C —
  2026-09-24.** Defesa em duas frases, ancorada em Stock-Watson (2016, §7.2) e AK,
  com Amengual-Watson citado (24 de 25 chaves; a entrada já estava no `.bib`, só
  não era citada). Por decisão do autor, o texto não cita números. ⚠ Em `q ≤ 3`
  câmbio, CDS e Ibovespa se ampliam (Ibovespa 8,6× em `q = 3`), e o modelo sem LP
  fica fora do paper. Nota: `2026-09-24_q_sensibilidade_anexo`.

- [x] **§4, suas oito figuras e `irf_section.md` migrados para a produção
  corrente, com a leitura das IRFs sob a escala LP — 2026-09-24.** Nada foi
  reestimado. `fig_section5.R` perdeu a trava, a legenda *wild bootstrap* saiu, e
  a contradição com a §5.2 some (BRL/USD 3,23%, CDS 30,5 p.b.). A leitura mudou:
  o IBC-Br não fica positivo em 36 meses, e o IPCA não fica positivo em nenhum
  horizonte. ⚠ A fase positiva das ações e a NFSP primária em h18–h32 são
  significativas a 90% e estão no texto. Nota: `2026-09-24_migracao_secao_4`.

- [x] **Resumo corrigido nas duas línguas — 2026-09-21.** Dizia que a importância
  do canal "pode depender da frequência dos dados e da estratégia de identificação";
  agora reporta que a frequência **não** explica a divergência com `goncalves2025`,
  porque as mesmas séries agregadas ao mês preservam as duas condições. ⚠ Fechou junto
  com a correção do mecanismo da §5.1: a condição de posto nunca falhou na coluna
  identificada (gap λ₁--λ₂ de 0,74 / 0,76 / 0,55), e o 0,10 antes publicado é o par
  (2,3). Nota: `2026-09-21_migracao_secao_5.md` §6.5.
  ⚠ **Superado em 2026-09-22**: o resumo não diz mais que a frequência não explica a
  divergência, e a linha das séries agregadas ao mês que sustentava a frase não existe
  mais. Ver o item `O que o resumo diz sobre frequência`, acima.

- [x] **`fomc_coincidence.R` marcado de vintage — ARQUIVADO em 2026-09-18**
  (autor), no lugar de reexecutado. **A §5.3 foi EXCLUÍDA do paper em 2026-09-21**
  (decisão do autor, `notas/2026-09-21_migracao_secao_5.md`), o que encerra a
  pergunta que a rodada editorial teria de decidir. Os números seguem em
  `output/instrument/fomc_coincidence.md` (janela 2013-01, 62 dias, commit
  `08ccff3`), e a ressalva de 2026-08-24 continua valendo no registro: a máscara
  global rederivada derruba `ξ_mp` para 3,671. Os p-valores que a §5.3 citava
  vinham do wild bootstrap das regressões diárias
  (`arquivo/R/instrument/event_tests.R`, arquivado junto); o bootstrap do DFM
  só entrava na seção de IRFs, que o paper não usa. As outras rodadas
  OLS deste item (`jk_sovereign_confound.R`, `fiscal_*`,
  `q_narrative_overlay.R`) foram arquivadas em 2026-09-17, e `ar_bands.R` em
  2026-09-18 (`arquivo/README.md`).
- [x] **Equações do tratamento de volatilidade COVID — sem apêndice, FEITO em
  2026-09-17.** Nenhuma equação de Lenza-Primiceri muda de forma no DFM: `F̂_t`
  ocupa o lugar de `y_t`, `r` o de `n`, e as (B1)-(B5) valem letra por letra.
  Pela decisão de 2026-09-16, isso é corpo mais nota de rodapé, não apêndice.
  A §3.1 ganhou `s_t` na eq. (5), a trajetória como eq. (5b) e a nota com a
  eq. (1) dos autores; a §3.6, as ressalvas de plug-in em θ̂ e do gate
  `hac_dim`. Nota: `notas/2026-09-17_volatilidade_covid_producao.md`.

- [x] **Apêndice das equações MOSW→DFM descartado, mapeamento no corpo —
  2026-09-16.** Decisão do autor: a extensão é troca de vetor, não derivação
  nova, e quem conhece MOSW reconstrói a adaptação sozinho. A §3.6 reporta em
  prosa que só mudam os vetores da razão identificada (`c_j' = sy_j·Λ_j'` e
  `c_mp'` no lugar dos coordenados), e a nota põe as duas equações lado a lado
  (`e_i'C_h(A)Γ/e_1'Γ` contra `δ·c_i'B_hΓ/c_mp'Γ`, com `KK'=I` porque `q=r`).
  Sem equação no corpo, também por decisão do autor: a razão é trivial para
  quem conhece IRF de DFM. Nota:
  `notas/2026-09-08_bandas_anderson_rubin_producao.md`.
- [x] **Expectativas fiscais Focus — teste isolado, 2026-09-01.** DLSP e
  resultado primário/nominal em nível ampliam o painel para 114 séries sem
  tocar produção; ξ_mp sobe de 5,24 a 5,81 (ainda < 10); DLSP e nominal
  esperados caem, sem sinal de deterioração fiscal esperada. Nota:
  `notas/2026-09-01_teste_expectativas_fiscais.md`.
- [x] **Revisão integral do paper — 2026-08-25.** Resumo a conclusão migrados
  para 111 séries `(5,5,4)`; manchetes 3,74%/24,5pb/30,7pb/74,8pb; prosa
  defensiva sobre UIP/dominância fiscal removida. Fonte: `paper/paper.tex`.
- [x] **Diagnósticos de máscara condensados na exposição — 2026-08-25.**
  Risco soberano e FOMC mostram só a máscara fixa; rederivação fica nos
  artefatos e no registro metodológico.
- [x] **§3-5 sincronizadas com a produção `p=4` — 2026-08-25.** Texto apenas,
  sem nova estimação. Nota: `notas/2026-08-25_sincronizacao_secoes_3_5_p4.md`.
- [x] **Diagnóstico MOSW qualificado como diagnóstico, não inferência —
  concluído.** Introdução e §3.6 tratam ξ_mp via \cite{montielolea} sem
  transferir cobertura AR ao DFM. Nota: `notas/2026-08-22_var_olea_estacionario.md`.
- [x] **Robustez weak-IV integrada à §5 (`sec:weak_iv`) — concluído.** DFM
  `p=4` separado do benchmark em níveis (`p=2` AIC, AR/MOSW 68/90% NW(0)).
  Nota: `notas/2026-08-22_var_niveis_aic_tendencia.md`.
- [x] **Invertibilidade separada da exogeneidade na §5 — concluído.** Ancorada
  em \cite{stockwatson2018}; regressões sobre inovações futuras dão
  0,771/0,550, Granger `p_boot` mínimo 0,268 — necessário, não suficiente.
- [x] **Máscaras rederivadas mantidas como diagnóstico, não exposição
  principal.** Soberano: ξ_mp 5,80→3,44 rederivado. FOMC: 5,33→3,67. Paper
  reporta só a seleção fixa.
- [x] **Comparação cambial na mesma base de choque — concluído.** 3,74%/50pb
  e 7,48%/100pb contra 3,4-5,6% de \cite{goncalves2025}, diferenças de desenho
  explicitadas.
- [x] **§4 migrada para 111 séries `(5,5,4)` — conferida 2026-08-25.** Seis
  subseções e legendas do CSV/cache correntes; cautela de `xi_mp=5,24`
  mantida.
- [x] **Selic, horizonte comum, cinco moedas em §4 — concluído.** Selic +24,1pb
  no impacto, CDI fora; manchetes em `h=0`; USD/EUR/CNY/INR/ARS em % da média.
- [x] **Agregados monetários omitidos — decisão editorial.** Bloco heterogêneo
  na produção corrente, sem parágrafo ou figura na §4.
- [x] **Reversão de médio prazo qualificada — concluído.** §4 trata como
  dinâmica conjunta sensível a `p`, não como modo quase unitário isolado nem
  confirmação de mecanismo. Fonte: `output/factors/factor_stationarity.md`.
- [x] **Preços reescritos sem antecipar a comparação cross-instrumento —
  concluído.** IPP imediato separado dos preços ao consumidor, sem rotular
  *price puzzle*; frase-marcador substituída pelo resultado do Tema D.
- [x] **Bloco acionário e IMAT reescritos.** Sete índices em retorno mensal
  sem acumulação, impactos entre −2,70% e −0,07%; amortecimento do IMAT
  associado a receita em dólar.
- [x] **Sem parágrafo/subseção de Limitações — decisão do autor, 2026-08-18.**
  Cautelas (instrumento fraco, reversão, preços, crédito, câmbio) ficam nas
  passagens substantivas correspondentes.
- [x] **Exogeneidade lead-lag: procedência resolvida, condição testada —
  2026-08-14.** É a Condição LP-IV (iii) de \cite{stockwatson2018}
  (*lead-lag exogeneity*), não Braun-Brüggemann; não é exigida pelo SVAR-IV
  (paga em invertibilidade). Teste canônico implementado (`01_exogeneidade.R`
  §1.7): **não rejeita**, `p_boot` mínimo 0,324 em `L=6`. ⚠ Condição só
  necessária, potência baixa (n=147); ⚠ `cambio_usd` defasado em `p_boot`
  0,064, único do bloco externo abaixo de 0,10 e fora dos preditores BS. Nota:
  `notas/2026-08-14_exogeneidade_lead_lag_e_invertibilidade.md`.
- [x] **Limiar "≥10" reatribuído — não é Montiel Olea-Stock-Watson —
  2026-08-14.** §3.6 chama de referência convencional do F de primeiro
  estágio 2SLS, não valor crítico MOSW da Wald robusta.
- [x] **Placebo `sp500_vix` corrigido na prosa — 2026-08-14.** §5.1 não cita
  mais S&P 500 (painel só tem VIX); acrescentar um nível do S&P 500 é item
  aberto no Tema B.
- [x] **Contradição resumo/§4.2 sobre reversão cambial — superada.** Resumo já
  não chama a reversão de sincronizada; interpretação refeita para `(5,5)` na
  migração da §4.
- [x] **Diagnóstico de relevância simplificado, alinhado a MOSW —
  2026-08-13.** Só ξ_mp e F_rob,mp (HC1) na mesma direção de normalização;
  migração para `(5,5)` deu 6,27/10,12 e 10,99/9,75. Fonte:
  `output/instrument/olea_alignment_audit.md`.
- [x] **Grade de $(r,q)$ incorporada — 2026-08-12, superada em 2026-08-13.**
  `tab:rq_sweep` mostrou platô em (7,5)-(8,6); (7,6) ficou congelado até a
  seleção conjunta adotar 111 séries `(5,5)`. Fonte:
  `output/instrument/mosw_strength_grid.csv`.
- [x] **Coincidência FOMC redigida no paper — 2026-08-12.** `sec:fomc` reporta
  exposição, timing, testes 0-3, confound não detectado. Fonte:
  `notas/2026-08-10_coincidencia_fomc.md`.
- [x] **Quatro correções pontuais em §3.4-§3.6 — auditadas e aplicadas,
  2026-07-26.** Variante BS-predeterminado + JK explicitada; frase obsoleta de
  (6,5) removida; correção de Kilian confirmada correta; validação de Olea
  comentada.
- [x] **Abstract, Introdução e Conclusão — rewrite, 2026-08-01.** Resumo:
  depreciação 5,55% BRL/USD, EMBI+/CDS em alta, curva até 5 anos; conclusão
  trata divergência com GRG (2025) como aberta. **Achado à parte, não
  corrigido:** §3.2/Anexo A ainda descrevem a curva como ajustada por Svensson
  em código do projeto — `script/yield_curve.R` foi deletado em 2026-07-26 e
  `yields_dia.csv` é hoje insumo externo fixo do orientador.
- [x] **Revisão de literatura §2 — reescrita, 2026-07-28.** Trilha
  não-fundamentalidade → FAVAR/DFM → AK → Mertens-Ravn → Stock-Watson →
  Gertler-Karadi → JK+BS → MOSW → GRG (2025). Chaves novas: `goncalves2025`,
  `bagliano1998`. Fora por decisão do autor: Bonomo-Martins, Blanchard (2004).
- [x] **§5 Robustez escrita no `tex/main.tex` — 2026-07-29/30.** Prosa com
  IC90, 9 figuras. Três erros corrigidos ao promover blocos comentados: a
  cronologia de reversão câmbio/EMBI/CDS **não inclui o câmbio**;
  `trab_pop_ocupada` sig68 positiva contra a previsão; `commodity_metal`
  corrigido para +3,43% (era erro de unidade). Detalhe: `irf_section.md` §5.7.
- [x] **Regra de dois níveis em §4/§5 — 2026-07-30.** 68% excluindo zero vira
  *direção e magnitude* (nunca "significativo"); 706 pares a 68% contra 92 a
  90%, todos h≤12. Fato inconveniente no corpo: IBC-Br não acompanha o vale
  setorial (só h0 sig68).
- [x] **Confound soberano no filtro JK — não confirmado, 2026-07-31, repetido
  em CDS diário 2026-08-09 com mesmo veredito.** ΔEMBI carrega a surpresa com
  coef 0,326 em dias comuns contra 0,099 nos 62 dias retidos; interações
  `x:1(jk_bs)` negativas nas quatro proxies de risco. ⚠ Coeficiente nos 62
  dias é positivo e marginal (p=0,097) — "menos risco", não "zero risco".
  Nota: `notas/2026-07-31_confound_soberano_jk.md`,
  `2026-08-09_confound_soberano_cds.md`.
- [x] **Redação do confound soberano em `paper/` — 2026-08-09, reescrito
  2026-08-10.** §5.2 `sec:confound` com as três ressalvas no corpo. Máscara
  JK re-derivada nos resíduos ortogonalizados (`z_jk_bs_norisk_mask`): 50/62
  dias sobrevivem, ξ_mp cai a 4,26 (produção 7,58 só nos valores) — sustenta
  direção, não intervalo. Fonte: `notas/2026-08-09_confound_soberano_cds.md`.
- [x] **Benchmark VAR pequeno substituído integralmente — 2026-08-22.** IPCA
  em nível, BIC `p=1`, `C_h B_1`, AR 68/90% NW(0); superado no mesmo dia como
  benchmark do paper. Nota: `notas/2026-08-22_var_producao_unica.md`.
- [x] **Estacionariedade dos fatores, cointegração e espectro — 2026-07-31.**
  4/7 fatores I(1), nenhum I(2); posto de cointegração não identificado → VAR
  em nível mantido (Sims-Stock-Watson 1990). Par dominante complexo, |λ|=0,977.
  ⚠ Apagar esse par inverte o sinal do vale de médio prazo em 12/14 séries
  (`cambio_usd` é a exceção que sobrevive). Nota:
  `notas/2026-07-31_estacionariedade_fatores.md`.
- [x] **Camada de citação estrutural — três correções, 2026-08-01.**
  Cooley-Quadrini reescrito para não atribuir heterogeneidade setorial a
  patrimônio/porte; Castelnuovo-Nisticò reposicionado como argumento para
  incluir o Ibovespa entre os preditores BS predeterminados.
- [x] **`juros_selic`/`juros_cdi` não são evidências independentes —
  2026-08-01.** Divergem só no 3º dígito; citar as duas como confirmação
  cruzada seria erro. `paper/paper.tex:335`.

---

## B. Robustez estatística a fazer

*Cinco itens transcritos em 2026-09-08 em ordem do último email do
orientador (`email/email_professor_04-09_16h42.md`), que fundamenta a
hipótese de que correlação intra-bloco subestima `r` e `q` em Boivin & Ng
(2006, JE 132(1), 169-194). A sugestão 5/5 foi feita no mesmo dia; a 1/5, a 2/5
e a 3/5, em 2026-09-10. As quatro estão fechadas abaixo. A 4/5 (`r=q=8` como
especificação principal) foi removida em 2026-09-24 por decisão do autor, sem
ser executada. Os itens que estavam aqui antes da zeragem de
2026-09-08 (reavaliação do canal de prêmio de risco, purificação FOMC
intradiária, sensibilidade sem superquarta, placebo S&P 500, decomposição
diário-vs-mensal da curva, discriminação choque-vs-Λ, leave-one-out sobre a
IRF, tabela cross-instrumento do bloco-manchete, preditor fiscal em
Bauer-Swanson) não foram executados, testados nem decididos — apenas
removidos do registro. Recuperáveis no histórico do git.*

*O item abaixo transcreve o passo 2/4 dos "próximos passos coordenados" do
e-mail do orientador de 2026-09-13 (`email/email_professor_13-09_10h45.md`),
resposta às sugestões 1/5, 2/5 e 3/5 acima (fechadas em 2026-09-10). Os passos
3/4 e 4/4 estão fechados abaixo; o 1/4 foi removido em 2026-09-24 por decisão
do autor, sem ser executado.*

*Plano do e-mail do orientador de 03-10 (`email/email_professor_03-10_11h31.md`), transcrito em
2026-10-03. É uma única rodada de verificações para decidir a submissão. Ele não pretende demonstrar
a exogeneidade do instrumento nem que o risco causa a depreciação: quer avaliar se a interpretação
monetária da resposta conjunta continua convincente diante de contaminação, imprecisão e pandemia.
**A ordem importa, porque o passo 0 pode mudar os fatores.** Os passos 0 a 4 rodaram (Fechados, abaixo).*

*Critério de decisão, combinado antes de rodar:*
- *Avaliam-se juntos a magnitude, a precisão, a relevância do instrumento e a estabilidade da resposta
  inicial de câmbio e CDS. Os horizontes posteriores só caracterizam persistência e reversão, sem
  exigir que o sinal se mantenha.*
- *Resposta inicial com suporte estatístico e economicamente estável nas verificações: avança-se para
  a submissão, com uma conclusão delimitada.*
- *Padrão mantido, mas precisão limitada ou menor nas subamostras: ajusta-se a linguagem e avalia-se se
  a evidência ainda sustenta uma contribuição publicável.*
- *Poucos eventos determinam o resultado, ou surgem divergências precisas e substantivas entre
  desenhos comparáveis: investiga-se antes de submeter. Inversões pontuais acompanhadas de grande
  incerteza não são tratadas isoladamente como invalidação.*
- *Reportar os conjuntos de 90% e 95%, sem transformar um nível específico em critério automático de
  submissão. **Reportar tudo o que rodar, inclusive o que não ficar bom.***

*O e-mail deixa para depois, fora desta rodada: o instrumento alternativo (extensão), os números da
DBGG e a agregação temporal completa.*

- [ ] **Passo 0/5: congelar a base.** Reconstruir as séries, comparar com as originais e reestimar o
  caso base completo, com fatores, identificação e IRFs. Primeiro reportar quanto mudam câmbio e CDS,
  e só depois congelar essa versão para os demais exercícios.
  **Rodado em 2026-10-03** na branch `feature/focus-horizonte-fixo`, não mergeada (nota
  `2026-10-03_focus_horizonte_fixo`, saídas em `output/focus_fixed_horizon/`). Decisões do autor: a
  fórmula do e-mail, que é a eq. (1) de Dovern, Fritsche e Slacalek (2012) com o timing da Focus (eles
  dão 2/12 ao ano corrente em novembro, porque a Consensus responde na primeira quinzena, e a fórmula
  dá 1/12); as seis séries; a meta Selic da última reunião do ano em nov/2012, 2013 e 2015; colunas
  `_12m`. Câmbio R$ 0,141 → 0,146 e CDS 34,0 → 33,9 p.b. no impacto, conjunto de 90% excluindo zero
  em h0–h5 e h0–h6; a reversão de h28–h36 deixa de excluir zero a 90% e continua a 80%. No painel,
  37/4255 pontos saem do conjunto de 90% antigo, e os pares significativos a 90% caem de 1588 para
  1051, 488 das perdas em h25–h36. ξ_mp 7,02 → 6,80 completa e 6,84 → 5,50 pré-COVID.
  - **Base reestimada em 2026-10-12** (nota `2026-10-12_msci_emergentes`). A série `msci` passou da
    ação da MSCI Inc. ao índice MSCI de emergentes, e as outras 114 séries ficaram bit-idênticas. Os
    passos 0 a 4 rodaram de novo:
    - θ̂ (7,51; 14,88; 1,42; 0,967); ξ_mp 6,66 completa e 5,60 pré-COVID;
    - câmbio 0,145 e CDS 33,5 p.b. no impacto;
    - nenhum ponto de outra série fora do conjunto de 90% do passo 0;
    - pares significantes a 90% de 1051 para 1132.
    
    Os números correntes da base são esses, e a seção 1 da nota do passo 0 dá o efeito das Focus.
  - O orientador viu câmbio e CDS (nota do passo 0, seção 1, e nota de 10-12, seção 2) e, em 12-10,
    liberou atualizar o artigo com a base reconstruída (`email/email_professor_12-10_19h40.md`).
  - Falta o autor congelar e promover. Promover muda o smoke test, `CLAUDE.md`, as notas e os números
    do paper, e exige rodar de novo as figuras do paper e os anexos, que na branch seguem na base de
    `main` (nota do passo 0, seção 9).
  - ⚠ `main` segue com a ação da MSCI Inc. no painel de produção, nos anexos, em `paper/img/` e nos
    números do `.tex`. A troca entra com a promoção.
  - ⚠ `download.R` desta branch não lê mais `data/raw/investing/msci.csv` e escreve 112 séries. Rodá-lo
    aqui tira a `msci` do `raw_data.csv` compartilhado, e o `clean.R` de `main` fica com 114 séries.
    A `msci` da branch vem do estágio `msci` (`data/raw/msci_em.csv`).
  - ⚠ "O IPCA nunca fica positivo" (§4) deixa de valer: positivo em h1 e h3–h7, máximo +0,038 p.p.
  - ⚠ `data/processed/` é o mesmo para todas as branches: ao voltar a `main`, rodar
    `Rscript script/run_all.R --only=clean` antes de estimar.
  - ⚠ A conferência 4/4 (abaixo) pode mudar o instrumento desta base: as 2 reuniões de Thanksgiving
    entram com a janela habitual, e os 7 meses de feriado saem dos momentos de Γ. Congelar antes ou
    depois dela é decisão do autor.
  - **Bloqueia** o passo 5/5, a parte 2 condicional do passo 3, o item do Tema A sobre §3.3 e
    `fig:placebos` e os itens do Tema A abertos em 10-13 (artigo atualizado, tabela antigo × novo,
    influência e extremos no texto). Os passos 1 a 4 já rodaram sobre esta base, em 10-05 a 10-09, antes de ela ser
    congelada, e de novo em 10-12, com a `msci` sendo o índice (Fechados, abaixo).
- [ ] **Passo 3/5, parte 2, condicional: a mesma regra na variação de terça a quarta.** Depende do
  passo 0. A regra fixada em 10-12 (`2cad8bd`) manda rodá-la só se câmbio ou CDS caírem sem as
  reuniões marcadas. Pela letra, a condição se cumpre no câmbio: o impacto cai de 0,145 para 0,107 e
  perde os 95% em todo horizonte. O CDS não cai (nota `2026-10-12_exclusao_extremos`, seção 4). Rodar
  ou não é decisão do autor.
  - Desenho já fixado: a mesma regra (percentil 95 da |variação| de S&P 500, VIX e Brent nos pregões
    de 2012-03 a 2025-12) aplicada à variação de terça a quarta, inteira antes do anúncio. Ela separa
    notícia na janela de um regime turbulento. É o "problema concreto" que o e-mail de 08-10 exige para
    acrescentar uma verificação.
  - ⚠ Não selecionar reuniões por câmbio, CDS, índice de emergentes, DXY ou EMBI.
  - ⚠ O e-mail de 12-10 não pede esta verificação: pede só que o texto explicite a regra das 11
    reuniões e que ela foi fixada antes, sugere "apenas duas verificações" (a ponte) e chama a rodada
    de última.
- [ ] **Passo 5/5: apêndice.** Depende do passo 0. Respostas de câmbio e CDS com a surpresa bruta, o
  instrumento ortogonalizado e o filtro de Jarociński-Karadi, com intervalos. O orientador diz que "já
  está estimado e é barato", e avisa que o filtro não separa um choque de risco de um monetário (os dois
  podem elevar o DI e derrubar a bolsa), então **não é argumento central de identificação**, o que o
  rodapé da §3.4 já diz.
  - ⚠ **Reverte a decisão de 2026-09-26** de tirar o filtro do paper inteiro, salvo esse rodapé.
    Reabrir é do autor.
  - ⚠ As linhas JK só existem na história do git (`3b9e402`, `output/irf/instrument_layers_irf.csv`).
    O CSV atual só tem `z_bruto` e `z_bs_purif`, e `instrument_layers_irf.R` não cita mais
    `z_jk_bs_purif` (`c3a6536`).
  - ⚠ "Já estimado" só vale se o passo 0 não mexer nos fatores; se mexer, reestimar. O passo 0 mexeu
    (θ̂ e fatores novos; ξ_mp de `z_jk_bs_purif` 5,01 → 4,83 na completa), então reestimar.
  - Já no registro (nota `2026-09-30_nota_filtro_jk`): ξ_mp 5,01 / 4,73, F_rob 7,59 / 7,78, 0/4255
    pontos fora do conjunto de 90% de produção, conjuntos 1,32× mais largos.
  - ⚠ O e-mail de 12-10 não menciona o passo 5 nem o põe na entrega de 19/20. Pede só que o texto
    reporte que, com a surpresa bruta, câmbio e CDS não são significantes a 90% no DFM (Tema A).

*Plano do e-mail do orientador de 12-10 (`email/email_professor_12-10_19h40.md`, itens 2, 3 e 5),
transcrito em 2026-10-13. **É a última rodada de verificações antes da decisão de submissão.** Prazo
da entrega: 19/20 de outubro, com a ponte do item 2, a comparação com `p = 2` e a versão atualizada do
artigo (Tema A). O ponto principal a esclarecer é a passagem do evento diário, em que o real aprecia,
ao DFM mensal, em que deprecia: pode ser uma trajetória com reversão posterior ou pode surgir da
especificação mensal. A ponte deve dizer se a inversão já aparece na trajetória após o evento, se
aparece ao passar à frequência mensal ou se surge só no DFM. Ele diz "sugiro apenas duas
verificações".*

*Critério de decisão, do mesmo e-mail:*
- *Se a trajetória após o evento e a forma reduzida mensal sustentarem uma interpretação coerente,
  fecha-se o posicionamento e segue-se para submissão.*
- *Se a depreciação aparecer só no DFM, avalia-se se a contribuição basta com uma conclusão
  explicitamente condicionada a esse método de identificação. Uma reescrita centrada no evento diário
  não é assumida de saída.*
- *Sem contribuição empiricamente defensável após as verificações, o projeto é encerrado. Falta de
  significância, sozinha, não decide: contam também precisão, magnitudes e a contribuição sustentável.*

- [ ] **Linha diária do Anexo B: CDS às 17h de Nova York.** Aberto em 14-10, quando o autor fixou o
  fechamento do CDS às 17h de NY (Fechados, abaixo), e mantido em 15-10. Até 15-10 o item cobria também o
  passo 2 (`daily_event.R`), que passou à conferência 3/4 (abaixo).
  - `het_conditions.R` (linha diária de `tab:het_frequency`) ainda usa a janela de quarta a quinta. A
    ponte (a) já usa a de `cds_pre_ny17` → `cds_post_ny17` de `output/copom_timing/meetings.csv`, que nas
    27 reuniões com o fechamento de quarta depois do anúncio vai da véspera à quarta.
  - No k = 1 da ponte, nas 102 reuniões: −1,24 p.b. (p 0,757) às 17h de NY, contra −0,49 (p 0,903) de
    quarta a quinta. Nenhum é significante.
  - No Anexo B, as semanas sem reunião não têm anúncio, e falta definir a janela delas às 17h de NY.
  - Toca o item do Anexo B no Tema A, que leva a linha diária ao `.tex`.
  - ⚠ Depende da janela do CDS que sair da conferência 3/4: se a do evento passar à ampliada, a do Anexo
    B muda junto.
- [ ] **Amostra completa com `p = 2`, o resto do desenho fixo.** Os conjuntos pré-COVID só existem em
  `p = 2`, porque em `p = 4` o teste tem mais momentos que observações (`hac_dim` 135 ≥ T = 90; nota
  `2026-10-05_precisao_ar`). Rodar a janela completa em `p = 2` separa a mudança de amostra da mudança de
  defasagem. Explicar a limitação de `p = 4` e não apresentar `p = 2` como a mesma especificação.
  - ⚠ Decisão de desenho do autor: θ̂ da escala COVID reestimado em `p = 2`, como no Anexo C
    (`p_sensitivity.R`), ou o θ̂ de `p = 4`. A célula pré-COVID roda sem escala porque nela s_t ≡ 1.

*Conferência do e-mail do orientador de 14-10 (`email/email_professor_14-10_17h44.md`), resposta às
três perguntas de `email_meu_14-10_10h55.md`, transcrita em 2026-10-15. Os pontos dela precisam ser
resolvidos antes de ler a comparação diária como resposta ao anúncio, "com algumas regras claras, sem
abrir outra rodada ampla". Ele não pede para repetir agora os exercícios de robustez: quer saber se as
correções mudam o sinal, a magnitude ou a precisão dos resultados centrais. As quatro entregas seguem a
ordem dele, e cada uma vai quando ficar pronta, sem esperar as outras. **A apreciação diária relatada
até aqui fica provisória até o fim da conferência.** ⚠ O corpo do e-mail numera 1 (câmbio) e 3
(reuniões) e não tem o item 2: a única instrução sobre o CDS é a entrega 3.*

- [ ] **Conferência 2/4: câmbio, a comparação corrigida.** A pergunta: a apreciação depende da fonte ou
  da definição da janela? A 1/4 fechou em 15-10, e as duas janelas novas já estão em
  `output/copom_timing/meetings.csv`: `ptax_pre`/`ptax_post` e `yahoo_wide_pre`/`yahoo_wide_post`.
  - O orientador não aceita o fuso da API do Yahoo como confirmação do horário da cotação, que pode ser
    só a convenção de apresentação da série. Também não conclui, pelo horário presumido, que a cotação
    resulta de poucos negócios.
  - Fonte preferida: uma série de câmbio à vista com horário de referência documentado, se houver. O
    repositório não tem uma; o único dado da Bloomberg nele é o CDS.
  - Sem ela, a PTAX de venda do BCB como diagnóstico adicional. A de quarta é apurada antes do
    comunicado, e a do primeiro dia útil seguinte o sucede.
    - Confirmar nas datas da amostra, porque o horário do comunicado mudou. A conferência de 10-13 já o
      confirmou nas 102 (13h a 13h) e dá a primeira sessão de PTAX das 9 fora (nota
      `2026-10-13_ponte_horarios_copom`, seções 4 e 6).
    - Descrever como resposta numa janela diária mais ampla, que também incorpora outras notícias. A
      PTAX não é fechamento nem medida intradiária.
  - O Yahoo fica, para comparar com a série atual, da observação do dia anterior à reunião à do primeiro
    dia útil posterior. Essa janela garante cobrir o anúncio e amplia a exposição a outras notícias.
    - Não apresentá-lo como janela estreita comprovadamente anterior e posterior ao anúncio enquanto o
      horário for desconhecido. A janela atual (noite de terça à de quarta em 96 das 102) vem da hora
      inferida.
    - **Decisão do autor de 15-10:** da linha datada terça à linha datada quinta, pelas datas das linhas
      e pelo calendário do próprio Yahoo, que tem a linha de quinta também nos feriados do Brasil. A outra
      leitura de "dia anterior à reunião", segunda, ficou de fora. Pela hora inferida, a janela contém o
      anúncio nas 111 reuniões e, no inverno europeu, vai da noite de segunda à de quarta.
  - Lado a lado com o que já existe: a PTAX de 10-05 deu −R$ 0,048 (1,04%; p 0,019 na bruta e 0,021 na
    ortogonalizada), e o Yahoo pela convenção −R$ 0,037 (p 0,012) e −R$ 0,029 (p 0,088), nota
    `2026-10-13_cambio_yahoo_convencao`.
  - Não trocar agora a série do DFM.
  - **Decisão do autor de 15-10:** seguir o orientador, com a PTAX como diagnóstico ao lado do Yahoo. A
    decisão reverte a de 14-10, "câmbio sempre o Yahoo, nunca a PTAX", que valeu para a ponte (a), já
    rodada. O estágio `ptax` e `data/raw/ptax_daily.csv` seguem no repositório, e `daily_event.R` hoje só
    usa a PTAX para o alinhamento (`fx_alignment.csv`).
  - Dependem da janela do câmbio, e todos a leem de `meetings.csv`:
    - a conferência (`copom_timing.R`);
    - o passo 2 (`daily_event.R`);
    - a ponte (a) (`event_trajectory.R`);
    - a ponte (b) (`monthly_reduced_form.R`), só no câmbio de fim de mês, nos 7 meses de reunião no
      último pregão;
    - a linha diária do Anexo B (`het_conditions.R`).
  - Toca o item das datas para a Bloomberg (abaixo) e o item do Anexo B no Tema A.
- [ ] **Conferência 3/4: CDS, a janela ampliada com as duas mudanças adjacentes.** Depende da resposta do
  orientador à pergunta da janela ampliada, enviada em 16-10 (Fechados, abaixo; decisão do autor de 15-10).
  - **Decisão do autor de 15-10:** fechamento às 17h de Nova York, o mesmo de 14-10. A janela estreita é a
    da ponte (a), `cds_pre_ny17` → `cds_post_ny17`.
  - **16-10: as duas leituras já estão em `meetings.csv`** para as 111 (`cds_wide_*`, a larga pelas datas,
    de terça a quinta; `cds_wide3_*`, a estreita mais uma variação de cada lado) e na tabela das 9; falta
    só a resposta do orientador e a regressão. Nota `2026-10-16_janela_ampliada_cds_bloomberg`.
  - **17-10: o orientador escolheu a estreita mais uma variação de cada lado** (e-mail de 17-10, item 1).
    É `cds_widened_*` em `meetings.csv`, e a larga saiu do código. É sensibilidade e não substitui a
    estreita. Contém o anúncio nas 111, contra 61 da estreita, que é ambígua em 50. Falta a regressão.
    Nota `2026-10-17_auditoria_janelas_copom`.
  - Leitura do registro para a ampliada: do fechamento de terça ao de quinta, às 17h de NY, com as
    variações de terça a quarta e de quarta a quinta reportadas ao lado da soma. Nas 27 reuniões em que o
    fechamento de quarta vem depois do anúncio, ela soma à janela estreita a variação seguinte; nas
    outras 75, a anterior. ⚠ O e-mail diz só "a janela ampliada, com as duas mudanças adjacentes", e o
    item 2 que responderia à pergunta do CDS não está no corpo.
  - O passo 2 (`daily_event.R`) ainda usa quarta a quinta e passa às 17h de NY nesta entrega. No k = 1 da
    ponte, −1,24 p.b. (NY 17h) contra −0,49 (quarta a quinta), nenhum significante a 90%.
  - Toca o item da linha diária do Anexo B (CDS às 17h de NY, acima) e a decisão do autor sobre a janela
    do CDS (Fechados, abaixo).
- [ ] **Mandar ao orientador a tabela corrigida e a comparação das três bases (e-mail de 17-10, item 4).**
  Anexo: `output/copom_timing/excluded_meetings_advisor.csv`, com a classificação pré, pós ou ambígua por
  reunião e mercado. A comparação está em `output/copom_windows/comparison.csv`. Depois, a convenção
  corrigida entra na ponte entre o evento diário e o resultado mensal (e-mail de 17-10). Nota:
  `2026-10-17_auditoria_janelas_copom`.
- [ ] **Rodar de novo, na produção de 104 reuniões, as saídas que leem o instrumento.** Aberto em
  2026-10-17, na branch `feature/auditoria-janelas-copom`. Ficaram na base de 102:
  - `ar_precision.R`, `daily_event.R`, `event_trajectory.R` e `monthly_reduced_form.R`, cujas guardas
    pinam 102 eventos;
  - `meeting_influence.R` e `placebo_holm.R`, que o e-mail de 17-10 diz não precisar repetir agora;
  - `mosw_strength_grid.R`, `model_var.R`, `instrument_diagnostics.R` e os anexos.

  A emenda de 16-10 à regra de 10-12 vai junto: S&P 500, VIX e Brent de quarta a sexta nas 2 de Ação de
  Graças, nunca 0. ⚠ Na produção nova o ξ_mp pré-COVID é 3,77 (era 5,60), abaixo de 3,84. Depende de
  decidir a promoção (passo 7).
- [ ] **Receber as cotações intradiárias da Bloomberg e conferir a hora do Yahoo.** As 8 datas foram
  enviadas em 16-10 (`email/email_meu_16-10_12h53.md`); depende do conhecido do orientador. Comparar a cotação no anúncio com as linhas do Yahoo das
  8 datas. ⚠ Só a cotação no horário do anúncio não diz a que hora corresponde a linha do Yahoo; casá-la
  com uma hora candidata (20h, 21h ou 22h) exige as cotações nessas horas. Se a hora não for a inferida, mudar `load_yahoo_brl()` (`R/instrument/di_surprise.R`) e rodar de
  novo `copom_timing.R` e o que lê `meetings.csv` (`daily_event.R`, `event_trajectory.R`,
  `monthly_reduced_form.R`, `het_conditions.R`). Toca a conferência 2/4. Não há leitor desses dados no
  código (decisão do autor de 16-10).

### Fechados (contexto)

- [x] **Conferência 4/4: reuniões recuperadas, e auditoria das janelas — 2026-10-17.** Branch
  `feature/auditoria-janelas-copom`, pelo e-mail de 17-10.
  - O filtro de S&P 500, VIX e Brent saiu. As 2 de Ação de Graças entram na produção (104), com a BS
    refeita, e as 7 de feriado no Brasil, de quarta a sexta, ficam na sensibilidade (111).
  - Câmbio e CDS em h0, significantes a 90% nas três bases: 0,145 / 0,136 / 0,125 e 33,5 / 32,4 / 30,6 p.b.
    ξ_mp 6,66 / 6,55 / 7,28.
  - Classificação pré, pós ou ambígua com margem de 30 min. Yahoo e CDS ficam como hipóteses. O DI1 fecha
    às 18h00 desde 2019, e antes vale o limite de 18h15.
  - ⚠ O ξ_mp pré-COVID da produção nova é 3,77.
  - Nota: `2026-10-17_auditoria_janelas_copom`.
- [x] **Mandar ao orientador a conferência 1/4 e perguntar a janela ampliada do CDS — 2026-10-16.**
  `email/email_meu_16-10_12h53.md`, com a tabela das 9 em anexo (`output/copom_timing/excluded_meetings_advisor.csv`,
  só o que o e-mail de 14-10 pede). Diz que as 2 de Thanksgiving ficaram fora por erro e entram na amostra
  principal, e pergunta se a janela ampliada do CDS é de terça a quinta ou a estreita mais uma variação de
  cada lado; as duas leituras já estão em `meetings.csv`. Nota: `2026-10-16_janela_ampliada_cds_bloomberg`.
- [x] **Mandar ao orientador as datas para a cotação intradiária da Bloomberg — 2026-10-16.** No mesmo
  e-mail: 8 datas (maior |ΔDI| por regime do anúncio e horário europeu, 6 no inverno europeu) com os
  horários do anúncio; nas 3 anteriores a 2016-07, o fim da ata e a primeira matéria do G1 (7 a 10 minutos
  depois). ⚠ Na 174ª a faixa (19h56–20h06) cai sobre as 20h inferidas do Yahoo. ⚠ Conta exploratória de
  14-10, não versionada: só as 10 reuniões de 2024-11 a 2025-12 têm intradiário no Yahoo, e nelas o câmbio
  anda |R$ 0,005| do anúncio à cotação da noite e |R$ 0,027| dela até quinta às 12h. Nota: idem, seção 2.
- [x] **Conferência 1/4: tabela das reuniões afetadas — 2026-10-15.** Branch
  `feature/focus-horizonte-fixo`, nada reestimado. As 9 fora das 102, com horários, feriado, motivo e
  janelas de DI, PTAX, Yahoo (convenção e larga) e CDS às 17h de NY. 7 caem pela quinta feriado no
  Brasil (DI e PTAX de quarta a sexta, um pregão, mesmo contrato); 2 só pelo filtro de S&P 500, VIX e
  Brent no Thanksgiving. ⚠ CDS ampliado fora (item acima). Nota: `2026-10-15_conferencia_reunioes_fora`.
- [x] **Evento diário e ponte (a): a janela do câmbio do Yahoo — respondido pelo orientador em
  2026-10-14.** Ponto 1 de `email_meu_14-10_10h55.md`. Resposta: o fuso da API não confirma a hora da
  cotação. Preferir câmbio à vista com horário documentado e, sem ele, a PTAX de venda como diagnóstico
  numa janela diária mais ampla. Manter o Yahoo para comparação, da véspera da reunião ao primeiro dia
  útil posterior, sem apresentá-lo como janela estreita. Não trocar agora a série do DFM. Abriu a
  conferência 2/4 e o item das datas para a Bloomberg, que leva a conta exploratória intradiária de
  14-10 (acima). Em 15-10 o autor seguiu o orientador e reverteu a decisão de 14-10 de nunca usar a PTAX.
- [x] **Decidir se as 9 reuniões fora das 102 entram no instrumento — respondido pelo orientador em
  2026-10-14.** Ponto 3 do mesmo e-mail. Resposta: nenhuma fica com z = 0 automaticamente; as 2 de
  Thanksgiving têm DI válido e não caem pela falta de um controle; as 7 de feriado no Brasil entram como
  sensibilidade, da última à primeira observação válida; surpresa indisponível é ausente, fora dos
  momentos de Γ e da regressão mensal. Abriu as conferências 1/4 e 4/4 (acima). Na ponte (b), tirar os 9
  meses não muda sinal nem significância. Nota: `2026-10-13_ponte_horarios_copom`, seção 6.
- [x] **Ponte (b): forma reduzida mensal sem os fatores — 2026-10-14.** Branch
  `feature/focus-horizonte-fixo`. Regra commitada antes de rodar (`e19a754`), em
  `script/monthly_reduced_form.R`.
  - Desenho: as 162 inovações do DFM, h = 0 e 1, surpresas ortogonalizada e bruta. Séries do painel
    (câmbio média, CDS fim de mês) e a outra agregação dos diários (câmbio de fim de mês alinhado, CDS
    média do Bloomberg).
  - Na linha de referência (painel, ortogonalizada), por +50 p.b. de surpresa: o real deprecia R$ 0,145
    no mês e R$ 0,293 até o seguinte, e o CDS alarga 41,3 e 43,0 p.b., tudo significante a 95%. Pela
    regra, caso (i): a depreciação aparece no mensal sem fatores.
  - Fim de mês contra média e meses sem reunião estão documentados na nota (seções 2 e 3). As três
    amostras (zero, sem os 9 meses de reunião fora, só reuniões) não mudam sinal nem significância.
  - ⚠ Com o câmbio de fim de mês, +0,115 e +0,158, não significante a 90%.
  - ⚠ Por +50 p.b. de `yield_6m`, o primeiro estágio tem F 9,30. O câmbio dá 0,078/0,158 e o CDS
    22,3/23,2, contra 0,145/0,179 e 33,5/36,9 do DFM.
  - ⚠ O CDS do painel pode estar desalinhado em 2016-11 e 2024-01, porque o horário do Investing não é
    conhecido.

  Nota: `2026-10-14_ponte_mensal_forma_reduzida`.
- [x] **Ponte (a): trajetória acumulada após o evento — 2026-10-14.** Branch
  `feature/focus-horizonte-fixo`. Regra commitada antes de rodar (`0b08071`), em
  `script/event_trajectory.R`.
  - Desenho: da última cotação antes do anúncio à 1ª, 5ª, 10ª e 20ª depois, contadas no próprio
    mercado. Câmbio Yahoo e CDS às 17h de NY. 101 reuniões, porque falta a 20ª cotação de 2025-12-10.
    Forma reduzida na surpresa ortogonalizada, HC1.
  - Por +50 p.b., o real aprecia R$ 0,029 na 1ª cotação (significante a 90%) e deprecia R$ 0,122 até a
    20ª (significante a 95%; 2,40%, significante a 90%). O CDS alarga 16,5 p.b. até a 10ª (significante
    a 95%).
  - Pela regra, a troca de sinal do câmbio já aparece na trajetória diária. ⚠ k = 5 e 10 do câmbio não
    são significantes a 90%, e a troca não fica datada.
  - ⚠ Conta exploratória fora da regra, não versionada: sem a reunião de 2020-03-18, o CDS é
    significante a 95% em k = 5, 10 e 20, e o câmbio em k = 20 fica em 0,117.
  - ⚠ k = 1 do CDS às 17h de NY difere do passo 2, que usa quarta a quinta (item acima).

  Nota: `2026-10-14_ponte_trajetoria_evento`.
- [x] **Ponte (a), antes de rodar: a janela do CDS — decidida pelo autor em 2026-10-14.** O CDS fecha
  sempre às 17h de Nova York: em 27 das 102 reuniões, a janela vai da cotação anterior à quarta até a
  de quarta.
  - ⚠ Decisão sobre um horário que nem o arquivo nem os dados fixam: o teste da regra `5048a09` deu
    inconclusivo (nota `2026-10-13_ponte_horarios_copom`, seção 5).
  - O orientador respondeu em 14-10 sem indicar horário: o corpo do e-mail não tem o item 2, e a entrega
    3 pede a janela ampliada, com as duas mudanças adjacentes (conferência 3/4, acima). O autor manteve
    as 17h de NY em 15-10.
  - Abriu o item do passo 2 e do Anexo B (acima).
- [x] **Ponte, conferência: o que é exatamente o dia do Copom — 2026-10-13.** Branch
  `feature/focus-horizonte-fixo`; nada reestimado, instrumento intocado. Anúncio reunião a reunião pelas
  atas do BCB (estágio `copom_atas`): 19h19–20h55 até jun/2016, 18h00–18h20 até out/2020, 18h30–19h12
  depois. As janelas do DI (fechamento a fechamento) e da PTAX (13h a 13h) cumprem a convenção nas 102.
  - ⚠ A janela do CDS de quarta a quinta só cumpre a convenção com fechamento em Londres; com Nova York
    falha em 27 (17h) a 77 (18h) das 102. O teste fixado antes (`5048a09`) é inconclusivo. Abriu o item
    da janela do CDS na ponte (a).
  - ⚠ 9 das 111 reuniões ficam fora (7 quintas de feriado no Brasil, 2 de Thanksgiving), e seus meses
    entram com z = 0. Abriu o item de decisão (acima).
  - **Câmbio refeito no mesmo dia** com o Yahoo pela convenção (decisão do autor): a janela vai da
    noite de terça à de quarta em 96 das 102. Nota `2026-10-13_cambio_yahoo_convencao`.

  Nota: `2026-10-13_ponte_horarios_copom`.
- [x] **Responder ao orientador sobre o plano de 03-10 — superado em 2026-10-13.** Os passos 0 a 4
  rodaram e foram reportados em `email/email_meu_12-10_17h22.md`, e ele respondeu em
  `email/email_professor_12-10_19h40.md`. Pré-COVID: aceitou os conjuntos em `p = 2`, sem apresentá-los
  como a mesma especificação. "Excluir uma reunião" e a avaliação conjunta dos placebos: respondidos em
  10-08, com Holm aprovado em 12-10. O filtro JK segue no passo 5/5. ⚠ `email/` não tem resposta do
  autor ao plano entre 03-10 e 08-10.
- [x] **Passo 3/5, parte 2: exclusão por movimentos extremos de VIX, S&P 500 ou Brent — 2026-10-12.**
  Regra fixada e commitada antes de rodar (`2cad8bd`): sai a reunião em que a variação log de quarta a
  quinta de alguma das três passa, em módulo, do percentil 95 da série nos pregões de 2012-03 a
  2025-12. Célula `sem_extremos` de `script/meeting_influence.R`, só em Γ. Marcadas 11 reuniões, 5 por
  série, três entre as dez mais influentes. ξ_mp 6,66 → 5,67. O CDS fica estável (32,0 contra 33,5
  p.b. no impacto), significante a 95% em h0, h1 e h3, e nenhum ponto do painel sai do conjunto de 90%
  de produção.
  - ⚠ O câmbio cai 26% no impacto (0,145 → 0,107), perde os 95% em todo horizonte e segue significante
    a 90% em h0–h4. A queda vem mais das reuniões marcadas pelo Brent, no sentido oposto ao da leitura
    registrada. Abriu o item da janela de terça a quarta (acima).
  - ⚠ O `BZ=F` não separa salto de troca de vencimento de variação de preço. Nenhuma das cinco datas
    marcadas pelo Brent é último dia útil do mês.

  Nota: `2026-10-12_exclusao_extremos`.
- [x] **Passo 4/5, placebos com Holm — 2026-10-09.** Desenho do e-mail de 08-10, na branch
  `feature/focus-horizonte-fixo` sobre a base do passo 0. Nada reestimado: são os p-valores AR em zero da
  tabela do passo 1, conferida contra o cache. Se a base mudar, rerodar `script/ar_precision.R` e
  `script/placebo_holm.R`.
  - Holm nos 18 testes (VIX, `msci` e EPU dos EUA em h = 0, 1, 3, 6, 12, 24) não rejeita nada a 10%,
    com menor p ajustado 0,983. Sem ajuste, rejeitam a 10% a `msci` em h3 e h6 (p 0,055) e o VIX em
    h6 (p 0,088).
  - Só o VIX entra na ortogonalização, como tendência de 65 pregões até a quarta, com coeficiente
    −0,025 (p 0,92). ⚠ Em h0 o mês do VIX se sobrepõe à janela, e o teste não é de todo independente.
  - **Rerodado em 10-12** com a `msci` sendo o índice de emergentes (até então era a ação da MSCI Inc.).
    Holm nos 18 testes segue sem rejeitar a 10% (menor p ajustado 0,575). Sem ajuste, rejeitam a 10% o
    índice em h0, h1 e h3 e o VIX em h6. ⚠ O índice cai 27,5 pontos no impacto e 27,3 em h1, e h1
    rejeita a 5% (p 0,032). A família de 12 saiu do script.

  Notas: `2026-10-09_placebos_holm` (desenho), `2026-10-12_msci_emergentes` (números correntes).
- [x] **Passo 3/5, influência das reuniões — 2026-10-08.** Desenho do e-mail de 08-10, na branch
  `feature/focus-horizonte-fixo` sobre a base do passo 0: fatores, VAR e inovações fixos, a reunião sai
  só do momento Γ, e T = 162 e o calendário ficam intactos. Ordem por max_k |ΔΓ_k|/EP_k nas 99 reuniões
  que entram em Γ. Se a base mudar, rerodar `script/meeting_influence.R`.
  - Nenhuma exclusão individual muda sinal ou força: câmbio h0 0,126–0,175, CDS 28,9–42,0, ξ_mp
    5,52–7,61.
  - Juntas, as 5 mais influentes levam ξ_mp a 3,59 e as 10 a 2,01 (81% do momento de normalização).
    Câmbio e CDS perdem os 95% sem as 5 e os 90% sem as 10, com ponto do mesmo sinal.
  - ⚠ A significância depende de poucas reuniões, em parte por construção da ordem.
  - ⚠ Três reuniões de 2012 caem antes da primeira inovação e não entram em Γ.
  - **Rerodado em 10-12** sobre a base com o índice de emergentes. As 5 e as 10 mais influentes são as
    mesmas. Sem as 5, ξ_mp vai a 3,54; sem as 10, a 1,82. ⚠ O câmbio sem as 5 é significante a 90% até
    h4, antes h5.

  Notas: `2026-10-08_influencia_reunioes` (desenho), `2026-10-12_msci_emergentes` (números correntes).
- [x] **Passo 2/5: evento diário — 2026-10-05.** Rodado na branch `feature/focus-horizonte-fixo` sobre
  a base do passo 0, com a PTAX como câmbio diário (estágio `ptax`) e as 102 reuniões como amostra
  comum. Se a base mudar, rerodar `script/daily_event.R`; só o lado do DFM depende dela.
  - No dia do Copom, +50 p.b. de surpresa vem com o real apreciando R$ 0,048 (1,04%), significante a
    95% com a surpresa bruta e com a ortogonalizada (p 0,019 e 0,021). O CDS não é significante a 90%.
  - O primeiro estágio é a identidade na bruta e tem F 656 na ortogonalizada.
  - O câmbio só troca de sinal no DFM mensal (+0,099 com a bruta, +0,146 na produção). A divergência
    surge na passagem do diário ao DFM, que muda frequência, janela, normalização, medida e modelo
    juntos, sem decomposição.
  - ⚠ No CDS o ponto troca de sinal já na ortogonalização (+0,9 → −0,5 p.b.), e nenhum dos dois é
    significante a 90%.
  - **Rerodado em 10-12.** As regressões diárias saíram byte-idênticas. No DFM, o câmbio vai a +0,096
    com a bruta e a +0,145 na produção.
  - **Câmbio refeito em 10-13** com o Yahoo pela convenção, por decisão do autor: −R$ 0,037 (0,80%, p
    0,012) na bruta e −R$ 0,029 (0,66%, p 0,088) na ortogonalizada. ⚠ A ortogonalizada perde os 95%. CDS
    e DFM não mudam. Nota `2026-10-13_cambio_yahoo_convencao`.

  Notas: `2026-10-05_evento_diario` (desenho), `2026-10-12_msci_emergentes` (números correntes).
- [x] **Passo 1/5: precisão — 2026-10-05.** Rodado na branch `feature/focus-horizonte-fixo` sobre a
  base do passo 0, ainda não congelada. Se a base mudar, rerodar `script/ar_precision.R`.
  - Câmbio e CDS são significantes a 95% no impacto (p 0,013 e 0,015), até h3 e h4.
  - Pré-COVID só em `p = 2` (ξ_mp 5,64; significantes a 95% em h0–h11), porque `p = 4` é barrado.
  - Os momentos de ξ_mp e dos testes de câmbio e CDS não têm autocorrelação até h12.
  - NW 1–3 não muda o impacto. NW 4–12 estreita os conjuntos, e ξ_mp chega a 10,01.
  - ⚠ O ponto pré-COVID de `p = 4` sai do conjunto de `p = 2` em h10–h22.
  - ⚠ Com a base nova, o impacto pré-COVID do câmbio em `p = 4` vai de 0,056 a 0,121.
  - **Rerodado em 10-12** sobre a base com o índice de emergentes. No impacto, câmbio e CDS seguem
    significantes a 95% (p 0,015 e 0,017). O pré-COVID `p = 2` tem ξ_mp 5,87. ⚠ O CDS deixa de ser
    significante a 95% em h2 (p 0,051), e ξ_mp com NW(12) fica em 9,79, abaixo de 10.

  Notas: `2026-10-05_precisao_ar` (desenho), `2026-10-12_msci_emergentes` (números correntes).
- [x] **Robustez à pandemia: respostas pré-COVID no Anexo C — 2026-09-30.** Sugestão do
  orientador de 28-09. `fig:precovid_sensibilidade`, em ponto (`hac_dim` 135 ≥ 90 barra a banda),
  com uma frase na §3.4 e nenhum número no corpo. Curva e risco ficam dentro do conjunto de 90%
  da produção (DI de 6 meses a 10 anos, CDS e EMBI+, 0/37 cada). ⚠ O câmbio sai no impacto
  (R$ 0,056 contra 0,141, abaixo do limite de R$ 0,069), a DBGG tem o sinal oposto ao da produção
  e sai em 22 dos 37 horizontes, e no painel 1407 de 4255 pontos saem, em 103 das 115 séries:
  IBC-Br, IPCA, Ibovespa e DLSP, fora da figura, em 12 a 21 dos 37 horizontes. ⚠ Ponto contra
  conjunto da amostra completa não é teste de igualdade. Branch `feature/robustez-pandemia`. Nota:
  `2026-09-30_robustez_pandemia`.
- [x] **IRFs por camada do instrumento e tabela de Bauer-Swanson no Anexo D — 2026-09-25.**
  `instrument_layers_irf.R` e `fig:instrumento_camadas`: nenhum ponto de `z_bruto` ou
  `z_bs_purif` sai do conjunto de 90% da produção (0/4255 cada), e o filtro JK amplia câmbio,
  CDS e juros longos em 12% a 36%. ⚠ O impacto do Ibovespa troca de sinal com o filtro
  (+0,19/+0,27% → −1,50%), por construção. `tab:bs_ortogonalizacao`, análoga à Tabela 3 de BS,
  tem Wald conjunta p 0,131 (DI) e 0,326 (Ibovespa). Nota: `2026-09-25_anexo_d_instrumento`.
- [x] **Sensibilidade a `p` no Anexo C; θ̂ reestimado com gradiente mais fino — 2026-09-25.**
  `p = 2..6`, θ reestimado em cada `p`, e todos os pontos dentro do conjunto de 90% de `p = 4`.
  A trava da condição de primeira ordem barrou `p = 5` com o `ndeps` padrão do `optim`, e o
  autor escolheu `ndeps = 1e-6` em todo `p`. ξ_mp 6,847997 → 6,848035, IRFs ≤ 8e-5 da escala,
  nenhum número do paper mudou. Nota: `2026-09-25_p_sensibilidade_anexo`.

- [x] **Ótimo global de θ̂ confirmado — 2026-09-24.** Multi-start de 750 inícios na
  caixa inteira, virou trava de `covid_volatility_theta.R`. Nenhum início passa de θ̂
  (+3,8e-7 log-ponto, precisão do otimizador), e há três máximos: θ̂ (137 inícios),
  ρ = 0 (−2,62) e uma crista nova no piso s̄2 = 1 (−4,79). θ̂ sai byte-idêntico.
  ⚠ Nenhum início com ρ0 ≤ 0,4 chega a θ̂: o de produção dependia do ρ0 = 0,8 de LP.
  Nota: `2026-09-24_otimo_global_theta`; `output/factors/covid_volatility_multistart.csv`.

- [x] **Figura de sensibilidade `q = 2,…,5` (`r = 5`) no Anexo C — FEITA em
  2026-09-24.** Passo 4/4. `q_sensitivity.R --window=cheia` escreve
  `paper/img/fig_q_sensibilidade.pdf`: oito séries até h36, com `q = 5` guardado contra
  `irf_coherence_h.csv` a 1e-10. Em h ≤ 36, 16, 5 e 4 das 20 séries ficam inteiras
  na banda de 90% (as mesmas contagens de 0–48). As pernas sem tratamento e
  pré-COVID ficam no registro. Nota: `2026-09-24_q_sensibilidade_anexo`.

- [x] **Sistema mensal de quatro observáveis identificado por heterocedasticidade —
  autorizado em 2026-09-21, reavaliado com o teste do `svars` em 2026-09-22.**
  Veredito: **a premissa estava errada**. O VAR mensal nas quatro observáveis do painel
  **não** identifica — o teste `Qr` de Lütkepohl et al. (2021) não rejeita `λ₁ = λ₂`
  em nenhum vértice (p 0,917 a 0,988), com os dois maiores autovalores praticamente
  coincidindo —, e as cinco inovações fatoriais também não a 5% (p 0,0761). Quem
  identifica é o sistema **diário** nas mesmas três séries de `goncalves2025`, no
  vértice de 3 meses (p 0,0033), e ali o aperto de 50 p.b. **fecha** o CDS 4,2 p.b. e
  **aprecia** o real 1,53% — o sinal deles, não o do DFM. ⚠ O que separa as duas
  linhas — a frequência, ou a troca da janela de anúncio pela variação de calendário —
  **não está medido**: a linha que somava as janelas Qua→Qui dentro do mês foi
  retirada por decisão do autor, e a única agregação mensal é a do painel. A rota het
  segue abandonada para o artigo. Pasta: `het_rigobon/`; nota: `2026-09-22_condicao_het_svars`.

- [x] **Bootstrap e correção de Kilian sob o tratamento de volatilidade
  COVID — ENCERRADO em 2026-09-18** (autor), sem ser derivado: o wild
  bootstrap e a correção de Kilian saíram do código, porque os conjuntos
  Anderson--Rubin os substituíram como inferência do DFM. A última versão com
  eles é `main` em `07b1cbd` (`arquivo/README.md`).
- [x] **Correção de outliers de 2020 (Lenza-Primiceri) — LIGADA EM PRODUÇÃO
  em 2026-09-17.** Passo 3/4. Virou o estimador do VAR dos fatores, descrito
  na §3.1. ξ_mp sobe de 6,057014 para 6,847997 na cheia, F_rob de 9,625428
  para 11,765250, e os conjuntos da §5 seguem `interval` a 68/90%; a pré-COVID
  não se move, porque nela `s_t = 1` em todo mês. Sob a escala, `r >= 7` é
  explosivo na cheia. Nota:
  `notas/2026-09-17_volatilidade_covid_producao.md`.

- [x] **Inferência AR e ξ_mp sob o tratamento de volatilidade COVID — FEITA
  em 2026-09-14.** Com `"standardized"`, o WLS é o OLS da regressão
  transformada, e `CovAhat_Sigmahat_Gamma.m` vale nela ao pé da letra, com θ̂
  tratado como conhecido; `"raw"` segue em `stop()`. Em θ neutro, reproduz o
  AR de produção a 1,5e-13; ξ_mp tratado de 6,848 em `(5,5,4)`. Bootstrap e
  Kilian viraram item próprio. Nota:
  `notas/2026-09-14_inferencia_volatilidade_covid_q.md`.
- [x] **Parametrização da volatilidade COVID — DECIDIDA em 2026-09-14**
  (autor): `t*` = 2020-03; θ por máxima verossimilhança (B5) com s̄ ≥ 1 e
  ρ ∈ [0,1]; `innovations = "standardized"`; sem centragem sob WLS em H e K;
  extração estática não estendida. θ̂ = (6,61; 12,47; 1,76; 0,944), com um
  máximo local em ρ = 0 2,6 log-pontos abaixo. Nota:
  `notas/2026-09-14_estimacao_theta_volatilidade_covid.md`.
- [x] **Truncamento `q < r` testado — FEITO em 2026-09-10** (pedido do autor,
  ligado à 4/5). Pré-COVID `p=2`: 115/115 séries *imateriais* em `q` = 3 e 4;
  cheia: 0/115, e o instrumento está nas direções descartadas (T1 p 0,051 /
  0,039 / 0,015). ⚠ Regras escritas depois da passada exploratória; bandas
  pré-COVID só em `p = 2`. Nota: `notas/2026-09-10_truncamento_q.md`.
- [x] **Poda por correlação — FEITA em 2026-09-10** (sugestão 2/5). Ligação
  completa em |ρ| ≥ 0,90 nas primeiras diferenças: saem 9 de 115 séries, e
  nenhum par entre blocos passa de 0,80. ⚠ Na pré-COVID, 3 dos 8 grupos não
  passam inteiros. Nota: `notas/2026-09-10_poda_correlacao_painel.md`.
- [x] **`(r,q)` no painel podado — FEITO em 2026-09-10** (sugestão 3/5). IC2
  5 → 3, AH 2 → 1, ABC 9 → 11 (instável), AW `q = 2` em todo `r`. A divergência
  **aumenta** (D 10 → 12) e a hipótese de subestimação sai **contrária**. ⚠ D cai
  a 6 em 0,80/0,85. Nota: idem.

- [x] **`r` por Ahn-Horenstein e Alessi-Barigozzi-Capasso — FEITO em
  2026-09-10** (sugestão 1/5). Base BLL, `k=1..20`: ER = GR = 2, ABC-IC*₁ = 9,
  veredito pré-registrado **misto**. ⚠ O 9 vem de um intervalo de 2 pontos da
  grade e dá 5 em 39/100 permutações; ⚠ o `factorselect` diverge no GR e no
  ABC (reimplementado). Nota: `notas/2026-09-10_selecao_fatores_ah_abc.md`.

- [x] **Bandas Anderson-Rubin do DFM — FEITAS em 2026-09-08, e promovidas a
  inferência operacional no lugar do wild bootstrap** (sugestão 5/5; decisão do
  autor reverte a retirada de 2026-08-12 sem cumprir a condição de reabertura
  registrada). Produção `(5,5,4)`: ξ_mp = 6,057014 pelo bloco `W2` de MOSW,
  5.635/5.635 células limitadas a 68/90/95%, prêmio de IV fraco de 1,38× sobre
  o delta-method a 90%. `(5,2)`: ξ_mp = 2,339, limitado só a 68% — a 90% saem
  2.205 retas e 3.429 pares de semirretas, que é a demonstração pedida. ⚠ `(8,8)`
  em `p=4` e a **janela pré-COVID inteira** não rodam (`hac_dim ≥ T`). ⚠ A troca
  move a contagem de significância: nas 58 séries pontuadas, sig90 em h≤12 cai
  de 256 para 159 e sig68 sobe de 1.021 para 1.897. Nota:
  `notas/2026-09-08_bandas_anderson_rubin_producao.md`.

- [x] **Benchmark VAR migrado para níveis, AIC e tendência linear —
  2026-08-22.** Cinco séries em nível, `p=2` AIC comum (`T=141`),
  `xi_mp=6,797335`, raiz máxima 0,965424; valida contra `vars::VARselect` a
  2,31e-14. Nota: `notas/2026-08-22_var_niveis_aic_tendencia.md`.
- [x] **Benchmark estacionário e weak-IV, concluído e superado no mesmo dia
  — 2026-08-22.** IBC-Br/IPCA em nível, resto em diferença; BIC `p=1`, AR
  68/90% NW(0). ⚠ Nenhum exercício testa validade da proxy. Nota:
  `notas/2026-08-22_var_producao_unica.md`.
- [x] **Varredura de `p` no impacto — FEITA em 2026-08-18.** Grade
  `p ∈ {2,3,4,6}`, 800 réplicas cada. Impacto invariante (`share_in90=1` em
  h≤36); reversão de médio prazo se move (h=22 sob p=6, h=15 sob p=2) —
  corrobora §4. ⚠ BIC/HQ selecionam `p=2` (não `p=1` como a ressalva antiga
  dizia); ⚠ `p=6` é a célula mais forte (ξ_mp 6,27) mas não justifica escolha
  por força. Nota: `notas/2026-08-18_varredura_p`.
- [x] **Rótulo "S&P 500 / VIX" corrigido na figura — 2026-08-14.**
  `fig_section5.R:213` agora escreve "VIX"; auto-teste passa em 45/46 séries.
  Acrescentar um nível do S&P 500 ao painel virou item aberto no Tema B.
- [x] **Pico uniforme em h=1 — hipótese superada pela produção `(5,5)`.**
  Curva pico em h=3, Selic em h=5; sem regularidade uniforme do bloco
  financeiro.
- [x] **Decisão conjunta de painel e dimensões — etapa intermediária superada
  em 2026-08-13.** Grade de 2.304 células recomendou 123 séries `(4,3)`
  (ξ_mp=5,05); substituída pela decisão final de 111 séries `(5,5)`. Nota:
  `notas/2026-08-13_decisao_conjunta_painel_dimensoes.md`.
- [x] **Composição experimental do painel, seis blocos candidatos — FEITO em
  2026-08-13, veredito superado pela decisão conjunta acima.** Nove variantes
  pré-especificadas, sem promoção conjunta sustentada pelas bandas. Nota:
  `notas/2026-08-13_teste_experimental_composicao_painel.md`.
- [x] **Teste de coincidência FOMC — FEITO em 2026-08-10.** Causa raiz: um
  `else` fazia "coleta não feita" indistinguível de "coleta vazia";
  `load_fomc_dates()` agora aborta. **Veredito: confound FOMC não
  detectado** — exposição maior que o council estimou (24/62 dias, 35,5% de
  Σ|z|), mas F_rob 0,94/`p_boot` 0,458 no bloco americano. ⚠ O teste 4 (a
  divisão) saiu do script no mesmo dia — não é reproduzível nem citável; a
  perna havia passado e sua remoção só torna a regra mais permissiva
  (`max|dif|=0` conferido). Nota: `notas/2026-08-10_coincidencia_fomc.md`;
  ver `historico_decisoes.md` §2.4.
- [x] **Robustez do próprio ξ_mp — REFEITA em 2026-08-13.** Leave-one-month-out:
  full ξ_mp 6,27 (min 4,89/máx 6,96), 0/147 descartes abaixo de 3,84 mas
  147/147 abaixo de 10. HAC: ξ_mp chega a 8,05 em NW(6). Validado contra
  `NW_hac_STATA.m`/`TaxSVARIV.m`. Nota: `output/instrument/xi_mp_robustness.md`.
- [x] **Robustez da construção do instrumento: vértice e agregação — FEITO em
  2026-07-27.** 260 células; vértice 126 du não é argmax mas a margem do
  desafiante (1,16) fica abaixo do limiar (2,00) — produção mantida. GK
  colapsa ξ_mp a 0,30 no vértice de produção (previsto pela nota 11 de GK).
  Nota: `output/instrument/instrument_construction_sweep.md`.
- [x] **Placebo `commodity_metal` violado — RESOLVIDO em 2026-07-28.** Não era
  exogeneidade: IC-Br do BCB é denominado em R$ e herda a resposta cambial
  (R$: +12,07 sig90 4/5h; US$: +0,42, 0/25h). Reclassificado de `placebo` para
  `ambiguous`. Fonte: `diagnostics/01_exogeneidade.R` §1.6.

---

## C. Identificação por momentos e por heterocedasticidade — ENCERRADO

**Ambas as rotas foram abandonadas em 2026-08-17, por decisão do autor.** Não há
item aberto neste tema. O código dedicado à heterocedasticidade foi removido em
2026-09-01; seus artefatos, nota e veredito permanecem em
`arquivo/heterocedasticidade/`. A rota não-gaussiana continua arquivada em
`arquivo/nao_gaussiana/`; o resumo está em `historico_decisoes.md` §0 e §1.

O núcleo de identificação foi colapsado para o ramo único `proxy` na mesma data
(`R/modeling/{dfm_pipeline,impulse_response}.R`), com o smoke test de produção
bit-idêntico como guard.

**Em 2026-09-21 o autor autorizou uma rodada exploratória que constrói IRFs pela
coluna rank-1.** Ela vive inteira em `het_rigobon/`, em quarentena: importa `R/` em
modo leitura, escreve só na própria pasta e **não** acrescentou ramo
`identification = "het"` a `compute_irf_dfm()`. A identificação segue abandonada para
o artigo, e o veredito da rodada está em `het_rigobon/README.md`. Os dois itens que
ela abriu são **editoriais** e estão no Tema A.

### Fechados (contexto)

- [x] **Resultado negativo da het incorporado ao paper — 2026-09-01,
  REESTIMADO em 2026-09-21.** §5.1 reporta o teste de proporcionalidade no
  diário e no mensal. A vintage de 2026-09-01 rodava `(4,4,4)` sem a escala LP,
  com 450 células válidas e família de 100 no desenho de calendário; a de
  2026-09-21 roda a produção `(5,5,4)` sob a escala, com inovações padronizadas
  e família de 37. **O veredito não mudou** — 0 de 37 sobrevivem a Holm — mas o
  `p_boot` de produção é marginal, 0,0508, contra 0,0559 antes, e o assintótico
  da mesma estatística, 0,0057, rejeitaria.
  ⚠ **O código dedicado voltou, como diagnóstico:** `R/identification/het_tests.R`
  e `script/het_conditions.R`. `ident_het_regimes()` e `het_shock_extraction.R`
  seguem removidos, e nenhuma IRF sai deste ramo em código vivo — a identificação
  por heterocedasticidade continua abandonada desde 2026-08-17.
  ⚠⚠ **A ESTATÍSTICA MUDOU EM 2026-09-22, e com ela todos os números acima.** Por
  decisão do autor a bateria foi reduzida ao teste do pacote `svars` — o `Qr`
  sequencial de Lütkepohl et al. (2021) sobre a distinção dos autovalores de `Λ` —,
  que é a forma multivariada da condição de posto de Rigobon. O teste de
  proporcionalidade de Mauchly, o gap λ₁−λ₂, `ratio_dir`, `rank1_share` e o placebo
  de permutação **saíram**, e os valores-p deste item (0,0508, 0,0559, 0,0003, 0,0057)
  são **descontinuados**. Os dois sistemas passaram a usar **as séries de GRG** — DI,
  câmbio BRL/USD e CDS de 5 anos; o conjunto que o projeto chamava de linha diária
  publicada usava DI de 2 anos e Ibovespa, que **não são deles**. Sob o teste novo: o
  diário rejeita no vértice de 3 meses (p 0,0033), o VAR mensal **nas mesmas três
  séries** não rejeita em nenhum vértice (0,917 a 0,988, com λ₁ ≈ λ₂ e determinante de
  eq. (6) em −0,03), e as inovações fatoriais não a 5% (0,0761). ⚠ **As duas
  diferenças entre as linhas não estão separadas** e nenhuma afirmação pode atribuir a
  queda a uma delas: o objeto que somava as janelas Qua→Qui dentro do mês foi retirado
  por decisão do autor no fim da rodada, com todos os seus números, e a única agregação
  mensal é a do painel — a última cotação do mês de referência nos vértices do DI e no
  CDS, a média mensal no câmbio. Tanto a afirmação de que a agregação vira o sinal
  quanto a de que ela destrói a separação dos autovalores foram **revertidas**.
  Fontes: `notas/2026-09-22_condicao_het_svars.md`,
  `output/het/het_conditions.md`, `arquivo/heterocedasticidade/README.md`.

- [x] **Enquadramento do GMR no paper — ENCERRADO SEM ENTRAR (2026-08-17).** A
  recomendação viva era usar o GMR como *teste*, não como estimativa concorrente,
  apoiada em duas afirmações de não-discriminação: o ponto do proxy cai dentro do
  CI90 do GMR em 100% das 5.439 células, e o esquema recursivo é rejeitado
  (ξ = 73,81). Nada disso entra no paper.
- [x] **Construir um teste com poder — ENCERRADO (2026-08-17).** O gargalo era a
  régua, não o estimador: a concordância de sinal satura contra o nulo (p=0,149)
  e a razão de magnitude nunca rejeitou a 5% (p=0,087).
- [x] **LMS (2017) como terceira leitura — ENCERRADO SEM TENTAR (2026-08-17).**
  `svars::id.ngml` era o desempate mais barato disponível; `svars` nunca foi
  instalado.
- [x] **Heterocedasticidade *condicional* (GARCH-SVAR) — ENCERRADA SEM TENTAR
  (2026-08-17).** Era a ponta solta declarada da rota het, a única com chance de
  produzir IRF mensal por dispensar datas de regime.
- [x] **Subseção de robustez sobre heterocedasticidade — NÃO SERÁ ESCRITA
  (2026-08-17).** Os números existiam e estavam conferidos (288 células válidas
  de 320, nenhuma identifica), mas a §5 não recebe a subseção.

> Os itens fechados anteriores deste tema — gate em η, implementação do ramo,
> corroboração contra nulo, coluna vice-líder, descarte do VAR pequeno — estão
> em `arquivo/nao_gaussiana/README.md` e em `historico_decisoes_secao0.md`.

---

## D. Diagnósticos e comparações pendentes

### Fechados (contexto)

- [x] **Câmbio diário do Yahoo: hora da cotação e janela pela convenção — 2026-10-13, na branch
  `feature/focus-horizonte-fixo`.**
  - Por decisão do autor, todo o câmbio diário passa ao Yahoo pela convenção: o passo 2, a conferência
    e a linha diária do Anexo B.
  - A linha datada d traz a cotação da noite (20h–22h em Brasília). Na quarta, ela vem depois do
    anúncio em 96 das 102 reuniões.
  - ⚠ A leitura de 10-05 ("45 de inverno deslocadas") estava errada: a janela pelas datas perde o
    anúncio nas 51 de verão.
  - Evento diário: −R$ 0,037 (p 0,012) na bruta e −R$ 0,029 (p 0,088) na ortogonalizada, que perde os
    95%.
  - Anexo B diário: `Qr` p 0,002, 0,064 e 0,081 nos três vértices. ⚠ A razão de variância do câmbio
    vai de 1,04 a 0,69. `het_rigobon/` segue com as datas, em quarentena.

  Nota: `2026-10-13_cambio_yahoo_convencao`.

- [x] **A série `msci` era a ação da MSCI Inc.; vira o índice MSCI de emergentes — 2026-10-12, na
  branch `feature/focus-horizonte-fixo`.** Achado no passo 4/5 (nota `2026-10-09_placebos_holm`,
  seção 4). O índice (MSCI 891800, preço em USD, fim de mês) vem da própria MSCI pelo estágio `msci`
  e entra em `clean.R` na coluna e na posição da `msci`. As outras 114 séries ficaram bit-idênticas,
  e os passos 0 a 4 rodaram de novo. Câmbio e CDS não mudam (0,145 e 33,5 p.b. no impacto). ⚠ Sem
  ajuste, o placebo do índice cai no impacto e em h1. ⚠ `main` segue com a ação até a promoção.
  Nota: `2026-10-12_msci_emergentes`.

- [x] **Placebo EPU dos EUA e o EPU como controle da ortogonalização — 2026-09-30, na branch
  `feature/placebo-epu`.** O controle pedido pelo orientador não absorve: a tendência de 13
  semanas do EPU diário antes da reunião não prevê a surpresa (p 0,543; a do mensal, t 0,0002), e
  o EPU segue `placebo_viola` em h1–h3 (h1 +11,52, 90% [0,66; 31,31]); a violação não existe na
  surpresa bruta nem com um bloco isolado da regressão BS, e zerar 2020-03 devolve zero ao
  conjunto. O autor seguiu com a limitação reconhecida: produção de `main` intocada, branch aberta
  e sem merge. ⚠ A branch leva o controle no código de produção e não pode entrar em `main` como
  está. Nota (só na branch): `2026-09-29_placebo_epu`.

- [x] **VAR mensal do Anexo B sob a escala COVID de Lenza-Primiceri — 2026-09-27.** Duas versões
  do VAR de DI, câmbio e CDS, MQO e MQP com θ próprio por vértice (máximo único em 750 inícios),
  ambas pelo caminho da linha fatorial (161 meses). O tratado não rejeita `λ₁ = λ₂` (p 0,965 /
  0,824 / 0,966), as três variâncias seguem subindo juntas, e a §3.3 não muda. O paper traz
  só o VAR tratado (lado a lado recusado pelo autor), e as duas tabelas do Anexo B viraram
  `tab:het_frequency`. ⚠ A linha sem tratamento se deslocou pela troca de caminho (p 0,988 /
  0,917 / 0,931 → 0,948 / 0,881 / 0,970), e o benchmark VAR segue sem escala. Nota:
  `2026-09-27_het_var_escala_covid`.

- [x] **Produção da branch promovida para `main` — 2026-09-26.** Fast-forward de
  `feature/bs-copom-surpresas-macro` (`63eea36..20a5f42`, 14 commits), a pedido do autor, antes
  de resolver o placebo EPU. Em `main`, `instrument.R` reproduz `instrument.csv` byte a byte e os
  sete validadores passam. Produção: `z_bs_purif`, conjuntos de 80/90%, ξ_mp 7,02 / 6,84, paper já
  migrado. ⚠ Quatro divulgações macro caem na própria quinta do Copom, contaminação contemporânea
  que nenhuma camada trata (`2026-09-25_bs_copom_surpresas_macro` §3.2). Notas:
  `2026-09-26_producao_bs_purif_bandas_80_90`, `2026-09-26_migracao_paper_bs_purif`.

- [x] **Ortogonalização Bauer-Swanson só nas reuniões do Copom, sem tendência —
  2026-09-25, na branch.** Segue a Tabela 3 (`table_3.m`: só constante, um mês
  com FOMC por observação), com 102 reuniões em vez de 638 quintas. A surpresa
  do Copom é previsível (Wald p 0,005, `R²` 0,227, revisão Focus da Selic com
  t 4,3). ξ_mp de produção cai de 6,85 para 2,43 (pré-COVID, de 8,64 para 1,89),
  e 20 reuniões trocam de classe. A tendência não era de BS, e a atribuição foi
  corrigida em `metodo.md`. Nota: `2026-09-25_bs_copom_surpresas_macro` §2.
- [x] **Bloco de surpresas macro na ortogonalização Bauer-Swanson — 2026-09-25,
  na branch.** Entram:
  - a surpresa do IPCA e a do PIB (primeira divulgação, lida nos cadernos do
    IBGE), cada uma menos a mediana Focus da última pesquisa e somada desde o
    Copom anterior, com a divulgação da própria quarta incluída;
  - a aceleração do núcleo EX0;
  - o IPCA esperado.

  Emprego e BBK ficam como lacunas. O bloco não é significativo em conjunto
  (p 0,159; PIB com t 1,95). ξ_mp de produção fica em 1,78 na cheia e 3,22 na
  pré-COVID. Insumos de `script/download_macro_news.R`. Nota: idem, §3–4.

- [x] **Comparação cross-instrumento do bloco de preços sob (5,5) — FECHADA em
  2026-08-18.** Escada `z_bruto` → `z_bs_purif` → `z_jk_bs_purif`: corcova de
  h2-h8 positiva nos três degraus (8/8 séries); BS amplifica (16/16), filtro de
  sinal atenua (8/8) — contradiz a nota de 07-12. Nenhum degrau alcança ξ_mp
  10 na cheia. ⚠ Pré-COVID troca a corcova por falha de médio prazo. Nota:
  `notas/2026-08-18_precos_cross_instrumento.md`.
- [x] **Benchmark GRG (2025) sem célula het — FECHADO em 2026-08-01.**
  Desacordo cambial é de frequência/propagação, não identificação: (i) réplica
  diária em Python dá real apreciando 4,53%/100bp, dentro do IC95% do GRG;
  (ii) proporcionalidade LR=135,1 no diário contra nenhuma identificação nas
  288 células mensais válidas. Inconveniente a incluir: IBOV +2,83%/100bp no
  mesmo `b_1` diário, não identificado naquele sistema. Fonte:
  `arquivo/heterocedasticidade/notas/2026-08-01_robustez_heterocedasticidade.md` §6.
- [x] **Dominância fiscal: impacto não depende de estado, persistência sim —
  FEITO em 2026-07-28/29, virou `sec:estado`, baseline CDS.** Impacto (h=0-4)
  robusto nos 7 indicadores; persistência (h=6-8) sob CDS alto (t_dif
  2,81-3,60). ⚠ Depende do indicador: EMBI não detecta nada (t=0,32). ⚠ χ²(9)
  assintótico super-rejeita nesta amostra — exige wild block bootstrap.
  Fonte: `diagnostics/diagnostico_dfm.md` seção 7.
- [x] **Bloco de ativos: janela reportável h≤12 — RESOLVIDO em 2026-07-28**
  (`diagnostics/06_bloco_ativos.R`). Seção cruzada 8/8 negativos em h=0 → 1/8
  em h=12 (amplitude 30,4×); ordenação por sensibilidade a juros se inverte.
  Nenhum dos 8 índices é sig90 em horizonte nenhum.
- [x] **Ações em retorno acumulado: bloco acionário nulo é mecânico — TESTADO
  E CONFIRMADO em 2026-07-31.** `diff()` do BLL estima a segunda diferença do
  log-preço; em nível o bloco vai de 0 para 39 células sig90. ⚠ Custa força de
  instrumento (ξ_mp 10,43→8,94 em log-nível). **Decisão do autor: mudança de
  painel fica de lado** (`historico_decisoes.md` §3.1); só o `cumsum` foi
  corrigido (Tema E). Nota: `notas/2026-07-31_acoes_representacao.md`.

---

## E. Código e higiene


*Zerado em 2026-09-08 (ver nota de revisão no topo do arquivo); o item acima
abriu em 2026-09-10. Os itens que estavam aqui antes (seleção de `q`, reprodutibilidade do
estágio `di`, padronização do 2º estágio de `amengual_watson()`, o tcode
antigo em `irfs_required_long.csv`, o shim `scalar_dynamic_factor_compat.R`,
documentação do bootstrap, `paper_numbers.tex` gerado, o rótulo de tcode em
dois artefatos) não foram executados, testados nem decididos — apenas
removidos do registro. Recuperáveis no histórico do git.*

### Fechados (contexto)

- [x] **Auditoria de `script/` e `R/` — FEITO em 2026-09-17.** Foram 25 scripts de
  rodadas fechadas para `arquivo/script/`, com 10 funções e `validation_tests.R`
  para `arquivo/R/`. As 6 travas foram para `script/validation/`, e as duas
  narrativas `q` viraram `q_sensitivity.R --window=`. Os autotestes (a) e (b) de
  `q_truncation.R` passaram a conferir a `cheia_p4_lp`. Smoke, as travas e os CSVs
  regerados saíram idênticos ao HEAD. Mapa: `registro/mapa_renomeacoes.md`;
  motivos: `arquivo/README.md`.
- [x] **`cumsum` do bloco acionário corrigido — FEITO em 2026-08-17.** Tcode 6
  (`x*100` sem acumular) para os 7 `asset_*`; h=0 invariante, smoke test
  bit-idêntico. Largura h36/h0 27,573→0,920, pico falso do Ibovespa
  +17,71%(h=21)→+2,01%(h=8). ⚠ sig68 em h≤12 não melhorou (20→20) e sig90 do
  bloco caiu de 4 para 2 — ver Prohibitions em `CLAUDE.md`.
- [x] **`kilian_correction`: teste de singularidade trocado — FEITO em
  2026-08-17.** `det(M)<1e-12` virou `rcond()`; no DFM `(5,5)` a Lyapunov
  900×900 tinha `det` 6,29e-19 mas `rcond` 1,7e-06 — o ramo `ginv` era sempre
  tomado, e SIGMAY tinha o defeito oposto. ⚠ O aviso "Usando pseudo-inversa
  para SIGMAY" que o item previa sair em toda rodada **não reproduz** em
  `(5,5)` (`det(SIGMAY)` 2,9e+24); ganho de tempo previsto também não se
  confirmou (0,198→0,190 min).
- [x] **`estimate_dynamic_factors()` com `q=1<r` corrigido — FEITO em
  2026-08-17.** `M <- diag(sqrt(eigenvals), nrow=q)` cobre todos os `q`;
  smoke test bit-idêntico, `mosw_strength_grid.csv` reproduzido com desvio 0.
- [x] **`amengual_watson()` validado contra o MATLAB de SW — FEITO em
  2026-08-17.** Tradução fiel: `q_hat` 5 contra 5; gap remanescente é a
  constante `log(147/146)`, população vs. amostra. Fonte:
  `output/validation/amengual_watson_validation.md`.
- [x] **`download_di.py`: gate de sanidade posto — FEITO em 2026-08-17.**
  Resolve release pela API, aborta se faltar coluna, <100k linhas ou
  cobertura incompleta. Vintage não fecha por código: upstream trunca/poda
  releases; script aborta com diagnóstico correto em vez de gravar painel
  truncado.
- [x] **`install.packages()` removido de `instrument_diagnostics.R` —
  2026-08-17.** Contra a regra "fail loud"; `broom`/`lmtest` nem eram usados.
- [x] **Renomes registrados no acervo — FEITO em 2026-08-17.**
  `registro/mapa_renomeacoes.md` é o mapa único (2026-07-26 a 2026-08-17).
  `notas/`/`pareceres/` ficam verbatim; `metodo.md` e afins são editados in
  place por serem documentos vivos.
- [x] **`tab:first_stage` cortada para o `.tex` — FEITO em 2026-08-14.** §3.6
  ganhou a Tabela 1 (surpresa bruta → +BS → +JK, duas janelas). Número
  inconveniente reportado: pré-COVID a surpresa bruta é mais forte (ξ_mp 14,86
  contra 10,99 da produção) — produção se justifica por fidelidade, não força.
- [x] **Documentos de governança ressincronizados com a produção —
  2026-08-14.** Quatro `.md` de regra que ainda falavam de 106 séries
  corrigidos contra o output corrente (smoke test, contagem Rigobon, gate
  não-gaussiano). Lição: cada um agora aponta para o artefato que o produz.
- [x] **Produção migrada para 111 séries `(5,5)` — 2026-08-13.** Painel
  `drop_setor_externo__eua__credito__imoveis`; 800 réplicas, zero falhas,
  impacto exato +50pb. Nota:
  `notas/2026-08-13_migracao_producao_painel_111_r5q5.md`.
- [x] **Seleção de fim de mês corrigida — 2026-08-12.** Curva/EMBI+/ANBIMA
  usam a maior data mensal; 25 meses corrigidos. ξ_mp daquela rodada
  7,65/11,53, superada pela migração de 2026-08-13. Nota:
  `notas/2026-08-12_correcao_fim_mes_curva.md`.
- [x] **`R/modeling/svensson_model.R` sem consumidor — FECHADO em
  2026-08-05.** Motor do `script/yield_curve.R` (deletado); curva do painel é
  insumo fixo do orientador. Movido para `arquivo/R/modeling/svensson_model.R`.
- [x] **Taxonomia do `irf_spec_sweep.R` migrada para ξ_mp — FEITO em
  2026-07-26.** `classify_sweep_cells` usa limiares MOSW (3,84/10); 320
  células regeneradas e conferidas contra `mosw_strength_grid.csv`.
- [x] **Prosa do coherence separada do corpo gerado — FEITO em 2026-07-26.**
  `irf_coherence_leitura.md` (manual) vs. `irf_coherence_report.md` (gerado).
- [x] **`irf_mp_raw` renomeado para `irf_mp_pre_tcode` — FEITO em
  2026-07-26.** Nenhum consumidor do campo; zero mudança de output.
- [x] **`script/run_all.R` — FEITO em 2026-07-26.** Orquestrador de 8 estágios,
  um `Rscript` por estágio; flags `--list/--dry-run/--from/--to/--only/--skip`.
- [x] **Branches consolidadas — FEITO em 2026-07-26.** Cinco branches locais
  merged em `main`; `codigo_olea/` (87MB, commitado por engano) removido e
  ignorado.

---

## Convenção de branches

Movida para `.claude/rules/writing.md` (§"Branch convention") em 2026-09-08.
