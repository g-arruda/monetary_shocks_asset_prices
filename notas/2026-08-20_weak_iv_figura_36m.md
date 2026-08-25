# Weak-IV até 36 meses: cinco respostas e câmbio em porcentagem

> **SUPERADA/INVÁLIDA — VAR estimado em séries não estacionárias.** Correção de apresentação e interpretação em 2026-08-20 sobre o
> proxy-SVAR observável `ibc5_cds_p4`, com `z_jk_bs_purif`, normalização em
> `yield_6m` a +50 pontos-base, amostra 2013-01--2025-09 e conjuntos
> Anderson--Rubin/MOSW analíticos. A especificação, a ordem `p=4`, a proxy, a
> amostra, o bootstrap do benchmark e os resultados em `h=0,...,4` não mudam.
> Esta nota substitui somente a comparação entre pontos do DFM e conjuntos AR
> do VAR que aparecia no texto vivo. As notas anteriores permanecem históricas.

## Correção

Um conjunto Anderson--Rubin calculado para a resposta do VAR cobre a resposta
desse VAR, não o ponto de outro modelo. Por isso, `script/model_var_weak_iv.R`
não lê mais a IRF do DFM, e o relatório gerado não conta quantos pontos do DFM
ficam dentro ou fora dos conjuntos do VAR. O artigo também não reporta mais os
“8 dos 25 pares”. O contraste entre os modelos fica restrito aos pontos de
impacto, na mesma normalização, sem atribuir cobertura do VAR ao DFM.

A figura principal agora cobre as cinco observáveis do VAR de produção entre
`h=0` e `h=36`: IBC-Br, IPCA, yield de 6 meses, câmbio e CDS. O IBC-Br e o
câmbio aparecem como `100 Δx / média amostral`, o yield em pontos-base, o IPCA
em pontos percentuais e o CDS em pontos-base. A grade 3×2 deixa a sexta célula
vazia e preserva as duas faixas azuis, a linha de ponto preta e o zero
tracejado das demais IRFs do artigo.

## Escala cambial

A média de `cambio_usd` nos 153 meses da amostra de estimação é
`4,111654334195838`. O fator de apresentação é, portanto,
`100 / 4,111654334195838`. No impacto do VAR principal, a resposta em nível
`0,077079283` passa a `1,8747%`, e o conjunto AR de 90% passa de
`[0,022745083; 0,156682478]` para `[0,5532%; 3,8107%]`. O ponto do DFM no
impacto, usado somente como contraste descritivo, passa de `0,157928066` para
`3,8410%`. A resposta do CDS permanece `11,7635` pontos-base, com conjunto
`[0,7029; 24,4227]`.

A mesma transformação foi aplicada às vinte linhas cambiais da tabela de
sensibilidade do apêndice, que correspondem a quatro células por cinco
horizontes. As linhas de CDS e EMBI+ não mudaram.

## Verificação

- `output/var/svar_iv_weak_robust.csv` tem 3.441 linhas: sete células, três
  níveis de confiança, 31 respostas por nível e 37 horizontes.
- Os sete diagnósticos foram reproduzidos; seis aparecem na tabela de
  sensibilidade e a sétima é a célula principal. Os valores de `xi_var`, F
  robusto e raiz máxima coincidem com a rodada anterior até quatro casas.
- As oito séries célula--resposta do apêndice entregam 40 conjuntos AR em
  `h=0,...,4`, todos intervalos limitados. Seus pontos e limites não mudaram na
  unidade original.
- A figura reúne 185 pares variável--horizonte. O maior desvio entre o ponto do
  caminho AR e o ponto do bootstrap do mesmo VAR em `h=0,...,36` é
  `9,24e-14`.
- Aplicar a escala percentual às vinte respostas cambiais do apêndice e
  invertê-la recupera pontos e limites com desvio máximo `2,78e-17`.
- `paper/paper_anpec.tex` compilou em duas passagens e gerou 30 páginas, sem
  referências indefinidas, avisos de tabela ou novos `overfull`. Permanece o
  `overfull` preexistente nas linhas 174--175, fora da seção modificada.

## Produtores e saídas

- `script/model_var_weak_iv.R` calcula os sete sistemas até `h=36` e mantém os
  consumidores tabulares em `h=0,...,4`.
- `script/fig_weak_iv.R` lê os conjuntos, o bootstrap e o painel apenas para as
  médias de escala. Antes de salvar, exige os 185 pares e a igualdade dos
  pontos.
- Saídas regeneradas: `output/var/svar_iv_weak_robust.csv`,
  `output/var/svar_iv_weak_robust_diag.csv`,
  `output/var/svar_iv_weak_robust.md`, `paper/fig_weak_iv_main.pdf` e
  `paper/paper_anpec.pdf`.
