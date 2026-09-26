# O paper migrado para a produção da branch: `z_bs_purif`, conjuntos de 80/90% e sem o filtro JK

> **BRANCH `feature/bs-copom-surpresas-macro`, 2026-09-26 — CURRENT na branch.** Rodada editorial
> em `paper/paper_anpec.tex`, **sem reestimação**. Os números vêm dos arquivos da produção da branch
> (`2026-09-26_producao_bs_purif_bandas_80_90`):
> - `output/irf/irf_coherence_cell.rds`, nas escalas de `irf_panel()` em `script/fig_section5.R`;
> - `output/instrument/mosw_strength_grid.csv`, `instrument_diagnostics.csv` e
>   `bs_orthogonalization.csv`;
> - `output/var/svar_iv_weak_robust.csv`.
>
> - Fecha o item de migração do Tema A de `registro/pendencias.md`. Com isso, o texto e as figuras
>   voltam a concordar na branch.
> - **Promovida para `main` no mesmo dia**, por fast-forward da branch (`63eea36..20a5f42`), a
>   pedido do autor. Até lá, `main` tinha o paper antigo (`z_jk_bs_purif`, 68/90%).
> - Base de comparação: a branch em `c3a6536`. Commits da rodada: `3b9e402` (o commit da migração
>   do código, que estava pendente), `c3a6536` (Anexo D), `acbfcf5` (paper).

## 1. Decisões do autor nesta rodada

