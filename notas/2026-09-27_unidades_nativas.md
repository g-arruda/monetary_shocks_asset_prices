# As séries em nível passam à própria unidade: fim da divisão pela média amostral

> **CURRENT — 2026-09-27, branch `feature/unidades-nativas`.** Rodada de apresentação, **sem
> reestimação**. Os números vêm de `output/irf/irf_coherence_cell.rds` e de
> `output/var/svar_iv_weak_robust.csv`, em escala 1 para as séries em nível. A produção é a de
> `2026-09-26_producao_bs_purif_bandas_80_90` e não mudou.

## 1. Decisão do autor

As séries com tcode 1 saem do modelo na unidade original. São elas o câmbio, o IBC-Br, os índices
de produção, as vendas e as horas trabalhadas. Até hoje, `script/fig_section5.R`,
`R/reporting/sensitivity.R` e `script/fig_weak_iv.R` multiplicavam essas respostas por
`100/média amostral`, e a prosa as chamava de "%". Nenhum artigo da literatura usa essa
normalização, e o autor pediu que ela acabasse.

A alternativa usual, pôr essas séries em log, foi estimada hoje em duas versões e recusada pelo
autor (`registro/historico_decisoes.md` §20). A decisão foi reportar na unidade que o tcode 1 já
entrega:
- o câmbio em reais por unidade de moeda, com três decimais, como o Focus câmbio já aparece na
  §4.4 (R$ 0,075/US$);
- os índices em pontos do índice;
- BRL/CNY, BRL/INR e BRL/ARS saem da prosa da §4.2. Em unidade nativa as cinco magnitudes deixam
  de ser comparáveis (R$ por dólar contra R$ por rupia), e a `fig:cambio` só mostra o dólar e o
  euro. As três séries seguem no painel e nos CSVs.

## 2. O que mudou

**Código.**
- `script/fig_section5.R`: as escalas `NA` viraram `1` e os rótulos passaram a "(R$/US$)",
  "(R$/€)" e "(pontos)". O painel deixou de ser lido, porque só servia à média.
- `R/reporting/sensitivity.R::rescale_to_paper_units()` perdeu o argumento `panel`.
- `script/q_sensitivity.R`, `script/p_sensitivity.R` e `script/instrument_layers_irf.R` seguem a
  mesma troca em `PAPER_PANELS`.
- `script/fig_weak_iv.R`: as duas colunas de escala viraram uma só, igual nos dois modelos.

**Figuras repintadas.** `fig_cambio_risco`, `fig_atividade`, `fig_weak_iv_main`,
`fig_q_sensibilidade`, `fig_p_sensibilidade` e `fig_instrumento_camadas`. Os CSVs que os três
scripts de anexo escrevem saíram byte-idênticos, o que confirma que nada foi reestimado.

**Paper.** Mudaram:
- o resumo em português e em inglês;
- a §4.2 e a §4.5;
- a §5;
- a conclusão;
- as legendas de `fig:cambio`, `fig:atividade`, `fig:q_sensibilidade`, `fig:p_sensibilidade` e
  `fig:instrumento_camadas`.

A nota do Anexo A já dizia que, com código 1, a resposta sai na unidade da série. Agora as figuras
concordam com ela.

## 3. Números: antes e depois

