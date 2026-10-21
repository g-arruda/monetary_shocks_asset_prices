# Convenções temporais no Anexo F e as cotações de CDS em feriados dos EUA

> **CURRENT — 2026-10-21.** Os dois itens do passo 1 de `registro/pendencias.md`, pelo e-mail do
> orientador de 19-10, item 4 (`email/email_professor_19-10_14h13.md`). Branch
> `feature/auditoria-janelas-copom`, **não mergeada**.
> - Nada foi reestimado. `script/copom_timing.R` rodou de novo, e as saídas que já existiam em
>   `output/copom_timing/` saíram bit-idênticas. A única saída nova é `cds_us_holidays.csv`.
> - Decisões do autor em 21-10, antes de escrever:
>   - o calendário da lista é a união da NYSE e do Federal Reserve, com uma coluna para cada;
>   - a lista fica no registro (CSV e esta nota). O artigo a menciona com o item "CDS estreito contra
>     ampliado" do passo 3;
>   - as convenções vão num Anexo F novo, depois do E. Um rodapé único na §3.3 foi descartado porque
>     não comporta sete URLs e quatro convenções;
>   - o anúncio entra numa oração, sem fontes;
>   - o horário do Yahoo e o do CDS são escritos como fato, sem fonte e **sem a palavra "hipótese"**;
>   - do Yahoo entram a janela diária e o deslocamento da média mensal;
>   - a margem de 30 minutos entra só como regra, sem as contagens;
>   - o formato é prosa mais uma tabela curta;
>   - a única remissão é um rodapé na §3.3.
> - ⚠ O e-mail pede para manter "documentadas as hipóteses sobre as cotações do Yahoo e do CDS". O
>   artigo não as chama de hipóteses, por decisão do autor. Para o registro, nenhum dos dois horários
>   é documentado pelo provedor: o do Yahoo é inferido dos carimbos da API, e o do CDS é a decisão do
>   autor de 14-10 (nota `2026-10-17_auditoria_janelas_copom`, seção 2).

## 1. As cotações de CDS em feriados dos EUA

**O CDS cota em todos os 156 dias úteis de feriado dos EUA de 2012-03 a 2025-12.** A lista está em
`output/copom_timing/cds_us_holidays.csv`, uma linha por dia, com as colunas:
- `nyse_closed` e `fed_closed`;
- a cotação, a anterior e a variação;
- `whole_number`, que marca as cotações inteiras.

**O calendário.** A lista é a união de dois calendários, contados só em dias úteis:
- a NYSE, com os dez feriados de bolsa e quatro fechamentos especiais: 29 e 30/10/2012 (furacão Sandy),
  05/12/2018 (luto por Bush) e 09/01/2025 (luto por Carter);
- o Federal Reserve, com os feriados federais, Columbus e Veterans incluídos.

As datas observadas seguem a regra de cada um. Os dois fecham na segunda depois de um feriado de
domingo. A NYSE também fecha na sexta antes de um feriado de sábado, exceto o 1º de janeiro, e o Fed
não fecha.

| feriado | NYSE e Fed | só NYSE | só Fed | total |
|---|---|---|---|---|
| Ano Novo | 12 | 0 | 0 | 12 |
| Martin Luther King Jr. Day | 13 | 0 | 0 | 13 |
| Washington's Birthday | 13 | 0 | 0 | 13 |
| Sexta-Feira Santa | 0 | 14 | 0 | 14 |
| Memorial Day | 14 | 0 | 0 | 14 |
| Juneteenth (desde 2022) | 4 | 0 | 0 | 4 |
| 4 de julho | 12 | 2 | 0 | 14 |
| Labor Day | 14 | 0 | 0 | 14 |
| Columbus Day | 0 | 0 | 14 | 14 |
| Veterans Day | 0 | 0 | 12 | 12 |
| Thanksgiving | 14 | 0 | 0 | 14 |
| Natal | 13 | 1 | 0 | 14 |
| fechamentos especiais da NYSE | 0 | 4 | 0 | 4 |
| **total** | **109** | **21** | **26** | **156** |

- Os dias só da NYSE são as sextas observadas (03/07/2015, 03/07/2020 e 24/12/2021), as Sextas-Feiras
  Santas e os fechamentos especiais.
