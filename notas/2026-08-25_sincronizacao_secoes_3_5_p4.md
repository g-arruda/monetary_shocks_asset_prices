# Sincronização textual das Seções 3--5 com o DFM em `p=4`

> **CURRENT como registro textual, sem nova estimação.** Esta rodada sincroniza
> `paper/paper_anpec.tex`, `output/irf/irf_section.md`, `registro/metodo.md`,
> `registro/pendencias.md` e `notas/_indice.md` com os artefatos canônicos da
> produção `(r,q,p)=(5,5,4)`. Nenhum script econométrico foi executado e nenhum
> artefato de estimação foi regenerado.

## Escopo

A edição do paper ficou restrita às Seções 3, 4 e 5. Resumo, abstract,
introdução, revisão de literatura, conclusão, apêndice, título e referências
permaneceram fora desta rodada. A documentação viva foi atualizada para separar
a produção em `p=4` das grades e decomposições históricas condicionadas a
`p=6`.

## Fontes conferidas

- `output/validation/production_spec_diagnostics.csv` e
  `production_spec_bootstrap_gate.csv` para painel, amostras, força,
  estabilidade, réplicas, semente e normalização.
- `output/factors/p_selection_lag_criteria.csv` e `p_selection.md` para AIC,
  BIC, amostra comum e termos determinísticos da seleção.
- `output/irf/irf_coherence_h.csv` e
  `output/validation/production_spec_headline_irf.csv` para pontos e bandas.
- `diagnostics/output/t1_7_invertibilidade_granger.csv` e os diagnósticos de
  exogeneidade para os testes de previsibilidade e invertibilidade.
- `output/instrument/jk_sovereign_confound.{csv,md}` e
  `output/instrument/fomc_coincidence.{csv,md}` para os exercícios de
  contaminação e as máscaras rederivadas.
- `output/var/svar_iv_weak_robust.{csv,md}` e
  `output/var/svar_iv_weak_robust_diag.csv` para o benchmark VAR observável.

## Números sincronizados

A produção tem 111 séries, 153 meses e 149 inovações. O AIC mínimo é 8,073207
em `p=4`, enquanto o BIC seleciona `p=2`, ambos sobre 141 observações comuns,
com constante e tendência linear. O VAR fatorial estimado mantém apenas
intercepto. Na amostra completa, `xi_mp/F_rob,mp=5,240158/10,060922` e a raiz
máxima é 0,968126. Na pré-COVID, os valores são 7,478324/11,874945 e 0,992483.

No impacto, os vértices de 3 meses, 1 ano, 2 anos, 5 anos e 10 anos sobem 38,9,
62,9, 72,8, 74,8 e 67,6 pontos-base, e a Selic sobe 24,1 pontos-base. BRL/USD,
EMBI+, CDS e Ibovespa permanecem em 3,74%, 24,5 pontos-base, 30,7 pontos-base e
-0,97%. O IPCA em `h=6` é 0,121 ponto percentual, e o IFIX é o único índice de
ações cuja banda de 90% exclui zero no impacto.

No exercício soberano, a sequência de `xi_mp` é 5,24, 5,80 e 6,49 nos valores,
com 3,44 na máscara rederivada. No exercício FOMC, a sequência é 5,24 e 5,33
nos valores, com 3,67 na máscara rederivada. Os testes contemporâneos não
confirmam contaminação, mas a perda de relevância sob reclassificação mantém o
veredito de sinal fraco de contaminação FOMC e não absolve o instrumento.

## Decisão editorial

A reversão de médio prazo é descrita como dinâmica estimada sensível a `p`. A
decomposição do par complexo dominante do VAR(6) permanece evidência histórica
e não interpreta a produção atual. O DFM conserva as bandas do *wild bootstrap*
como inferência operacional, enquanto os conjuntos Anderson--Rubin/MOSW ficam
restritos ao benchmark VAR observável em `p=2`.
