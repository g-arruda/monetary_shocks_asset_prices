# A §4 migrada para a produção corrente, com as oito figuras repintadas

> **CURRENT — 2026-09-24.** Rodada editorial em `paper/paper_anpec.tex`, **sem
> reestimação**. Os números saem do cache de produção
> `output/irf/irf_coherence_cell.rds` e de `output/irf/irf_coherence_h.csv`, os
> mesmos que alimentam a §5.2 desde 2026-09-21.
> - Painel de produção de 115 séries, 2012-03 a 2025-12, `(r,q,p) = (5,5,4)`,
>   162 inovações, escala de volatilidade COVID de Lenza-Primiceri, conjuntos
>   Anderson--Rubin de 68% e 90% com NW(0), horizontes de 0 a 36 meses (os do §3.1).
> - **Fecha a sincronização aberta em 2026-09-08.** A §3 migrou em 2026-09-17, a
>   §5 em 2026-09-21, e agora a §4. A contradição entre as duas deixou de existir:
>   BRL/USD $3{,}23\%$ e CDS $30{,}5$ p.b. no impacto nas duas seções.
> - Decisões do autor nesta rodada: a §4 inteira é reescrita (prosa, figuras e
>   legendas); fora dela, só números e datas defasados, sem mexer no argumento; a
>   prosa reporta **pontos**, e os conjuntos aparecem só onde o texto anterior já
>   citava bandas, agora com os conjuntos AR e a regra de dois níveis.

## 1. O que a §4 era

A §4 estava na vintage de 2013-01--2025-09, sem a escala LP, e a legenda da
`fig:curva` descrevia bandas de *wild bootstrap* com 800 réplicas, método que saiu
do código em 2026-09-18. A prosa descrevia horizontes até 48 meses, embora as
figuras e o §3.1 parem em 36. `script/fig_section5.R` estava congelado atrás de
`--repaint-paper-figures` desde 2026-09-08.

## 2. Preflight

- O smoke test do `CLAUDE.md` reproduz bit a bit o `h=0` do cache, e a
  diferença máxima entre `main_sdfm()` e o cache é **0** na matriz inteira até
  `h=36`.
- `script/validation/validate_production_spec.R` passa sem alterar nenhum arquivo.

## 3. O que muda na leitura

A troca não é só de números. Cinco passagens da §4 anterior descreviam
trajetórias que a produção não tem:

| bloco | §4 anterior | produção corrente |
|---|---|---|
| Curva | picos entre h4 e h6; cruzamentos de h17 a h22; negativa e "mais próxima do eixo" ao fim de quatro anos | todos os vértices com pico em **h3** (6m em 74,0 p.b.); cruzamentos de h14 a h16, Selic em h17; em h36 entre −78,6 (3m) e −119,4 p.b. (2a), **ainda no vale** |
| Câmbio | 3,74 / 2,90 / 3,58 / 3,19 / 4,36% (USD/EUR/CNY/INR/ARS) | 3,23 / 2,37 / 3,06 / 2,61 / 3,59%; picos em h1–h3; cruzamentos de h11 a h14; apreciação de 1,38 a 3,89% em h36 |
| EMBI+/CDS | 24,5/30,7; cruzamentos em h14/h15; vales em h28/h29 | 25,1/30,5; picos em h1 (26,8/33,5); **os dois** cruzam em h14; −17,2/−23,5 p.b. em h36, ainda no vale |
| Atividade | IBC-Br −0,45%, positivo de h2 a h13; "a banda de 90% só exclui zero no impacto" | IBC-Br −0,66%, **nunca positivo**; o conjunto de 90% exclui zero em h0, h3 e h6–h24; todo o bloco fica negativo por 36 meses, com um segundo vale industrial em h10–h12 maior que o impacto em valor absoluto |
| Preços | corcova positiva no IPCA (0,131 em h5), positivo por um ano | **o IPCA nunca fica positivo** (−0,045 no impacto, vale de −0,311 em h30); IPP e IGP-M sobem e cruzam em h8; EX1 e INPC também sem troca de sinal |
| Ações | vales em h1, pico em h11–h12, "bandas abrangem zero na maior parte dos meses" | o impacto não é significativo em nenhum índice; o 90% exclui zero **só na fase positiva** (Ibovespa h5–h10, SMLL h8–h9, IDIV h5/h8/h9, IMAT h2 e h4–h13, IFIX h11–h14) e no IFIX em h1, com sinal negativo |
| Crédito | picos entre h3 e h6, cruzamentos de h13 a h22 | picos em h3 (PF em h3–h4), cruzamentos de h11 a h14, contração de −0,75 a −1,40% em h36 |

