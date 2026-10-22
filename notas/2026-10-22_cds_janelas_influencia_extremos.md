# CDS estreito contra ampliado no Anexo F, e influência, extremos e surpresa bruta no texto

> **CURRENT — 2026-10-22.** Dois itens do passo 3 de `registro/pendencias.md`: "CDS estreito contra
> ampliado" (e-mail do orientador de 19-10, item 4) e "Influência, extremos e surpresa bruta no texto"
> (e-mails de 12-10, item 1, e de 19-10, item 5). Branch `feature/auditoria-janelas-copom`, **não
> mergeada**.
> - Nada reestimado. Só `paper/paper.tex` e o registro mudam. Os números vêm de
>   `output/daily_event/regressions.csv` e `comparison.csv`, de `output/meeting_influence/joint_fx_cds.csv`,
>   `joint_strength.csv`, `ranking.csv` e `extreme_meetings.csv`, e de
>   `output/copom_timing/cds_us_holidays.csv`, todos na base de 111.
> - Decisões do autor em 22-10, antes de escrever:
>   - a comparação estreita × ampliada vai no parágrafo do CDS do Anexo F, com números, por +50 p.b. de
>     surpresa ortogonalizada, Wald HC1 a 90%, nas 111 reuniões e na de 104;
>   - a limitação de 28/11/2013 e a checagem de feriados entram numa frase do mesmo parágrafo, com a
>     contagem;
>   - influência e extremos vão numa §5 com duas subseções, 5.1 Benchmark VAR e 5.2 Reuniões influentes
>     e movimentos externos extremos;
>   - a 5.2 tem prosa e tabela. A tabela traz ξ_mp, o impacto e os horizontes significantes a 90%. A
>     prosa fala só de sinal e significância;
>   - a regra e a ordem ficam no corpo, e a fórmula da influência vai em rodapé, com 81% e 48%;
>   - entram também a concentração, uma frase sobre o fim do horizonte sem os extremos e o Brent pelas
>     exclusões individuais, sem números;
>   - a surpresa bruta vai numa frase sem números no parágrafo de leitura do Anexo E, só na base de 111;
>   - a rodada é commitada à parte, depois do commit das rodadas de 21-10 e 22-10 (`5a5a1c1`).
> - ⚠ **A surpresa bruta no e-mail de 12-10.** O e-mail do autor de 12-10 (`email/email_meu_12-10_17h22.md`,
>   item 2) diz "No DFM com a surpresa bruta, câmbio e CDS não são significantes a 90%", e o orientador
>   repetiu isso no e-mail de 12-10 (item 1) e retomou no de 19-10 (item 5). A nota
>   `2026-10-05_evento_diario` (seção 5) diz que eles **são** significantes a 90% e não a 95%, na base de
>   102. Na base de 111 vale o mesmo (seção 3). O artigo segue os dados. A errata ao orientador fica a
>   critério do autor.

## 1. CDS estreito contra ampliado (Anexo F)

**Os números.** Vêm de `regressions.csv`, surpresa `ortogonalizada`. A forma reduzida é por +50 p.b. de
surpresa, e o intervalo de 90% é `coef ± qnorm(0.95)·se`, com o EP HC1 de `script/daily_event.R`. É a
convenção da `fig:ponte`.

| base | janela | n | ponto (p.b.) | 90% Wald | p |
|---|---|---|---|---|---|
| 111 | estreita | 111 | −0,797 | [−6,59; 5,00] | 0,821 |
| 111 | ampliada | 111 | +7,715 | [0,69; 14,73] | 0,071 |
| 104 | estreita | 104 | −0,856 | [−7,45; 5,74] | 0,831 |
| 104 | ampliada | 104 | +6,879 | [−0,98; 14,74] | 0,150 |

- Na estreita, o número das 111 coincide, no arredondamento do artigo, com o da 1ª cotação da `fig:ponte`
  (110 reuniões): −0,8 [−6,6; 5,0].
- Os conjuntos AR da nota `2026-10-18_conferencias_ponte` (seção 3) dão a mesma leitura: a ampliada é
  significante a 90% na de 111 e não é na de 104.
- O 95% não entra. Continua só no Anexo E.

**O texto.** A janela ampliada é a estreita com uma cotação a mais de cada lado. A frase diz que a alta é
compatível com um ajuste posterior ao anúncio, mas que essa janela incorpora também outras notícias (e-mail
de 19-10, item 4). Na de 104, a ampliada deixa de ser significante a 90%.

**Os feriados.**
- O CDS cota em todos os 156 dias úteis de feriado dos EUA de 2012-03 a 2025-12, nos calendários da NYSE e
  do Federal Reserve (nota `2026-10-21_convencoes_temporais_feriados_cds`, seção 1).