**O filtro de sinal de Jarociński-Karadi sai do paper inteiro.** Não fica como camada alternativa.
Saíram:
- o parágrafo da terceira camada na §3.3 e sua nota de rodapé (versão *poor man's*, 67/35 reuniões);
- a linha 3 da `tab:first_stage`;
- a coluna (2) da `tab:bs_ortogonalizacao`, o retorno do Ibovespa, que só existia para definir o
  filtro;
- a linha tracejada da `fig:instrumento_camadas`. `script/instrument_layers_irf.R` passou a rodar só
  `z_bs_purif` e `z_bruto`, e `instrument_layers_irf.csv` perdeu as linhas JK;
- as frases de JK na §2 (co-movimento no FOMC, BVAR, choque purificado), no resumo em português e
  em inglês e na introdução.

`jarocinski2020` continua na bibliografia, citado na §3.3 pela soma mensal das surpresas. O código
continua construindo as três camadas (`R/instrument/build_variants.R`), porque a grade de força e os
diagnósticos usam as três. Só o paper deixa de reportar a terceira.

**Fora da §4, o escopo é o da rodada de 2026-09-24.** Trocaram-se os números, a descrição do
instrumento e as frases que a produção nova tornou falsas. O item do Tema A "absorver a leitura da
§4 no resumo, na introdução e na conclusão" continua aberto, e a "reversão altamente sincronizada"
continua no resumo e na conclusão.

## 2. O que mudou, por seção

| seção | antes (`main`) | agora (branch) |
|---|---|---|
| Resumo, PT e EN | BRL/USD 3,23%; o instrumento combina ortogonalização e filtro de sinal | 3,53%; o instrumento são as surpresas do Copom ortogonalizadas |
| §1 | "a regra de sinal de JK, que separa…" | só a ortogonalização de BS |
| §2 | JK (um terço dos anúncios do FOMC, BVAR) e BS | só BS (12–20% das surpresas) |
| §3.3 | três camadas; regressão com tendência nas 638 quintas, com câmbio e revisões Focus; `R²` 0,022 "sem contrapartida" | duas camadas; regressão nas 102 reuniões, só com constante, sobre as tendências de 65 pregões de Ibovespa, S&P 500, VIX, Brent e inclinação do DI, mais as surpresas de IPCA e de PIB, a aceleração do núcleo EX0 e o IPCA esperado; `R²` 0,124, no piso da faixa de BS; o resíduo é o instrumento |
| §3.4 | ξ_mp 6,85 / 8,64, F_rob 11,77 / 13,81, "evidência mista"; o filtro eleva a força | ξ_mp 7,02 / 6,84, F_rob 8,62 / 8,31, as duas abaixo de 10 nas duas janelas; a ortogonalização eleva ξ_mp (6,68 → 7,02; 6,66 → 6,84), baixa o F_rob na amostra completa (9,37 → 8,62) e o eleva na pré-COVID (7,79 → 8,31); "80% e 90%" |
| `tab:first_stage` | três linhas, produção na 3 | duas linhas, produção na 2 (99 meses, β 0,722, EP 0,246, p 0,004) |
| As 13 menções a "68%" | 12 legendas e a §3.4 | 80% |
| §4 | a produção de `main` | todos os números re-derivados do cache (seção 3 abaixo) |
| §5 | DFM 3,23% / 30,5 p.b.; VAR 2,02% / 15,7 p.b., *price puzzle* em h2 e h4 | DFM 3,53% / 34,0 p.b.; VAR 2,49% / 23,3 p.b., *price puzzle* em h4–h5 |
| Conclusão | 3,23%; "o câmbio perde significância estatística bem antes dessa reversão" | 3,53%; o conjunto de 90% do câmbio exclui zero de h0 a h4 e volta a excluí-lo de h32 a h36, no ramo da apreciação |
| `tab:bs_ortogonalizacao` | duas colunas, oito preditores, 638 quintas, com tendência | uma coluna (coeficiente e EP), nove preditores em dois blocos, 102 reuniões, só constante; `R²` 0,124, Wald conjunta p 0,122, Wald do bloco macro p 0,059; a legenda traz as unidades e o timing das notícias macro |
| `fig:instrumento_camadas` | produção JK; tracejadas a bruta e a ortogonalizada | produção ortogonalizada; tracejada só a bruta |

## 3. A §4: forma igual, magnitudes maiores, sete frases reescritas

A forma das respostas não muda:
- a curva tem pico em h3 em todos os vértices;
- o IBC-Br fica negativo por 36 meses;
- o IPCA nunca fica positivo.

Os cruzamentos de zero da curva antecipam um mês (h13–h15, Selic h16), e as magnitudes sobem. No
impacto:
- a curva sobe 40,0 / 61,7 / 72,1 / 77,3 / 70,7 p.b. (3m, 1a, 2a, 5a, 10a) e a Selic 26,8 p.b.;
- o BRL/USD sobe 3,53%, o EMBI+ 28,3 p.b. e o CDS 34,0 p.b.;
- a DLSP cai 0,74 p.p. do PIB;
- o IBC-Br cai 0,77% e o IPCA 0,077 p.p.;
- o Ibovespa cai 2,47%.

Sete passagens deixaram de ser verdadeiras e foram reescritas:

1. **Picos.** O BRL/USD e o CDS passam a ter pico em h1 (4,45%, 36,7 p.b.), e a Selic em h3. O
   parágrafo de abertura passa a dizer "entre o impacto e o quinto mês", porque a expectativa Focus
   de DLSP tem o maior recuo no impacto, e "cruzamentos entre h11 e h17".
2. **Ajuste cambial.** O conjunto de 80% no impacto contém zero, [−71,7; 1,5] bilhões. O de 68%
   excluía, [−45,4; −1,0]. O conjunto de 90% passa a excluir zero em h35–h36, com sinal negativo.
3. **Primário esperado.** O conjunto de 80% exclui zero só em h2. O de 68% excluía de h1 a h5.
4. **Bloco de atividade.** O "segundo vale que supera o impacto em valor absoluto" só vale para
   bens duráveis, bens de capital e horas. Na indústria de transformação e no varejo ele fica pouco
   abaixo do impacto (−2,31% contra −2,35%, −1,36% contra −1,40%). O conjunto de 90% dos bens
   duráveis fica sem lacuna (h0–h21).
5. **Ações.** Os sete índices caem no impacto, porque o IMAT passa a −0,39%. Com isso sai a frase
   da receita em dólar amortecendo o impacto. Nenhum índice é significativo a 90% no impacto, como
   antes. Na fase positiva, o conjunto de 90% exclui zero no Ibovespa (h5–h9), no SMLL (h8–h9) e no
   IDIV (h8). É nova a exclusão no fim da janela, com sinal negativo, em cinco índices: Ibovespa e
   IDIV em h34–h36, IFNC em h33–h36, IMOB em h35–h36 e SMLL em h36.
6. **NFSP primária.** O conjunto de 90% exclui zero em h1 e h16–h33, contra h1 e h18–h32 antes. O
   pico é de 5,06 bilhões em h26.
7. **Conclusão.** A frase do câmbio (tabela acima).

O IBC-Br passa a ser significativo a 90% em h0 e h3–h25. Os serviços passam a h13–h29, e o IPCA
passa a h17–h36 na §5.

**Auditoria.** Os 143 números da §4 e os 20 da §5 foram conferidos por script contra o cache, no
arredondamento impresso. Todos batem, e os dois que não vêm do cache são os AIC do VAR (−11,106 e
−11,006), que não dependem do instrumento. Os valores na fronteira do arredondamento foram
conferidos com dez dígitos. Por isso a expectativa Focus de IPCA fica em 0,174 e o pico do IGP-M em
0,155.

## 4. Verificações

- `instrument_layers_irf.R` roda até o fim, e a produção confere contra `irf_coherence_h.csv` a
  1e-10.
- O paper compila sem erro, sem referência indefinida e sem *overfull*. Os dois avisos que a
  migração criou foram corrigidos: o rótulo da linha 2 da `tab:first_stage` ficou mais curto, e a
  `tab:bs_ortogonalizacao` passou a trazer coeficiente e EP na mesma linha.
- Grep de resíduos vazio no corpo impresso: `68\%`, 3,23, 6,85, 8,64, 11,77, 13,81, "filtro de
  sinal", *poor man's*, 638, "tendência temporal".

## 5. O que fica aberto

- **Tema D:** promover a produção da branch para `main`. Feito no mesmo dia, depois desta nota.
- **Tema D:** o placebo EPU dos EUA viola a 90% em h1–h3. O paper não publica placebos, e nada no
  texto depende dele.
- **Tema A:** absorver a leitura da §4 no resumo, na introdução e na conclusão.