⚠ **Dois números inconvenientes entraram no texto por essa regra.** A fase positiva
dos retornos acionários é significativa a 90% em cinco índices, enquanto o impacto
negativo não é significativo em nenhum. E a NFSP primária, que cai no impacto,
fica **positiva e significativa a 90% de h18 a h32** (pico de R$ 4,63 bilhões em
h27).

## 4. Frases de banda que ficaram falsas

As seis foram reescritas com os conjuntos AR:

- NFSP primária: "a banda de 90% abrange zero em todo o horizonte" passou a ser
  "exclui zero em h1 e de h18 a h32";
- ajuste cambial: o conjunto de 68% no impacto é [−45,4; −1,0] bilhões, não
  [−29,4; −6,2], e o de 90% contém zero em todos os horizontes;
- expectativa de DLSP: "a banda de 90% abrange zero" passou a ser "exclui zero
  apenas no impacto";
- resultado primário esperado: "a banda de 68% abrange zero em todo o horizonte"
  passou a ser "o de 68% exclui zero de h1 a h5, e o de 90% contém zero sempre";
- resultado nominal esperado: "a de 68% exclui zero de h0 a h14" passou a ser "o
  de 90% exclui zero de h0 a h6 e volta a excluí-lo a partir de h30, com sinal positivo";
- IBC-Br e bloco de atividade: ver a tabela acima; o conjunto do varejo exclui
  zero sem interrupção de h0 a h23, e o de serviços só de h16 a h27.

## 5. Fora da §4

Por decisão do autor, só números e datas mudaram:

- no resumo em português e em inglês, BRL/USD 3,64% passou a 3,23%, e a amostra
  passou de 2013–2025 a 2012–2025;
- na introdução, a amostra passou de "2013 e 2025" a "2012 e 2025" e de "janeiro de
  2013 e setembro de 2025" a "março de 2012 e dezembro de 2025"; o roteiro passou
  a ter a §5, comparação com o VAR, e a §6, a conclusão;
- na conclusão, 3,64% passou a 3,23%. A frase "sem resposta estatisticamente
  significativa em nenhum dos oito índices setoriais" estava falsa duas vezes: são
  sete índices, e cinco excluem zero a 90% na fase positiva. Ela passou a
  "sem resposta de impacto estatisticamente significativa em nenhum dos sete
  índices", que é verdadeira. "A inflação apresenta evidências de repasse cambial
  no curto prazo" passou a "a inflação ao produtor", porque o IPCA não sobe em
  nenhum horizonte.

⚠ **O que ficou para o autor** está no Tema A de `registro/pendencias.md`. São
frases de argumento que a leitura nova enfraquece e que esta rodada não reescreveu:
"o mercado de trabalho responde com defasagem" (as horas caem 1,23% já no impacto,
com 90% excluindo zero), a reversão "sincronizada" do resumo (os cruzamentos vão de
h11 a h16, mas curva e risco soberano continuam caindo em h36) e o silêncio do
resumo e da conclusão sobre a atividade persistente e a NFSP primária positiva no
médio prazo.

## 6. Código e artefatos

- `script/fig_section5.R` perdeu a trava `--repaint-paper-figures` e o bloco
  `FROZEN` do cabeçalho. O resto do script ficou intacto, e o laço de validação que
  ele já tinha confere cada ponto e cada conjunto plotado contra
  `irf_coherence_h.csv` com tolerância de 1e-10.
- Oito figuras repintadas: `fig_{curva,cambio_risco,fiscal,expectativas,atividade,credito,precos,acoes}.pdf`.
  `fig_placebos.pdf` foi repintada junto, mas não tem consumidor no paper desde a
  exclusão da §5.1 antiga.
- `output/irf/irf_section.md` foi reescrito na vintage corrente, com os impactos e
  os conjuntos AR de 68% e 90%.

## 7. Verificação

- Cada um dos **140 números** da §4 nova bate com o cache depois do arredondamento
  impresso (script descartável no scratchpad; a lista de tuplas está na sessão).
- A §4 bate com a §5.2 em BRL/USD 3,23%, CDS 30,5 p.b., IBC-Br −0,66%, IPCA
  −0,045 e pico do 6m de 74,0 p.b. em h3.
- `pdflatex` + `bibtex`: 26 páginas, sem erro, sem *overfull* e sem referência
  indefinida.
- Um grep por `3,74`, `30,7`, `3,64`, `bootstrap`, `2013` e `quatro anos` só
  encontra comentários `%` do autor e a chave `mertensravn2013`.
