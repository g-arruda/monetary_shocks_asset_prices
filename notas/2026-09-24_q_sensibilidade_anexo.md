# `q = r` justificado na §3.1 e a sensibilidade a `q` no Anexo C

> **CURRENT — 2026-09-24.** Rodada editorial em `paper/paper_anpec.tex`, **sem
> reestimação da produção**.
> - Produção de 115 séries, 2012-03 a 2025-12, `(r,q,p) = (5,5,4)`, escala de
>   volatilidade COVID de Lenza-Primiceri e conjuntos Anderson--Rubin de 68% e 90%
>   com NW(0).
> - Fecha dois itens de `registro/pendencias.md`: `q = r` (Tema A) e a figura
>   `q = 2,…,5` (Tema B, passo 4/4 do e-mail do orientador de 2026-09-13).
> - Nada em `R/` mudou. O smoke test e `script/validation/` não são afetados.

## 1. O que mudou no paper

**§3.1.** A frase segundo a qual `q = 5` era "decisão explícita" e o `q = 2` de
Amengual-Watson era "reportado mas não usado" saiu. No lugar entrou uma defesa de
duas frases:
- Amengual-Watson, agora citado, seleciona `q = 2`;
- a especificação fixa `q = r`, como Stock-Watson (2016), que diante do mesmo
  conflito sobre-especificam o espaço das inovações para que ele contenha o dos
  choques de interesse, e como Alessi-Kerssenfischer (2019);
- o Anexo C repete o exercício de sensibilidade de AK, com `q` de 2 a 5.

As âncoras foram conferidas nos textos salvos em `artigos/`:
- Stock-Watson (2016), §7.2: "we err on the side of over-specifying the space of
  innovations…";
- AK, nota 4: `q = r`, `r = 8` pelo Bai-Ng, robustez nas Figuras A1–A3. A A3 é a
  do número de fatores dinâmicos.

**Anexo C, novo.** Tem só a figura `fig:q_sensibilidade`, sem parágrafo, e a
legenda segue o padrão da §4. A figura tem oito painéis:
- DI de 2 e de 5 anos;
- BRL/USD e CDS;
- IBC-Br e IPCA;
- Ibovespa e DLSP.

`q = 5` aparece com os conjuntos AR, e `q = 4, 3, 2` como estimativas pontuais,
como na Figura A3 de AK. O eixo vai até h36, com os rótulos e as escalas de
`script/fig_section5.R`.

**Bibliografia.** `amengual2007consistent` passou a ser citada, e o paper usa agora
24 das 25 chaves. ⚠ O registro dizia que Amengual-Watson "não está em
`references.bib`". A entrada existia, só não era citada.

## 2. Código

`script/q_sensitivity.R --window=cheia` escreve `paper/fig_q_sensibilidade.pdf`
além do PDF de registro de quatro páginas até h48, que continua igual nas duas
janelas. A figura reusa `plot_dimension_overlay()` (`R/identification/spec_sweep.R`)
sem mudá-la.

**Guarda.** O ponto e os limites de 68/90% de `q = 5` nas oito séries, em h ≤ 36,
batem com `output/irf/irf_coherence_h.csv` a 1e-10, a mesma checagem de
`fig_section5.R`. A linha de produção do anexo é, portanto, a da §4.

`--window=pre_covid` roda sem tocar no paper. Os dois PDFs de registro saem
idênticos aos commitados, salvo o carimbo de data.

## 3. Decisões do autor

1. **A defesa é curta e ancorada em Stock-Watson e AK.** Não entra a perna do
   truncamento, que diria que reter as `q` direções de maior variância pode
   descartar aquelas em que está a covariância do instrumento. A citação de
   Stock-Watson já carrega esse argumento.
2. **Sem números no texto.** O item do Tema A previa citar as contagens e as
   razões de impacto. Elas ficam nesta nota, e a figura mostra o que dizem.
3. **Citar Amengual-Watson**, gastando a chave 24 de 25.
4. **Só as séries principais na figura**: oito das vinte da narrativa.

O horizonte de 36 meses não foi decisão do autor. Ele segue o §3.1 ("de 0 a 36
meses") e as figuras da §4.

## 4. Os números, em h = 0 a 36

Estes números saíram de uma conta de leitura sobre as mesmas células de
`q_sensitivity.R --window=cheia`. É a fração de horizontes em que o ponto de cada
`q` cai no conjunto de 90% de `q = 5`. **Nenhum script os grava**, e o paper não
cita nenhum deles.

Séries inteiramente dentro da banda, entre as 20 da narrativa:

| `q = 4` | `q = 3` | `q = 2` |
|---|---|---|
| 16 | 5 | 4 |

As contagens são as mesmas de h = 0 a 48 (`q_narrative_r5p4_covid_summary.csv`,
que a mesma conta reproduz exatamente).

Com `q = 4`, quatro séries saem da banda em algum horizonte:

| série | horizontes dentro | em 0–48 |
|---|---|---|
| `cambio_usd` | 29 de 37 (0,784) | 0,837 |
| `expect_focus_fiscal_primary_balance_ny` | 24 de 37 (0,649) | 0,735 |
| `expect_focus_fiscal_dlsp_ny` | 35 de 37 (0,946) | 0,959 |
| `expect_focus_cambio_ny` | 36 de 37 (0,973) | 0,980 |

Impacto de cada `q` sobre o de `q = 5`, em h = 0:

| série | `q = 4` | `q = 3` | `q = 2` |
|---|---|---|---|
| `asset_ibov` | 1,15 | 8,62 | 8,49 |
| `cambio_usd` | 1,54 | 2,31 | 2,37 |
| `cds_5y` | 1,35 | 2,47 | 2,47 |
| `ibc_br` | 1,53 | 2,56 | 2,49 |
| `price_ipca` | 1,20 | 3,75 | 4,55 |
| `yield_2y` | 1,15 | 1,51 | 1,51 |

O IBC-Br fica inteiro na banda nos três `q`, mesmo com impacto 2,6 vezes o de
produção em `q = 3`, porque a banda dele é larga. Contagem e razão de impacto
medem coisas diferentes.

## 5. O que fica fora do paper

- **O modelo sem a escala LP.** Nele nenhuma das 20 séries fica contida em
  `q = 3`, contra 5 no tratado, e o impacto do Ibovespa em `q = 3` é 24 vezes o de
  produção, contra 8,6 no tratado. A correção reduz a sensibilidade, mas não a
  elimina. ⚠ A comparação é limpa: os conjuntos de `q = 5` têm a mesma largura com
  e sem o tratamento (razão mediana 1,00 em h ≥ 1, nas 16 séries com banda nos dois
  arquivos). Fica para resposta a parecerista.
- **O mecanismo do truncamento na cheia tratada** (`q_truncation_directions.csv`,
  célula `cheia_p4_lp`, de um script hoje arquivado). As direções 4 e 5 somam 15%
  da variância das inovações e 56% da covariância entre o instrumento e a inovação
  do DI de seis meses. ⚠ O teste conjunto T1 não rejeita a 5% (p 0,203 / 0,109 /
  0,068 em `q` = 2 / 3 / 4).

## 6. O que não se pode dizer

- **Que as respostas são insensíveis a `q`.** Com `q ≤ 3` os impactos de câmbio,
  CDS e Ibovespa se ampliam, e a figura mostra isso. A defesa do texto é a de
  Stock-Watson e AK, não a insensibilidade.
- **Que `q = 2, 3, 4` têm conjuntos.** Só há pontos.
- **Que o paper cita estes números.** Não cita.