| passagem | série, horizonte | antes (% da média) | agora |
|---|---|---:|---:|
| resumo, §4.2, §5, conclusão | BRL/USD, h0 | 3,53% | R$ 0,141/US$ |
| §4.2 | BRL/EUR, h0 | 2,64% | R$ 0,121/€ |
| §4.2, §5 | BRL/USD, pico em h1 | 4,45% | R$ 0,178/US$ |
| §4.2 | BRL/EUR, pico em h1 | 3,44% | R$ 0,157/€ |
| §4.2 | BRL/USD, h36 | (não citado) | −R$ 0,115/US$ |
| §4.2 | BRL/EUR, h36 | −1,51% | −R$ 0,069/€ |
| §4.5, §5 | IBC-Br, h0 | −0,77% | −0,77 ponto |
| §4.5 | transformação, h0 | −2,35% | −2,43 |
| §4.5 | bens duráveis, h0 | −6,67% | −7,97 |
| §4.5 | bens de capital, h0 | −3,88% | −3,68 |
| §4.5 | varejo, h0 | −1,40% | −1,38 |
| §4.5 | serviços, h0 | −0,82% | −0,79 |
| §4.5 | horas, h0 | −1,37% | −1,27 |
| §4.5 | IBC-Br, h2 / h15 / h24 / h36 | −0,45 / −0,67 / −0,59 / −0,35% | −0,45 / −0,66 / −0,59 / −0,35 |
| §4.5 | duráveis h9, horas h10, capital h12 | −7,13 / −1,41 / −4,39% | −8,52 / −1,30 / −4,16 |
| §4.5 | transformação e varejo, h10 | −2,31 / −1,36% | −2,39 / −1,34 |
| §4.5 | faixa em h36 | −0,21% (duráveis) a −0,90% (capital) | −0,22 (horas) a −0,85 (capital) |
| §4.5 | serviços, h23 / h36 | −1,10 / −0,89% | −1,06 / −0,86 |
| §5 | IBC-Br no VAR, h0 / h4 | −1,28 / −0,42% | −1,27 / −0,42 |
| §5 | IBC-Br no DFM, h4 | −0,55% | −0,55 |
| §5 | BRL/USD no VAR, h0 / h1 | 2,49 / 3,95% | R$ 0,100 / 0,158 por US$ |
| `irf_section.md` | BRL/USD, conjuntos de 80 e 90% em h0 | [2,15; 5,65] e [1,72; 6,86] | [0,086; 0,226] e [0,069; 0,275] |

Como a média do IBC-Br e dos índices de atividade fica perto de 100, os números em pontos ficam
perto dos antigos. No câmbio a escala muda por inteiro.

## 4. O que não muda, e a exceção

A troca multiplica cada série por um escalar positivo. Por isso não mudam sinais, horizontes de
pico, vale e cruzamento, a topologia dos conjuntos AR e a significância. As comparações entre o
DFM e o VAR na mesma série também não mudam, porque os dois lados usavam a mesma média, na mesma
janela.

**Mudam as comparações entre séries.** No h36 da §4.5, a menor resposta em valor absoluto entre
transformação, duráveis, capital, varejo e horas era a dos bens duráveis (−0,21%). Em pontos, é a
das horas trabalhadas (−0,22 contra −0,25 dos duráveis), e a frase mudou de sujeito.

## 5. Erro de rótulo corrigido em `fig_weak_iv_main`

Na coluna do DFM, o IBC-Br era desenhado com escala 1, em pontos, sob o rótulo "% da média". Na
coluna do VAR, era dividido pela média. Com média 99,5 a diferença era de 0,5% e não aparecia na
figura. Agora as duas colunas estão em pontos, com o mesmo rótulo.

## 6. O número que a média escondia

⚠ **BRL/ARS.** No impacto, a resposta é R$ 0,0063 por peso, maior que o nível do fim da amostra
(0,0038). A série cai de 0,411 em 2012-03 para 0,0038 em 2025-12, e a média é 0,163. Com a
divisão pela média, o mesmo impacto aparecia como 3,88%, um número de aparência comum. Isso é uma
propriedade do modelo em nível para uma série que cai duas ordens de grandeza na janela, e não da
apresentação. O BRL/ARS saiu da prosa pela decisão da §1, mas segue no painel.

## 7. Verificação

- Os 31 números novos da prosa foram conferidos por script contra o cache e contra o CSV do VAR,
  e todos batem no arredondamento impresso. O script também conferiu as afirmações de vale e de
  ordem da §4.5.
- Nenhuma ocorrência de `100 / mean`, `colMeans(panel`, "média amostral" ou "% da média" sobra em
  `script/`, `R/` ou `paper/paper_anpec.tex`.
- O `.tex` compila sem erro, sem referência indefinida e sem overfull.
- `R/modeling/` e `R/identification/` não foram tocados, e os validadores não precisam rodar.
