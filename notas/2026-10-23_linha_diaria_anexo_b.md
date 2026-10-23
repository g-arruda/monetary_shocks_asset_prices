# Linha diária do Anexo B: câmbio realinhado e CDS às 17h de Nova York

> **CURRENT — 2026-10-23.** Último item do passo 3 de `registro/pendencias.md`, "Linha diária do
> Anexo B". Branch `feature/auditoria-janelas-copom`, **não mergeada**.
> - Supera a seção 7 da nota `2026-10-13_cambio_yahoo_convencao`, cujo CDS ainda ia de quarta a quinta.
> - O instrumento, o painel e a produção não mudam. As linhas mensais e a fatorial de
>   `output/het/` saíram idênticas às anteriores, e os sete validadores passam.
> - Decisões do autor em 23-10, antes de rodar:
>   - nas semanas sem reunião, o CDS usa a regra do câmbio, a janela de um anúncio às 18h00 de quarta;
>   - as 7 reuniões com quinta-feira de feriado no Brasil ficam fora, como antes, porque falta o DI de
>     quinta;
>   - o Anexo B ganha um parágrafo antes da tabela com toda a descrição dos painéis, e a legenda fica só
>     com as colunas e o teste;
>   - o parágrafo remete à `tab:horarios`, e o Anexo F não muda;
>   - a frase da linha fatorial é trocada, sem números;
>   - a regra é commitada antes de rodar (`2f388c3`).
> - Decisões do autor em 23-10, depois de ver os números:
>   - a frase da §3.3 ("a condição vale com o DI de três meses, embora o resultado dependa do vértice")
>     fica;
>   - o parágrafo dá o p de Holm dos três vértices.

## 1. A janela

- **DI.** Do fechamento de quarta ao de quinta, como antes.
- **Câmbio.** O Yahoo `BRL=X` pela hora da cotação, desde 10-13. Nas semanas de reunião, `yahoo_pre` e
  `yahoo_post` de `output/copom_timing/meetings.csv`. Nas demais, da noite de terça à de quarta.
- **CDS, novo.** O `PX_LAST` da Bloomberg às 17h de Nova York, das 18h às 20h em Brasília.
  - **Semanas com reunião.** A janela estreita do Anexo E, `cds_pre_ny17` e `cds_post_ny17` de
    `meetings.csv`. Ela vai de quarta a quinta em 76 das 104 semanas de reunião do painel. Nas outras 28,
    em que o fechamento de quarta vem depois do anúncio, vai da cotação anterior à quarta até a quarta.
    As 28 são todas as reuniões desse tipo entre as 111.
  - **Semanas sem reunião.** A janela de um anúncio às 18h00 de quarta.
    - Quando o fechamento cai às 18h00 em Brasília (horário de verão americano sem o brasileiro), ele
      conta como anterior, como nas 72 reuniões em que isso acontece. A janela vai de quarta à cotação
      seguinte, em 360 das 554 semanas.
    - Quando cai às 19h ou às 20h, a janela vai da cotação anterior à quarta até a quarta, em 194.
  - O CDS mudou em 222 semanas: as 28 de reunião e as 194 sem reunião.
- **Amostra.** As mesmas 658 semanas de antes, 104 com reunião. O teste perde a primeira, que é a da
  165ª reunião, e ficam `n_C` = 103 e `n_NC` = 554. As 7 reuniões com quinta-feira de feriado ficam fora
  porque falta o DI de quinta. Uma semana sem cotação numa janela vira NA e sai, sem carregar valor.
- **Guardas** em `script/het_conditions.R`:
  - toda semana de reunião acha as suas janelas de câmbio e de CDS em `meetings.csv`;
  - o ΔCDS dessas semanas é igual ao `d_cds_ny17`, a menos de arredondamento (diferenças de até 2e-15
    vindas do CSV pararam a primeira execução, corrigido em `6660755`).

## 2. A linha diária

`output/het/het_conditions.csv` e `het_variance_ratios.csv`. A coluna "`.tex` até hoje" é a impressa
antes desta rodada, com o câmbio e o CDS de quarta a quinta. A coluna "10-13" tem o câmbio realinhado e o
CDS ainda de quarta a quinta.

| vértice | estatística | `.tex` até hoje | 10-13 | agora |
|---|---|---|---|---|
| 3 meses | razão DI / câmbio / CDS | 5,54 / 1,04 / 0,80 | 5,47 / 0,69 / 0,81 | **5,46 / 0,68 / 0,78** |
| | λ₁ / λ₂ | 7,55 / 1,36 | 7,03 / 1,15 | **6,69 / 1,04** |
| | `Qr` p com correção | 0,003 | 0,0019 | **0,0004** |
| | Holm | 0,010 | 0,006 | **0,001** |
| 6 meses | razão DI / câmbio / CDS | 2,84 / 1,04 / 0,77 | 2,79 / 0,70 / 0,78 | **2,78 / 0,68 / 0,76** |
| | `Qr` p com correção | 0,084 | 0,064 | **0,034** |
| | Holm | — | 0,127 | **0,068** |
| 12 meses | razão DI / câmbio / CDS | 2,66 / 1,04 / 0,78 | 2,62 / 0,70 / 0,79 | **2,62 / 0,69 / 0,77** |
| | `Qr` p com correção | 0,147 | 0,081 | **0,047** |
| | Holm | — | 0,127 | **0,068** |

