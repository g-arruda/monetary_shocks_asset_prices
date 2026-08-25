# Handoff, 2026-08-25

## Tópico
Integração da migração DFM para `p=4`, do benchmark VAR observável e da revisão
integral do paper.

## Decisões ativas
- O DFM usa `(r,q,p)=(5,5,4)`, `xi_mp=5,24` e bandas wild bootstrap; o
  benchmark observável usa VAR(2) em níveis com tendência e conjuntos
  Anderson--Rubin/MOSW.
- A comparação VAR--DFM é descritiva e não isola exclusivamente o conjunto
  informacional nem transfere cobertura entre os modelos.
- O paper está sincronizado com 111 séries e reporta 3,74% para o câmbio, 24,5
  pb para o EMBI+, 30,7 pb para o CDS e 74,8 pb para o DI de cinco anos no
  impacto.
- As subseções de risco soberano e FOMC mantêm fixa a máscara de produção; os
  exercícios de rederivação permanecem apenas nos diagnósticos e registros.

## Arquivos-chave
- `paper/paper_anpec.tex` e `paper/fig_weak_iv_main.pdf` — manuscrito e figura
  comparativa correntes.
- `output/irf/irf_coherence_h.csv` — pontos e bandas do DFM.
- `output/var/svar_iv_weak_robust.csv` — pontos e conjuntos do VAR.
- `registro/pendencias.md` — índice vivo dos itens que continuam abertos.

## Próximos passos
- Decidir `q`, hoje mantido operacionalmente em 5 apesar do conflito entre o
  critério admissível e a força da proxy.
- Priorizar a decomposição do wedge de UIP e o repasse diário versus mensal da
  curva antes de fortalecer a interpretação de mecanismo.
- Implementar `paper_numbers.tex` como higiene preventiva; a divergência
  textual corrente já foi eliminada manualmente.