- A cotação de 28/11/2013 fecha a janela da reunião de 27/11. É um valor inteiro e fica na amostra.
- A janela ampliada dessa reunião, de 26/11 a 02/12, não entra no texto (decisão do autor).

## 2. Influência e extremos (§5.2 e `tab:influencia`)

**A §5.** Passa a ter duas subseções. `sec:robustez` fica na seção. A 5.1, Benchmark VAR, leva
`sec:weak_iv` e o texto de antes sem mudança. A 5.2 leva `sec:influencia`. Nenhum `\ref` do `.tex` aponta
para esses rótulos.

**A tabela** (`joint_strength.csv`, `joint_fx_cds.csv`, nível 0,9):

| reuniões retiradas | ξ_mp | câmbio h0 | câmbio, meses a 90% | CDS h0 | CDS, meses a 90% |
|---|---|---|---|---|---|
| nenhuma | 7,28 | 0,125 | 0–6 | 30,6 | 0–7, 35–36 |
| as 5 mais influentes | 4,82 | 0,150 | 3–6 | 36,2 | 0–7 |
| as 10 mais influentes | 2,36 | 0,005 | nenhum | 22,5 | nenhum |
| as 14 com movimento extremo | 6,00 | 0,090 | 1–4, 32–36 | 29,4 | 0–6, 30–36 |

**A prosa.**
- Nenhuma exclusão inverte o sinal do câmbio ou do CDS de h0 a h6 (conferido em `joint_fx_cds.csv`).
- Sem as dez, os conjuntos de 90% não são limitados (ξ_mp 2,36 < 2,71), e a inferência é inconclusiva, não
  uma resposta nula.
- A regra dos extremos é dita fixada antes de ver os resultados (`2cad8bd`, emenda `cb24156`).
- O rodapé dá a fórmula da influência e a concentração: as dez carregam 81,3% de d₀'Γ̂ e 47,9% da soma dos
  quadrados do instrumento (`joint_strength.csv`, colunas `den` e `instrument_ss`).

**O Brent**, por `ranking.csv`. Em h0, as três exclusões individuais que mais baixam o câmbio, entre as 108
reuniões em Γ̂, são de reuniões marcadas só pelo Brent:

| reunião | variação do câmbio em h0 sem ela |
|---|---|
| 2021-03-18 | −0,0168 |
| 2022-03-17 | −0,0163 |
| 2020-03-19 | −0,0106 |

- A quarta é a de 2022-02-03, marcada pelo S&P 500, com −0,0092.
- As exclusões individuais somam −0,024 nas seis reuniões marcadas só pelo Brent e −0,006 nas sete
  marcadas só por S&P 500 ou VIX. A de 2022-06-17, marcada pelas duas, dá +0,002.
- ⚠ A de 2016-01-21, também do Brent, sobe o câmbio em +0,0195. Por isso o texto diz "as três que mais
  reduzem", e não "as reuniões do Brent".
- A soma não vai ao texto (decisão do autor).

**Fora do texto, por decisão do autor:**
- ⚠ a regra marca 3 das 9 janelas de quarta a sexta, cuja variação de dois dias é comparada com um limiar
  de um dia (nota `2026-10-20_saidas_base_111`, seção 5);
- as 3 reuniões de 2012 que vêm antes da primeira inovação, de modo que a ordem cobre 108 das 111.

## 3. Surpresa bruta (Anexo E)

`comparison.csv`, estágio `dfm_mensal`, base `producao_111`, h0, ξ_mp 7,69:

| série | ponto | 90% | 95% |
|---|---|---|---|
| câmbio (R$/US$) | 0,101 | [0,015; 0,179] | [−0,017; 0,206] |
| CDS (p.b.) | 24,9 | [6,0; 45,1] | [−0,4; 52,6] |

- A frase sem números vai no parágrafo de leitura do Anexo E: no mês do anúncio, os dois são significantes
  a 90% e não a 95%.
- Fora do texto: na de 104, nenhum dos dois é significante a 90%. Em h1, o câmbio com a bruta também não é
  significante a 90% ([−0,005; 0,246], `output/irf/instrument_layers_irf.csv`).

## 4. Verificação

- `pdflatex` + `bibtex` + `pdflatex` ×2 sem erro, overfull ou underfull. O único aviso, `TS1/aer/m/n`, já
  existia. O artigo tem 37 páginas, e a `tab:influencia` sai na p. 19.
- `grep` em `paper.tex`: nenhum "exclui zero"; o 95% como nível de confiança só no Anexo E.
- ⚠ `\autoref` segue imprimindo "Table" (item da versão integrada).