- ⚠ **Os três vértices rejeitam a 5% sem ajuste**, e com Holm só o de 3 meses rejeita a 5%. Antes, só o de
  3 meses rejeitava a 5%. O p continua subindo com o vencimento, como a razão de variância do DI cai.
  A §3.3 fica como está, por decisão do autor.
- **A correção de curtose continua decidindo.** Sem ela, os três vértices rejeitam com p abaixo de 1e-5
  (`Qr` 65,3, 28,6 e 25,3). O fator de curtose cai de 4,97 a 4,14 no vértice de 3 meses, e de 5,04 a
  4,24 e de 4,95 a 4,15 nos outros dois.
- **Só a variância do DI sobe nas semanas de reunião.** As do câmbio ficam entre 0,68 e 0,69 da variância
  das demais semanas, e as do CDS entre 0,76 e 0,78. A frase da §3.3 continua verdadeira.
- O câmbio de cada semana não mudou, mas a razão dele vai de 0,69–0,70 a 0,68–0,69. As matrizes por
  regime saem dos resíduos de MQG do sistema (`fit_het_cv()`), que dependem das três séries. A
  fidelidade dos resíduos às séries fica entre 0,982 e 0,985, acima do piso de 0,98 da guarda `inert_lag`.
- O determinante normalizado do vértice de 3 meses vai de 33,8 a 26,8.

## 3. As linhas mensais

- **VAR mensal, por MQO e sob a escala.** Byte-idêntico, assim como `het_var_theta.csv`.
- **Linha fatorial.** Idêntica à da nota de 10-13, na base da branch: λ₁ 3,05 (EP 0,72), λ₂ 1,72
  (0,41).

  | teste | p |
  |---|---|
  | `λ₁ = λ₂` | 0,312 (sem correção 0,228) |
  | `λ₁ = λ₂ = λ₃` | 0,354 |
  | `λ₁ = … = λ₄` | 0,240 |
  | `λ₁ = … = λ₅` | 0,145 |

  Nenhum teste sequencial rejeita a 10%. As rejeições 0,035, 0,021 e 0,013 que a legenda imprimia eram
  da base anterior à branch.

## 4. O que foi ao `.tex`

O Anexo B, e nada mais. A §3.3, o Anexo F e o resumo não mudam.

- **Parágrafo novo antes da tabela**, que leva a descrição dos três painéis. Ela estava na legenda:
  - as janelas do DI, do câmbio e do CDS, com e sem reunião, com remissão à `tab:horarios`;
  - por que as 7 reuniões de feriado ficam fora;
  - 103 e 554 semanas, 657 das 658;
  - o Holm dos três vértices, 0,001 e 0,068;
  - o VAR mensal com a escala da COVID;
  - a linha fatorial, em que nenhum teste sequencial rejeita a 10%;
  - a frase de que frequência e objeto medido mudam juntos.
- **Tabela.**
  - As três linhas diárias e a fatorial com os números novos. As mensais ficam.
  - O título do bloco diário passa de "variação de quarta para quinta-feira" a "janela do anúncio".
- **Legenda.** Só as séries, a razão de variância, os λ, o `Qr` e a correção de curtose.
- O PDF compila sem erro nem overfull. O "Table 4" do `\autoref` é o problema já registrado na versão
  integrada.

## 5. O que pode e o que não pode ser dito

- Pode: no diário, com o DI de quarta a quinta e o câmbio e o CDS da última cotação antes do anúncio à
  primeira depois, a condição de posto vale nos três vértices a 5% sem ajuste. Com Holm para os três,
  ela vale a 5% só no vértice de 3 meses, com p 0,001 contra 0,068 nos outros.
- Pode: nas semanas de reunião, só a variância do DI sobe. As do câmbio e do CDS ficam abaixo das demais
  semanas.
- Pode: sem a correção de curtose, todo vértice rejeitaria.
- Pode: no painel mensal, nem o VAR (por MQO ou sob a escala) nem as inovações fatoriais rejeitam, e na
  linha fatorial nenhum teste sequencial rejeita a 10%.
- Não pode: tratar como correntes os p 0,003, 0,084 e 0,147, o Holm 0,010, a razão do câmbio 1,04, as 102 e
  553 semanas, nem os 0,0019, 0,064 e 0,081 da nota de 10-13.
- Não pode: citar as rejeições da linha fatorial (0,035, 0,021 e 0,013).
- Não pode: dizer que só o vértice de 3 meses rejeita sem dizer que é com Holm, ou sem dar o nível.
- Não pode: decompor a diferença entre o diário e o mensal em frequência e objeto medido. A proibição
  de 2026-09-22 continua.

## 6. O que mudou

- `R/identification/het_tests.R`: `build_weekly_changes()` aceita `prices` vazio. `het_rigobon/` continua
  passando preços, e nada nele muda.
- `script/het_conditions.R`: o CDS sai de `prices` e é diferenciado na própria janela. As constantes
  `CDS_CLOSE_NY` e `NO_MEETING_RELEASE` servem também ao câmbio, sem mudar o resultado. Entram as duas
  guardas, e `daily_changes.csv` ganha `cds_pre` e `cds_post`.
- `output/het/`: `daily_changes.csv`, `het_conditions.csv`, `het_qr_tests.csv`, `het_variance_ratios.csv`
  e `het_lambda.csv`. Mudam só as linhas diárias.
- `paper/paper.tex`, o Anexo B.
- `CLAUDE.md`, `.claude/rules/data.md`, `.claude/rules/writing.md`, `script/README.md`,
  `registro/pendencias.md`, `registro/fechados.md` e `notas/_indice.md`.