- Os dias só do Fed são Columbus e Veterans, com as segundas observadas de 12/11/2012 e 12/11/2018.
- Os 72 dias só dos EUA do teste (A) (nota `2026-10-13_ponte_horarios_copom`, seção 5.2) estão todos na
  lista. O script confere isso e confere também que cada dia da lista tem cotação.
- **A SIFMA não virou coluna**, ajuste à opção aprovada. A recomendação dela para a Sexta-Feira Santa
  muda de ano a ano e não está no registro. A Sexta-Feira Santa já entra na lista pela NYSE.

**O que isso diz sobre 28/11/2013.**
- Cotar num feriado dos EUA não distingue a observação de 28/11/2013, porque o CDS cota em todos.
- O que a distingue é o valor inteiro. Ela é a única cotação inteira entre os 156 dias: 205,000, contra
  205,168 na véspera.
- Um único feriado tem variação zero: 11/11/2014, Veterans Day, com a NYSE aberta e só o Fed fechado.

## 2. O Anexo F

**`paper/paper.tex`**, depois de `tab:ponte`: `\section*{Anexo F. Convenções temporais e fontes}`, com
`\label{anexo-F}`.

Quatro parágrafos:
1. **Anúncio e margem.** Os horários são de Brasília, no fuso de cada data. O anúncio é o término da
   última sessão registrado na ata, ou o horário mínimo do BCB, o que vier depois. Depois vem a regra
   dos 30 minutos.
2. **DI.** A cotação é o último negócio, de modo que seu horário é no máximo o fim da negociação do
   DI1. A grade é esta:
   - 18h00 de 2019 a 09/12/2022, com sessão estendida;
   - contínua das 9h00 às 18h00 desde 12/12/2022;
   - 18h15 de 2012 a 2018, o fim do segmento BM&F, por fontes secundárias.
3. **Câmbio.** O Yahoo BRL=X é cotado à meia-noite de Londres, das 20h00 às 22h00 em Brasília. A data da
   linha é a data UTC desse instante. A trajetória do Anexo E escolhe as cotações pelo horário. A média
   mensal do painel fica deslocada uma noite para trás no inverno europeu.
4. **CDS.** O CDS diário é o PX_LAST da Bloomberg, às 17h00 de Nova York, das 18h00 às 20h00 em
   Brasília. O CDS mensal do painel é o do Investing.com.

**`tab:horarios`.** Três colunas (série, cotação, horário em Brasília) e quatro linhas: os dois períodos
do DI, o Yahoo e o CDS. Não tem coluna de status.

**As fontes.** Três rodapés com URL, todos no parágrafo do DI. O orçamento de 25 chaves não muda.
- Rodapé 1: as capturas do Wayback de 07/01/2019 e 24/01/2022 e o Ofício Circular 094/2020-PRE.
- Rodapé 2: a grade atual da B3 e a InfoMoney de 23/11/2022.
- Rodapé 3: a Exame de 19/10/2012 e o Jornal do Comércio de 14/10/2016.

As URLs são as do item 5 de `email/email_meu_18-10_20h26.md`. As sete responderam 200 em 21-10.

**O ofício, conferido no PDF.**
- É de 30/07/2020, e não de 01/11/2020, como o nome do arquivo sugere.
- Altera a grade a partir de 03/11/2020, no fim do horário de verão dos EUA.
- Diz que os contratos de derivativos que não especifica, e todos os de renda fixa, ficam com o horário
  inalterado.
- O anexo do ofício não lista nenhum contrato de juros.

**A remissão.** Um rodapé na §3.3, em "O Copom anuncia a decisão depois do fechamento do mercado", aponta
para a `tab:horarios` e para o Anexo F.

**O preâmbulo** passa a ter `\usepackage[hyphens]{url}` e `\Urlmuskip=0mu plus 2mu`.
- Sem eles, as URLs dos rodapés davam 1 overfull de 42 pt e 5 underfull.
- Com eles, o artigo compila sem aviso, como antes da rodada, em 34 páginas.

**O que o Anexo F não cobre.**
- O Anexo B não é citado, porque o `.tex` ainda não leva o câmbio realinhado. É o item "Linha diária do
  Anexo B" do passo 3.
- A limitação de 28/11/2013 no texto vai com o item "CDS estreito contra ampliado" do passo 3.
